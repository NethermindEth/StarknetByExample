use core::option::OptionTrait;
use core::traits::{Into, TryInto};
use starknet::ContractAddress;
use snforge_std::{
    BlockId, declare, ContractClassTrait, ContractClass, prank, CheatSpan, CheatTarget, roll
};
use super::{
    erc20::{IERC20Dispatcher, IERC20DispatcherTrait},
    erc721::{IERC721Dispatcher, IERC721DispatcherTrait},
    nft_auction::{INFTAuctionDispatcher, INFTAuctionDispatcherTrait}
};

// ERC721 token
pub const erc721_name: felt252 = 'My NFT';
pub const erc721_symbol: felt252 = 'MNFT';


// ERC20 token
pub const erc20_name: felt252 = 'My Token';
pub const erc20_symbol: felt252 = 'MTKN';
pub const erc20_recipient: felt252 = 'admin';
pub const erc20_decimals: u8 = 1_u8;
pub const erc20_initial_supply: u128 = 100000000000_u128;


// NFT Auction
pub const starting_price: u64 = 10000_u64;
pub const seller: felt252 = 'seller';
pub const duration: u64 = 60_u64;
pub const discount_rate: u64 = 5_u64;
pub const total_supply: u128 = 2_u128;

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
        discount_rate.into(),
        total_supply.into()
    ];
    let (nft_auction_address, _) = nft_auction.deploy(@nft_auction_constructor_calldata).unwrap();

    (erc721_address, erc20_address, nft_auction_address)
}

#[test]
fn test_buy() {
    let (erc721_address, erc20_address, nft_auction_address) = get_contract_addresses();

    let erc721_dispatcher = IERC721Dispatcher { contract_address: erc721_address };
    let erc20_dispatcher = IERC20Dispatcher { contract_address: erc20_address };
    let nft_auction_dispatcher = INFTAuctionDispatcher { contract_address: nft_auction_address };

    let erc20_admin: ContractAddress = 'admin'.try_into().unwrap();
    // let seller: ContractAddress = 'seller'.try_into().unwrap();
    let buyer: ContractAddress = 'buyer'.try_into().unwrap();

    // Transfer erc20 tokens to buyer
    prank(CheatTarget::One(erc20_address), erc20_admin, CheatSpan::TargetCalls(1));
    erc20_dispatcher.transfer(buyer, 10.into());

    // Buy token
    prank(CheatTarget::One(nft_auction_address), buyer, CheatSpan::TargetCalls(1));
    nft_auction_dispatcher.buy(1);

    assert_eq!(erc721_dispatcher.owner_of(1), buyer);
}
