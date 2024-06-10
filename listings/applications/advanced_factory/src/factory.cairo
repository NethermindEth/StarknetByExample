// ANCHOR: contract
pub use starknet::{ContractAddress, ClassHash};

#[starknet::interface]
pub trait ICrowdfundingFactory<TContractState> {
    fn create_campaign(
        ref self: TContractState,
        title: ByteArray,
        description: ByteArray,
        target: u256,
        duration: u64
    ) -> ContractAddress;
    fn update_campaign_class_hash(ref self: TContractState, new_class_hash: ClassHash);
}

#[starknet::contract]
pub mod CrowdfundingFactory {
    use core::num::traits::zero::Zero;
    use starknet::{
        ContractAddress, ClassHash, SyscallResultTrait, syscalls::deploy_syscall,
        get_caller_address, get_contract_address
    };
    use alexandria_storage::list::{List, ListTrait};
    use advanced_factory::campaign::{ICampaignDispatcher, ICampaignDispatcherTrait};
    use components::ownable::ownable_component;

    component!(path: ownable_component, storage: ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl OwnableImpl = ownable_component::Ownable<ContractState>;
    impl OwnableInternalImpl = ownable_component::OwnableInternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        ownable: ownable_component::Storage,
        /// Store all of the created campaign instances' addresses
        campaigns: List<ICampaignDispatcher>,
        /// Store the class hash of the contract to deploy
        campaign_class_hash: ClassHash,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        #[flat]
        OwnableEvent: ownable_component::Event,
        ClassHashUpdated: ClassHashUpdated,
        CampaignCreated: CampaignCreated,
    }

    #[derive(Drop, starknet::Event)]
    struct ClassHashUpdated {
        new_class_hash: ClassHash,
    }

    #[derive(Drop, starknet::Event)]
    struct CampaignCreated {
        caller: ContractAddress,
        contract_address: ContractAddress
    }

    pub mod Errors {
        pub const CLASS_HASH_ZERO: felt252 = 'Class hash cannot be zero';
    }

    #[constructor]
    fn constructor(ref self: ContractState, class_hash: ClassHash) {
        assert(class_hash.is_non_zero(), Errors::CLASS_HASH_ZERO);
        self.campaign_class_hash.write(class_hash);
        self.ownable._init(get_caller_address());
    }


    #[abi(embed_v0)]
    impl CrowdfundingFactory of super::ICrowdfundingFactory<ContractState> {
        // ANCHOR: deploy
        fn create_campaign(
            ref self: ContractState,
            title: ByteArray,
            description: ByteArray,
            target: u256,
            duration: u64
        ) -> ContractAddress {
            let caller = get_caller_address();
            let this = get_contract_address();

            // Create contructor arguments
            let mut constructor_calldata: Array::<felt252> = array![];
            ((caller, title, description, target), duration, this)
                .serialize(ref constructor_calldata);

            // Contract deployment
            let (contract_address, _) = deploy_syscall(
                self.campaign_class_hash.read(), 0, constructor_calldata.span(), false
            )
                .unwrap_syscall();

            // track new campaign instance
            let mut campaigns = self.campaigns.read();
            campaigns.append(ICampaignDispatcher { contract_address }).unwrap();

            self.emit(Event::CampaignCreated(CampaignCreated { caller, contract_address }));

            contract_address
        }
        // ANCHOR_END: deploy

        fn update_campaign_class_hash(ref self: ContractState, new_class_hash: ClassHash) {
            self.ownable._assert_only_owner();

            // update own campaign class hash value
            self.campaign_class_hash.write(new_class_hash);

            // upgrade each campaign with the new class hash
            let campaigns = self.campaigns.read();
            let mut i = 0;
            while let Option::Some(campaign) = campaigns.get(i).unwrap_syscall() {
                campaign.upgrade(new_class_hash);
                i += 1;
            };

            self.emit(Event::ClassHashUpdated(ClassHashUpdated { new_class_hash }));
        }
    }
}
// ANCHOR_END: contract

