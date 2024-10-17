use erc721::erc721::{
    IERC721Dispatcher, IERC721DispatcherTrait // , ERC721::{Event, Transfer, Approval}
};

use snforge_std::{declare, DeclareResultTrait, ContractClassTrait, start_cheat_caller_address,};
use starknet::{ContractAddress, contract_address_const};

pub const TOKEN_ID: u256 = 21;

pub fn OWNER() -> ContractAddress {
    contract_address_const::<'OWNER'>()
}

pub fn ZERO() -> ContractAddress {
    contract_address_const::<0>()
}

pub fn SPENDER() -> ContractAddress {
    contract_address_const::<'SPENDER'>()
}

fn deploy() -> (IERC721Dispatcher, ContractAddress) {
    let contract = declare("ERC721").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    (IERC721Dispatcher { contract_address }, contract_address)
}

fn setup() -> (IERC721Dispatcher, ContractAddress) {
    let (contract, contract_address) = deploy();
    contract.mint(OWNER(), TOKEN_ID);
    (contract, contract_address)
}

//
// Getters
//

#[test]
fn test_balance_of() {
    let (contract, _) = setup();
    assert_eq!(contract.balance_of(OWNER()), 1);
}

#[test]
#[should_panic(expected: ('ERC721: invalid account',))]
fn test_balance_of_zero() {
    let (contract, _) = setup();
    contract.balance_of(ZERO());
}

#[test]
fn test_owner_of() {
    let (contract, _) = setup();
    assert_eq!(contract.owner_of(TOKEN_ID), OWNER());
}

#[test]
#[should_panic(expected: ('ERC721: invalid token ID',))]
fn test_owner_of_non_minted() {
    let (contract, _) = setup();
    contract.owner_of(7);
}

#[test]
fn test_get_approved() {
    let (mut contract, contract_address) = setup();
    let spender = SPENDER();
    let token_id = TOKEN_ID;

    start_cheat_caller_address(contract_address, OWNER());

    assert_eq!(contract.get_approved(token_id), ZERO());
    contract.approve(spender, token_id);
    assert_eq!(contract.get_approved(token_id), spender);
}

#[test]
#[should_panic(expected: ('ERC721: invalid token ID',))]
fn test_get_approved_nonexistent() {
    let (contract, _) = setup();
    contract.get_approved(7);
}
