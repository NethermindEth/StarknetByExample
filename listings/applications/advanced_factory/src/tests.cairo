use advanced_factory::contract::{
    CampaignFactory, ICampaignFactoryDispatcher, ICampaignFactoryDispatcherTrait
};
use starknet::{
    ContractAddress, ClassHash, get_block_timestamp, contract_address_const, get_caller_address
};
use snforge_std::{
    declare, ContractClass, ContractClassTrait, start_cheat_caller_address,
    stop_cheat_caller_address, spy_events, SpyOn, EventSpy, EventAssertions, get_class_hash
};

// Define a goal contract to deploy
use crowdfunding::campaign::{Campaign, ICampaignDispatcher, ICampaignDispatcherTrait};
use components::ownable::{IOwnableDispatcher, IOwnableDispatcherTrait};


/// Deploy a campaign factory contract with the provided campaign class hash
fn deploy_factory_with(campaign_class_hash: ClassHash) -> ICampaignFactoryDispatcher {
    let mut constructor_calldata: @Array::<felt252> = @array![campaign_class_hash.into()];

    let contract = declare("CampaignFactory").unwrap();
    let contract_address = contract.precalculate_address(constructor_calldata);
    let factory_owner: ContractAddress = contract_address_const::<'factory_owner'>();
    start_cheat_caller_address(contract_address, factory_owner);

    contract.deploy(constructor_calldata).unwrap();

    stop_cheat_caller_address(contract_address);

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
fn test_create_campaign() {
    let factory = deploy_factory();

    let mut spy = spy_events(SpyOn::One(factory.contract_address));

    let campaign_creator: ContractAddress = contract_address_const::<'campaign_creator'>();
    start_cheat_caller_address(factory.contract_address, campaign_creator);

    let title: ByteArray = "New campaign";
    let description: ByteArray = "Some description";
    let goal: u256 = 10000;
    let start_time = get_block_timestamp();
    let end_time = start_time + 60;
    let token = contract_address_const::<'token'>();

    let campaign_address = factory
        .create_campaign(title.clone(), description.clone(), goal, start_time, end_time, token);
    let campaign = ICampaignDispatcher { contract_address: campaign_address };

    let details = campaign.get_details();
    assert_eq!(details.title, title);
    assert_eq!(details.description, description);
    assert_eq!(details.goal, goal);
    assert_eq!(details.start_time, start_time);
    assert_eq!(details.end_time, end_time);
    assert_eq!(details.claimed, false);
    assert_eq!(details.canceled, false);
    assert_eq!(details.token, token);
    assert_eq!(details.total_pledges, 0);
    assert_eq!(details.creator, campaign_creator);

    let campaign_ownable = IOwnableDispatcher { contract_address: campaign_address };
    assert_eq!(campaign_ownable.owner(), factory.contract_address);

    spy
        .assert_emitted(
            @array![
                (
                    factory.contract_address,
                    CampaignFactory::Event::CampaignCreated(
                        CampaignFactory::CampaignCreated {
                            creator: campaign_creator, contract_address: campaign_address
                        }
                    )
                )
            ]
        );
}

#[test]
fn test_uprade_campaign_class_hash() {
    let factory = deploy_factory();
    let old_class_hash = factory.get_campaign_class_hash();
    let new_class_hash = declare("MockContract").unwrap().class_hash;

    let token = contract_address_const::<'token'>();

    // deploy a pending campaign with the old class hash
    let start_time_pending = get_block_timestamp() + 20;
    let end_time_pending = start_time_pending + 60;
    let pending_campaign_creator = contract_address_const::<'pending_campaign_creator'>();
    start_cheat_caller_address(factory.contract_address, pending_campaign_creator);
    let pending_campaign = factory
        .create_campaign(
            "title 1", "description 1", 10000, start_time_pending, end_time_pending, token
        );

    assert_eq!(old_class_hash, get_class_hash(pending_campaign));

    // deploy an active campaign with the old class hash
    let start_time_active = get_block_timestamp();
    let end_time_active = start_time_active + 60;
    let active_campaign_creator = contract_address_const::<'active_campaign_creator'>();
    start_cheat_caller_address(factory.contract_address, active_campaign_creator);
    let active_campaign = factory
        .create_campaign(
            "title 2", "description 2", 20000, start_time_active, end_time_active, token
        );

    assert_eq!(old_class_hash, get_class_hash(active_campaign));

    // update the factory's campaign class hash value
    let mut spy = spy_events(
        SpyOn::Multiple(array![factory.contract_address, pending_campaign, active_campaign])
    );

    let factory_owner = contract_address_const::<'factory_owner'>();
    start_cheat_caller_address(factory.contract_address, factory_owner);
    factory.update_campaign_class_hash(new_class_hash);

    assert_eq!(factory.get_campaign_class_hash(), new_class_hash);
    assert_eq!(old_class_hash, get_class_hash(pending_campaign));
    assert_eq!(old_class_hash, get_class_hash(active_campaign));

    spy
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

    // upgrade pending campaign
    start_cheat_caller_address(factory.contract_address, pending_campaign_creator);
    factory.upgrade_campaign(pending_campaign, Option::None);

    assert_eq!(get_class_hash(pending_campaign), new_class_hash);
    assert_eq!(get_class_hash(active_campaign), old_class_hash);

    spy
        .assert_emitted(
            @array![
                (
                    pending_campaign,
                    Campaign::Event::Upgraded(Campaign::Upgraded { implementation: new_class_hash })
                )
            ]
        );

    // upgrade active campaign
    start_cheat_caller_address(factory.contract_address, active_campaign_creator);
    factory.upgrade_campaign(active_campaign, Option::None);

    assert_eq!(get_class_hash(pending_campaign), new_class_hash);
    assert_eq!(get_class_hash(active_campaign), new_class_hash);

    spy
        .assert_emitted(
            @array![
                (
                    active_campaign,
                    Campaign::Event::Upgraded(Campaign::Upgraded { implementation: new_class_hash })
                )
            ]
        );
}
