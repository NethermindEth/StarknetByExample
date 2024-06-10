use core::clone::Clone;
use core::result::ResultTrait;
use advanced_factory::factory::{
    ICrowdfundingFactoryDispatcher, ICrowdfundingFactoryDispatcherTrait
};
use starknet::{ContractAddress, ClassHash, get_block_timestamp, contract_address_const};
use snforge_std::{declare, ContractClass, ContractClassTrait, start_cheat_caller_address};

// Define a target contract to deploy
use advanced_factory::campaign::{ICampaignDispatcher, ICampaignDispatcherTrait};
use components::ownable::{IOwnableDispatcher, IOwnableDispatcherTrait};

/// Deploy a campaign factory contract
fn deploy_factory(campaign_class_hash: ClassHash) -> ICrowdfundingFactoryDispatcher {
    let mut constructor_calldata: @Array::<felt252> = @array![campaign_class_hash.into()];

    let contract = declare("CrowdfundingFactory").unwrap();
    let (contract_address, _) = contract.deploy(constructor_calldata).unwrap();

    ICrowdfundingFactoryDispatcher { contract_address }
}

#[test]
fn test_deploy_campaign_constructor() {
    let campaign_class_hash = declare("Campaign").unwrap().class_hash;
    let factory = deploy_factory(campaign_class_hash);

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


