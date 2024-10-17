use erc721::erc721::{
    IERC721Dispatcher, IERC721DispatcherTrait, ERC721::{Event, Transfer, Approval}
};

use snforge_std::{
    declare, DeclareResultTrait, ContractClassTrait, start_cheat_caller_address, spy_events,
    EventSpyAssertionsTrait,
};
use starknet::{ContractAddress, contract_address_const};

pub const TOKEN_ID: u256 = 21;

pub fn CALLER() -> ContractAddress {
    contract_address_const::<'CALLER'>()
}

pub fn OPERATOR() -> ContractAddress {
    contract_address_const::<'OPERATOR'>()
}

pub fn OTHER() -> ContractAddress {
    contract_address_const::<'OTHER'>()
}

pub fn OWNER() -> ContractAddress {
    contract_address_const::<'OWNER'>()
}

pub fn SPENDER() -> ContractAddress {
    contract_address_const::<'SPENDER'>()
}

pub fn ZERO() -> ContractAddress {
    contract_address_const::<0>()
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

//
// approve
//

#[test]
fn test_approve_from_owner() {
    let (mut contract, contract_address) = setup();
    let mut spy = spy_events();

    start_cheat_caller_address(contract_address, OWNER());
    contract.approve(SPENDER(), TOKEN_ID);

    spy
        .assert_emitted(
            @array![
                (
                    contract_address,
                    Event::Approval(
                        Approval { owner: OWNER(), approved: SPENDER(), token_id: TOKEN_ID }
                    )
                )
            ]
        );

    let approved = contract.get_approved(TOKEN_ID);
    assert_eq!(approved, SPENDER());
}

#[test]
fn test_approve_from_operator() {
    let (mut contract, contract_address) = setup();

    start_cheat_caller_address(contract_address, OWNER());
    contract.set_approval_for_all(OPERATOR(), true);

    let mut spy = spy_events();

    start_cheat_caller_address(contract_address, OPERATOR());
    contract.approve(SPENDER(), TOKEN_ID);
    spy
        .assert_emitted(
            @array![
                (
                    contract_address,
                    Event::Approval(
                        Approval { owner: OWNER(), approved: SPENDER(), token_id: TOKEN_ID }
                    )
                )
            ]
        );

    let approved = contract.get_approved(TOKEN_ID);
    assert_eq!(approved, SPENDER());
}

#[test]
#[should_panic(expected: ('ERC721: unauthorized caller',))]
fn test_approve_from_unauthorized() {
    let (mut contract, contract_address) = setup();

    start_cheat_caller_address(contract_address, OTHER());
    contract.approve(SPENDER(), TOKEN_ID);
}

#[test]
#[should_panic(expected: ('ERC721: invalid token ID',))]
fn test_approve_nonexistent() {
    let (mut contract, _) = setup();
    contract.approve(SPENDER(), TOKEN_ID);
}

#[test]
fn test_approve_auth_is_approved_for_all() {
    let (mut contract, contract_address) = setup();
    let auth = CALLER();

    start_cheat_caller_address(contract_address, OWNER());
    contract.set_approval_for_all(auth, true);

    let mut spy = spy_events();

    start_cheat_caller_address(contract_address, auth);
    contract.approve(SPENDER(), TOKEN_ID);
    spy
        .assert_emitted(
            @array![
                (
                    contract_address,
                    Event::Approval(
                        Approval { owner: OWNER(), approved: SPENDER(), token_id: TOKEN_ID }
                    )
                )
            ]
        );

    let approved = contract.get_approved(TOKEN_ID);
    assert_eq!(approved, SPENDER());
}
