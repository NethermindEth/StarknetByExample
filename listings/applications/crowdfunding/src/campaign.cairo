pub mod contributions;

// ANCHOR: contract
use starknet::{ClassHash, ContractAddress};

#[derive(Drop, Debug, Serde, PartialEq, starknet::Store)]
pub enum Status {
    ACTIVE,
    CLOSED,
    PENDING,
    SUCCESSFUL,
    UNSUCCESSFUL,
}

#[derive(Drop, Serde)]
pub struct Details {
    pub target: u256,
    pub title: ByteArray,
    pub end_time: u64,
    pub description: ByteArray,
    pub status: Status,
    pub token: ContractAddress,
    pub total_contributions: u256,
}

#[starknet::interface]
pub trait ICampaign<TContractState> {
    fn claim(ref self: TContractState);
    fn close(ref self: TContractState, reason: ByteArray);
    fn contribute(ref self: TContractState, amount: u256);
    fn get_contributions(self: @TContractState) -> Array<(ContractAddress, u256)>;
    fn get_details(self: @TContractState) -> Details;
    fn start(ref self: TContractState);
    fn upgrade(ref self: TContractState, impl_hash: ClassHash) -> Result<(), Array<felt252>>;
    fn withdraw(ref self: TContractState);
}

#[starknet::contract]
pub mod Campaign {
    use components::ownable::ownable_component::OwnableInternalTrait;
    use core::num::traits::zero::Zero;
    use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};
    use starknet::{
        ClassHash, ContractAddress, SyscallResultTrait, get_block_timestamp, contract_address_const,
        get_caller_address, get_contract_address
    };
    use components::ownable::ownable_component;
    use super::contributions::contributable_component;
    use super::{Details, Status};

    component!(path: ownable_component, storage: ownable, event: OwnableEvent);
    component!(path: contributable_component, storage: contributions, event: ContributableEvent);

    #[abi(embed_v0)]
    pub impl OwnableImpl = ownable_component::Ownable<ContractState>;
    impl OwnableInternalImpl = ownable_component::OwnableInternalImpl<ContractState>;
    #[abi(embed_v0)]
    impl ContributableImpl = contributable_component::Contributable<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        ownable: ownable_component::Storage,
        #[substorage(v0)]
        contributions: contributable_component::Storage,
        end_time: u64,
        token: IERC20Dispatcher,
        creator: ContractAddress,
        target: u256,
        title: ByteArray,
        description: ByteArray,
        total_contributions: u256,
        status: Status
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        #[flat]
        OwnableEvent: ownable_component::Event,
        Activated: Activated,
        ContributableEvent: contributable_component::Event,
        ContributionMade: ContributionMade,
        Claimed: Claimed,
        Closed: Closed,
        Upgraded: Upgraded,
        Withdrawn: Withdrawn,
    }

    #[derive(Drop, starknet::Event)]
    pub struct ContributionMade {
        #[key]
        pub contributor: ContractAddress,
        pub amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Claimed {
        pub amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Activated {}

    #[derive(Drop, starknet::Event)]
    pub struct Closed {
        pub reason: ByteArray,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Upgraded {
        pub implementation: ClassHash
    }

    #[derive(Drop, starknet::Event)]
    pub struct Withdrawn {
        #[key]
        pub contributor: ContractAddress,
        pub amount: u256,
    }

    pub mod Errors {
        pub const NOT_FACTORY: felt252 = 'Caller not factory';
        pub const ENDED: felt252 = 'Campaign already ended';
        pub const NOT_PENDING: felt252 = 'Campaign not pending';
        pub const STILL_ACTIVE: felt252 = 'Campaign not ended';
        pub const ZERO_DONATION: felt252 = 'Donation must be > 0';
        pub const ZERO_TARGET: felt252 = 'Target must be > 0';
        pub const ZERO_DURATION: felt252 = 'Duration must be > 0';
        pub const ZERO_FUNDS: felt252 = 'No funds to claim';
        pub const TRANSFER_FAILED: felt252 = 'Transfer failed';
        pub const TITLE_EMPTY: felt252 = 'Title empty';
        pub const CLASS_HASH_ZERO: felt252 = 'Class hash cannot be zero';
        pub const FACTORY_ZERO: felt252 = 'Factory address cannot be zero';
        pub const CREATOR_ZERO: felt252 = 'Creator address cannot be zero';
        pub const TARGET_NOT_REACHED: felt252 = 'Target not reached';
        pub const TARGET_ALREADY_REACHED: felt252 = 'Target already reached';
        pub const NOTHING_TO_WITHDRAW: felt252 = 'Nothing to withdraw';
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        owner: ContractAddress,
        title: ByteArray,
        description: ByteArray,
        target: u256,
        duration: u64,
        token_address: ContractAddress
    ) {
        assert(owner.is_non_zero(), Errors::CREATOR_ZERO);
        assert(title.len() > 0, Errors::TITLE_EMPTY);
        assert(target > 0, Errors::ZERO_TARGET);
        assert(duration > 0, Errors::ZERO_DURATION);

        self.token.write(IERC20Dispatcher { contract_address: token_address });

        self.title.write(title);
        self.target.write(target);
        self.description.write(description);
        self.end_time.write(get_block_timestamp() + duration);
        self.creator.write(get_caller_address());
        self.ownable._init(owner);
        self.status.write(Status::PENDING)
    }

    #[abi(embed_v0)]
    impl Campaign of super::ICampaign<ContractState> {
        fn claim(ref self: ContractState) {
            self.ownable._assert_only_owner();
            assert(self._is_active(), Errors::ENDED);
            assert(self._is_target_reached(), Errors::TARGET_NOT_REACHED);
            // no need to check end_time, as the owner can prematurely end the campaign

            let this = get_contract_address();
            let token = self.token.read();

            let amount = token.balance_of(this);
            assert(amount > 0, Errors::ZERO_FUNDS);

            self.status.write(Status::SUCCESSFUL);

            // no need to set total_contributions to 0, as the campaign has ended
            // and the field can be used as a testament to how much was raised

            let success = token.transfer(get_caller_address(), amount);
            assert(success, Errors::TRANSFER_FAILED);

            self.emit(Event::Claimed(Claimed { amount }));
        }

        fn close(ref self: ContractState, reason: ByteArray) {
            self.ownable._assert_only_owner();
            assert(self._is_active(), Errors::ENDED);

            self.status.write(Status::CLOSED);

            let mut contributions = self.get_contributions();
            while let Option::Some((contributor, amt)) = contributions
                .pop_front() {
                    self.contributions.remove(contributor);
                    self.token.read().transfer(contributor, amt);
                };

            self.emit(Event::Closed(Closed { reason }));
        }

        fn contribute(ref self: ContractState, amount: u256) {
            assert(self._is_active(), Errors::ENDED);
            assert(amount > 0, Errors::ZERO_DONATION);

            let contributor = get_caller_address();
            let this = get_contract_address();
            let success = self.token.read().transfer_from(contributor, this, amount.into());
            assert(success, Errors::TRANSFER_FAILED);

            self.contributions.add(contributor, amount);
            self.total_contributions.write(self.total_contributions.read() + amount);

            self.emit(Event::ContributionMade(ContributionMade { contributor, amount }));
        }

        fn get_contributions(self: @ContractState) -> Array<(ContractAddress, u256)> {
            self.contributions.get_contributions_as_arr()
        }

        fn get_details(self: @ContractState) -> Details {
            Details {
                title: self.title.read(),
                description: self.description.read(),
                target: self.target.read(),
                end_time: self.end_time.read(),
                status: self.status.read(),
                token: self.token.read().contract_address,
                total_contributions: self.total_contributions.read(),
            }
        }

        fn start(ref self: ContractState) {
            self.ownable._assert_only_owner();
            assert(self.status.read() == Status::PENDING, Errors::NOT_PENDING);

            self.status.write(Status::ACTIVE);

            self.emit(Event::Activated(Activated {}));
        }

        fn upgrade(ref self: ContractState, impl_hash: ClassHash) -> Result<(), Array<felt252>> {
            if get_caller_address() != self.creator.read() {
                return Result::Err(array![Errors::NOT_FACTORY]);
            }
            if impl_hash.is_zero() {
                return Result::Err(array![Errors::CLASS_HASH_ZERO]);
            }

            starknet::syscalls::replace_class_syscall(impl_hash)?;

            self.emit(Event::Upgraded(Upgraded { implementation: impl_hash }));

            Result::Ok(())
        }

        fn withdraw(ref self: ContractState) {
            if self._is_expired() && !self._is_target_reached() && self._is_active() {
                self.status.write(Status::UNSUCCESSFUL);
            }
            assert(
                self.status.read() == Status::UNSUCCESSFUL || self.status.read() == Status::CLOSED,
                Errors::STILL_ACTIVE
            );
            assert(self.contributions.get(get_caller_address()) != 0, Errors::NOTHING_TO_WITHDRAW);

            let contributor = get_caller_address();
            let amount = self.contributions.remove(contributor);

            // no need to set total_contributions to 0, as the campaign has ended
            // and the field can be used as a testament to how much was raised

            self.token.read().transfer(contributor, amount);

            self.emit(Event::Withdrawn(Withdrawn { contributor, amount }));
        }
    }

    #[generate_trait]
    impl CampaignInternalImpl of CampaignInternalTrait {
        fn _is_expired(self: @ContractState) -> bool {
            get_block_timestamp() < self.end_time.read()
        }

        fn _is_active(self: @ContractState) -> bool {
            self.status.read() == Status::ACTIVE
        }

        fn _is_target_reached(self: @ContractState) -> bool {
            self.total_contributions.read() >= self.target.read()
        }
    }
}
// ANCHOR_END: contract


