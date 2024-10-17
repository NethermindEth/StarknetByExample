use erc721::erc721::{IERC721Dispatcher, IERC721DispatcherTrait// , ERC721::{Event, Transfer, Approval}
};

use snforge_std::{declare, DeclareResultTrait, ContractClassTrait};
use starknet::{ContractAddress, contract_address_const};

pub const TOKEN_ID: u256 = 21;

pub fn OWNER() -> ContractAddress {
    contract_address_const::<'OWNER'>()
}

fn deploy() -> IERC721Dispatcher {
    let contract = declare("ERC721").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    IERC721Dispatcher { contract_address }
}

fn setup() -> IERC721Dispatcher {
    let contract = deploy();
    contract.mint(OWNER(), TOKEN_ID);
    contract
}

#[test]
fn test_balance_of() {
    let contract = setup();
    assert_eq!(contract.balance_of(OWNER()), 1);
}
