use starknet::ClassHash;

#[starknet::interface]
pub trait ICampaign<TContractState> {
    fn donate(ref self: TContractState, amount: u256);
    fn withdraw(ref self: TContractState);
    fn upgrade(ref self: TContractState, impl_hash: ClassHash);
}

#[starknet::contract]
pub mod Campaign {
    use components::ownable::ownable_component::OwnableInternalTrait;
    use core::num::traits::zero::Zero;
    use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};
    use starknet::{
        ClassHash, ContractAddress, get_block_timestamp, contract_address_const,
        syscalls::replace_class_syscall, get_caller_address, get_contract_address
    };
    use components::ownable::ownable_component;

    component!(path: ownable_component, storage: ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl OwnableImpl = ownable_component::Ownable<ContractState>;
    impl OwnableInternalImpl = ownable_component::OwnableInternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        ownable: ownable_component::Storage,
        donations: LegacyMap<ContractAddress, u256>,
        end_time: u64,
        eth_token: IERC20Dispatcher,
        factory: ContractAddress,
        target: u256,
        total_donations: u256,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        #[flat]
        OwnableEvent: ownable_component::Event,
        Donated: Donated,
        Withdrawn: Withdrawn,
        Upgraded: Upgraded,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Donated {
        #[key]
        pub donor: ContractAddress,
        pub amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Withdrawn {
        pub amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Upgraded {
        pub implementation: ClassHash
    }

    pub mod Errors {
        pub const NOT_FACTORY: felt252 = 'Caller not factory';
        pub const INACTIVE: felt252 = 'Campaign already ended';
        pub const STILL_ACTIVE: felt252 = 'Campaign not ended';
        pub const ZERO_DONATION: felt252 = 'Donation must be > 0';
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        creator: ContractAddress,
        target: u256,
        duration: u64,
        factory: ContractAddress
    ) {
        assert(factory.is_non_zero(), 'factory address zero');
        assert(creator.is_non_zero(), 'creator address zero');
        assert(target > 0, 'target == 0');
        assert(duration > 0, 'duration == 0');

        let eth_address = contract_address_const::<
            0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7
        >();
        self.eth_token.write(IERC20Dispatcher { contract_address: eth_address });

        self.target.write(target);
        self.end_time.write(get_block_timestamp() + duration);
        self.factory.write(factory);
        self.ownable._init(creator);
    }

    #[abi(embed_v0)]
    impl Campaign of super::ICampaign<ContractState> {
        fn donate(ref self: ContractState, amount: u256) {
            self._assert_campaign_active();
            assert(amount > 0, Errors::ZERO_DONATION);

            let donor = get_caller_address();
            let this = get_contract_address();
            self.eth_token.read().transfer_from(donor, this, amount);

            self.donations.write(donor, self.donations.read(donor) + amount);
            self.total_donations.write(self.total_donations.read() + amount);

            self.emit(Event::Donated(Donated { donor, amount }));
        }

        fn withdraw(ref self: ContractState) {}

        fn upgrade(ref self: ContractState, impl_hash: ClassHash) {}
    }

    #[generate_trait]
    impl CampaignInternal of CampaignInternalTrait {
        fn _assert_only_factory(self: @ContractState) {
            let caller = get_caller_address();
            assert(caller == self.factory.read(), Errors::NOT_FACTORY);
        }

        fn _assert_campaign_active(self: @ContractState) {
            assert(get_block_timestamp() < self.end_time.read(), Errors::INACTIVE);
        }

        fn _assert_is_ended(self: @ContractState) {
            assert(get_block_timestamp() >= self.end_time.read(), Errors::STILL_ACTIVE);
        }
    }
}
