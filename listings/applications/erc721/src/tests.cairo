// use starknet::ContractAddress;
// use starknet::get_caller_address;
// use snforge_std::{declare, ContractClassTrait, ContractClass, cheat_caller_address, CheatSpan};

// pub const erc721_name: felt252 = 'My NFT';
// pub const erc721_symbol: felt252 = 'MNFT';

// fn get_erc721_contract_address() -> ContractAddress {
//     let erc721 = declare("ERC721").unwrap();
//     let erc721_constructor_calldata = array![erc721_name, erc721_symbol];
//     let (erc721_address, _) = erc721.deploy(@erc721_constructor_calldata).unwrap();
//     erc721_address
// }

// #[test]
// fn test_erc721_contract() {
//     let erc721_address = get_erc721_contract_address();
//     let erc721_dispatcher = IERC721Dispatcher { contract_address: erc721_address };

//     // Test get_name
//     assert_eq!(erc721_dispatcher.get_name(), erc721_name);

//     // Test get_symbol
//     assert_eq!(erc721_dispatcher.get_symbol(), erc721_symbol);

//     // Mint a token and test balance_of, owner_of, get_token_uri
//     let minter: ContractAddress = 'minter'.try_into().unwrap();
//     let token_id = 1.into();
//     let token_uri = "ipfs://token-uri";

//     cheat_caller_address(erc721_address, minter, CheatSpan::TargetCalls(1));
//     erc721_dispatcher.mint(minter, token_id);
//     erc721_dispatcher._set_token_uri(token_id, token_uri.into());

//     assert_eq!(erc721_dispatcher.balance_of(minter), 1.into());
//     assert_eq!(erc721_dispatcher.owner_of(token_id), minter);
//     assert_eq!(erc721_dispatcher.get_token_uri(token_id), token_uri.into());

//     // Approve another address and test get_approved
//     let approved: ContractAddress = 'approved'.try_into().unwrap();
//     cheat_caller_address(erc721_address, minter, CheatSpan::TargetCalls(1));
//     erc721_dispatcher.approve(approved, token_id);
//     assert_eq!(erc721_dispatcher.get_approved(token_id), approved);

//     // Set approval for all and test is_approved_for_all
//     let operator: ContractAddress = 'operator'.try_into().unwrap();
//     erc721_dispatcher.set_approval_for_all(operator, true);
//     assert!(erc721_dispatcher.is_approved_for_all(minter, operator));

//     // Transfer the token and test owner_of
//     let recipient: ContractAddress = 'recipient'.try_into().unwrap();
//     cheat_caller_address(erc721_address, operator, CheatSpan::TargetCalls(1));
//     erc721_dispatcher.transfer_from(minter, recipient, token_id);
//     assert_eq!(erc721_dispatcher.owner_of(token_id), recipient);
// }

// #[test]
// fn test_erc721_burn() {
//     let erc721_address = get_erc721_contract_address();
//     let erc721_dispatcher = IERC721Dispatcher { contract_address: erc721_address };

//     // Mint a token and burn it
//     let minter: ContractAddress = 'minter'.try_into().unwrap();
//     let token_id = 1.into();

//     cheat_caller_address(erc721_address, minter, CheatSpan::TargetCalls(1));
//     erc721_dispatcher.mint(minter, token_id);

//     assert_eq!(erc721_dispatcher.balance_of(minter), 1.into());
//     assert_eq!(erc721_dispatcher.owner_of(token_id), minter);

//     cheat_caller_address(erc721_address, minter, CheatSpan::TargetCalls(1));
//     erc721_dispatcher._burn(token_id);

//     assert_eq!(erc721_dispatcher.balance_of(minter), 0.into());
//     assert_eq!(erc721_dispatcher.owner_of(token_id), ContractAddress::default());
// }


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
    let (project_address, _) = deploy_project('ApeMonkey', 'APE');
    let contract = IERC721Dispatcher{ contract_address: project_address };

    let name = contract.get_name();
    assert(name == 'ApeMonkey', 'wrong name');
    
}

#[test]
#[available_gas(2000000)]
fn test_get_symbol() {
    let (project_address, _) = deploy_project('ApeMonkey', 'APE');
    let contract = IERC721Dispatcher{ contract_address: project_address };

    let symbol = contract.get_symbol();
    assert(symbol == 'APE', 'wrong symbol');
}

#[test]
#[available_gas(2000000)]
fn test_balance_of() {
    let (project_address, _) = deploy_project('ApeMonkey', 'APE');
    let contract = IERC721Dispatcher{ contract_address: project_address };
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
    let (project_address, _) = deploy_project('ApeMonkey', 'APE');
    let contract = IERC721Dispatcher{ contract_address: project_address };
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
    let (project_address, _) = deploy_project('ApeMonkey', 'APE');
    let contract = IERC721Dispatcher{ contract_address: project_address };
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
    let (project_address, _) = deploy_project('ApeMonkey', 'APE');
    let contract = IERC721Dispatcher{ contract_address: project_address };

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
    let (project_address, _) = deploy_project('ApeMonkey', 'APE');
    let contract = IERC721Dispatcher{ contract_address: project_address };
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
    let (project_address, _) = deploy_project('ApeMonkey', 'APE');
    let contract = IERC721Dispatcher{ contract_address: project_address };

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
    let (project_address, _) = deploy_project('ApeMonkey', 'APE');
    let contract = IERC721Dispatcher{ contract_address: project_address };
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
    let (project_address, _) = deploy_project('ApeMonkey', 'APE');
    let contract = IERC721Dispatcher{ contract_address: project_address };

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

    let (project_address, _) = deploy_project('ApeMonkey', 'APE');
    let contract = IERC721Dispatcher{ contract_address: project_address };

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