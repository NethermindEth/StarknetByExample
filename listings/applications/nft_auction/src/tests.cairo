use core::option::OptionTrait;
use core::traits::{Into, TryInto};
use starknet::ContractAddress;
use snforge_std::{
    BlockId, declare, ContractClassTrait, ContractClass, prank, CheatSpan, CheatTarget, roll, warp
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
pub const erc20_initial_supply: u128 = 10000_u128;


// NFT Auction
pub const starting_price: felt252 = 500;
pub const seller: felt252 = 'seller';
pub const duration: felt252 = 60; // in seconds
pub const discount_rate: felt252 = 5;
pub const total_supply: felt252 = 2;

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
        starting_price,
        seller,
        duration,
        discount_rate,
        total_supply
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
    let seller: ContractAddress = 'seller'.try_into().unwrap();
    let buyer: ContractAddress = 'buyer'.try_into().unwrap();

    // Transfer erc20 tokens to buyer
    assert_eq!(erc20_dispatcher.balance_of(buyer), 0.into());
    prank(CheatTarget::One(erc20_address), erc20_admin, CheatSpan::TargetCalls(1));
    let transfer_amt = 5000;
    erc20_dispatcher.transfer(buyer, transfer_amt.into());
    assert_eq!(erc20_dispatcher.balance_of(buyer), transfer_amt.into());

    // Buy token
    prank(CheatTarget::One(nft_auction_address), buyer, CheatSpan::TargetCalls(3));
    prank(CheatTarget::One(erc20_address), buyer, CheatSpan::TargetCalls(2));

    let nft_id_1 = 1;
    let seller_bal_before_buy = erc20_dispatcher.balance_of(seller);
    let buyer_bal_before_buy = erc20_dispatcher.balance_of(buyer);
    let nft_price = nft_auction_dispatcher.get_price().into();

    // buyer approves nft auction contract to spend own erc20 token
    erc20_dispatcher.approve(nft_auction_address, nft_price);

    nft_auction_dispatcher.buy(nft_id_1);

    let seller_bal_after_buy = erc20_dispatcher.balance_of(seller);
    let buyer_bal_after_buy = erc20_dispatcher.balance_of(buyer);

    assert_eq!(seller_bal_after_buy, seller_bal_before_buy + nft_price);
    assert_eq!(buyer_bal_after_buy, buyer_bal_before_buy - nft_price);
    assert_eq!(erc721_dispatcher.owner_of(nft_id_1), buyer);

    // Forward block timestamp in order for a reduced nft price    
    let forward_blocktime_by = 4000; // milliseconds
    warp(CheatTarget::One(nft_auction_address), forward_blocktime_by, CheatSpan::TargetCalls(1));

    // Buy token again after some time
    let nft_id_2 = 2;

    // buyer approves nft auction contract to spend own erc20 token
    erc20_dispatcher.approve(nft_auction_address, nft_price);

    assert_ne!(erc721_dispatcher.owner_of(nft_id_2), buyer);
    nft_auction_dispatcher.buy(nft_id_2);
    assert_eq!(erc721_dispatcher.owner_of(nft_id_2), buyer);
}

#[test]
#[should_panic(expected: 'auction ended')]
fn test_buy_should_panic_when_total_supply_reached() {
    let (_, erc20_address, nft_auction_address) = get_contract_addresses();
    let erc20_dispatcher = IERC20Dispatcher { contract_address: erc20_address };
    let nft_auction_dispatcher = INFTAuctionDispatcher { contract_address: nft_auction_address };
    let erc20_admin: ContractAddress = 'admin'.try_into().unwrap();
    let buyer: ContractAddress = 'buyer'.try_into().unwrap();

    // Transfer erc20 tokens to buyer
    prank(CheatTarget::One(erc20_address), erc20_admin, CheatSpan::TargetCalls(1));
    let transfer_amt = 5000;
    erc20_dispatcher.transfer(buyer, transfer_amt.into());

    // Buy token
    prank(CheatTarget::One(nft_auction_address), buyer, CheatSpan::TargetCalls(4));
    prank(CheatTarget::One(erc20_address), buyer, CheatSpan::TargetCalls(3));

    let nft_id_1 = 1;
    let nft_price = nft_auction_dispatcher.get_price().into();

    // buyer approves nft auction contract to spend own erc20 token
    erc20_dispatcher.approve(nft_auction_address, nft_price);
    nft_auction_dispatcher.buy(nft_id_1);

    // Forward block timestamp in order for a reduced nft price    
    let forward_blocktime_by = 4000; // 4 seconds (in milliseconds)
    warp(CheatTarget::One(nft_auction_address), forward_blocktime_by, CheatSpan::TargetCalls(1));

    // Buy token again after some time
    let nft_id_2 = 2;
    // buyer approves nft auction contract to spend own erc20 token
    erc20_dispatcher.approve(nft_auction_address, nft_price);
    nft_auction_dispatcher.buy(nft_id_2);

    // Buy token again after the total supply has reached
    let nft_id_3 = 3;
    // buyer approves nft auction contract to spend own erc20 token
    erc20_dispatcher.approve(nft_auction_address, nft_price);
    nft_auction_dispatcher.buy(nft_id_3);
}

#[test]
#[should_panic(expected: 'auction ended')]
fn test_buy_should_panic_when_duration_ended() {
    let (_, erc20_address, nft_auction_address) = get_contract_addresses();
    let erc20_dispatcher = IERC20Dispatcher { contract_address: erc20_address };
    let nft_auction_dispatcher = INFTAuctionDispatcher { contract_address: nft_auction_address };
    let erc20_admin: ContractAddress = 'admin'.try_into().unwrap();
    let buyer: ContractAddress = 'buyer'.try_into().unwrap();

    // Transfer erc20 tokens to buyer
    prank(CheatTarget::One(erc20_address), erc20_admin, CheatSpan::TargetCalls(1));
    let transfer_amt = 5000;
    erc20_dispatcher.transfer(buyer, transfer_amt.into());

    // Buy token
    prank(CheatTarget::One(nft_auction_address), buyer, CheatSpan::TargetCalls(4));
    prank(CheatTarget::One(erc20_address), buyer, CheatSpan::TargetCalls(3));

    let nft_id_1 = 1;
    let nft_price = nft_auction_dispatcher.get_price().into();

    // buyer approves nft auction contract to spend own erc20 token
    erc20_dispatcher.approve(nft_auction_address, nft_price);
    nft_auction_dispatcher.buy(nft_id_1);

    // Forward block timestamp to a time after duration has ended
    // During deployment, duration was set to 60 seconds 
    let forward_blocktime_by = 61000; // 61 seconds (in milliseconds)
    warp(CheatTarget::One(nft_auction_address), forward_blocktime_by, CheatSpan::TargetCalls(1));

    // Buy token again after some time
    let nft_id_2 = 2;
    // buyer approves nft auction contract to spend own erc20 token
    erc20_dispatcher.approve(nft_auction_address, nft_price);
    nft_auction_dispatcher.buy(nft_id_2);
}

#[test]
fn test_price_decreases_after_some_time() {
    let (_, _, nft_auction_address) = get_contract_addresses();
    let nft_auction_dispatcher = INFTAuctionDispatcher { contract_address: nft_auction_address };

    let nft_price_before_time_travel = nft_auction_dispatcher.get_price();

    // Forward time
    let forward_blocktime_by = 10000; // 10 seconds (in milliseconds)
    warp(CheatTarget::One(nft_auction_address), forward_blocktime_by, CheatSpan::TargetCalls(1));

    let nft_price_after_time_travel = nft_auction_dispatcher.get_price();

    assert_gt!(nft_price_before_time_travel, nft_price_after_time_travel);
}
