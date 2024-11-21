use core::option::OptionTrait;
use core::traits::TryInto;
use core::traits::Into;
use starknet::{ContractAddress, contract_address_const, account::Call};
use core::integer::{U64IntoFelt252};

use snforge_std::{
    declare, ContractClassTrait, start_mock_call, stop_mock_call, start_cheat_caller_address,
    stop_cheat_caller_address, start_cheat_block_timestamp, stop_cheat_block_timestamp
};
use snforge_std::signature::KeyPairTrait;
use snforge_std::signature::stark_curve::{
    StarkCurveKeyPairImpl, StarkCurveSignerImpl, StarkCurveVerifierImpl
};
use super::utils::{
    deploy_account_contract, deploy_erc20_contract, create_transfer_call, create_approve_call,
    declare_erc20_contract, deploy_declared_erc20
};

use aa_tutorial::standard_account::IAccountDispatcher;
use aa_tutorial::standard_account::IAccountDispatcherTrait;
use aa_tutorial::standard_account::IAccountSafeDispatcher;
use aa_tutorial::standard_account::IAccountSafeDispatcherTrait;

use openzeppelin::token::erc20::interface::IERC20Dispatcher;
use openzeppelin::token::erc20::interface::IERC20DispatcherTrait;

#[test]
fn check_stored_pub_key() {
    let public_key = 999;
    let limit = 1000000000000000; //0.001 * 10 ** 18
    let contract_address = deploy_account_contract(public_key, limit);
    let dispatcher = IAccountDispatcher { contract_address };
    let stored_pub_key = dispatcher.public_key();
    assert(public_key == stored_pub_key, 'Wrong pub key');
}

#[test]
fn check_stored_time_limit() {
    let mut signer = KeyPairTrait::<felt252, felt252>::from_secret_key(123);
    let time_limit = 600; //600 seconds - 10 minutes
    let contract_address = deploy_account_contract(signer.public_key, time_limit);
    let dispatcher = IAccountDispatcher { contract_address };

    let stored_time_limit = dispatcher.get_time_limit();

    assert(time_limit == stored_time_limit, 'Time limit wrong');
}

#[test]
fn check_stored_spending_limit() {
    let mut signer = KeyPairTrait::<felt252, felt252>::from_secret_key(123);
    let time_limit = 600;
    let spending_limit = 1000000000000000; //0.001 * 10 ** 18
    let contract_address = deploy_account_contract(signer.public_key, time_limit);
    let dispatcher = IAccountDispatcher { contract_address };

    let mock_token_address: ContractAddress = contract_address_const::<1121321>();
    dispatcher.set_spending_limit(mock_token_address, spending_limit);
    let stored_spending_limit = dispatcher.get_spending_limit(mock_token_address);

    //Will revert after time_limit seconds have passed.
    assert(stored_spending_limit == spending_limit, 'Wrong spending limit');
}

#[test]
fn check_spending_limit_after_transfer() {
    let mut signer = KeyPairTrait::<felt252, felt252>::from_secret_key(123);
    let time_limit = 600;
    let spending_limit = 10000000000000000; //0.01 * 10 ** 18
    let account_address = deploy_account_contract(signer.public_key, time_limit);
    let token_address = deploy_erc20_contract(
        'MyToken', 'MTK', 10000000000000000000, account_address
    ); //Pre-mints 10 MTK.

    let account_dispatcher = IAccountDispatcher { contract_address: account_address };

    account_dispatcher.set_spending_limit(token_address, spending_limit);
    let mock_account_address = contract_address_const::<
        0x067981c7f9f55bcbdd4e0d0a9c5bbcea77dacb42cccbf13554a847d6353f728e
    >();
    let transfer_value: u256 = 1000000000000000; //0.001 MTK

    let transferCall = create_transfer_call(token_address, mock_account_address, transfer_value);

    start_cheat_caller_address(account_address, 0.try_into().unwrap());
    account_dispatcher.__execute__(array![transferCall]);
    stop_cheat_caller_address(account_address);

    let remaining_limit = account_dispatcher.get_spending_limit(token_address);
    println!("Remaining limit: {}", remaining_limit);
    let current_limit = account_dispatcher.get_current_spending_limit(token_address);
    println!("Remaining current limit: {}", current_limit);

    assert(remaining_limit == (spending_limit - transfer_value), 'Spending limit wrong');
}

#[test]
fn spending_limit_after_time_limit() {
    let mut signer = KeyPairTrait::<felt252, felt252>::from_secret_key(123);
    let time_limit = 600;
    let spending_limit = 10000000000000000; //0.01 * 10 ** 18
    let account_address = deploy_account_contract(signer.public_key, time_limit);
    let token_address = deploy_erc20_contract(
        'MyToken', 'MTK', 10000000000000000000, account_address
    ); //Pre-mints 10 MTK.

    let account_dispatcher = IAccountDispatcher { contract_address: account_address };

    let start_timestamp = 1000;
    start_cheat_block_timestamp(account_address, start_timestamp);
    account_dispatcher.set_spending_limit(token_address, spending_limit);
    stop_cheat_block_timestamp(account_address);
    let mock_account_address = contract_address_const::<123456789>();
    let transfer_value: u256 = 1000000000000000; //0.001 MTK

    let transferCall1 = create_transfer_call(token_address, mock_account_address, transfer_value);

    start_cheat_caller_address(account_address, 0.try_into().unwrap());
    account_dispatcher.__execute__(array![transferCall1]);

    let new_timestamp = start_timestamp + time_limit + 10;
    start_cheat_block_timestamp(account_address, new_timestamp);
    let new_limit = account_dispatcher.get_spending_limit(token_address);
    assert(new_limit == spending_limit, 'Spending limit wrong');

    let transferCall2 = create_transfer_call(token_address, mock_account_address, transfer_value);
    account_dispatcher.__execute__(array![transferCall2]);

    let spending_limit_timestamp = account_dispatcher.get_spending_limit_timestamp(token_address);
    stop_cheat_block_timestamp(account_address);

    assert(spending_limit_timestamp == new_timestamp, 'Timestamp not updated');
}

#[test]
fn multicall_spending_limit() {
    let mut signer = KeyPairTrait::<felt252, felt252>::from_secret_key(123);
    let time_limit = 600;
    let spending_limit = 10000000000000000; //0.01 * 10 ** 18
    let account_address = deploy_account_contract(signer.public_key, time_limit);
    let erc20_class = declare_erc20_contract();

    let token_address1 = deploy_declared_erc20(
        erc20_class, 'MyToken', 'MTK', 10000000000000000000, account_address
    ); //Pre-mints 10 MTK.
    let token_address2 = deploy_declared_erc20(
        erc20_class, 'MyTokenTest', 'MTKT', 10000000000000000000, account_address
    ); //Pre-mints 10 MTK1.
    let account_dispatcher = IAccountDispatcher { contract_address: account_address };

    let transfer_value: u256 = 1000000000000000; //0.001 MTK
    let approve_value: u256 = 5000000000000000; //0.005 MTK

    let mock_account_address = contract_address_const::<123456789>();
    let transferCall_1 = create_transfer_call(token_address1, mock_account_address, transfer_value);
    let approveCall_1 = create_approve_call(token_address1, mock_account_address, approve_value);
    let approveCall_2 = create_approve_call(token_address2, mock_account_address, approve_value);
    let start_timestamp_1 = 1000;
    let start_timestamp_2 = 1200;
    start_cheat_block_timestamp(account_address, start_timestamp_1);
    account_dispatcher.set_spending_limit(token_address1, spending_limit);
    stop_cheat_block_timestamp(account_address);

    start_cheat_block_timestamp(account_address, start_timestamp_2);
    account_dispatcher.set_spending_limit(token_address2, spending_limit);
    stop_cheat_block_timestamp(account_address);

    start_cheat_caller_address(account_address, 0.try_into().unwrap());
    account_dispatcher.__execute__(array![transferCall_1, approveCall_1, approveCall_2]);

    let spending_limit_1 = account_dispatcher.get_spending_limit(token_address1);
    let spending_limit_2 = account_dispatcher.get_spending_limit(token_address2);
    assert(
        spending_limit_1 == (spending_limit - (approve_value + transfer_value)),
        'Multicall limit wrong'
    );
    assert(spending_limit_2 == (spending_limit - approve_value), 'Token2 limit wrong');

    start_cheat_block_timestamp(account_address, start_timestamp_2 + time_limit + 150);
    let transferCall_2 = create_transfer_call(token_address2, mock_account_address, transfer_value);
    account_dispatcher.__execute__(array![transferCall_2]);
    stop_cheat_block_timestamp(account_address);
    let spending_limit_21 = account_dispatcher.get_spending_limit(token_address2);
    println!("spending_limit_21: {}", spending_limit_21);
    assert(spending_limit_21 == (spending_limit - transfer_value), 'Spending limit wrong');
    stop_cheat_caller_address(account_address);
}

#[test]
#[should_panic(expected: ('u256_sub Overflow',))]
fn check_over_spending_limit() {
    let mut signer = KeyPairTrait::<felt252, felt252>::from_secret_key(123);
    let time_limit = 600;
    let spending_limit = 10000000000000000; //0.01 * 10 ** 18
    let account_address = deploy_account_contract(signer.public_key, time_limit);
    let token_address = deploy_erc20_contract(
        'MyToken', 'MTK', 10000000000000000000, account_address
    ); //Pre-mints 10 MTK.
    let mock_account_address = contract_address_const::<123456789>();

    let account_dispatcher = IAccountDispatcher { contract_address: account_address };

    let start_timestamp = 1000;
    let approve_value = 11000000000000000; // 0.0011 * 10 ** 18

    start_cheat_block_timestamp(account_address, start_timestamp);
    account_dispatcher.set_spending_limit(token_address, spending_limit);
    stop_cheat_block_timestamp(account_address);

    start_cheat_caller_address(account_address, 0.try_into().unwrap());
    let approveCall = create_approve_call(token_address, mock_account_address, approve_value);
    start_cheat_block_timestamp(account_address, start_timestamp + 500);
    account_dispatcher.__execute__(array![approveCall]);
    stop_cheat_block_timestamp(account_address);
    stop_cheat_caller_address(account_address);
}
