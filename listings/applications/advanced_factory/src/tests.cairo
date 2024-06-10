use core::clone::Clone;
use core::result::ResultTrait;
use advanced_factory::factory::{
    ICrowdfundingFactoryDispatcher, ICrowdfundingFactoryDispatcherTrait
};
use starknet::{
    ContractAddress, ClassHash, get_block_timestamp, contract_address_const, get_caller_address
};
use snforge_std::{declare, ContractClass, ContractClassTrait, start_cheat_caller_address};

// Define a target contract to deploy
use advanced_factory::campaign::{ICampaignDispatcher, ICampaignDispatcherTrait};
use components::ownable::{IOwnableDispatcher, IOwnableDispatcherTrait};


/// Deploy a campaign factory contract with the provided campaign class hash
fn deploy_factory_with(campaign_class_hash: ClassHash) -> ICrowdfundingFactoryDispatcher {
    let mut constructor_calldata: @Array::<felt252> = @array![campaign_class_hash.into()];

    let contract = declare("CrowdfundingFactory").unwrap();
    let contract_address = contract.precalculate_address(constructor_calldata);
    let factory_owner: ContractAddress = contract_address_const::<'factory_owner'>();
    start_cheat_caller_address(contract_address, factory_owner);

    contract.deploy(constructor_calldata).unwrap();

    ICrowdfundingFactoryDispatcher { contract_address }
}

/// Deploy a campaign factory contract with default campaign class hash
fn deploy_factory() -> ICrowdfundingFactoryDispatcher {
    let campaign_class_hash = declare("Campaign").unwrap().class_hash;
    deploy_factory_with(campaign_class_hash)
}

#[test]
fn test_deploy_factory() {
    let campaign_class_hash = declare("Campaign").unwrap().class_hash;
    let factory = deploy_factory_with(campaign_class_hash);

    assert_eq!(factory.get_campaign_class_hash(), campaign_class_hash);

    let factory_owner: ContractAddress = contract_address_const::<'factory_owner'>();
    let factory_ownable = IOwnableDispatcher { contract_address: factory.contract_address };
    assert_eq!(factory_ownable.owner(), factory_owner);
}

#[test]
fn test_deploy_campaign() {
    let factory = deploy_factory();

    let campaign_owner: ContractAddress = contract_address_const::<'campaign_owner'>();
    start_cheat_caller_address(factory.contract_address, campaign_owner);

    let title: ByteArray = "New campaign";
    let description: ByteArray = "Some description";
    let target: u256 = 10000;
    let duration: u64 = 60;

    let campaign_address = factory
        .create_campaign(title.clone(), description.clone(), target, duration);
    let campaign = ICampaignDispatcher { contract_address: campaign_address };

    assert_eq!(campaign.get_title(), title);
    assert_eq!(campaign.get_description(), description);
    assert_eq!(campaign.get_target(), target);
    assert_eq!(campaign.get_end_time(), get_block_timestamp() + duration);

    let campaign_ownable = IOwnableDispatcher { contract_address: campaign.contract_address };
    assert_eq!(campaign_ownable.owner(), campaign_owner);
}
// #[test]
// fn test_deploy_campaign_argument() {
//     let init_value = 10;
//     let argument_value = 20;

//     let campaign_class_hash = declare("Campaign").unwrap().class_hash;
//     let factory = deploy_factory(campaign_class_hash, init_value);

//     let campaign_address = factory.create_campaign_at(argument_value);
//     let campaign = ICampaignDispatcher { contract_address: campaign_address };

//     assert_eq!(campaign.get_current_count(), argument_value);
// }

// #[test]
// fn test_deploy_multiple() {
//     let init_value = 10;
//     let argument_value = 20;

//     let campaign_class_hash = declare("Campaign").unwrap().class_hash;
//     let factory = deploy_factory(campaign_class_hash, init_value);

//     let mut campaign_address = factory.create_campaign();
//     let campaign_1 = ICampaignDispatcher { contract_address: campaign_address };

//     campaign_address = factory.create_campaign_at(argument_value);
//     let campaign_2 = ICampaignDispatcher { contract_address: campaign_address };

//     assert_eq!(campaign_1.get_current_count(), init_value);
//     assert_eq!(campaign_2.get_current_count(), argument_value);
// }


