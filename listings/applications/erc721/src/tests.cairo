use core::num::traits::Zero;
use erc721::interfaces::{
    IERC721, IERC721Dispatcher, IERC721DispatcherTrait, IERC721SafeDispatcher,
    IERC721SafeDispatcherTrait, IERC721Mintable, IERC721MintableDispatcher,
    IERC721MintableDispatcherTrait, IERC721BurnableDispatcher, IERC721BurnableDispatcherTrait,
};
use erc721::erc721::{ERC721, ERC721::{Event, Transfer, Approval, ApprovalForAll, InternalTrait}};
use snforge_std::{
    declare, test_address, DeclareResultTrait, ContractClassTrait, start_cheat_caller_address,
    spy_events, EventSpyAssertionsTrait,
};
use starknet::{ContractAddress, contract_address_const};

pub const SUCCESS: felt252 = 'SUCCESS';
pub const FAILURE: felt252 = 'FAILURE';
pub const PUBKEY: felt252 = 'PUBKEY';
pub const TOKEN_ID: u256 = 21;
pub const NONEXISTENT_TOKEN_ID: u256 = 7;

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

pub fn RECIPIENT() -> ContractAddress {
    contract_address_const::<'RECIPIENT'>()
}

pub fn SPENDER() -> ContractAddress {
    contract_address_const::<'SPENDER'>()
}

pub fn ZERO() -> ContractAddress {
    contract_address_const::<0>()
}

pub fn DATA(success: bool) -> Span<felt252> {
    let value = if success {
        SUCCESS
    } else {
        FAILURE
    };
    array![value].span()
}

fn deploy_account() -> ContractAddress {
    let contract = declare("AccountMock").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![PUBKEY]).unwrap();
    contract_address
}

fn deploy_receiver() -> ContractAddress {
    let contract = declare("ERC721ReceiverMock").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    contract_address
}

fn deploy_non_receiver() -> ContractAddress {
    let contract = declare("NonReceiverMock").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    contract_address
}

fn setup(mint_to: ContractAddress) -> (IERC721Dispatcher, ContractAddress) {
    let contract = declare("ERC721").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    if mint_to != ZERO() {
        let contract = IERC721MintableDispatcher { contract_address };
        contract.mint(mint_to, TOKEN_ID);
    }
    let contract = IERC721Dispatcher { contract_address };
    (contract, contract_address)
}

fn setup_internals() -> ERC721::ContractState {
    let mut state = ERC721::contract_state_for_testing();
    state.mint(OWNER(), TOKEN_ID);
    state
}

//
// Getters
//

#[test]
fn test_balance_of() {
    let (contract, _) = setup(OWNER());
    assert_eq!(contract.balance_of(OWNER()), 1);
}

#[test]
#[should_panic(expected: ('ERC721: invalid account',))]
fn test_balance_of_zero() {
    let (contract, _) = setup(OWNER());
    contract.balance_of(ZERO());
}

#[test]
fn test_owner_of() {
    let (contract, _) = setup(OWNER());
    assert_eq!(contract.owner_of(TOKEN_ID), OWNER());
}

#[test]
#[should_panic(expected: ('ERC721: invalid token ID',))]
fn test_owner_of_non_minted() {
    let (contract, _) = setup(OWNER());
    contract.owner_of(NONEXISTENT_TOKEN_ID);
}

#[test]
fn test_get_approved() {
    let (mut contract, contract_address) = setup(OWNER());
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
    let (contract, _) = setup(OWNER());
    contract.get_approved(NONEXISTENT_TOKEN_ID);
}

//
// approve
//

#[test]
fn test_approve_from_owner() {
    let (mut contract, contract_address) = setup(OWNER());
    let mut spy = spy_events();

    start_cheat_caller_address(contract_address, OWNER());
    contract.approve(SPENDER(), TOKEN_ID);

    spy
        .assert_emitted(
            @array![
                (
                    contract_address,
                    Event::Approval(
                        Approval { owner: OWNER(), approved: SPENDER(), token_id: TOKEN_ID },
                    ),
                ),
            ],
        );

    let approved = contract.get_approved(TOKEN_ID);
    assert_eq!(approved, SPENDER());
}

#[test]
fn test_approve_from_operator() {
    let (mut contract, contract_address) = setup(OWNER());

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
                        Approval { owner: OWNER(), approved: SPENDER(), token_id: TOKEN_ID },
                    ),
                ),
            ],
        );

    let approved = contract.get_approved(TOKEN_ID);
    assert_eq!(approved, SPENDER());
}

#[test]
#[should_panic(expected: ('ERC721: unauthorized caller',))]
fn test_approve_from_unauthorized() {
    let (mut contract, contract_address) = setup(OWNER());

    start_cheat_caller_address(contract_address, OTHER());
    contract.approve(SPENDER(), TOKEN_ID);
}

#[test]
#[should_panic(expected: ('ERC721: invalid token ID',))]
fn test_approve_nonexistent() {
    let (mut contract, _) = setup(OWNER());
    contract.approve(SPENDER(), NONEXISTENT_TOKEN_ID);
}

#[test]
fn test_approve_auth_is_approved_for_all() {
    let (mut contract, contract_address) = setup(OWNER());
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
                        Approval { owner: OWNER(), approved: SPENDER(), token_id: TOKEN_ID },
                    ),
                ),
            ],
        );

    let approved = contract.get_approved(TOKEN_ID);
    assert_eq!(approved, SPENDER());
}

//
// set_approval_for_all
//

#[test]
fn test_set_approval_for_all() {
    let (mut contract, contract_address) = setup(OWNER());
    let mut spy = spy_events();

    start_cheat_caller_address(contract_address, OWNER());
    let not_approved_for_all = !contract.is_approved_for_all(OWNER(), OPERATOR());
    assert!(not_approved_for_all);

    contract.set_approval_for_all(OPERATOR(), true);
    spy
        .assert_emitted(
            @array![
                (
                    contract_address,
                    Event::ApprovalForAll(
                        ApprovalForAll { owner: OWNER(), operator: OPERATOR(), approved: true },
                    ),
                ),
            ],
        );

    let is_approved_for_all = contract.is_approved_for_all(OWNER(), OPERATOR());
    assert!(is_approved_for_all);

    contract.set_approval_for_all(OPERATOR(), false);
    spy
        .assert_emitted(
            @array![
                (
                    contract_address,
                    Event::ApprovalForAll(
                        ApprovalForAll { owner: OWNER(), operator: OPERATOR(), approved: false },
                    ),
                ),
            ],
        );

    let not_approved_for_all = !contract.is_approved_for_all(OWNER(), OPERATOR());
    assert!(not_approved_for_all);
}

#[test]
#[should_panic(expected: ('ERC721: invalid operator',))]
fn test_set_approval_for_all_invalid_operator() {
    let (mut contract, _) = setup(OWNER());
    contract.set_approval_for_all(ZERO(), true);
}

//
// transfer_from
//

#[test]
fn test_transfer_from_owner() {
    let owner = OWNER();
    let recipient = RECIPIENT();
    let (mut contract, contract_address) = setup(owner);

    // set approval to check reset
    start_cheat_caller_address(contract_address, owner);
    contract.approve(OTHER(), TOKEN_ID);

    assert_state_before_transfer(contract, owner, recipient, TOKEN_ID);

    let approved = contract.get_approved(TOKEN_ID);
    assert_eq!(approved, OTHER());

    let mut spy = spy_events();

    contract.transfer_from(owner, recipient, TOKEN_ID);
    spy
        .assert_emitted(
            @array![
                (
                    contract_address,
                    Event::Transfer(Transfer { from: owner, to: recipient, token_id: TOKEN_ID }),
                ),
            ],
        );

    assert_state_after_transfer(contract, owner, recipient, TOKEN_ID);
}

#[test]
#[should_panic(expected: ('ERC721: invalid token ID',))]
fn test_transfer_from_nonexistent() {
    let (mut contract, contract_address) = setup(OWNER());
    start_cheat_caller_address(contract_address, OWNER());
    contract.transfer_from(ZERO(), RECIPIENT(), NONEXISTENT_TOKEN_ID);
}

#[test]
#[should_panic(expected: ('ERC721: invalid receiver',))]
fn test_transfer_from_to_zero() {
    let (mut contract, contract_address) = setup(OWNER());
    start_cheat_caller_address(contract_address, OWNER());
    contract.transfer_from(OWNER(), ZERO(), TOKEN_ID);
}

#[test]
fn test_transfer_from_to_owner() {
    let owner = OWNER();
    let (mut contract, contract_address) = setup(owner);
    let mut spy = spy_events();

    assert_eq!(contract.owner_of(TOKEN_ID), owner);
    assert_eq!(contract.balance_of(owner), 1);

    start_cheat_caller_address(contract_address, owner);
    contract.transfer_from(owner, owner, TOKEN_ID);
    spy
        .assert_emitted(
            @array![
                (
                    contract_address,
                    Event::Transfer(Transfer { from: owner, to: owner, token_id: TOKEN_ID }),
                ),
            ],
        );

    assert_eq!(contract.owner_of(TOKEN_ID), owner);
    assert_eq!(contract.balance_of(owner), 1);
}

#[test]
fn test_transfer_from_approved() {
    let token_id = TOKEN_ID;
    let owner = OWNER();
    let recipient = RECIPIENT();
    let (mut contract, contract_address) = setup(owner);

    assert_state_before_transfer(contract, owner, recipient, token_id);

    start_cheat_caller_address(contract_address, owner);
    contract.approve(OPERATOR(), token_id);

    let mut spy = spy_events();

    start_cheat_caller_address(contract_address, OPERATOR());
    contract.transfer_from(owner, recipient, token_id);
    spy
        .assert_emitted(
            @array![
                (
                    contract_address,
                    Event::Transfer(Transfer { from: owner, to: recipient, token_id }),
                ),
            ],
        );

    assert_state_after_transfer(contract, owner, recipient, token_id);
}

#[test]
fn test_transfer_from_approved_for_all() {
    let token_id = TOKEN_ID;
    let owner = OWNER();
    let recipient = RECIPIENT();
    let (mut contract, contract_address) = setup(owner);

    assert_state_before_transfer(contract, owner, recipient, token_id);

    start_cheat_caller_address(contract_address, owner);
    contract.set_approval_for_all(OPERATOR(), true);

    let mut spy = spy_events();

    start_cheat_caller_address(contract_address, OPERATOR());
    contract.transfer_from(owner, recipient, token_id);
    spy
        .assert_emitted(
            @array![
                (
                    contract_address,
                    Event::Transfer(Transfer { from: owner, to: recipient, token_id }),
                ),
            ],
        );

    assert_state_after_transfer(contract, owner, recipient, token_id);
}

#[test]
#[should_panic(expected: ('ERC721: unauthorized caller',))]
fn test_transfer_from_unauthorized() {
    let (mut contract, contract_address) = setup(OWNER());
    start_cheat_caller_address(contract_address, OTHER());
    contract.transfer_from(OWNER(), RECIPIENT(), TOKEN_ID);
}

//
// safe_transfer_from
//

#[test]
fn test_safe_transfer_from_to_account() {
    let account = deploy_account();
    let mut spy = spy_events();
    let owner = OWNER();
    let (mut contract, contract_address) = setup(owner);

    assert_state_before_transfer(contract, owner, account, TOKEN_ID);

    start_cheat_caller_address(contract_address, owner);
    contract.safe_transfer_from(owner, account, TOKEN_ID, DATA(true));
    spy
        .assert_emitted(
            @array![
                (
                    contract_address,
                    Event::Transfer(Transfer { from: owner, to: account, token_id: TOKEN_ID }),
                ),
            ],
        );

    assert_state_after_transfer(contract, owner, account, TOKEN_ID);
}

#[test]
fn test_safe_transfer_from_to_receiver() {
    let receiver = deploy_receiver();
    let mut spy = spy_events();
    let owner = OWNER();
    let (mut contract, contract_address) = setup(owner);

    assert_state_before_transfer(contract, owner, receiver, TOKEN_ID);

    start_cheat_caller_address(contract_address, owner);
    contract.safe_transfer_from(owner, receiver, TOKEN_ID, DATA(true));
    spy
        .assert_emitted(
            @array![
                (
                    contract_address,
                    Event::Transfer(Transfer { from: owner, to: receiver, token_id: TOKEN_ID }),
                ),
            ],
        );

    assert_state_after_transfer(contract, owner, receiver, TOKEN_ID);
}

#[test]
#[should_panic(expected: ('ERC721: safe transfer failed',))]
fn test_safe_transfer_from_to_receiver_failure() {
    let receiver = deploy_receiver();
    let owner = OWNER();
    let (mut contract, contract_address) = setup(owner);

    start_cheat_caller_address(contract_address, owner);
    contract.safe_transfer_from(owner, receiver, TOKEN_ID, DATA(false));
}

#[test]
#[should_panic(expected: ('ENTRYPOINT_NOT_FOUND', 'ENTRYPOINT_FAILED'))]
fn test_safe_transfer_from_to_non_receiver() {
    let none_receiver = deploy_non_receiver();
    let owner = OWNER();
    let (mut contract, contract_address) = setup(owner);

    start_cheat_caller_address(contract_address, owner);
    contract.safe_transfer_from(owner, none_receiver, TOKEN_ID, DATA(true));
}

#[test]
#[should_panic(expected: ('ERC721: invalid token ID',))]
fn test_safe_transfer_from_nonexistent() {
    let (mut contract, contract_address) = setup(OWNER());
    start_cheat_caller_address(contract_address, OWNER());
    contract.safe_transfer_from(ZERO(), RECIPIENT(), NONEXISTENT_TOKEN_ID, DATA(true));
}

#[test]
#[should_panic(expected: ('ERC721: invalid receiver',))]
fn test_safe_transfer_from_to_zero() {
    let (mut contract, contract_address) = setup(OWNER());
    start_cheat_caller_address(contract_address, OWNER());
    contract.safe_transfer_from(OWNER(), ZERO(), TOKEN_ID, DATA(true));
}

#[test]
fn test_safe_transfer_from_to_owner() {
    let owner = deploy_receiver();
    let (mut contract, contract_address) = setup(owner);

    assert_eq!(contract.owner_of(TOKEN_ID), owner);
    assert_eq!(contract.balance_of(owner), 1);

    let mut spy = spy_events();

    start_cheat_caller_address(contract_address, owner);
    contract.safe_transfer_from(owner, owner, TOKEN_ID, DATA(true));
    spy
        .assert_emitted(
            @array![
                (
                    contract_address,
                    Event::Transfer(Transfer { from: owner, to: owner, token_id: TOKEN_ID }),
                ),
            ],
        );

    assert_eq!(contract.owner_of(TOKEN_ID), owner);
    assert_eq!(contract.balance_of(owner), 1);
}

#[test]
fn test_safe_transfer_from_approved() {
    let receiver = deploy_receiver();
    let owner = OWNER();
    let (mut contract, contract_address) = setup(owner);

    assert_state_before_transfer(contract, owner, receiver, TOKEN_ID);

    start_cheat_caller_address(contract_address, owner);
    contract.approve(OPERATOR(), TOKEN_ID);

    let mut spy = spy_events();

    start_cheat_caller_address(contract_address, OPERATOR());
    contract.safe_transfer_from(owner, receiver, TOKEN_ID, DATA(true));
    spy
        .assert_emitted(
            @array![
                (
                    contract_address,
                    Event::Transfer(Transfer { from: owner, to: receiver, token_id: TOKEN_ID }),
                ),
            ],
        );

    assert_state_after_transfer(contract, owner, receiver, TOKEN_ID);
}

#[test]
fn test_safe_transfer_from_approved_for_all() {
    let receiver = deploy_receiver();
    let owner = OWNER();
    let (mut contract, contract_address) = setup(owner);

    assert_state_before_transfer(contract, owner, receiver, TOKEN_ID);

    start_cheat_caller_address(contract_address, owner);
    contract.set_approval_for_all(OPERATOR(), true);

    let mut spy = spy_events();

    start_cheat_caller_address(contract_address, OPERATOR());
    contract.safe_transfer_from(owner, receiver, TOKEN_ID, DATA(true));
    spy
        .assert_emitted(
            @array![
                (
                    contract_address,
                    Event::Transfer(Transfer { from: owner, to: receiver, token_id: TOKEN_ID }),
                ),
            ],
        );

    assert_state_after_transfer(contract, owner, receiver, TOKEN_ID);
}

#[test]
#[should_panic(expected: ('ERC721: unauthorized caller',))]
fn test_safe_transfer_from_unauthorized() {
    let (mut contract, contract_address) = setup(OWNER());
    start_cheat_caller_address(contract_address, OTHER());
    contract.safe_transfer_from(OWNER(), RECIPIENT(), TOKEN_ID, DATA(true));
}

//
// mint
//

#[test]
fn test_mint() {
    let mut spy = spy_events();
    let recipient = RECIPIENT();
    let (mut contract, contract_address) = setup(ZERO());

    assert!(contract.balance_of(recipient).is_zero());

    {
        let mut contract = IERC721MintableDispatcher { contract_address };
        contract.mint(recipient, TOKEN_ID);
    }

    spy
        .assert_emitted(
            @array![
                (
                    contract_address,
                    Event::Transfer(Transfer { from: ZERO(), to: recipient, token_id: TOKEN_ID }),
                ),
            ],
        );

    assert_eq!(contract.owner_of(TOKEN_ID), recipient);
    assert_eq!(contract.balance_of(recipient), 1);
    assert!(contract.get_approved(TOKEN_ID).is_zero());
}

#[test]
#[should_panic(expected: ('ERC721: invalid receiver',))]
fn test_mint_to_zero() {
    let (_, contract_address) = setup(ZERO());
    let mut contract = IERC721MintableDispatcher { contract_address };
    contract.mint(ZERO(), TOKEN_ID);
}

#[test]
#[should_panic(expected: ('ERC721: token already minted',))]
fn test_mint_already_exist() {
    let (_, contract_address) = setup(OWNER());
    let mut contract = IERC721MintableDispatcher { contract_address };
    contract.mint(RECIPIENT(), TOKEN_ID);
}

//
// burn
//

#[test]
#[feature("safe_dispatcher")]
fn test_burn() {
    let (mut contract, contract_address) = setup(OWNER());

    start_cheat_caller_address(contract_address, OWNER());
    // we test that approvals get removed when burning
    contract.approve(OTHER(), TOKEN_ID);

    assert_eq!(contract.owner_of(TOKEN_ID), OWNER());
    assert_eq!(contract.balance_of(OWNER()), 1);
    assert_eq!(contract.get_approved(TOKEN_ID), OTHER());

    let mut spy = spy_events();

    {
        let mut contract = IERC721BurnableDispatcher { contract_address };
        contract.burn(TOKEN_ID);
    }

    spy
        .assert_emitted(
            @array![
                (
                    contract_address,
                    Event::Transfer(Transfer { from: OWNER(), to: ZERO(), token_id: TOKEN_ID }),
                ),
            ],
        );

    assert_eq!(contract.balance_of(OWNER()), 0);

    let contract = IERC721SafeDispatcher { contract_address };
    match contract.owner_of(TOKEN_ID) {
        Result::Ok(_) => panic!("`owner_of` did not panic"),
        Result::Err(panic_data) => {
            assert(*panic_data.at(0) == 'ERC721: invalid token ID', *panic_data.at(0));
        },
    };
    match contract.get_approved(TOKEN_ID) {
        Result::Ok(_) => panic!("`get_approved` did not panic"),
        Result::Err(panic_data) => {
            assert(*panic_data.at(0) == 'ERC721: invalid token ID', *panic_data.at(0));
        },
    };
}

#[test]
#[should_panic(expected: ('ERC721: invalid token ID',))]
fn test_burn_nonexistent() {
    let (_, contract_address) = setup(OWNER());
    let mut contract = IERC721BurnableDispatcher { contract_address };
    contract.burn(NONEXISTENT_TOKEN_ID);
}

//
// Internals
//

#[test]
fn test__require_owned() {
    let mut state = setup_internals();
    let owner = state._require_owned(TOKEN_ID);
    assert_eq!(owner, OWNER());
}

#[test]
#[should_panic(expected: ('ERC721: invalid token ID',))]
fn test__require_owned_nonexistent() {
    let mut state = setup_internals();
    state._require_owned(NONEXISTENT_TOKEN_ID);
}

#[test]
fn test__is_approved_or_owner_owner() {
    let mut state = setup_internals();
    let authorized = state._is_approved_or_owner(OWNER(), OWNER(), TOKEN_ID);
    assert!(authorized);
}

#[test]
fn test__is_approved_or_owner_approved_for_all() {
    let mut state = setup_internals();

    start_cheat_caller_address(test_address(), OWNER());
    state.set_approval_for_all(SPENDER(), true);

    let authorized = state._is_approved_or_owner(OWNER(), SPENDER(), TOKEN_ID);
    assert!(authorized);
}

#[test]
fn test__is_approved_or_owner_approved() {
    let mut state = setup_internals();

    start_cheat_caller_address(test_address(), OWNER());
    state.approve(SPENDER(), TOKEN_ID);

    let authorized = state._is_approved_or_owner(OWNER(), SPENDER(), TOKEN_ID);
    assert!(authorized);
}

#[test]
fn test__is_approved_or_owner_not_authorized() {
    let mut state = setup_internals();
    let not_authorized = !state._is_approved_or_owner(OWNER(), CALLER(), TOKEN_ID);
    assert!(not_authorized);
}

#[test]
fn test__is_approved_or_owner_zero_address() {
    let mut state = setup_internals();
    let not_authorized = !state._is_approved_or_owner(OWNER(), ZERO(), TOKEN_ID);
    assert!(not_authorized);
}

//
// Helpers
//

fn assert_state_before_transfer(
    contract: IERC721Dispatcher, owner: ContractAddress, recipient: ContractAddress, token_id: u256,
) {
    assert_eq!(contract.owner_of(token_id), owner);
    assert_eq!(contract.balance_of(owner), 1);
    assert!(contract.balance_of(recipient).is_zero());
}

fn assert_state_after_transfer(
    contract: IERC721Dispatcher, owner: ContractAddress, recipient: ContractAddress, token_id: u256,
) {
    assert_eq!(contract.owner_of(token_id), recipient);
    assert_eq!(contract.balance_of(owner), 0);
    assert_eq!(contract.balance_of(recipient), 1);
    assert!(contract.get_approved(token_id).is_zero());
}
