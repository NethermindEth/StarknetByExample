// use core::integer::U64IntoFelt252;
use starknet::{ContractAddress, contract_address_const};
use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};
use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};
use snforge_std::{start_cheat_caller_address, stop_cheat_caller_address};
use snforge_std::{start_cheat_block_timestamp, stop_cheat_block_timestamp};
use snforge_std::signature::KeyPairTrait;
use snforge_std::signature::stark_curve::{
    StarkCurveKeyPairImpl, StarkCurveSignerImpl, StarkCurveVerifierImpl
};

use account_spending_limits::account::SpendingLimit;
use account_spending_limits::account::{
    ISpendingLimitsAccountDispatcher, ISpendingLimitsAccountDispatcherTrait
};

fn deploy_account_contract(public_key: felt252) -> ISpendingLimitsAccountDispatcher {
    let contract = declare("SpendingLimitsAccount").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![public_key]).unwrap();
    ISpendingLimitsAccountDispatcher { contract_address }
}

fn deploy_erc20_contract() -> (IERC20Dispatcher, ContractAddress) {
    // deploy mock ETH token
    let contract = declare("ERC20Upgradeable").unwrap().contract_class();
    let name: ByteArray = "Ethereum";
    let symbol: ByteArray = "ETH";
    let supply: u256 = 10000000000000000000;
    let mut calldata = array![];
    let deployer = contract_address_const::<'deployer'>();
    ((name, symbol, supply, deployer), deployer).serialize(ref calldata);
    let address = contract.precalculate_address(@calldata);
    start_cheat_caller_address(address, deployer);
    contract.deploy(@calldata).unwrap();
    stop_cheat_caller_address(address);
    (IERC20Dispatcher { contract_address: address }, deployer)
}

fn deploy_and_fund(
    public_key: felt252
) -> (ISpendingLimitsAccountDispatcher, IERC20Dispatcher, ContractAddress) {
    let account = deploy_account_contract(public_key);
    let (eth, deployer) = deploy_erc20_contract();
    start_cheat_caller_address(eth.contract_address, deployer);
    eth.transfer(account.contract_address, 3);
    stop_cheat_caller_address(eth.contract_address);
    (account, eth, deployer)
}

#[test]
fn test_deploy_account_and_fund() {
    let mut signer = KeyPairTrait::<felt252, felt252>::from_secret_key(123);
    let (account, eth, _) = deploy_and_fund(signer.public_key);

    let balance = eth.balance_of(account.contract_address);
    assert_eq!(balance, 3);
    let available = account.get_available_spending_amount(eth.contract_address);
    assert_eq!(available, 3);
}

#[test]
fn test_stored_pub_key() {
    let public_key = 999;
    let dispatcher = deploy_account_contract(public_key);
    assert_eq!(dispatcher.public_key(), public_key);
}

#[test]
fn test_set_limit() {
    let mut signer = KeyPairTrait::<felt252, felt252>::from_secret_key(123);
    let (account, eth, _) = deploy_and_fund(signer.public_key);

    start_cheat_caller_address(account.contract_address, account.contract_address);
    let eth_limit = SpendingLimit {
        timestamp: starknet::get_block_timestamp() + 1000, max_amount: 2,
    };
    account.set_spending_limit(eth.contract_address, eth_limit);
    let available = account.get_available_spending_amount(eth.contract_address);
    assert_eq!(available, 2);
    stop_cheat_caller_address(account.contract_address);

    let stored_limit = account.get_spending_limit(eth.contract_address).unwrap();
    assert_eq!(stored_limit.timestamp, eth_limit.timestamp);
    assert_eq!(stored_limit.max_amount, eth_limit.max_amount);
}

#[test]
fn test_no_limit() {
    let mut signer = KeyPairTrait::<felt252, felt252>::from_secret_key(123);
    let (account, eth, _) = deploy_and_fund(signer.public_key);

    let stored_limit = account.get_spending_limit(eth.contract_address);
    assert!(stored_limit.is_none());
}

#[test]
#[should_panic(expected: ('Account: Invalid caller',))]
fn test_set_limit_wrong_caller() {
    let mut signer = KeyPairTrait::<felt252, felt252>::from_secret_key(123);
    let (account, eth, _) = deploy_and_fund(signer.public_key);
    account
        .set_spending_limit(
            eth.contract_address,
            SpendingLimit { timestamp: starknet::get_block_timestamp() + 1000, max_amount: 2, }
        );
}

#[test]
#[should_panic(expected: ('Account: Invalid timestamp',))]
fn test_set_limit_with_invalid_timestamp() {
    let mut signer = KeyPairTrait::<felt252, felt252>::from_secret_key(123);
    let (account, eth, _) = deploy_and_fund(signer.public_key);
    start_cheat_caller_address(account.contract_address, account.contract_address);
    start_cheat_block_timestamp(account.contract_address, starknet::get_block_timestamp() + 1);
    account
        .set_spending_limit(eth.contract_address, SpendingLimit { timestamp: 0, max_amount: 2, });
    stop_cheat_block_timestamp(account.contract_address);
    stop_cheat_caller_address(account.contract_address);
}

#[test]
#[should_panic(expected: ('Account: Active limit exists',))]
fn test_set_active_limit() {
    let mut signer = KeyPairTrait::<felt252, felt252>::from_secret_key(123);
    let (account, eth, _) = deploy_and_fund(signer.public_key);
    start_cheat_caller_address(account.contract_address, account.contract_address);
    account
        .set_spending_limit(
            eth.contract_address,
            SpendingLimit { timestamp: starknet::get_block_timestamp() + 1000, max_amount: 2, }
        );
    account
        .set_spending_limit(
            eth.contract_address,
            SpendingLimit { timestamp: starknet::get_block_timestamp() + 2000, max_amount: 3, }
        );
    stop_cheat_caller_address(account.contract_address);
}

#[test]
fn test_get_limit_after_inactive_limit() {
    let mut signer = KeyPairTrait::<felt252, felt252>::from_secret_key(123);
    let (account, eth, _) = deploy_and_fund(signer.public_key);
    start_cheat_caller_address(account.contract_address, account.contract_address);
    account
        .set_spending_limit(
            eth.contract_address,
            SpendingLimit { timestamp: starknet::get_block_timestamp() + 1000, max_amount: 2, }
        );
    stop_cheat_caller_address(account.contract_address);

    start_cheat_block_timestamp(account.contract_address, starknet::get_block_timestamp() + 1001);
    let stored_limit = account.get_spending_limit(eth.contract_address);
    assert!(stored_limit.is_none());
    let available = account.get_available_spending_amount(eth.contract_address);
    assert_eq!(available, 3);
    stop_cheat_block_timestamp(account.contract_address);
}

#[test]
fn test_set_new_limit_after_inactive_limit() {
    let mut signer = KeyPairTrait::<felt252, felt252>::from_secret_key(123);
    let (account, eth, _) = deploy_and_fund(signer.public_key);
    start_cheat_caller_address(account.contract_address, account.contract_address);
    account
        .set_spending_limit(
            eth.contract_address,
            SpendingLimit { timestamp: starknet::get_block_timestamp() + 1000, max_amount: 2, }
        );
    let available = account.get_available_spending_amount(eth.contract_address);
    assert_eq!(available, 2);

    start_cheat_block_timestamp(account.contract_address, starknet::get_block_timestamp() + 1000);
    let new_limit = SpendingLimit {
        timestamp: starknet::get_block_timestamp() + 2000, max_amount: 1,
    };
    account.set_spending_limit(eth.contract_address, new_limit);
    let stored_limit = account.get_spending_limit(eth.contract_address).unwrap();
    assert_eq!(stored_limit.timestamp, new_limit.timestamp);
    assert_eq!(stored_limit.max_amount, new_limit.max_amount);
    let available = account.get_available_spending_amount(eth.contract_address);
    assert_eq!(available, 1);
    stop_cheat_block_timestamp(account.contract_address);
    stop_cheat_caller_address(account.contract_address);
}

// #[test]
// fn test_spend_limit() {
//     let mut signer = KeyPairTrait::<felt252, felt252>::from_secret_key(123);
//     let (account, eth, _) = deploy_and_fund(signer.public_key);

//     start_cheat_caller_address(account.contract_address, account.contract_address);
//     let eth_limit = SpendingLimit {
//         timestamp: starknet::get_block_timestamp() + 1000, max_amount: 2,
//     };
//     account.set_spending_limit(eth.contract_address, eth_limit);
//     let available = account.get_available_spending_amount(eth.contract_address);
//     assert_eq!(available, 2);

//     let spender = contract_address_const::<'spender'>();
//     eth.approve(spender, 1);
//     eth.transfer(spender, 1);
//     assert_eq!(account.get_available_spending_amount(eth.contract_address), 1);
//     // eth.approve(spender, 1);
//     // eth.transfer(spender, 1);
//     // assert_eq!(account.get_available_spending_amount(eth.contract_address), 0);

//     stop_cheat_caller_address(account.contract_address);
// }


// #[test]
// #[should_panic(expected: ('Account: Limit exceeded',))]
// fn test_spend_over_limit() {
//     let mut signer = KeyPairTrait::<felt252, felt252>::from_secret_key(123);
//     let (account, eth, _) = deploy_and_fund(signer.public_key);

//     start_cheat_caller_address(account.contract_address, account.contract_address);
//     let eth_limit = SpendingLimit {
//         timestamp: starknet::get_block_timestamp() + 1000, max_amount: 2,
//     };
//     account.set_spending_limit(eth.contract_address, eth_limit);
//     let available = account.get_available_spending_amount(eth.contract_address);
//     assert_eq!(available, 2);

//     let spender = contract_address_const::<'spender'>();
//     eth.approve(spender, 3);

//     stop_cheat_caller_address(account.contract_address);
// }
