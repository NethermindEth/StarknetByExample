use core::traits::TryInto;
use core::clone::Clone;
use core::result::ResultTrait;
use advanced_factory::contract::{
    CampaignFactory, ICampaignFactoryDispatcher, ICampaignFactoryDispatcherTrait
};
use starknet::{
    ContractAddress, ClassHash, get_block_timestamp, contract_address_const, get_caller_address
};
use snforge_std::{
    declare, ContractClass, ContractClassTrait, start_cheat_caller_address, spy_events, SpyOn,
    EventSpy, EventAssertions, get_class_hash
};

// Define a target contract to deploy
use crowdfunding::campaign::{Campaign, ICampaignDispatcher, ICampaignDispatcherTrait};
use crowdfunding::campaign::Status;
use components::ownable::{IOwnableDispatcher, IOwnableDispatcherTrait};


/// Deploy a campaign factory contract with the provided campaign class hash
fn deploy_factory_with(campaign_class_hash: ClassHash) -> ICampaignFactoryDispatcher {
    let mut constructor_calldata: @Array::<felt252> = @array![campaign_class_hash.into()];

    let contract = declare("CampaignFactory").unwrap();
    let contract_address = contract.precalculate_address(constructor_calldata);
    let factory_owner: ContractAddress = contract_address_const::<'factory_owner'>();
    start_cheat_caller_address(contract_address, factory_owner);

    contract.deploy(constructor_calldata).unwrap();

    ICampaignFactoryDispatcher { contract_address }
}

/// Deploy a campaign factory contract with default campaign class hash
fn deploy_factory() -> ICampaignFactoryDispatcher {
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

    let mut spy = spy_events(SpyOn::One(factory.contract_address));

    let campaign_owner: ContractAddress = contract_address_const::<'campaign_owner'>();
    start_cheat_caller_address(factory.contract_address, campaign_owner);

    let title: ByteArray = "New campaign";
    let description: ByteArray = "Some description";
    let target: u256 = 10000;
    let duration: u64 = 60;
    let token = contract_address_const::<'token'>();

    let campaign_address = factory
        .create_campaign(title.clone(), description.clone(), target, duration, token);
    let campaign = ICampaignDispatcher { contract_address: campaign_address };

    let details = campaign.get_details();
    assert_eq!(details.title, title);
    assert_eq!(details.description, description);
    assert_eq!(details.target, target);
    assert_eq!(details.end_time, get_block_timestamp() + duration);
    assert_eq!(details.status, Status::PENDING);
    assert_eq!(details.token, token);
    assert_eq!(details.total_contributions, 0);

    let campaign_ownable = IOwnableDispatcher { contract_address: campaign_address };
    assert_eq!(campaign_ownable.owner(), campaign_owner);

    spy
        .assert_emitted(
            @array![
                (
                    factory.contract_address,
                    CampaignFactory::Event::CampaignCreated(
                        CampaignFactory::CampaignCreated {
                            caller: campaign_owner, contract_address: campaign_address
                        }
                    )
                )
            ]
        );
}

#[test]
fn test_update_campaign_class_hash() {
    let factory = deploy_factory();

    let token = contract_address_const::<'token'>();
    let campaign_address_1 = factory.create_campaign("title 1", "description 1", 10000, 60, token);
    let campaign_address_2 = factory.create_campaign("title 2", "description 2", 20000, 120, token);

    assert_eq!(factory.get_campaign_class_hash(), get_class_hash(campaign_address_1));
    assert_eq!(factory.get_campaign_class_hash(), get_class_hash(campaign_address_2));

    let mut spy_factory = spy_events(SpyOn::One(factory.contract_address));
    let mut spy_campaigns = spy_events(
        SpyOn::Multiple(array![campaign_address_1, campaign_address_2])
    );

    let new_class_hash = declare("MockContract").unwrap().class_hash;
    factory.update_campaign_class_hash(new_class_hash);

    assert_eq!(factory.get_campaign_class_hash(), new_class_hash);
    assert_eq!(get_class_hash(campaign_address_1), new_class_hash);
    assert_eq!(get_class_hash(campaign_address_2), new_class_hash);

    spy_factory
        .assert_emitted(
            @array![
                (
                    factory.contract_address,
                    CampaignFactory::Event::ClassHashUpdated(
                        CampaignFactory::ClassHashUpdated { new_class_hash }
                    )
                )
            ]
        );

    spy_campaigns
        .assert_emitted(
            @array![
                (
                    campaign_address_1,
                    Campaign::Event::Upgraded(Campaign::Upgraded { implementation: new_class_hash })
                ),
                (
                    campaign_address_2,
                    Campaign::Event::Upgraded(Campaign::Upgraded { implementation: new_class_hash })
                )
            ]
        );
}
