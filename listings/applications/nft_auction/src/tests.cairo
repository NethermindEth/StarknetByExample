use core::option::OptionTrait;
use core::traits::{Into, TryInto};
use starknet::ContractAddress;
use snforge_std::{declare, ContractClassTrait};

// ERC721 token
pub const erc721_name: felt252 = 'My NFT';
pub const erc721_symbol: felt252 = 'MNFT';


// ERC20 token
pub const erc20_name: felt252 = 'My Token';
pub const erc20_symbol: felt252 = 'MTKN';
pub const erc20_recipient: felt252 = 'admin';
pub const erc20_decimals: u8 = 8_u8;
pub const erc20_initial_supply: u128 = 100000000000_u128;


// NFT Auction
pub const starting_price: u64 = 10000_u64;
pub const seller: felt252 = 'seller';
pub const duration: u64 = 60_u64;
pub const discount_rate: u64 = 5_u64;

fn get_contract_addresses() -> (ContractAddress, ContractAddress, ContractAddress) {
    let erc721 = declare("ERC721").unwrap();
    let erc721_constructor_calldata = array![erc721_name, erc721_symbol];
    let (erc721_address, _) = erc721.deploy(@erc721_constructor_calldata).unwrap();

    let erc20 = declare("ERC20").unwrap();
    let erc20_constructor_calldata = array![
        erc20_recipient,
        erc20_name,
        erc20_decimals.into(),
        erc20_initial_supply.into(),
        erc20_symbol
    ];
    let (erc20_address, _) = erc20.deploy(@erc20_constructor_calldata).unwrap();

    let nft_auction = declare("NFTAuction").unwrap();
    let nft_auction_constructor_calldata = array![
        erc20_address.into(),
        erc721_address.into(),
        starting_price.into(),
        seller,
        duration.into(),
        discount_rate.into()
    ];
    let (nft_auction_address, _) = nft_auction.deploy(@nft_auction_constructor_calldata).unwrap();

    (erc721_address, erc20_address, nft_auction_address)
}

#[test]
fn test_deployment() {
    let (erc721, erc20, nft_auction) = get_contract_addresses();
    println!("CAs: {:?}, {:?}, {:?}", erc721, erc20, nft_auction);
}
