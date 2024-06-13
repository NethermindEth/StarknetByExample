use core::traits::TryInto;
use core::clone::Clone;
use core::result::ResultTrait;
use starknet::{
    ContractAddress, ClassHash, get_block_timestamp, contract_address_const, get_caller_address,
};
use snforge_std::{
    declare, ContractClass, ContractClassTrait, start_cheat_caller_address,
    stop_cheat_caller_address, spy_events, SpyOn, EventSpy, EventAssertions, get_class_hash,
    cheat_block_timestamp_global
};

use crowdfunding::campaign::{Campaign, ICampaignDispatcher, ICampaignDispatcherTrait};
use crowdfunding::campaign::Status;
use components::ownable::{IOwnableDispatcher, IOwnableDispatcherTrait};
use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};

const ERC20_SUPPLY: u256 = 10000;

/// Deploy a campaign contract with the provided data
fn deploy(
    contract: ContractClass,
    title: ByteArray,
    description: ByteArray,
    target: u256,
    token: ContractAddress
) -> ICampaignDispatcher {
    let creator = contract_address_const::<'creator'>();
    let mut calldata: Array::<felt252> = array![];
    ((creator, title, description, target), token).serialize(ref calldata);

    let contract_address = contract.precalculate_address(@calldata);
    let owner = contract_address_const::<'owner'>();
    start_cheat_caller_address(contract_address, owner);

    contract.deploy(@calldata).unwrap();

    stop_cheat_caller_address(contract_address);

    ICampaignDispatcher { contract_address }
}

fn deploy_with_token(
    contract: ContractClass, token: ContractClass
) -> (ICampaignDispatcher, IERC20Dispatcher) {
    // define ERC20 data
    let token_name: ByteArray = "My Token";
    let token_symbol: ByteArray = "MTKN";
    let token_supply: u256 = 100000;
    let token_owner = contract_address_const::<'token_owner'>();

    // deploy ERC20 token
    let mut token_constructor_calldata = array![];
    (token_name, token_symbol, token_supply, token_owner).serialize(ref token_constructor_calldata);
    let (token_address, _) = token.deploy(@token_constructor_calldata).unwrap();

    // transfer amounts to some contributors
    let contributor_1 = contract_address_const::<'contributor_1'>();
    let contributor_2 = contract_address_const::<'contributor_2'>();
    let contributor_3 = contract_address_const::<'contributor_3'>();

    start_cheat_caller_address(token_address, token_owner);
    let token_dispatcher = IERC20Dispatcher { contract_address: token_address };
    token_dispatcher.transfer(contributor_1, 10000);
    token_dispatcher.transfer(contributor_2, 10000);
    token_dispatcher.transfer(contributor_3, 10000);

    // deploy the actual Campaign contract
    let campaign_dispatcher = deploy(contract, "title 1", "description 1", 10000, token_address);

    // approve the contributions for each contributor
    start_cheat_caller_address(token_address, contributor_1);
    token_dispatcher.approve(campaign_dispatcher.contract_address, 10000);
    start_cheat_caller_address(token_address, contributor_2);
    token_dispatcher.approve(campaign_dispatcher.contract_address, 10000);
    start_cheat_caller_address(token_address, contributor_3);
    token_dispatcher.approve(campaign_dispatcher.contract_address, 10000);

    // NOTE: don't forget to stop the caller address cheat on the ERC20 contract!!
    // Otherwise, any call to this contract from any source will have the cheated
    // address as the caller
    stop_cheat_caller_address(token_address);

    (campaign_dispatcher, token_dispatcher)
}

#[test]
fn test_deploy() {
    let contract = declare("Campaign").unwrap();
    let campaign = deploy(
        contract, "title 1", "description 1", 10000, contract_address_const::<'token'>()
    );

    let details = campaign.get_details();
    assert_eq!(details.title, "title 1");
    assert_eq!(details.description, "description 1");
    assert_eq!(details.target, 10000);
    assert_eq!(details.end_time, 0);
    assert_eq!(details.status, Status::DRAFT);
    assert_eq!(details.token, contract_address_const::<'token'>());
    assert_eq!(details.total_contributions, 0);
    assert_eq!(details.creator, contract_address_const::<'creator'>());

    let owner: ContractAddress = contract_address_const::<'owner'>();
    let campaign_ownable = IOwnableDispatcher { contract_address: campaign.contract_address };
    assert_eq!(campaign_ownable.owner(), owner);
}

#[test]
fn test_successful_campaign() {
    let token_class = declare("ERC20").unwrap();
    let contract_class = declare("Campaign").unwrap();
    let (campaign, token) = deploy_with_token(contract_class, token_class);
    let duration: u64 = 60;

    let creator = contract_address_const::<'creator'>();
    let contributor_1 = contract_address_const::<'contributor_1'>();
    let contributor_2 = contract_address_const::<'contributor_2'>();
    let contributor_3 = contract_address_const::<'contributor_3'>();

    let mut spy = spy_events(SpyOn::One(campaign.contract_address));

    // start campaign
    start_cheat_caller_address(campaign.contract_address, creator);
    campaign.start(duration);
    assert_eq!(campaign.get_details().status, Status::ACTIVE);
    assert_eq!(campaign.get_details().end_time, get_block_timestamp() + duration);

    spy
        .assert_emitted(
            @array![(campaign.contract_address, Campaign::Event::Activated(Campaign::Activated {}))]
        );

    // 1st donation
    start_cheat_caller_address(campaign.contract_address, contributor_1);
    let mut prev_balance = token.balance_of(contributor_1);
    campaign.contribute(3000);
    assert_eq!(campaign.get_details().total_contributions, 3000);
    assert_eq!(campaign.get_contribution(contributor_1), 3000);
    assert_eq!(token.balance_of(contributor_1), prev_balance - 3000);

    spy
        .assert_emitted(
            @array![
                (
                    campaign.contract_address,
                    Campaign::Event::ContributionMade(
                        Campaign::ContributionMade { contributor: contributor_1, amount: 3000 }
                    )
                )
            ]
        );

    // 2nd donation
    start_cheat_caller_address(campaign.contract_address, contributor_2);
    prev_balance = token.balance_of(contributor_2);
    campaign.contribute(500);
    assert_eq!(campaign.get_details().total_contributions, 3500);
    assert_eq!(campaign.get_contribution(contributor_2), 500);
    assert_eq!(token.balance_of(contributor_2), prev_balance - 500);

    spy
        .assert_emitted(
            @array![
                (
                    campaign.contract_address,
                    Campaign::Event::ContributionMade(
                        Campaign::ContributionMade { contributor: contributor_2, amount: 500 }
                    )
                )
            ]
        );

    // 3rd donation
    start_cheat_caller_address(campaign.contract_address, contributor_3);
    prev_balance = token.balance_of(contributor_3);
    campaign.contribute(7000);
    assert_eq!(campaign.get_details().total_contributions, 10500);
    assert_eq!(campaign.get_contribution(contributor_3), 7000);
    assert_eq!(token.balance_of(contributor_3), prev_balance - 7000);

    spy
        .assert_emitted(
            @array![
                (
                    campaign.contract_address,
                    Campaign::Event::ContributionMade(
                        Campaign::ContributionMade { contributor: contributor_3, amount: 7000 }
                    )
                )
            ]
        );

    // claim 
    cheat_block_timestamp_global(get_block_timestamp() + duration);
    start_cheat_caller_address(campaign.contract_address, creator);
    prev_balance = token.balance_of(creator);
    campaign.claim();
    assert_eq!(token.balance_of(creator), prev_balance + 10500);
    assert_eq!(campaign.get_details().status, Status::SUCCESSFUL);

    spy
        .assert_emitted(
            @array![
                (
                    campaign.contract_address,
                    Campaign::Event::Claimed(Campaign::Claimed { amount: 10500 })
                )
            ]
        );
}

#[test]
fn test_upgrade_class_hash() {
    let new_class_hash = declare("MockUpgrade").unwrap().class_hash;
    let owner = contract_address_const::<'owner'>();

    // test pending campaign
    let contract_class = declare("Campaign").unwrap();
    let token_class = declare("ERC20").unwrap();
    let (campaign, _) = deploy_with_token(contract_class, token_class);
    let mut spy = spy_events(SpyOn::One(campaign.contract_address));

    start_cheat_caller_address(campaign.contract_address, owner);
    campaign.upgrade(new_class_hash, Option::None);
    stop_cheat_caller_address(campaign.contract_address);

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

    // test active campaign
    let (campaign, token) = deploy_with_token(contract_class, token_class);
    let mut spy = spy_events(SpyOn::One(campaign.contract_address));
    let duration: u64 = 60;
    let creator = contract_address_const::<'creator'>();
    let contributor_1 = contract_address_const::<'contributor_1'>();
    let contributor_2 = contract_address_const::<'contributor_2'>();
    let contributor_3 = contract_address_const::<'contributor_3'>();
    let prev_balance_contributor_1 = token.balance_of(contributor_1);
    let prev_balance_contributor_2 = token.balance_of(contributor_2);
    let prev_balance_contributor_3 = token.balance_of(contributor_3);

    start_cheat_caller_address(campaign.contract_address, creator);
    campaign.start(duration);
    start_cheat_caller_address(campaign.contract_address, contributor_1);
    campaign.contribute(3000);
    start_cheat_caller_address(campaign.contract_address, contributor_2);
    campaign.contribute(1000);
    start_cheat_caller_address(campaign.contract_address, contributor_3);
    campaign.contribute(2000);

    start_cheat_caller_address(campaign.contract_address, owner);
    campaign.upgrade(new_class_hash, Option::Some(duration));
    stop_cheat_caller_address(campaign.contract_address);

    assert_eq!(prev_balance_contributor_1, token.balance_of(contributor_1));
    assert_eq!(prev_balance_contributor_2, token.balance_of(contributor_2));
    assert_eq!(prev_balance_contributor_3, token.balance_of(contributor_3));
    assert_eq!(campaign.get_details().total_contributions, 0);
    assert_eq!(campaign.get_details().end_time, get_block_timestamp() + duration);

    spy
        .assert_emitted(
            @array![
                (
                    campaign.contract_address,
                    Campaign::Event::Upgraded(Campaign::Upgraded { implementation: new_class_hash })
                ),
                (
                    campaign.contract_address,
                    Campaign::Event::RefundedAll(
                        Campaign::RefundedAll { reason: "contract upgraded" }
                    )
                )
            ]
        );
}

#[test]
fn test_close() {
    let contract_class = declare("Campaign").unwrap();
    let token_class = declare("ERC20").unwrap();
    let duration: u64 = 60;

    // test closed campaign
    let (campaign, token) = deploy_with_token(contract_class, token_class);
    let mut spy = spy_events(SpyOn::One(campaign.contract_address));
    let creator = contract_address_const::<'creator'>();
    let contributor_1 = contract_address_const::<'contributor_1'>();
    let contributor_2 = contract_address_const::<'contributor_2'>();
    let contributor_3 = contract_address_const::<'contributor_3'>();
    let prev_balance_contributor_1 = token.balance_of(contributor_1);
    let prev_balance_contributor_2 = token.balance_of(contributor_2);
    let prev_balance_contributor_3 = token.balance_of(contributor_3);

    start_cheat_caller_address(campaign.contract_address, creator);
    campaign.start(duration);
    start_cheat_caller_address(campaign.contract_address, contributor_1);
    campaign.contribute(3000);
    start_cheat_caller_address(campaign.contract_address, contributor_2);
    campaign.contribute(1000);
    start_cheat_caller_address(campaign.contract_address, contributor_3);
    campaign.contribute(2000);
    let total_contributions = campaign.get_details().total_contributions;

    start_cheat_caller_address(campaign.contract_address, creator);
    campaign.close("testing");
    stop_cheat_caller_address(campaign.contract_address);

    assert_eq!(prev_balance_contributor_1, token.balance_of(contributor_1));
    assert_eq!(prev_balance_contributor_2, token.balance_of(contributor_2));
    assert_eq!(prev_balance_contributor_3, token.balance_of(contributor_3));
    assert_eq!(campaign.get_details().total_contributions, total_contributions);
    assert_eq!(campaign.get_details().status, Status::CLOSED);

    spy
        .assert_emitted(
            @array![
                (
                    campaign.contract_address,
                    Campaign::Event::RefundedAll(Campaign::RefundedAll { reason: "testing" })
                ),
                (
                    campaign.contract_address,
                    Campaign::Event::Closed(
                        Campaign::Closed { reason: "testing", status: Status::CLOSED }
                    )
                )
            ]
        );

    // test failed campaign
    let (campaign, token) = deploy_with_token(contract_class, token_class);
    let mut spy = spy_events(SpyOn::One(campaign.contract_address));
    let creator = contract_address_const::<'creator'>();
    let contributor_1 = contract_address_const::<'contributor_1'>();
    let contributor_2 = contract_address_const::<'contributor_2'>();
    let contributor_3 = contract_address_const::<'contributor_3'>();
    let prev_balance_contributor_1 = token.balance_of(contributor_1);
    let prev_balance_contributor_2 = token.balance_of(contributor_2);
    let prev_balance_contributor_3 = token.balance_of(contributor_3);

    start_cheat_caller_address(campaign.contract_address, creator);
    campaign.start(duration);
    start_cheat_caller_address(campaign.contract_address, contributor_1);
    campaign.contribute(3000);
    start_cheat_caller_address(campaign.contract_address, contributor_2);
    campaign.contribute(1000);
    start_cheat_caller_address(campaign.contract_address, contributor_3);
    campaign.contribute(2000);
    let total_contributions = campaign.get_details().total_contributions;

    cheat_block_timestamp_global(duration);

    start_cheat_caller_address(campaign.contract_address, creator);
    campaign.close("testing");
    stop_cheat_caller_address(campaign.contract_address);

    assert_eq!(prev_balance_contributor_1, token.balance_of(contributor_1));
    assert_eq!(prev_balance_contributor_2, token.balance_of(contributor_2));
    assert_eq!(prev_balance_contributor_3, token.balance_of(contributor_3));
    assert_eq!(campaign.get_details().total_contributions, total_contributions);
    assert_eq!(campaign.get_details().status, Status::FAILED);

    spy
        .assert_emitted(
            @array![
                (
                    campaign.contract_address,
                    Campaign::Event::RefundedAll(Campaign::RefundedAll { reason: "testing" })
                ),
                (
                    campaign.contract_address,
                    Campaign::Event::Closed(
                        Campaign::Closed { reason: "testing", status: Status::FAILED }
                    )
                )
            ]
        );
}

#[test]
fn test_refund() {
    // setup
    let duration: u64 = 60;
    let (campaign, token) = deploy_with_token(
        declare("Campaign").unwrap(), declare("ERC20").unwrap()
    );
    let mut spy = spy_events(SpyOn::One(campaign.contract_address));
    let creator = contract_address_const::<'creator'>();
    let contributor = contract_address_const::<'contributor_1'>();
    let amount: u256 = 3000;
    let prev_balance = token.balance_of(contributor);

    // donate
    start_cheat_caller_address(campaign.contract_address, creator);
    campaign.start(duration);
    start_cheat_caller_address(campaign.contract_address, contributor);
    campaign.contribute(amount);
    assert_eq!(campaign.get_details().total_contributions, amount);
    assert_eq!(campaign.get_contribution(contributor), amount);
    assert_eq!(token.balance_of(contributor), prev_balance - amount);

    // refund
    start_cheat_caller_address(campaign.contract_address, creator);
    campaign.refund(contributor, "testing");
    assert_eq!(campaign.get_details().total_contributions, 0);
    assert_eq!(campaign.get_contribution(contributor), 0);
    assert_eq!(token.balance_of(contributor), prev_balance);

    spy
        .assert_emitted(
            @array![
                (
                    campaign.contract_address,
                    Campaign::Event::Refunded(
                        Campaign::Refunded { contributor, amount, reason: "testing" }
                    )
                )
            ]
        );
}

#[test]
fn test_withdraw() {
    // setup
    let duration: u64 = 60;
    let (campaign, token) = deploy_with_token(
        declare("Campaign").unwrap(), declare("ERC20").unwrap()
    );
    let mut spy = spy_events(SpyOn::One(campaign.contract_address));
    let creator = contract_address_const::<'creator'>();
    let contributor = contract_address_const::<'contributor_1'>();
    let amount: u256 = 3000;
    let prev_balance = token.balance_of(contributor);
    start_cheat_caller_address(campaign.contract_address, creator);
    campaign.start(duration);

    // donate
    start_cheat_caller_address(campaign.contract_address, contributor);
    campaign.contribute(amount);
    assert_eq!(campaign.get_details().total_contributions, amount);
    assert_eq!(campaign.get_contribution(contributor), amount);
    assert_eq!(token.balance_of(contributor), prev_balance - amount);

    // withdraw
    campaign.withdraw("testing");
    assert_eq!(campaign.get_details().total_contributions, 0);
    assert_eq!(campaign.get_contribution(contributor), 0);
    assert_eq!(token.balance_of(contributor), prev_balance);

    spy
        .assert_emitted(
            @array![
                (
                    campaign.contract_address,
                    Campaign::Event::Withdrawn(
                        Campaign::Withdrawn { contributor, amount, reason: "testing" }
                    )
                )
            ]
        );
}
