use starknet::ContractAddress;

// In order to make contract calls within our Vault,
// we need to have the interface of the remote ERC20 contract defined to import the Dispatcher.
#[starknet::interface]
pub trait IERC20<TContractState> {
    fn name(self: @TContractState) -> felt252;
    fn symbol(self: @TContractState) -> felt252;
    fn decimals(self: @TContractState) -> u8;
    fn total_supply(self: @TContractState) -> u256;
    fn balance_of(self: @TContractState, account: ContractAddress) -> u256;
    fn allowance(self: @TContractState, owner: ContractAddress, spender: ContractAddress) -> u256;
    fn transfer(ref self: TContractState, recipient: ContractAddress, amount: u256) -> bool;
    fn transfer_from(
        ref self: TContractState, sender: ContractAddress, recipient: ContractAddress, amount: u256
    ) -> bool;
    fn approve(ref self: TContractState, spender: ContractAddress, amount: u256) -> bool;
}

#[starknet::interface]
pub trait IERC721<TContractState> {
    fn total_supply(self: @TContractState) -> u128;
    fn safe_mint(ref self: TContractState, recipient: ContractAddress, tokenId: u256);
}

#[starknet::interface]
pub trait INFTAuction<TContractState> {
    fn buy(ref self: TContractState);
}

#[starknet::contract]
pub mod NFTAuction {
    use super::{IERC20Dispatcher, IERC20DispatcherTrait, IERC721Dispatcher, IERC721DispatcherTrait};
    use starknet::{ContractAddress, get_caller_address, get_contract_address, get_block_timestamp};

    #[storage]
    struct Storage {
        erc20_token: IERC20Dispatcher,
        erc721_token: IERC721Dispatcher,
        starting_price: u64,
        seller: ContractAddress,
        duration: u64,
        discount_rate: u64,
        start_at: u64,
        expires_at: u64,
        purchase_count: u128
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
    ) {
        assert(starting_price >= discount_rate * duration, 'starting price too low');

        self.erc20_token.write(IERC20Dispatcher { contract_address: erc20_token });
        self.erc721_token.write(IERC721Dispatcher { contract_address: erc721_token });
        self.starting_price.write(starting_price);
        self.seller.write(seller);
        self.duration.write(duration);
        self.discount_rate.write(discount_rate);
        self.start_at.write(get_block_timestamp());
        self.expires_at.write(get_block_timestamp() + duration);
    }

    #[generate_trait]
    impl PrivateFunctions of PrivateFunctionsTrait {
        fn get_price(self: @ContractState) -> u64 {
            let time_elapsed = get_block_timestamp() - self.start_at.read();
            let discount = self.discount_rate.read() * time_elapsed;
            self.starting_price.read() - discount
        }
    }

    #[abi(embed_v0)]
    impl NFTAuction of super::INFTAuction<ContractState> {
        fn buy(ref self: ContractState) {
            // Check duration
            assert(get_block_timestamp() < self.expires_at.read(), 'auction ended');
            // Check total supply
            assert(
                self.purchase_count.read() <= self.erc721_token.read().total_supply(),
                'auction ended'
            );

            let caller = get_caller_address();

            // Get NFT price
            let price: u256 = self.get_price().into();
            // Check payment token balance
            assert(self.erc20_token.read().balance_of(caller) >= price, 'insufficient balance');
            // Transfer payment token to contract
            self.erc20_token.read().transfer(self.seller.read(), price);
            // Mint token to buyer's address
            self.erc721_token.read().safe_mint(caller, 1);

            // Increase purchase count
            self.purchase_count.write(self.purchase_count.read() + 1);
        }
    }
}
