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
use components::ownable::{IOwnableDispatcher, IOwnableDispatcherTrait};
use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};

/// Deploy a campaign contract with the provided data
fn deploy(
    contract: ContractClass,
    title: ByteArray,
    description: ByteArray,
    goal: u256,
    start_time: u64,
    end_time: u64,
    token: ContractAddress
) -> ICampaignDispatcher {
    let creator = contract_address_const::<'creator'>();
    let mut calldata: Array::<felt252> = array![];
    ((creator, title, description, goal), start_time, end_time, token).serialize(ref calldata);

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
    let token_recipient = token_owner;

    // deploy ERC20 token
    let mut token_constructor_calldata = array![];
    ((token_name, token_symbol, token_supply, token_recipient), token_owner)
        .serialize(ref token_constructor_calldata);
    let (token_address, _) = token.deploy(@token_constructor_calldata).unwrap();

    // transfer amounts to some pledgers
    let pledger_1 = contract_address_const::<'pledger_1'>();
    let pledger_2 = contract_address_const::<'pledger_2'>();
    let pledger_3 = contract_address_const::<'pledger_3'>();

    start_cheat_caller_address(token_address, token_owner);
    let token_dispatcher = IERC20Dispatcher { contract_address: token_address };
    token_dispatcher.transfer(pledger_1, 10000);
    token_dispatcher.transfer(pledger_2, 10000);
    token_dispatcher.transfer(pledger_3, 10000);

    // deploy the actual Campaign contract
    let start_time = get_block_timestamp();
    let end_time = start_time + 60;
    let campaign_dispatcher = deploy(
        contract, "title 1", "description 1", 10000, start_time, end_time, token_address
    );

    // approve the pledges for each pledger
    start_cheat_caller_address(token_address, pledger_1);
    token_dispatcher.approve(campaign_dispatcher.contract_address, 10000);
    start_cheat_caller_address(token_address, pledger_2);
    token_dispatcher.approve(campaign_dispatcher.contract_address, 10000);
    start_cheat_caller_address(token_address, pledger_3);
    token_dispatcher.approve(campaign_dispatcher.contract_address, 10000);

    // NOTE: don't forget to stop the caller address cheat on the ERC20 contract!!
    // Otherwise, any call to this contract from any source will have the cheated
    // address as the caller
    stop_cheat_caller_address(token_address);

    (campaign_dispatcher, token_dispatcher)
}

#[test]
fn test_deploy() {
    let start_time = get_block_timestamp();
    let end_time = start_time + 60;
    let contract = declare("Campaign").unwrap();
    let campaign = deploy(
        contract,
        "title 1",
        "description 1",
        10000,
        start_time,
        end_time,
        contract_address_const::<'token'>()
    );

    let details = campaign.get_details();
    assert_eq!(details.title, "title 1");
    assert_eq!(details.description, "description 1");
    assert_eq!(details.goal, 10000);
    assert_eq!(details.start_time, start_time);
    assert_eq!(details.end_time, end_time);
    assert_eq!(details.claimed, false);
    assert_eq!(details.canceled, false);
    assert_eq!(details.token, contract_address_const::<'token'>());
    assert_eq!(details.total_pledges, 0);
    assert_eq!(details.creator, contract_address_const::<'creator'>());

    let owner: ContractAddress = contract_address_const::<'owner'>();
    let campaign_ownable = IOwnableDispatcher { contract_address: campaign.contract_address };
    assert_eq!(campaign_ownable.owner(), owner);
}

#[test]
fn test_successful_campaign() {
    let token_class = declare("ERC20Upgradeable").unwrap();
    let contract_class = declare("Campaign").unwrap();
    let (campaign, token) = deploy_with_token(contract_class, token_class);

    let creator = contract_address_const::<'creator'>();
    let pledger_1 = contract_address_const::<'pledger_1'>();
    let pledger_2 = contract_address_const::<'pledger_2'>();
    let pledger_3 = contract_address_const::<'pledger_3'>();

    let mut spy = spy_events(SpyOn::One(campaign.contract_address));

    // 1st donation
    start_cheat_caller_address(campaign.contract_address, pledger_1);
    let mut prev_balance = token.balance_of(pledger_1);
    campaign.pledge(3000);
    assert_eq!(campaign.get_details().total_pledges, 3000);
    assert_eq!(campaign.get_pledge(pledger_1), 3000);
    assert_eq!(token.balance_of(pledger_1), prev_balance - 3000);

    spy
        .assert_emitted(
            @array![
                (
                    campaign.contract_address,
                    Campaign::Event::PledgeMade(
                        Campaign::PledgeMade { pledger: pledger_1, amount: 3000 }
                    )
                )
            ]
        );

    // 2nd donation
    start_cheat_caller_address(campaign.contract_address, pledger_2);
    prev_balance = token.balance_of(pledger_2);
    campaign.pledge(500);
    assert_eq!(campaign.get_details().total_pledges, 3500);
    assert_eq!(campaign.get_pledge(pledger_2), 500);
    assert_eq!(token.balance_of(pledger_2), prev_balance - 500);

    spy
        .assert_emitted(
            @array![
                (
                    campaign.contract_address,
                    Campaign::Event::PledgeMade(
                        Campaign::PledgeMade { pledger: pledger_2, amount: 500 }
                    )
                )
            ]
        );

    // 3rd donation
    start_cheat_caller_address(campaign.contract_address, pledger_3);
    prev_balance = token.balance_of(pledger_3);
    campaign.pledge(7000);
    assert_eq!(campaign.get_details().total_pledges, 10500);
    assert_eq!(campaign.get_pledge(pledger_3), 7000);
    assert_eq!(token.balance_of(pledger_3), prev_balance - 7000);

    spy
        .assert_emitted(
            @array![
                (
                    campaign.contract_address,
                    Campaign::Event::PledgeMade(
                        Campaign::PledgeMade { pledger: pledger_3, amount: 7000 }
                    )
                )
            ]
        );

    // claim 
    cheat_block_timestamp_global(campaign.get_details().end_time);
    start_cheat_caller_address(campaign.contract_address, creator);
    prev_balance = token.balance_of(creator);
    campaign.claim();
    assert_eq!(token.balance_of(creator), prev_balance + 10500);
    assert!(campaign.get_details().claimed);

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
    let token_class = declare("ERC20Upgradeable").unwrap();
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
    let pledger_1 = contract_address_const::<'pledger_1'>();
    let pledger_2 = contract_address_const::<'pledger_2'>();
    let pledger_3 = contract_address_const::<'pledger_3'>();
    let prev_balance_pledger_1 = token.balance_of(pledger_1);
    let prev_balance_pledger_2 = token.balance_of(pledger_2);
    let prev_balance_pledger_3 = token.balance_of(pledger_3);

    start_cheat_caller_address(campaign.contract_address, pledger_1);
    campaign.pledge(3000);
    start_cheat_caller_address(campaign.contract_address, pledger_2);
    campaign.pledge(1000);
    start_cheat_caller_address(campaign.contract_address, pledger_3);
    campaign.pledge(2000);

    start_cheat_caller_address(campaign.contract_address, owner);
    campaign.upgrade(new_class_hash, Option::Some(duration));
    stop_cheat_caller_address(campaign.contract_address);

    assert_eq!(prev_balance_pledger_1, token.balance_of(pledger_1));
    assert_eq!(prev_balance_pledger_2, token.balance_of(pledger_2));
    assert_eq!(prev_balance_pledger_3, token.balance_of(pledger_3));
    assert_eq!(campaign.get_details().total_pledges, 0);
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
fn test_cancel() {
    let contract_class = declare("Campaign").unwrap();
    let token_class = declare("ERC20Upgradeable").unwrap();

    // test canceled campaign
    let (campaign, token) = deploy_with_token(contract_class, token_class);
    let mut spy = spy_events(SpyOn::One(campaign.contract_address));
    let creator = contract_address_const::<'creator'>();
    let pledger_1 = contract_address_const::<'pledger_1'>();
    let pledger_2 = contract_address_const::<'pledger_2'>();
    let pledger_3 = contract_address_const::<'pledger_3'>();
    let pledge_1: u256 = 3000;
    let pledge_2: u256 = 3000;
    let pledge_3: u256 = 3000;
    let prev_balance_pledger_1 = token.balance_of(pledger_1);
    let prev_balance_pledger_2 = token.balance_of(pledger_2);
    let prev_balance_pledger_3 = token.balance_of(pledger_3);

    start_cheat_caller_address(campaign.contract_address, pledger_1);
    campaign.pledge(pledge_1);
    start_cheat_caller_address(campaign.contract_address, pledger_2);
    campaign.pledge(pledge_2);
    start_cheat_caller_address(campaign.contract_address, pledger_3);
    campaign.pledge(pledge_3);
    assert_eq!(campaign.get_details().total_pledges, pledge_1 + pledge_2 + pledge_3);
    assert_eq!(token.balance_of(pledger_1), prev_balance_pledger_1 - pledge_1);
    assert_eq!(token.balance_of(pledger_2), prev_balance_pledger_2 - pledge_2);
    assert_eq!(token.balance_of(pledger_3), prev_balance_pledger_3 - pledge_3);

    start_cheat_caller_address(campaign.contract_address, creator);
    campaign.cancel("testing");
    stop_cheat_caller_address(campaign.contract_address);

    assert_eq!(prev_balance_pledger_1, token.balance_of(pledger_1));
    assert_eq!(prev_balance_pledger_2, token.balance_of(pledger_2));
    assert_eq!(prev_balance_pledger_3, token.balance_of(pledger_3));
    assert_eq!(campaign.get_details().total_pledges, 0);
    assert!(campaign.get_details().canceled);

    spy
        .assert_emitted(
            @array![
                (
                    campaign.contract_address,
                    Campaign::Event::RefundedAll(Campaign::RefundedAll { reason: "testing" })
                ),
                (
                    campaign.contract_address,
                    Campaign::Event::Canceled(Campaign::Canceled { reason: "testing" })
                )
            ]
        );

    // test failed campaign
    let (campaign, token) = deploy_with_token(contract_class, token_class);
    let mut spy = spy_events(SpyOn::One(campaign.contract_address));
    let creator = contract_address_const::<'creator'>();
    let pledger_1 = contract_address_const::<'pledger_1'>();
    let pledger_2 = contract_address_const::<'pledger_2'>();
    let pledger_3 = contract_address_const::<'pledger_3'>();
    let pledge_1: u256 = 3000;
    let pledge_2: u256 = 3000;
    let pledge_3: u256 = 3000;
    let prev_balance_pledger_1 = token.balance_of(pledger_1);
    let prev_balance_pledger_2 = token.balance_of(pledger_2);
    let prev_balance_pledger_3 = token.balance_of(pledger_3);

    start_cheat_caller_address(campaign.contract_address, pledger_1);
    campaign.pledge(pledge_1);
    start_cheat_caller_address(campaign.contract_address, pledger_2);
    campaign.pledge(pledge_2);
    start_cheat_caller_address(campaign.contract_address, pledger_3);
    campaign.pledge(pledge_3);
    assert_eq!(campaign.get_details().total_pledges, pledge_1 + pledge_2 + pledge_3);
    assert_eq!(token.balance_of(pledger_1), prev_balance_pledger_1 - pledge_1);
    assert_eq!(token.balance_of(pledger_2), prev_balance_pledger_2 - pledge_2);
    assert_eq!(token.balance_of(pledger_3), prev_balance_pledger_3 - pledge_3);

    cheat_block_timestamp_global(campaign.get_details().end_time);

    start_cheat_caller_address(campaign.contract_address, creator);
    campaign.cancel("testing");
    stop_cheat_caller_address(campaign.contract_address);

    assert_eq!(prev_balance_pledger_1, token.balance_of(pledger_1));
    assert_eq!(prev_balance_pledger_2, token.balance_of(pledger_2));
    assert_eq!(prev_balance_pledger_3, token.balance_of(pledger_3));
    assert_eq!(campaign.get_details().total_pledges, 0);
    assert!(campaign.get_details().canceled);

    spy
        .assert_emitted(
            @array![
                (
                    campaign.contract_address,
                    Campaign::Event::RefundedAll(Campaign::RefundedAll { reason: "testing" })
                ),
                (
                    campaign.contract_address,
                    Campaign::Event::Canceled(Campaign::Canceled { reason: "testing" })
                )
            ]
        );
}

#[test]
fn test_refund() {
    // setup
    let (campaign, token) = deploy_with_token(
        declare("Campaign").unwrap(), declare("ERC20Upgradeable").unwrap()
    );
    let mut spy = spy_events(SpyOn::One(campaign.contract_address));
    let creator = contract_address_const::<'creator'>();
    let pledger_1 = contract_address_const::<'pledger_1'>();
    let pledger_2 = contract_address_const::<'pledger_2'>();
    let amount_1: u256 = 3000;
    let amount_2: u256 = 1500;
    let prev_balance_1 = token.balance_of(pledger_1);
    let prev_balance_2 = token.balance_of(pledger_2);

    // donate
    start_cheat_caller_address(campaign.contract_address, pledger_1);
    campaign.pledge(amount_1);
    assert_eq!(campaign.get_details().total_pledges, amount_1);
    assert_eq!(campaign.get_pledge(pledger_1), amount_1);
    assert_eq!(token.balance_of(pledger_1), prev_balance_1 - amount_1);

    start_cheat_caller_address(campaign.contract_address, pledger_2);
    campaign.pledge(amount_2);
    assert_eq!(campaign.get_details().total_pledges, amount_1 + amount_2);
    assert_eq!(campaign.get_pledge(pledger_2), amount_2);
    assert_eq!(token.balance_of(pledger_2), prev_balance_2 - amount_2);

    // refund
    start_cheat_caller_address(campaign.contract_address, creator);
    campaign.refund(pledger_1, "testing");
    assert_eq!(campaign.get_details().total_pledges, amount_2);
    assert_eq!(campaign.get_pledge(pledger_2), amount_2);
    assert_eq!(token.balance_of(pledger_2), prev_balance_2 - amount_2);
    assert_eq!(token.balance_of(pledger_1), prev_balance_1);

    spy
        .assert_emitted(
            @array![
                (
                    campaign.contract_address,
                    Campaign::Event::Refunded(
                        Campaign::Refunded {
                            pledger: pledger_1, amount: amount_1, reason: "testing"
                        }
                    )
                )
            ]
        );
}

#[test]
fn test_unpledge() {
    // setup
    let (campaign, token) = deploy_with_token(
        declare("Campaign").unwrap(), declare("ERC20Upgradeable").unwrap()
    );
    let mut spy = spy_events(SpyOn::One(campaign.contract_address));
    let pledger = contract_address_const::<'pledger_1'>();
    let amount: u256 = 3000;
    let prev_balance = token.balance_of(pledger);

    // donate
    start_cheat_caller_address(campaign.contract_address, pledger);
    campaign.pledge(amount);
    assert_eq!(campaign.get_details().total_pledges, amount);
    assert_eq!(campaign.get_pledge(pledger), amount);
    assert_eq!(token.balance_of(pledger), prev_balance - amount);

    // unpledge
    campaign.unpledge("testing");
    assert_eq!(campaign.get_details().total_pledges, 0);
    assert_eq!(campaign.get_pledge(pledger), 0);
    assert_eq!(token.balance_of(pledger), prev_balance);

    spy
        .assert_emitted(
            @array![
                (
                    campaign.contract_address,
                    Campaign::Event::Unpledged(
                        Campaign::Unpledged { pledger, amount, reason: "testing" }
                    )
                )
            ]
        );
}
