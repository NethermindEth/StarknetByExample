use starknet::{ContractAddress, contract_address_const, get_caller_address};

use erc721::contracts::ERC721::{
    ERC721Contract, IExternalDispatcher as IERC721Dispatcher,
    IExternalDispatcherTrait as IERC721DispatcherTrait
};

use traits::Into;
use traits::TryInto;
use array::ArrayTrait;
use option::OptionTrait;

use snforge_std::{CheatTarget, ContractClassTrait, EventSpy, SpyOn, start_prank, stop_prank};

use super::tests_lib::{deploy_project};

#[test]
#[available_gas(2000000)]
fn test_get_name() {
    let (project_address, _) = deploy_project('Foo', 'BAR');
    let contract = IERC721Dispatcher { contract_address: project_address };

    let name = contract.get_name();
    assert(name == 'Foo', 'wrong name');
}

#[test]
#[available_gas(2000000)]
fn test_get_symbol() {
    let (project_address, _) = deploy_project('Foo', 'BAR');
    let contract = IERC721Dispatcher { contract_address: project_address };

    let symbol = contract.get_symbol();
    assert(symbol == 'BAR', 'wrong symbol');
}

#[test]
#[available_gas(2000000)]
fn test_balance_of() {
    let (project_address, _) = deploy_project('Foo', 'BAR');
    let contract = IERC721Dispatcher { contract_address: project_address };
    let OWNER: ContractAddress = contract_address_const::<'OWNER'>();
    start_prank(CheatTarget::One(project_address), OWNER);

    let balance = contract.balance_of(OWNER);
    assert(balance == 0, 'wrong balance');

    let nft_id: u256 = 1.into();

    contract.mint(OWNER, nft_id);
    let balance = contract.balance_of(OWNER);
    assert(balance == 1, 'wrong balance');
}

#[test]
#[available_gas(2000000)]
fn test_owner_of() {
    let (project_address, _) = deploy_project('Foo', 'BAR');
    let contract = IERC721Dispatcher { contract_address: project_address };
    let OWNER: ContractAddress = contract_address_const::<'OWNER'>();
    start_prank(CheatTarget::One(project_address), OWNER);

    let nft_id: u256 = 1.into();
    contract.mint(OWNER, nft_id);

    let owner = contract.owner_of(nft_id);
    assert(owner == OWNER, 'wrong owner');
}

#[test]
#[available_gas(2000000)]
fn test_get_approved() {
    let (project_address, _) = deploy_project('Foo', 'BAR');
    let contract = IERC721Dispatcher { contract_address: project_address };
    let OWNER: ContractAddress = contract_address_const::<'OWNER'>();
    start_prank(CheatTarget::One(project_address), OWNER);

    // caller address:
    let caller = get_caller_address();

    let nft_id: u256 = 1.into();
    contract.mint(OWNER, nft_id);

    let user = starknet::contract_address_const::<'USER'>();
    contract.approve(user, nft_id);

    let approved = contract.get_approved(nft_id);
    assert(approved == user, 'wrong approved');
}

#[test]
#[available_gas(2000000)]
fn test_is_approved_for_all() {
    let (project_address, _) = deploy_project('Foo', 'BAR');
    let contract = IERC721Dispatcher { contract_address: project_address };

    let OWNER: ContractAddress = contract_address_const::<'OWNER'>();
    start_prank(CheatTarget::One(project_address), OWNER);

    let user = starknet::contract_address_const::<'USER'>();

    let is_approved = contract.is_approved_for_all(OWNER, user);
    assert(!is_approved, 'approved for all');

    contract.set_approval_for_all(user, true);
    let is_approved = contract.is_approved_for_all(OWNER, user);
    assert(is_approved, 'not approved for all');
}

#[test]
#[available_gas(2000000)]
fn test_get_token_uri() {
    let (project_address, _) = deploy_project('Foo', 'BAR');
    let contract = IERC721Dispatcher { contract_address: project_address };
    let OWNER: ContractAddress = contract_address_const::<'OWNER'>();
    start_prank(CheatTarget::One(project_address), OWNER);

    let nft_id: u256 = 1.into();
    contract.mint(OWNER, nft_id);

    let uri = contract.get_token_uri(nft_id);
    assert(uri == '', 'wrong uri');

    contract.set_token_uri(nft_id, 'https://example.com/1');
    let uri = contract.get_token_uri(nft_id);
    assert(uri == 'https://example.com/1', 'wrong uri');
}

#[test]
#[available_gas(2000000)]
fn test_transfer_from() {
    let (project_address, _) = deploy_project('Foo','BAR');
    let contract = IERC721Dispatcher { contract_address: project_address };

    let OWNER: ContractAddress = contract_address_const::<'OWNER'>();
    start_prank(CheatTarget::One(project_address), OWNER);

    let user = starknet::contract_address_const::<'USER'>();
    let nft_id: u256 = 1.into();
    contract.mint(OWNER, nft_id);

    contract.transfer_from(OWNER, user, nft_id);

    let new_owner = contract.owner_of(nft_id);
    assert(new_owner == user, 'wrong new OWNER');
}

#[test]
#[available_gas(2000000)]
fn test_transfer_from_approved() {
    let (project_address, _) = deploy_project('Foo', 'BAR');
    let contract = IERC721Dispatcher { contract_address: project_address };
    let OWNER: ContractAddress = contract_address_const::<'OWNER'>();
    start_prank(CheatTarget::One(project_address), OWNER);

    let user = starknet::contract_address_const::<'USER'>();
    let nft_id: u256 = 1.into();

    contract.mint(OWNER, nft_id);
    contract.approve(user, nft_id);

    contract.transfer_from(OWNER, user, nft_id);

    let new_owner = contract.owner_of(nft_id);
    assert(new_owner == user, 'wrong new OWNER');
}

#[test]
#[available_gas(2000000)]
fn test_transfer_from_approved_for_all() {
    let (project_address, _) = deploy_project('Foo', 'BAR');
    let contract = IERC721Dispatcher { contract_address: project_address };

    let OWNER: ContractAddress = contract_address_const::<'OWNER'>();
    start_prank(CheatTarget::One(project_address), OWNER);

    let user = starknet::contract_address_const::<'USER'>();

    let nft_id: u256 = 1.into();
    contract.mint(OWNER, nft_id);
    contract.set_approval_for_all(user, true);

    contract.transfer_from(OWNER, user, nft_id);

    let new_owner = contract.owner_of(nft_id);
    assert(new_owner == user, 'wrong new OWNER');
}

#[test]
#[available_gas(2000000)]
#[should_panic]
fn test_transfer_from_not_approved() {
    let (project_address, _) = deploy_project('Foo', 'BAR');
    let contract = IERC721Dispatcher { contract_address: project_address };

    let OWNER: ContractAddress = contract_address_const::<'OWNER'>();
    start_prank(CheatTarget::One(project_address), OWNER);

    let user = starknet::contract_address_const::<'USER'>();
    let nft_id: u256 = 1.into();

    contract.mint(OWNER, nft_id);
    contract.approve(user, nft_id);

    let random_user = starknet::contract_address_const::<789>();
    contract.transfer_from(random_user, user, nft_id);

    let new_owner = contract.owner_of(nft_id);
    assert(new_owner == user, 'wrong new OWNER');
}

#[test]
#[available_gas(2000000)]
fn test_erc721_burn() {
    let erc721_address = get_erc721_contract_address();
    let erc721_dispatcher = IERC721Dispatcher { contract_address: erc721_address };
}
