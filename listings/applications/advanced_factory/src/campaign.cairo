#[starknet::interface]
pub trait ICampaign<TContractState> {
    fn get_current_count(self: @TContractState) -> u128;
    fn increment(ref self: TContractState);
    fn decrement(ref self: TContractState);
}


#[starknet::contract]
pub mod Campaign {
    use components::ownable::ownable_component::OwnableInternalTrait;
    use core::num::traits::zero::Zero;
    use starknet::{
        ClassHash, ContractAddress, get_block_timestamp, syscalls::replace_class_syscall,
        get_caller_address
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
        donations: LegacyMap<ContractAddress, u128>,
        end_time: u64,
        factory: ContractAddress,
        target: u128,
        total_donations: u128,
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
        pub amount: u128,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Withdrawn {
        pub amount: u128,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Upgraded {
        pub implementation: ClassHash
    }

    pub mod Errors {
        pub const NOT_FACTORY: felt252 = 'Not factory';
        pub const INACTIVE: felt252 = 'Campaign no longer active';
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        creator: ContractAddress,
        target: u128,
        duration: u64,
        factory: ContractAddress
    ) {
        assert(factory.is_non_zero(), 'factory address zero');
        assert(creator.is_non_zero(), 'creator address zero');
        assert(target > 0, 'target == 0');
        assert(duration > 0, 'duration == 0');

        self.target.write(target);
        self.end_time.write(get_block_timestamp() + duration);
        self.factory.write(factory);
        self.ownable._init(creator);
    }
    // #[abi(embed_v0)]
    // impl Campaign of super::ICampaign<ContractState> {

    // }

    #[generate_trait]
    impl CampaignInternal of CampaignInternalTrait {
        fn _assert_only_factory(self: @ContractState) {
            let caller = get_caller_address();
            assert(caller == self.factory.read(), Errors::NOT_FACTORY);
        }

        fn _assert_only_active(self: @ContractState) {
            assert(get_block_timestamp() < self.end_time.read(), Errors::INACTIVE);
        }
    }
}
