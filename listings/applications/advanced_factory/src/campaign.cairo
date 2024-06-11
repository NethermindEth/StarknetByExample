mod contributions;

// ANCHOR: contract
use starknet::ClassHash;

#[starknet::interface]
pub trait ICampaign<TContractState> {
    fn claim(ref self: TContractState);
    fn contribute(ref self: TContractState, amount: u256);
    fn get_description(self: @TContractState) -> ByteArray;
    fn get_title(self: @TContractState) -> ByteArray;
    fn get_target(self: @TContractState) -> u256;
    fn get_end_time(self: @TContractState) -> u64;
    fn upgrade(ref self: TContractState, impl_hash: ClassHash);
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
        eth_token: IERC20Dispatcher,
        factory: ContractAddress,
        target: u256,
        title: ByteArray,
        description: ByteArray,
        total_contributions: u256,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        #[flat]
        OwnableEvent: ownable_component::Event,
        ContributableEvent: contributable_component::Event,
        ContributionMade: ContributionMade,
        Claimed: Claimed,
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
        creator: ContractAddress,
        title: ByteArray,
        description: ByteArray,
        target: u256,
        duration: u64,
        factory: ContractAddress
    ) {
        assert(factory.is_non_zero(), Errors::FACTORY_ZERO);
        assert(creator.is_non_zero(), Errors::CREATOR_ZERO);
        assert(title.len() > 0, Errors::TITLE_EMPTY);
        assert(target > 0, Errors::ZERO_TARGET);
        assert(duration > 0, Errors::ZERO_DURATION);

        let eth_address = contract_address_const::<
            0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7
        >();
        self.eth_token.write(IERC20Dispatcher { contract_address: eth_address });

        self.title.write(title);
        self.target.write(target);
        self.description.write(description);
        self.end_time.write(get_block_timestamp() + duration);
        self.factory.write(factory);
        self.ownable._init(creator);
    }

    #[abi(embed_v0)]
    impl Campaign of super::ICampaign<ContractState> {
        fn claim(ref self: ContractState) {
            self.ownable._assert_only_owner();
            assert(!self._is_active(), Errors::STILL_ACTIVE);
            assert(self._is_target_reached(), Errors::TARGET_NOT_REACHED);

            let this = get_contract_address();
            let eth_token = self.eth_token.read();

            let amount = eth_token.balance_of(this);
            assert(amount > 0, Errors::ZERO_FUNDS);

            // no need to set total_contributions to 0, as the campaign has ended
            // and the field can be used as a testament to how much was raised

            let success = eth_token.transfer(get_caller_address(), amount);
            assert(success, Errors::TRANSFER_FAILED);

            self.emit(Event::Claimed(Claimed { amount }));
        }

        fn contribute(ref self: ContractState, amount: u256) {
            assert(self._is_active(), Errors::ENDED);
            assert(amount > 0, Errors::ZERO_DONATION);

            let contributor = get_caller_address();
            let this = get_contract_address();
            let success = self.eth_token.read().transfer_from(contributor, this, amount.into());
            assert(success, Errors::TRANSFER_FAILED);

            self.contributions.add(contributor, amount);
            self.total_contributions.write(self.total_contributions.read() + amount);

            self.emit(Event::ContributionMade(ContributionMade { contributor, amount }));
        }

        fn get_title(self: @ContractState) -> ByteArray {
            self.title.read()
        }

        fn get_description(self: @ContractState) -> ByteArray {
            self.description.read()
        }

        fn get_target(self: @ContractState) -> u256 {
            self.target.read()
        }

        fn get_end_time(self: @ContractState) -> u64 {
            self.end_time.read()
        }

        fn upgrade(ref self: ContractState, impl_hash: ClassHash) {
            assert(get_caller_address() == self.factory.read(), Errors::NOT_FACTORY);
            assert(impl_hash.is_non_zero(), Errors::CLASS_HASH_ZERO);

            starknet::syscalls::replace_class_syscall(impl_hash).unwrap_syscall();

            self.emit(Event::Upgraded(Upgraded { implementation: impl_hash }));
        }

        fn withdraw(ref self: ContractState) {
            assert(!self._is_active(), Errors::STILL_ACTIVE);
            assert(!self._is_target_reached(), Errors::TARGET_ALREADY_REACHED);
            assert(self.contributions.get(get_caller_address()) != 0, Errors::NOTHING_TO_WITHDRAW);

            let contributor = get_caller_address();
            let amount = self.contributions.withhold(contributor);

            // no need to set total_contributions to 0, as the campaign has ended
            // and the field can be used as a testament to how much was raised

            self.eth_token.read().transfer(contributor, amount);

            self.emit(Event::Withdrawn(Withdrawn { contributor, amount }));
        }
    }

    #[generate_trait]
    impl CampaignInternalImpl of CampaignInternalTrait {
        fn _is_active(self: @ContractState) -> bool {
            get_block_timestamp() < self.end_time.read()
        }

        fn _is_target_reached(self: @ContractState) -> bool {
            self.total_contributions.read() >= self.target.read()
        }
    }
}
// ANCHOR_END: contract


