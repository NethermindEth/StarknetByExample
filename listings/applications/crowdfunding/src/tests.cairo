use core::traits::TryInto;
use core::clone::Clone;
use core::result::ResultTrait;
use starknet::{
    ContractAddress, ClassHash, get_block_timestamp, contract_address_const, get_caller_address,
};
use snforge_std::{
    declare, ContractClass, ContractClassTrait, start_cheat_caller_address,
    stop_cheat_caller_address, spy_events, SpyOn, EventSpy, EventAssertions, get_class_hash
};

use crowdfunding::campaign::{Campaign, ICampaignDispatcher, ICampaignDispatcherTrait};
use crowdfunding::campaign::Status;
use components::ownable::{IOwnableDispatcher, IOwnableDispatcherTrait};
use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};

const ERC20_SUPPLY: u256 = 10000;

/// Deploy a campaign contract with the provided data
fn deploy_with(
    title: ByteArray, description: ByteArray, target: u256, duration: u64, token: ContractAddress
) -> ICampaignDispatcher {
    let creator = contract_address_const::<'creator'>();
    let mut calldata: Array::<felt252> = array![];
    ((creator, title, description, target), duration, token).serialize(ref calldata);

    let contract = declare("Campaign").unwrap();
    let contract_address = contract.precalculate_address(@calldata);
    let owner = contract_address_const::<'owner'>();
    start_cheat_caller_address(contract_address, owner);

    contract.deploy(@calldata).unwrap();

    stop_cheat_caller_address(contract_address);

    ICampaignDispatcher { contract_address }
}

/// Deploy a campaign contract with default data
fn deploy() -> ICampaignDispatcher {
    deploy_with("title 1", "description 1", 10000, 60, contract_address_const::<'token'>())
}

fn deploy_with_token() -> ICampaignDispatcher {
    // define ERC20 data
    let erc20_name: ByteArray = "My Token";
    let erc20_symbol: ByteArray = "MTKN";
    let erc20_supply: u256 = 100000;
    let erc20_owner = contract_address_const::<'erc20_owner'>();

    // deploy ERC20 token
    let erc20 = declare("ERC20").unwrap();
    let mut erc20_constructor_calldata = array![];
    (erc20_name, erc20_symbol, erc20_supply, erc20_owner).serialize(ref erc20_constructor_calldata);
    let (erc20_address, _) = erc20.deploy(@erc20_constructor_calldata).unwrap();

    // transfer amounts to some contributors
    let contributor_1 = contract_address_const::<'contributor_1'>();
    let contributor_2 = contract_address_const::<'contributor_2'>();
    let contributor_3 = contract_address_const::<'contributor_3'>();

    start_cheat_caller_address(erc20_address, erc20_owner);
    let erc20_dispatcher = IERC20Dispatcher { contract_address: erc20_address };
    erc20_dispatcher.transfer(contributor_1, 10000);
    erc20_dispatcher.transfer(contributor_2, 10000);
    erc20_dispatcher.transfer(contributor_3, 10000);

    // deploy the actual Campaign contract
    let campaign_dispatcher = deploy_with("title 1", "description 1", 10000, 60, erc20_address);

    // approve the contributions for each contributor
    start_cheat_caller_address(erc20_address, contributor_1);
    erc20_dispatcher.approve(campaign_dispatcher.contract_address, 10000);
    start_cheat_caller_address(erc20_address, contributor_2);
    erc20_dispatcher.approve(campaign_dispatcher.contract_address, 10000);
    start_cheat_caller_address(erc20_address, contributor_3);
    erc20_dispatcher.approve(campaign_dispatcher.contract_address, 10000);

    // NOTE: don't forget to stop the caller address cheat on the ERC20 contract!!
    // Otherwise, any call to this contract from any source will have the cheated
    // address as the caller
    stop_cheat_caller_address(erc20_address);

    campaign_dispatcher
}

fn _get_token_dispatcher(campaign: ICampaignDispatcher) -> IERC20Dispatcher {
    let token_address = campaign.get_details().token;
    IERC20Dispatcher { contract_address: token_address }
}

#[test]
fn test_deploy() {
    let campaign = deploy();

    let details = campaign.get_details();
    assert_eq!(details.title, "title 1");
    assert_eq!(details.description, "description 1");
    assert_eq!(details.target, 10000);
    assert_eq!(details.end_time, get_block_timestamp() + 60);
    assert_eq!(details.status, Status::PENDING);
    assert_eq!(details.token, contract_address_const::<'token'>());
    assert_eq!(details.total_contributions, 0);
    assert_eq!(details.creator, contract_address_const::<'creator'>());

    let owner: ContractAddress = contract_address_const::<'owner'>();
    let campaign_ownable = IOwnableDispatcher { contract_address: campaign.contract_address };
    assert_eq!(campaign_ownable.owner(), owner);
}

#[test]
fn test_successful_campaign() {
    let campaign = deploy_with_token();
    let token = _get_token_dispatcher(campaign);

    let creator = contract_address_const::<'creator'>();
    let contributor_1 = contract_address_const::<'contributor_1'>();
    let contributor_2 = contract_address_const::<'contributor_2'>();
    let contributor_3 = contract_address_const::<'contributor_3'>();

    start_cheat_caller_address(campaign.contract_address, creator);
    campaign.start();
    assert_eq!(campaign.get_details().status, Status::ACTIVE);

    start_cheat_caller_address(campaign.contract_address, contributor_1);
    let mut prev_balance = token.balance_of(contributor_1);
    campaign.contribute(3000);
    assert_eq!(campaign.get_details().total_contributions, 3000);
    assert_eq!(campaign.get_contribution(contributor_1), 3000);
    assert_eq!(token.balance_of(contributor_1), prev_balance - 3000);

    start_cheat_caller_address(campaign.contract_address, contributor_2);
    prev_balance = token.balance_of(contributor_2);
    campaign.contribute(500);
    assert_eq!(campaign.get_details().total_contributions, 3500);
    assert_eq!(campaign.get_contribution(contributor_2), 500);
    assert_eq!(token.balance_of(contributor_2), prev_balance - 500);

    start_cheat_caller_address(campaign.contract_address, contributor_3);
    prev_balance = token.balance_of(contributor_3);
    campaign.contribute(7000);
    assert_eq!(campaign.get_details().total_contributions, 10500);
    assert_eq!(campaign.get_contribution(contributor_3), 7000);
    assert_eq!(token.balance_of(contributor_3), prev_balance - 7000);

    start_cheat_caller_address(campaign.contract_address, creator);
    prev_balance = token.balance_of(creator);
    campaign.claim();
    assert_eq!(token.balance_of(creator), prev_balance + 10500);
    assert_eq!(campaign.get_details().status, Status::SUCCESSFUL);
}

#[test]
fn test_upgrade_class_hash() {
    let campaign = deploy();

    let mut spy = spy_events(SpyOn::One(campaign.contract_address));

    let new_class_hash = declare("MockContract").unwrap().class_hash;

    let owner = contract_address_const::<'owner'>();
    start_cheat_caller_address(campaign.contract_address, owner);

    if let Result::Err(errs) = campaign.upgrade(new_class_hash) {
        panic(errs)
    }

    assert_eq!(get_class_hash(campaign.contract_address), new_class_hash);

    spy
        .assert_emitted(
            @array![
                (
                    campaign.contract_address,
                    Campaign::Event::Upgraded(Campaign::Upgraded { implementation: new_class_hash })
                )
            ]
        );
}

#[test]
#[should_panic(expected: 'Not owner')]
fn test_upgrade_class_hash_fail() {
    let campaign = deploy();

    let new_class_hash = declare("MockContract").unwrap().class_hash;

    let random_address = contract_address_const::<'random_address'>();
    start_cheat_caller_address(campaign.contract_address, random_address);

    if let Result::Err(errs) = campaign.upgrade(new_class_hash) {
        panic(errs)
    }
}

