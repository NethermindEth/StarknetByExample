use core::result::ResultTrait;
use starknet::{ContractAddress, account::Call, contract_address_const};
use core::integer::{U64IntoFelt252, U256TryIntoFelt252};

use snforge_std::{declare, ContractClassTrait, ContractClass};

fn deploy_account_contract(public_key: felt252, time_limit: u64) -> ContractAddress {
    let contract = declare("Account").unwrap();
    let time_limit_felt252: felt252 = U64IntoFelt252::into(time_limit);
    let constructor_args = array![public_key, time_limit_felt252];
    let (contract_address, _) = contract.deploy(@constructor_args).unwrap();
    contract_address
}

fn deploy_erc20_contract(
    name: felt252, symbol: felt252, fixed_supply: u256, recipient: ContractAddress,
) -> ContractAddress {
    let contract = declare("MyERC20Token").unwrap();
    let constructor_args = array![
        name, symbol, fixed_supply.low.into(), fixed_supply.high.into(), recipient.into(),
    ];

    let (contract_address, _) = contract.deploy(@constructor_args).unwrap();
    contract_address
}

fn declare_erc20_contract() -> ContractClass {
    declare("MyERC20Token").unwrap()
}

fn deploy_declared_erc20(
    class: ContractClass,
    name: felt252,
    symbol: felt252,
    fixed_supply: u256,
    recipient: ContractAddress,
) -> ContractAddress {
    let constructor_args = array![
        name, symbol, fixed_supply.low.into(), fixed_supply.high.into(), recipient.into(),
    ];

    let (contract_address, _) = class.deploy(@constructor_args).unwrap();
    contract_address
}


fn create_transfer_call(
    token_address: ContractAddress, recipient: ContractAddress, value: u256,
) -> Call {
    return Call {
        to: token_address,
        selector: selector!("transfer"),
        calldata: array![recipient.into(), value.low.into(), value.high.into()].span(),
    };
}

fn create_approve_call(
    token_address: ContractAddress, allowed_address: ContractAddress, value: u256,
) -> Call {
    return Call {
        to: token_address,
        selector: selector!("approve"),
        calldata: array![allowed_address.into(), value.low.into(), value.high.into()].span(),
    };
}
