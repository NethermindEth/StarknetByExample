pub mod pledges;

// ANCHOR: contract
use starknet::{ClassHash, ContractAddress};

#[derive(Drop, Debug, Serde, PartialEq, starknet::Store)]
pub enum Status {
    ACTIVE,
    CANCELED,
    DRAFT,
    SUCCESSFUL,
    FAILED,
}

#[derive(Drop, Serde)]
pub struct Details {
    pub creator: ContractAddress,
    pub goal: u256,
    pub title: ByteArray,
    pub end_time: u64,
    pub description: ByteArray,
    pub status: Status,
    pub token: ContractAddress,
    pub total_pledges: u256,
}

#[starknet::interface]
pub trait ICampaign<TContractState> {
    fn claim(ref self: TContractState);
    fn cancel(ref self: TContractState, reason: ByteArray);
    fn pledge(ref self: TContractState, amount: u256);
    fn get_pledge(self: @TContractState, pledger: ContractAddress) -> u256;
    fn get_pledges(self: @TContractState) -> Array<(ContractAddress, u256)>;
    fn get_details(self: @TContractState) -> Details;
    fn launch(ref self: TContractState, duration: u64);
    fn refund(ref self: TContractState, pledger: ContractAddress, reason: ByteArray);
    fn upgrade(ref self: TContractState, impl_hash: ClassHash, new_duration: Option<u64>);
    fn unpledge(ref self: TContractState, reason: ByteArray);
}

#[starknet::contract]
pub mod Campaign {
    use components::ownable::ownable_component::OwnableInternalTrait;
    use core::num::traits::zero::Zero;
    use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};
    use starknet::{
        ClassHash, ContractAddress, SyscallResultTrait, get_block_timestamp, contract_address_const,
        get_caller_address, get_contract_address, class_hash::class_hash_const
    };
    use components::ownable::ownable_component;
    use super::pledges::pledgeable_component;
    use super::{Details, Status};

    component!(path: ownable_component, storage: ownable, event: OwnableEvent);
    component!(path: pledgeable_component, storage: pledges, event: PledgeableEvent);

    #[abi(embed_v0)]
    pub impl OwnableImpl = ownable_component::Ownable<ContractState>;
    impl OwnableInternalImpl = ownable_component::OwnableInternalImpl<ContractState>;
    #[abi(embed_v0)]
    impl PledgeableImpl = pledgeable_component::Pledgeable<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        ownable: ownable_component::Storage,
        #[substorage(v0)]
        pledges: pledgeable_component::Storage,
        end_time: u64,
        token: IERC20Dispatcher,
        creator: ContractAddress,
        goal: u256,
        title: ByteArray,
        description: ByteArray,
        total_pledges: u256,
        status: Status
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        #[flat]
        OwnableEvent: ownable_component::Event,
        Claimed: Claimed,
        Canceled: Canceled,
        Launched: Launched,
        PledgeableEvent: pledgeable_component::Event,
        PledgeMade: PledgeMade,
        Refunded: Refunded,
        RefundedAll: RefundedAll,
        Unpledged: Unpledged,
        Upgraded: Upgraded,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Canceled {
        pub reason: ByteArray,
        pub status: Status,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Claimed {
        pub amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Launched {}

    #[derive(Drop, starknet::Event)]
    pub struct PledgeMade {
        #[key]
        pub pledger: ContractAddress,
        pub amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Refunded {
        #[key]
        pub pledger: ContractAddress,
        pub amount: u256,
        pub reason: ByteArray,
    }

    #[derive(Drop, starknet::Event)]
    pub struct RefundedAll {
        pub reason: ByteArray,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Unpledged {
        #[key]
        pub pledger: ContractAddress,
        pub amount: u256,
        pub reason: ByteArray,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Upgraded {
        pub implementation: ClassHash
    }

    pub mod Errors {
        pub const NOT_CREATOR: felt252 = 'Not creator';
        pub const ENDED: felt252 = 'Campaign already ended';
        pub const NOT_DRAFT: felt252 = 'Campaign not draft';
        pub const STILL_ACTIVE: felt252 = 'Campaign not ended';
        pub const STILL_DRAFT: felt252 = 'Campaign not yet active';
        pub const CANCELED: felt252 = 'Campaign canceled';
        pub const FAILED: felt252 = 'Campaign failed';
        pub const CLASS_HASH_ZERO: felt252 = 'Class hash cannot be zero';
        pub const ZERO_DONATION: felt252 = 'Donation must be > 0';
        pub const ZERO_TARGET: felt252 = 'Target must be > 0';
        pub const ZERO_DURATION: felt252 = 'Duration must be > 0';
        pub const ZERO_FUNDS: felt252 = 'No funds to claim';
        pub const ZERO_ADDRESS_CONTRIBUTOR: felt252 = 'Contributor cannot be zero';
        pub const TRANSFER_FAILED: felt252 = 'Transfer failed';
        pub const TITLE_EMPTY: felt252 = 'Title empty';
        pub const ZERO_ADDRESS_CALLER: felt252 = 'Caller cannot be zero';
        pub const CREATOR_ZERO: felt252 = 'Creator address cannot be zero';
        pub const TARGET_NOT_REACHED: felt252 = 'Target not reached';
        pub const TARGET_ALREADY_REACHED: felt252 = 'Target already reached';
        pub const NOTHING_TO_WITHDRAW: felt252 = 'Nothing to unpledge';
        pub const NOTHING_TO_REFUND: felt252 = 'Nothing to refund';
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        creator: ContractAddress,
        title: ByteArray,
        description: ByteArray,
        goal: u256,
        token_address: ContractAddress,
    ) {
        assert(creator.is_non_zero(), Errors::CREATOR_ZERO);
        assert(title.len() > 0, Errors::TITLE_EMPTY);
        assert(goal > 0, Errors::ZERO_TARGET);

        self.token.write(IERC20Dispatcher { contract_address: token_address });

        self.title.write(title);
        self.goal.write(goal);
        self.description.write(description);
        self.creator.write(creator);
        self.ownable._init(get_caller_address());
        self.status.write(Status::DRAFT)
    }

    #[abi(embed_v0)]
    impl Campaign of super::ICampaign<ContractState> {
        fn claim(ref self: ContractState) {
            self._assert_only_creator();
            assert(
                self.status.read() == Status::ACTIVE && self._is_expired(), Errors::STILL_ACTIVE
            );
            assert(self._is_goal_reached(), Errors::TARGET_NOT_REACHED);

            let this = get_contract_address();
            let token = self.token.read();

            let amount = token.balance_of(this);
            assert(amount > 0, Errors::ZERO_FUNDS);

            self.status.write(Status::SUCCESSFUL);

            // no need to reset the pledges, as the campaign has ended
            // and the data can be used as a testament to how much was raised

            let owner = get_caller_address();
            let success = token.transfer(owner, amount);
            assert(success, Errors::TRANSFER_FAILED);

            self.emit(Event::Claimed(Claimed { amount }));
        }

        fn cancel(ref self: ContractState, reason: ByteArray) {
            self._assert_only_creator();
            assert(self.status.read() == Status::ACTIVE, Errors::ENDED);

            if !self._is_goal_reached() && self._is_expired() {
                self.status.write(Status::FAILED);
            } else {
                self.status.write(Status::CANCELED);
            }

            self._refund_all(reason.clone());
            let status = self.status.read();

            self.emit(Event::Canceled(Canceled { reason, status }));
        }

        fn pledge(ref self: ContractState, amount: u256) {
            assert(self.status.read() != Status::DRAFT, Errors::STILL_DRAFT);
            assert(self.status.read() == Status::ACTIVE && !self._is_expired(), Errors::ENDED);
            assert(amount > 0, Errors::ZERO_DONATION);

            let pledger = get_caller_address();
            let this = get_contract_address();
            let success = self.token.read().transfer_from(pledger, this, amount);
            assert(success, Errors::TRANSFER_FAILED);

            self.pledges.add(pledger, amount);
            self.total_pledges.write(self.total_pledges.read() + amount);

            self.emit(Event::PledgeMade(PledgeMade { pledger, amount }));
        }

        fn get_pledge(self: @ContractState, pledger: ContractAddress) -> u256 {
            self.pledges.get(pledger)
        }

        fn get_pledges(self: @ContractState) -> Array<(ContractAddress, u256)> {
            self.pledges.get_pledges_as_arr()
        }

        fn get_details(self: @ContractState) -> Details {
            Details {
                creator: self.creator.read(),
                title: self.title.read(),
                description: self.description.read(),
                goal: self.goal.read(),
                end_time: self.end_time.read(),
                status: self.status.read(),
                token: self.token.read().contract_address,
                total_pledges: self.total_pledges.read(),
            }
        }

        fn launch(ref self: ContractState, duration: u64) {
            self._assert_only_creator();
            assert(self.status.read() == Status::DRAFT, Errors::NOT_DRAFT);
            assert(duration > 0, Errors::ZERO_DURATION);

            self.end_time.write(get_block_timestamp() + duration);
            self.status.write(Status::ACTIVE);

            self.emit(Event::Launched(Launched {}));
        }

        fn refund(ref self: ContractState, pledger: ContractAddress, reason: ByteArray) {
            self._assert_only_creator();
            assert(pledger.is_non_zero(), Errors::ZERO_ADDRESS_CONTRIBUTOR);
            assert(self.status.read() != Status::DRAFT, Errors::STILL_DRAFT);
            assert(self.status.read() == Status::ACTIVE, Errors::ENDED);
            assert(self.pledges.get(pledger) != 0, Errors::NOTHING_TO_REFUND);

            let amount = self._refund(pledger);

            self.emit(Event::Refunded(Refunded { pledger, amount, reason }))
        }

        fn upgrade(ref self: ContractState, impl_hash: ClassHash, new_duration: Option<u64>) {
            self.ownable._assert_only_owner();
            assert(impl_hash.is_non_zero(), Errors::CLASS_HASH_ZERO);
            assert(
                self.status.read() == Status::ACTIVE || self.status.read() == Status::DRAFT,
                Errors::ENDED
            );

            // only active campaigns have funds to refund and duration to update
            if self.status.read() == Status::ACTIVE {
                if let Option::Some(duration) = new_duration {
                    assert(duration > 0, Errors::ZERO_DURATION);
                    self.end_time.write(get_block_timestamp() + duration);
                };
                self._refund_all("contract upgraded");
            }

            starknet::syscalls::replace_class_syscall(impl_hash).unwrap_syscall();

            self.emit(Event::Upgraded(Upgraded { implementation: impl_hash }));
        }

        fn unpledge(ref self: ContractState, reason: ByteArray) {
            assert(self.status.read() != Status::DRAFT, Errors::STILL_DRAFT);
            assert(self.status.read() == Status::ACTIVE, Errors::ENDED);
            assert(!self._is_goal_reached(), Errors::TARGET_ALREADY_REACHED);
            assert(self.pledges.get(get_caller_address()) != 0, Errors::NOTHING_TO_WITHDRAW);

            let pledger = get_caller_address();
            let amount = self._refund(pledger);

            self.emit(Event::Unpledged(Unpledged { pledger, amount, reason }));
        }
    }

    #[generate_trait]
    impl CampaignInternalImpl of CampaignInternalTrait {
        fn _assert_only_creator(self: @ContractState) {
            let caller = get_caller_address();
            assert(caller.is_non_zero(), Errors::ZERO_ADDRESS_CALLER);
            assert(caller == self.creator.read(), Errors::NOT_CREATOR);
        }

        fn _is_expired(self: @ContractState) -> bool {
            get_block_timestamp() >= self.end_time.read()
        }

        fn _is_goal_reached(self: @ContractState) -> bool {
            self.total_pledges.read() >= self.goal.read()
        }

        fn _refund(ref self: ContractState, pledger: ContractAddress) -> u256 {
            let amount = self.pledges.remove(pledger);

            // if the campaign is "failed", then there's no need to set total_pledges to 0, as
            // the campaign has ended and the field can be used as a testament to how much was raised
            if self.status.read() == Status::ACTIVE {
                self.total_pledges.write(self.total_pledges.read() - amount);
            }

            let success = self.token.read().transfer(pledger, amount);
            assert(success, Errors::TRANSFER_FAILED);

            amount
        }

        fn _refund_all(ref self: ContractState, reason: ByteArray) {
            let mut pledges = self.pledges.get_pledges_as_arr();
            while let Option::Some((pledger, _)) = pledges.pop_front() {
                self._refund(pledger);
            };
            self.emit(Event::RefundedAll(RefundedAll { reason }));
        }
    }
}
// ANCHOR_END: contract


