// ANCHOR: contract
pub use starknet::{ContractAddress, ClassHash};

#[starknet::interface]
pub trait ICampaignFactory<TContractState> {
    fn create_campaign(
        ref self: TContractState,
        title: ByteArray,
        description: ByteArray,
        target: u256,
        duration: u64,
        token_address: ContractAddress
    ) -> ContractAddress;
    fn get_campaign_class_hash(self: @TContractState) -> ClassHash;
    fn update_campaign_class_hash(ref self: TContractState, new_class_hash: ClassHash);
}

#[starknet::contract]
pub mod CampaignFactory {
    use core::num::traits::zero::Zero;
    use starknet::{
        ContractAddress, ClassHash, SyscallResultTrait, syscalls::deploy_syscall,
        get_caller_address, get_contract_address
    };
    use alexandria_storage::list::{List, ListTrait};
    use crowdfunding::campaign::{ICampaignDispatcher, ICampaignDispatcherTrait};
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
        ClassHashUpdateFailed: ClassHashUpdateFailed,
        CampaignCreated: CampaignCreated,
    }

    #[derive(Drop, starknet::Event)]
    pub struct ClassHashUpdated {
        pub new_class_hash: ClassHash,
    }

    #[derive(Drop, starknet::Event)]
    pub struct ClassHashUpdateFailed {
        pub campaign: ContractAddress,
        pub errors: Array<felt252>
    }

    #[derive(Drop, starknet::Event)]
    pub struct CampaignCreated {
        pub caller: ContractAddress,
        pub contract_address: ContractAddress
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
    impl CampaignFactory of super::ICampaignFactory<ContractState> {
        // ANCHOR: deploy
        fn create_campaign(
            ref self: ContractState,
            title: ByteArray,
            description: ByteArray,
            target: u256,
            duration: u64,
            token_address: ContractAddress,
        ) -> ContractAddress {
            let caller = get_caller_address();

            // Create contructor arguments
            let mut constructor_calldata: Array::<felt252> = array![];
            ((caller, title, description, target), duration, token_address)
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

        fn get_campaign_class_hash(self: @ContractState) -> ClassHash {
            self.campaign_class_hash.read()
        }

        fn update_campaign_class_hash(ref self: ContractState, new_class_hash: ClassHash) {
            self.ownable._assert_only_owner();

            // update own campaign class hash value
            self.campaign_class_hash.write(new_class_hash);

            // upgrade each campaign with the new class hash
            let campaigns = self.campaigns.read();
            let mut i = 0;
            while let Option::Some(campaign) = campaigns
                .get(i)
                .unwrap_syscall() {
                    if let Result::Err(errors) = campaign.upgrade(new_class_hash) {
                        self
                            .emit(
                                Event::ClassHashUpdateFailed(
                                    ClassHashUpdateFailed {
                                        campaign: campaign.contract_address, errors
                                    }
                                )
                            )
                    }
                    i += 1;
                };

            self.emit(Event::ClassHashUpdated(ClassHashUpdated { new_class_hash }));
        }
    }
}
// ANCHOR_END: contract


