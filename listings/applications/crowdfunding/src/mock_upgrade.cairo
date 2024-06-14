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
    use crowdfunding::campaign::pledges::pledgeable_component;
    use crowdfunding::campaign::{ICampaign, Details, Status, Campaign::Errors};

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
        target: u256,
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
        Launched: Launched,
        Claimed: Claimed,
        Canceled: Canceled,
        PledgeableEvent: pledgeable_component::Event,
        PledgeMade: PledgeMade,
        Refunded: Refunded,
        Upgraded: Upgraded,
        Unpledged: Unpledged,
        RefundedAll: RefundedAll,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Launched {}

    #[derive(Drop, starknet::Event)]
    pub struct PledgeMade {
        #[key]
        pub contributor: ContractAddress,
        pub amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Claimed {
        pub amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Canceled {
        pub reason: ByteArray,
        pub status: Status,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Refunded {
        #[key]
        pub contributor: ContractAddress,
        pub amount: u256,
        pub reason: ByteArray,
    }

    #[derive(Drop, starknet::Event)]
    pub struct RefundedAll {
        pub reason: ByteArray,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Upgraded {
        pub implementation: ClassHash
    }

    #[derive(Drop, starknet::Event)]
    pub struct Unpledged {
        #[key]
        pub contributor: ContractAddress,
        pub amount: u256,
        pub reason: ByteArray,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        creator: ContractAddress,
        title: ByteArray,
        description: ByteArray,
        target: u256,
        token_address: ContractAddress,
    // TODO: add recepient address
    ) {
        assert(creator.is_non_zero(), Errors::CREATOR_ZERO);
        assert(title.len() > 0, Errors::TITLE_EMPTY);
        assert(target > 0, Errors::ZERO_TARGET);

        self.token.write(IERC20Dispatcher { contract_address: token_address });

        self.title.write(title);
        self.target.write(target);
        self.description.write(description);
        self.creator.write(creator);
        self.ownable._init(get_caller_address());
        self.status.write(Status::DRAFT)
    }

    #[abi(embed_v0)]
    impl MockUpgrade of ICampaign<ContractState> {
        fn claim(ref self: ContractState) {
            self._assert_only_creator();
            assert(self._is_active() && self._is_expired(), Errors::STILL_ACTIVE);
            assert(self._is_target_reached(), Errors::TARGET_NOT_REACHED);

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
            assert(self._is_active(), Errors::ENDED);

            if !self._is_target_reached() && self._is_expired() {
                self.status.write(Status::FAILED);
            } else {
                self.status.write(Status::CLOSED);
            }

            self._refund_all(reason.clone());
            let status = self.status.read();

            self.emit(Event::Canceled(Canceled { reason, status }));
        }

        fn pledge(ref self: ContractState, amount: u256) {
            assert(self.status.read() != Status::DRAFT, Errors::STILL_DRAFT);
            assert(self._is_active() && !self._is_expired(), Errors::ENDED);
            assert(amount > 0, Errors::ZERO_DONATION);

            let contributor = get_caller_address();
            let this = get_contract_address();
            let success = self.token.read().transfer_from(contributor, this, amount);
            assert(success, Errors::TRANSFER_FAILED);

            self.pledges.add(contributor, amount);
            self.total_pledges.write(self.total_pledges.read() + amount);

            self.emit(Event::PledgeMade(PledgeMade { contributor, amount }));
        }

        fn get_pledge(self: @ContractState, contributor: ContractAddress) -> u256 {
            self.pledges.get(contributor)
        }

        fn get_pledges(self: @ContractState) -> Array<(ContractAddress, u256)> {
            self.pledges.get_pledges_as_arr()
        }

        fn get_details(self: @ContractState) -> Details {
            Details {
                creator: self.creator.read(),
                title: self.title.read(),
                description: self.description.read(),
                target: self.target.read(),
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

        fn refund(ref self: ContractState, contributor: ContractAddress, reason: ByteArray) {
            self._assert_only_creator();
            assert(contributor.is_non_zero(), Errors::ZERO_ADDRESS_CONTRIBUTOR);
            assert(self.status.read() != Status::DRAFT, Errors::STILL_DRAFT);
            assert(self._is_active(), Errors::ENDED);
            assert(self.pledges.get(contributor) != 0, Errors::NOTHING_TO_REFUND);

            let amount = self._refund(contributor);

            self.emit(Event::Refunded(Refunded { contributor, amount, reason }))
        }

        /// There are currently 3 possibilities for performing contract upgrades:
        ///  1. Trust the campaign factory owner -> this is suboptimal, as factory owners have no responsibility to either creators or contributors,
        ///     and there's nothing stopping them from implementing a malicious upgrade.
        ///  2. Trust the campaign creator -> the contributors already trust the campaign creator that they'll do what they promised in the campaign.
        ///     It's not a stretch to trust them with verifying that the contract upgrade is necessary. 
        ///  3. Trust no one, contract upgrades are forbidden -> could be a problem if a vulnerability is discovered and campaign funds are in danger.
        /// 
        /// This function implements the 2nd option, as it seems to be the most optimal solution, especially from the point of view of what to do if
        /// any of the upgrades fail for whatever reason - campaign creator is solely responsible for upgrading their contracts. 
        /// 
        /// To improve contributor trust, contract upgrades refund all of contributor funds, so that on the off chance that the creator is in cahoots
        /// with factory owners to implement a malicious upgrade, the contributor funds would be returned.
        /// There are some problems with this though:
        ///  - contributors wouldn't have even been donating if they weren't trusting the creator - since the funds end up with them in the end, they
        ///    have to trust that creators would use the campaign funds as they promised when creating the campaign.
        ///  - since the funds end up with the creators, they have no incentive to implement a malicious upgrade - they'll have the funds either way.
        ///  - each time there's an upgrade, the campaign gets reset, which introduces a new problem - what if the Campaign was close to ending?
        ///    We just took all of their pledges away, and there might not be enough time to get them back. We solve this by letting the creators
        ///    prolong the duration of the campaign.
        fn upgrade(ref self: ContractState, impl_hash: ClassHash, new_duration: Option<u64>) {
            self.ownable._assert_only_owner();
            assert(impl_hash.is_non_zero(), Errors::CLASS_HASH_ZERO);
            assert(
                self.status.read() == Status::ACTIVE || self.status.read() == Status::DRAFT,
                Errors::ENDED
            );

            // only active campaigns have funds to refund and duration to update
            if self.status.read() == Status::ACTIVE {
                let duration = match new_duration {
                    Option::Some(val) => val,
                    Option::None => 0,
                };
                assert(duration > 0, Errors::ZERO_DURATION);
                self._refund_all("contract upgraded");
                self.total_pledges.write(0);
                self.end_time.write(get_block_timestamp() + duration);
            }

            starknet::syscalls::replace_class_syscall(impl_hash).unwrap_syscall();

            self.emit(Event::Upgraded(Upgraded { implementation: impl_hash }));
        }

        fn unpledge(ref self: ContractState, reason: ByteArray) {
            assert(self.status.read() != Status::DRAFT, Errors::STILL_DRAFT);
            assert(self.status.read() != Status::SUCCESSFUL, Errors::ENDED);
            assert(self.status.read() != Status::CLOSED, Errors::CLOSED);
            assert(!self._is_target_reached(), Errors::TARGET_ALREADY_REACHED);
            assert(self.pledges.get(get_caller_address()) != 0, Errors::NOTHING_TO_WITHDRAW);

            let contributor = get_caller_address();
            let amount = self.pledges.remove(contributor);

            // no need to set total_pledges to 0, as the campaign has ended
            // and the field can be used as a testament to how much was raised

            let success = self.token.read().transfer(contributor, amount);
            assert(success, Errors::TRANSFER_FAILED);

            self.emit(Event::Unpledged(Unpledged { contributor, amount, reason }));
        }
    }

    #[generate_trait]
    impl MockUpgradeInternalImpl of CampaignInternalTrait {
        fn _assert_only_creator(self: @ContractState) {
            let caller = get_caller_address();
            assert(caller.is_non_zero(), Errors::ZERO_ADDRESS_CALLER);
            assert(caller == self.creator.read(), Errors::NOT_CREATOR);
        }

        fn _is_expired(self: @ContractState) -> bool {
            get_block_timestamp() >= self.end_time.read()
        }

        fn _is_active(self: @ContractState) -> bool {
            self.status.read() == Status::ACTIVE
        }

        fn _is_target_reached(self: @ContractState) -> bool {
            self.total_pledges.read() >= self.target.read()
        }

        fn _refund(ref self: ContractState, contributor: ContractAddress) -> u256 {
            let amount = self.pledges.remove(contributor);

            // if the campaign is "failed", then there's no need to set total_pledges to 0, as
            // the campaign has ended and the field can be used as a testament to how much was raised
            if self.status.read() == Status::ACTIVE {
                self.total_pledges.write(self.total_pledges.read() - amount);
            }

            let success = self.token.read().transfer(contributor, amount);
            assert(success, Errors::TRANSFER_FAILED);

            amount
        }

        fn _refund_all(ref self: ContractState, reason: ByteArray) {
            let mut pledges = self.pledges.get_pledges_as_arr();
            while let Option::Some((contributor, _)) = pledges
                .pop_front() {
                    self._refund(contributor);
                };
            self.emit(Event::RefundedAll(RefundedAll { reason }));
        }
    }
}
