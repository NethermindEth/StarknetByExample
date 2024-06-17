#[starknet::contract]
pub mod MockUpgrade {
    use components::ownable::ownable_component::OwnableInternalTrait;
    use core::num::traits::zero::Zero;
    use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};
    use starknet::{
        ClassHash, ContractAddress, SyscallResultTrait, get_block_timestamp, contract_address_const,
        get_caller_address, get_contract_address, class_hash::class_hash_const
    };
    use components::ownable::ownable_component;
    use crowdfunding::campaign::pledgeable::pledgeable_component;
    use crowdfunding::campaign::{ICampaign, Details, Campaign::Errors};

    component!(path: ownable_component, storage: ownable, event: OwnableEvent);
    component!(path: pledgeable_component, storage: pledges, event: PledgeableEvent);

    #[abi(embed_v0)]
    pub impl OwnableImpl = ownable_component::Ownable<ContractState>;
    impl OwnableInternalImpl = ownable_component::OwnableInternalImpl<ContractState>;
    #[abi(embed_v0)]
    impl PledgeableImpl = pledgeable_component::Pledgeable<ContractState>;

    #[storage]
    struct Storage {
        canceled: bool,
        claimed: bool,
        creator: ContractAddress,
        description: ByteArray,
        end_time: u64,
        goal: u256,
        #[substorage(v0)]
        ownable: ownable_component::Storage,
        #[substorage(v0)]
        pledges: pledgeable_component::Storage,
        start_time: u64,
        title: ByteArray,
        token: IERC20Dispatcher,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        Claimed: Claimed,
        Canceled: Canceled,
        #[flat]
        OwnableEvent: ownable_component::Event,
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
    }

    #[derive(Drop, starknet::Event)]
    pub struct Claimed {
        pub amount: u256,
    }

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

    const NINETY_DAYS: u64 = consteval_int!(90 * 24 * 60 * 60);

    #[constructor]
    fn constructor(
        ref self: ContractState,
        creator: ContractAddress,
        title: ByteArray,
        description: ByteArray,
        goal: u256,
        start_time: u64,
        end_time: u64,
        token_address: ContractAddress,
    ) {
        assert(creator.is_non_zero(), Errors::CREATOR_ZERO);
        assert(title.len() > 0, Errors::TITLE_EMPTY);
        assert(goal > 0, Errors::ZERO_GOAL);
        assert(start_time >= get_block_timestamp(), Errors::START_TIME_IN_PAST);
        assert(end_time >= start_time, Errors::END_BEFORE_START);
        assert(end_time <= get_block_timestamp() + NINETY_DAYS, Errors::END_BIGGER_THAN_MAX);
        assert(token_address.is_non_zero(), Errors::ZERO_ADDRESS_TOKEN);

        self.creator.write(creator);
        self.title.write(title);
        self.goal.write(goal);
        self.description.write(description);
        self.start_time.write(start_time);
        self.end_time.write(end_time);
        self.token.write(IERC20Dispatcher { contract_address: token_address });
        self.ownable._init(get_caller_address());
    }

    #[abi(embed_v0)]
    impl MockUpgrade of ICampaign<ContractState> {
        fn cancel(ref self: ContractState, reason: ByteArray) {
            self._assert_only_creator();
            assert(!self.canceled.read(), Errors::CANCELED);
            assert(!self.claimed.read(), Errors::CLAIMED);

            self.canceled.write(true);

            self._refund_all(reason.clone());

            self.emit(Event::Canceled(Canceled { reason }));
        }

        fn claim(ref self: ContractState) {
            self._assert_only_creator();
            assert(self._is_started(), Errors::NOT_STARTED);
            assert(self._is_ended(), Errors::STILL_ACTIVE);
            assert(self._is_goal_reached(), Errors::GOAL_NOT_REACHED);
            assert(!self.claimed.read(), Errors::CLAIMED);

            let this = get_contract_address();
            let token = self.token.read();
            let amount = token.balance_of(this);
            assert(amount > 0, Errors::ZERO_PLEDGES);

            self.claimed.write(true);

            // no need to reset the pledges, as the campaign has ended
            // and the data can be used as a testament to how much was raised

            let owner = get_caller_address();
            let success = token.transfer(owner, amount);
            assert(success, Errors::TRANSFER_FAILED);

            self.emit(Event::Claimed(Claimed { amount }));
        }

        fn get_details(self: @ContractState) -> Details {
            Details {
                creator: self.creator.read(),
                title: self.title.read(),
                description: self.description.read(),
                goal: self.goal.read(),
                start_time: self.start_time.read(),
                end_time: self.end_time.read(),
                claimed: self.claimed.read(),
                canceled: self.canceled.read(),
                token: self.token.read().contract_address,
                total_pledges: self.pledges.get_total(),
            }
        }

        fn get_pledge(self: @ContractState, pledger: ContractAddress) -> u256 {
            self.pledges.get(pledger)
        }

        fn get_pledgers(self: @ContractState) -> Array<ContractAddress> {
            self.pledges.array()
        }

        fn pledge(ref self: ContractState, amount: u256) {
            assert(self._is_started(), Errors::NOT_STARTED);
            assert(!self._is_ended(), Errors::ENDED);
            assert(!self.canceled.read(), Errors::CANCELED);
            assert(amount > 0, Errors::ZERO_DONATION);

            let pledger = get_caller_address();
            let this = get_contract_address();
            let success = self.token.read().transfer_from(pledger, this, amount);
            assert(success, Errors::TRANSFER_FAILED);

            self.pledges.add(pledger, amount);

            self.emit(Event::PledgeMade(PledgeMade { pledger, amount }));
        }

        fn refund(ref self: ContractState, pledger: ContractAddress, reason: ByteArray) {
            self._assert_only_creator();
            assert(self._is_started(), Errors::NOT_STARTED);
            assert(!self.claimed.read(), Errors::CLAIMED);
            assert(!self.canceled.read(), Errors::CANCELED);
            assert(pledger.is_non_zero(), Errors::ZERO_ADDRESS_PLEDGER);
            assert(self.pledges.get(pledger) != 0, Errors::NOTHING_TO_REFUND);

            let amount = self._refund(pledger);

            self.emit(Event::Refunded(Refunded { pledger, amount, reason }))
        }

        fn unpledge(ref self: ContractState, reason: ByteArray) {
            assert(self._is_started(), Errors::NOT_STARTED);
            assert(!self._is_goal_reached(), Errors::PLEDGES_LOCKED);
            assert(self.pledges.get(get_caller_address()) != 0, Errors::NOTHING_TO_UNPLEDGE);

            let pledger = get_caller_address();
            let amount = self._refund(pledger);

            self.emit(Event::Unpledged(Unpledged { pledger, amount, reason }));
        }

        fn upgrade(ref self: ContractState, impl_hash: ClassHash, new_end_time: Option<u64>) {
            self.ownable._assert_only_owner();
            assert(impl_hash.is_non_zero(), Errors::CLASS_HASH_ZERO);

            // only active campaigns have funds to refund and an end time to update
            if self._is_started() {
                if let Option::Some(end_time) = new_end_time {
                    assert(end_time >= get_block_timestamp(), Errors::END_BEFORE_NOW);
                    assert(
                        end_time <= get_block_timestamp() + NINETY_DAYS, Errors::END_BIGGER_THAN_MAX
                    );
                    self.end_time.write(end_time);
                };
                self._refund_all("contract upgraded");
            }

            starknet::syscalls::replace_class_syscall(impl_hash).unwrap_syscall();

            self.emit(Event::Upgraded(Upgraded { implementation: impl_hash }));
        }
    }

    #[generate_trait]
    impl MockUpgradeInternalImpl of MockUpgradeInternalTrait {
        fn _assert_only_creator(self: @ContractState) {
            let caller = get_caller_address();
            assert(caller.is_non_zero(), Errors::ZERO_ADDRESS_CALLER);
            assert(caller == self.creator.read(), Errors::NOT_CREATOR);
        }

        fn _is_ended(self: @ContractState) -> bool {
            get_block_timestamp() >= self.end_time.read()
        }

        fn _is_goal_reached(self: @ContractState) -> bool {
            self.pledges.get_total() >= self.goal.read()
        }

        fn _is_started(self: @ContractState) -> bool {
            get_block_timestamp() >= self.start_time.read()
        }

        fn _refund(ref self: ContractState, pledger: ContractAddress) -> u256 {
            let amount = self.pledges.remove(pledger);

            let success = self.token.read().transfer(pledger, amount);
            assert(success, Errors::TRANSFER_FAILED);

            amount
        }

        fn _refund_all(ref self: ContractState, reason: ByteArray) {
            let mut pledges = self.pledges.array();
            while let Option::Some(pledger) = pledges.pop_front() {
                self._refund(pledger);
            };
            self.emit(Event::RefundedAll(RefundedAll { reason }));
        }
    }
}
