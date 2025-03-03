// [!region contract]
use starknet::ContractAddress;

#[starknet::interface]
pub trait IERC20<TContractState> {
    fn get_name(self: @TContractState) -> felt252;
    fn get_symbol(self: @TContractState) -> felt252;
    fn get_decimals(self: @TContractState) -> u8;
    fn get_total_supply(self: @TContractState) -> felt252;
    fn balance_of(self: @TContractState, account: ContractAddress) -> felt252;
    fn allowance(
        self: @TContractState, owner: ContractAddress, spender: ContractAddress,
    ) -> felt252;
    fn transfer(ref self: TContractState, recipient: ContractAddress, amount: felt252);
    fn transfer_from(
        ref self: TContractState,
        sender: ContractAddress,
        recipient: ContractAddress,
        amount: felt252,
    );
    fn approve(ref self: TContractState, spender: ContractAddress, amount: felt252);
    fn increase_allowance(ref self: TContractState, spender: ContractAddress, added_value: felt252);
    fn decrease_allowance(
        ref self: TContractState, spender: ContractAddress, subtracted_value: felt252,
    );
}

#[starknet::interface]
trait IERC721<TContractState> {
    fn get_name(self: @TContractState) -> felt252;
    fn get_symbol(self: @TContractState) -> felt252;
    fn get_token_uri(self: @TContractState, token_id: u256) -> felt252;
    fn balance_of(self: @TContractState, account: ContractAddress) -> u256;
    fn owner_of(self: @TContractState, token_id: u256) -> ContractAddress;
    fn get_approved(self: @TContractState, token_id: u256) -> ContractAddress;
    fn is_approved_for_all(
        self: @TContractState, owner: ContractAddress, operator: ContractAddress,
    ) -> bool;
    fn approve(ref self: TContractState, to: ContractAddress, token_id: u256);
    fn set_approval_for_all(ref self: TContractState, operator: ContractAddress, approved: bool);
    fn transfer_from(
        ref self: TContractState, from: ContractAddress, to: ContractAddress, token_id: u256,
    );
    fn mint(ref self: TContractState, to: ContractAddress, token_id: u256);
}

#[starknet::interface]
pub trait INFTDutchAuction<TContractState> {
    fn buy(ref self: TContractState, token_id: u256);
    fn get_price(self: @TContractState) -> u64;
}

#[starknet::contract]
pub mod NFTDutchAuction {
    use super::{IERC20Dispatcher, IERC20DispatcherTrait, IERC721Dispatcher, IERC721DispatcherTrait};
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp};
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    struct Storage {
        erc20_token: ContractAddress,
        erc721_token: ContractAddress,
        starting_price: u64,
        seller: ContractAddress,
        duration: u64,
        discount_rate: u64,
        start_at: u64,
        expires_at: u64,
        purchase_count: u128,
        total_supply: u128,
    }

    mod Errors {
        pub const AUCTION_ENDED: felt252 = 'auction has ended';
        pub const LOW_STARTING_PRICE: felt252 = 'low starting price';
        pub const INSUFFICIENT_BALANCE: felt252 = 'insufficient balance';
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        erc20_token: ContractAddress,
        erc721_token: ContractAddress,
        starting_price: u64,
        seller: ContractAddress,
        duration: u64,
        discount_rate: u64,
        total_supply: u128,
    ) {
        assert(starting_price >= discount_rate * duration, Errors::LOW_STARTING_PRICE);

        self.erc20_token.write(erc20_token);
        self.erc721_token.write(erc721_token);
        self.starting_price.write(starting_price);
        self.seller.write(seller);
        self.duration.write(duration);
        self.discount_rate.write(discount_rate);
        self.start_at.write(get_block_timestamp());
        self.expires_at.write(get_block_timestamp() + duration * 1000);
        self.total_supply.write(total_supply);
    }

    #[abi(embed_v0)]
    impl NFTDutchAuction of super::INFTDutchAuction<ContractState> {
        fn get_price(self: @ContractState) -> u64 {
            let time_elapsed = (get_block_timestamp() - self.start_at.read())
                / 1000; // Ignore milliseconds
            let discount = self.discount_rate.read() * time_elapsed;
            self.starting_price.read() - discount
        }

        fn buy(ref self: ContractState, token_id: u256) {
            // Check duration
            assert(get_block_timestamp() < self.expires_at.read(), Errors::AUCTION_ENDED);
            // Check total supply
            assert(self.purchase_count.read() < self.total_supply.read(), Errors::AUCTION_ENDED);

            let erc20_dispatcher = IERC20Dispatcher { contract_address: self.erc20_token.read() };
            let erc721_dispatcher = IERC721Dispatcher {
                contract_address: self.erc721_token.read(),
            };

            let caller = get_caller_address();
            // Get NFT price
            let price: u256 = self.get_price().into();
            let buyer_balance: u256 = erc20_dispatcher.balance_of(caller).into();
            // Ensure buyer has enough token for payment
            assert(buyer_balance >= price, Errors::INSUFFICIENT_BALANCE);
            // Transfer payment token from buyer to seller
            erc20_dispatcher.transfer_from(caller, self.seller.read(), price.try_into().unwrap());
            // Mint token to buyer's address
            erc721_dispatcher.mint(caller, token_id);
            // Increase purchase count
            self.purchase_count.write(self.purchase_count.read() + 1);
        }
    }
}
// [!endregion contract]

#[cfg(test)]
mod tests {
    use starknet::ContractAddress;
    use snforge_std::{
        declare, DeclareResultTrait, ContractClassTrait, cheat_caller_address, CheatSpan,
        cheat_block_timestamp,
    };
    use nft_dutch_auction::erc721::{IERC721Dispatcher, IERC721DispatcherTrait};
    use super::{INFTDutchAuctionDispatcher, INFTDutchAuctionDispatcherTrait};
    use erc20::token::{IERC20Dispatcher, IERC20DispatcherTrait};

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
        let erc721 = declare("ERC721").unwrap().contract_class();
        let erc721_constructor_calldata = array![erc721_name, erc721_symbol];
        let (erc721_address, _) = erc721.deploy(@erc721_constructor_calldata).unwrap();
        let erc20 = declare("erc20").unwrap().contract_class();
        let erc20_constructor_calldata = array![
            erc20_recipient,
            erc20_name,
            erc20_decimals.into(),
            erc20_initial_supply.into(),
            erc20_symbol,
        ];
        let (erc20_address, _) = erc20.deploy(@erc20_constructor_calldata).unwrap();
        let nft_auction = declare("NFTDutchAuction").unwrap().contract_class();
        let nft_auction_constructor_calldata = array![
            erc20_address.into(),
            erc721_address.into(),
            starting_price,
            seller,
            duration,
            discount_rate,
            total_supply,
        ];
        let (nft_auction_address, _) = nft_auction
            .deploy(@nft_auction_constructor_calldata)
            .unwrap();
        (erc721_address, erc20_address, nft_auction_address)
    }

    #[test]
    fn test_buy() {
        let (erc721_address, erc20_address, nft_auction_address) = get_contract_addresses();
        let erc721_dispatcher = IERC721Dispatcher { contract_address: erc721_address };
        let erc20_dispatcher = IERC20Dispatcher { contract_address: erc20_address };
        let nft_auction_dispatcher = INFTDutchAuctionDispatcher {
            contract_address: nft_auction_address,
        };
        let erc20_admin: ContractAddress = 'admin'.try_into().unwrap();
        let seller: ContractAddress = 'seller'.try_into().unwrap();
        let buyer: ContractAddress = 'buyer'.try_into().unwrap();

        // Transfer erc20 tokens to buyer
        assert_eq!(erc20_dispatcher.balance_of(buyer), 0.into());
        cheat_caller_address(erc20_address, erc20_admin, CheatSpan::TargetCalls(1));
        let transfer_amt = 5000;
        erc20_dispatcher.transfer(buyer, transfer_amt.into());
        assert_eq!(erc20_dispatcher.balance_of(buyer), transfer_amt.into());

        // Buy token
        cheat_caller_address(nft_auction_address, buyer, CheatSpan::TargetCalls(3));
        cheat_caller_address(erc20_address, buyer, CheatSpan::TargetCalls(2));

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
        cheat_block_timestamp(nft_auction_address, forward_blocktime_by, CheatSpan::TargetCalls(1));

        // Buy token again after some time
        let nft_id_2 = 2;

        // buyer approves nft auction contract to spend own erc20 token
        erc20_dispatcher.approve(nft_auction_address, nft_price);

        assert_ne!(erc721_dispatcher.owner_of(nft_id_2), buyer);
        nft_auction_dispatcher.buy(nft_id_2);
        assert_eq!(erc721_dispatcher.owner_of(nft_id_2), buyer);
    }

    #[test]
    #[should_panic(expected: 'auction has ended')]
    fn test_buy_should_panic_when_total_supply_reached() {
        let (_, erc20_address, nft_auction_address) = get_contract_addresses();
        let erc20_dispatcher = IERC20Dispatcher { contract_address: erc20_address };
        let nft_auction_dispatcher = INFTDutchAuctionDispatcher {
            contract_address: nft_auction_address,
        };
        let erc20_admin: ContractAddress = 'admin'.try_into().unwrap();
        let buyer: ContractAddress = 'buyer'.try_into().unwrap();

        // Transfer erc20 tokens to buyer
        cheat_caller_address(erc20_address, erc20_admin, CheatSpan::TargetCalls(1));
        let transfer_amt = 5000;
        erc20_dispatcher.transfer(buyer, transfer_amt.into());

        // Buy token
        cheat_caller_address(nft_auction_address, buyer, CheatSpan::TargetCalls(4));
        cheat_caller_address(erc20_address, buyer, CheatSpan::TargetCalls(3));

        let nft_id_1 = 1;
        let nft_price = nft_auction_dispatcher.get_price().into();

        // buyer approves nft auction contract to spend own erc20 token
        erc20_dispatcher.approve(nft_auction_address, nft_price);
        nft_auction_dispatcher.buy(nft_id_1);

        // Forward block timestamp in order for a reduced nft price
        let forward_blocktime_by = 4000; // 4 seconds (in milliseconds)
        cheat_block_timestamp(nft_auction_address, forward_blocktime_by, CheatSpan::TargetCalls(1));

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
    #[should_panic(expected: 'auction has ended')]
    fn test_buy_should_panic_when_duration_ended() {
        let (_, erc20_address, nft_auction_address) = get_contract_addresses();
        let erc20_dispatcher = IERC20Dispatcher { contract_address: erc20_address };
        let nft_auction_dispatcher = INFTDutchAuctionDispatcher {
            contract_address: nft_auction_address,
        };
        let erc20_admin: ContractAddress = 'admin'.try_into().unwrap();
        let buyer: ContractAddress = 'buyer'.try_into().unwrap();

        // Transfer erc20 tokens to buyer
        cheat_caller_address(erc20_address, erc20_admin, CheatSpan::TargetCalls(1));
        let transfer_amt = 5000;
        erc20_dispatcher.transfer(buyer, transfer_amt.into());

        // Buy token
        cheat_caller_address(nft_auction_address, buyer, CheatSpan::TargetCalls(4));
        cheat_caller_address(erc20_address, buyer, CheatSpan::TargetCalls(3));

        let nft_id_1 = 1;
        let nft_price = nft_auction_dispatcher.get_price().into();

        // buyer approves nft auction contract to spend own erc20 token
        erc20_dispatcher.approve(nft_auction_address, nft_price);
        nft_auction_dispatcher.buy(nft_id_1);

        // Forward block timestamp to a time after duration has ended
        // During deployment, duration was set to 60 seconds
        let forward_blocktime_by = 61000; // 61 seconds (in milliseconds)
        cheat_block_timestamp(nft_auction_address, forward_blocktime_by, CheatSpan::TargetCalls(1));

        // Buy token again after some time
        let nft_id_2 = 2;
        // buyer approves nft auction contract to spend own erc20 token
        erc20_dispatcher.approve(nft_auction_address, nft_price);
        nft_auction_dispatcher.buy(nft_id_2);
    }

    #[test]
    fn test_price_decreases_after_some_time() {
        let (_, _, nft_auction_address) = get_contract_addresses();
        let nft_auction_dispatcher = INFTDutchAuctionDispatcher {
            contract_address: nft_auction_address,
        };

        let nft_price_before_time_travel = nft_auction_dispatcher.get_price();

        // Forward time
        let forward_blocktime_by = 10000; // 10 seconds (in milliseconds)
        cheat_block_timestamp(nft_auction_address, forward_blocktime_by, CheatSpan::TargetCalls(1));

        let nft_price_after_time_travel = nft_auction_dispatcher.get_price();

        println!("price: {:?}", nft_price_after_time_travel);

        assert_gt!(nft_price_before_time_travel, nft_price_after_time_travel);
    }
}
