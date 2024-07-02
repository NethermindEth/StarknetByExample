use starknet::ContractAddress;
use starknet::get_caller_address;
use snforge_std::{declare, ContractClassTrait, ContractClass, cheat_caller_address, CheatSpan};

pub const erc721_name: felt252 = 'My NFT';
pub const erc721_symbol: felt252 = 'MNFT';

fn get_erc721_contract_address() -> ContractAddress {
    let erc721 = declare("ERC721").unwrap();
    let erc721_constructor_calldata = array![erc721_name, erc721_symbol];
    let (erc721_address, _) = erc721.deploy(@erc721_constructor_calldata).unwrap();
    erc721_address
}

#[test]
fn test_erc721_contract() {
    let erc721_address = get_erc721_contract_address();
    let erc721_dispatcher = IERC721Dispatcher { contract_address: erc721_address };

    // Test get_name
    assert_eq!(erc721_dispatcher.get_name(), erc721_name);

    // Test get_symbol
    assert_eq!(erc721_dispatcher.get_symbol(), erc721_symbol);

    // Mint a token and test balance_of, owner_of, get_token_uri
    let minter: ContractAddress = 'minter'.try_into().unwrap();
    let token_id = 1.into();
    let token_uri = "ipfs://token-uri";

    cheat_caller_address(erc721_address, minter, CheatSpan::TargetCalls(1));
    erc721_dispatcher.mint(minter, token_id);
    erc721_dispatcher._set_token_uri(token_id, token_uri.into());

    assert_eq!(erc721_dispatcher.balance_of(minter), 1.into());
    assert_eq!(erc721_dispatcher.owner_of(token_id), minter);
    assert_eq!(erc721_dispatcher.get_token_uri(token_id), token_uri.into());

    // Approve another address and test get_approved
    let approved: ContractAddress = 'approved'.try_into().unwrap();
    cheat_caller_address(erc721_address, minter, CheatSpan::TargetCalls(1));
    erc721_dispatcher.approve(approved, token_id);
    assert_eq!(erc721_dispatcher.get_approved(token_id), approved);

    // Set approval for all and test is_approved_for_all
    let operator: ContractAddress = 'operator'.try_into().unwrap();
    erc721_dispatcher.set_approval_for_all(operator, true);
    assert!(erc721_dispatcher.is_approved_for_all(minter, operator));

    // Transfer the token and test owner_of
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();
    cheat_caller_address(erc721_address, operator, CheatSpan::TargetCalls(1));
    erc721_dispatcher.transfer_from(minter, recipient, token_id);
    assert_eq!(erc721_dispatcher.owner_of(token_id), recipient);
}

#[test]
fn test_erc721_burn() {
    let erc721_address = get_erc721_contract_address();
    let erc721_dispatcher = IERC721Dispatcher { contract_address: erc721_address };

    // Mint a token and burn it
    let minter: ContractAddress = 'minter'.try_into().unwrap();
    let token_id = 1.into();

    cheat_caller_address(erc721_address, minter, CheatSpan::TargetCalls(1));
    erc721_dispatcher.mint(minter, token_id);

    assert_eq!(erc721_dispatcher.balance_of(minter), 1.into());
    assert_eq!(erc721_dispatcher.owner_of(token_id), minter);

    cheat_caller_address(erc721_address, minter, CheatSpan::TargetCalls(1));
    erc721_dispatcher._burn(token_id);

    assert_eq!(erc721_dispatcher.balance_of(minter), 0.into());
    assert_eq!(erc721_dispatcher.owner_of(token_id), ContractAddress::default());
}
