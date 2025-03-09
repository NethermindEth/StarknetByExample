use starknet::ContractAddress;

// [!region interface]
#[starknet::interface]
pub trait IERC721<TContractState> {
    fn balance_of(self: @TContractState, owner: ContractAddress) -> u256;
    fn owner_of(self: @TContractState, token_id: u256) -> ContractAddress;
    // The function `safe_transfer_from(address _from, address _to, uint256 _tokenId)`
    // is not included because the same behavior can be achieved by calling
    // `safe_transfer_from(from, to, tokenId, data)` with an empty `data`
    // parameter. This approach reduces redundancy in the contract's interface.
    fn safe_transfer_from(
        ref self: TContractState,
        from: ContractAddress,
        to: ContractAddress,
        token_id: u256,
        data: Span<felt252>,
    );
    fn transfer_from(
        ref self: TContractState, from: ContractAddress, to: ContractAddress, token_id: u256,
    );
    fn approve(ref self: TContractState, approved: ContractAddress, token_id: u256);
    fn set_approval_for_all(ref self: TContractState, operator: ContractAddress, approved: bool);
    fn get_approved(self: @TContractState, token_id: u256) -> ContractAddress;
    fn is_approved_for_all(
        self: @TContractState, owner: ContractAddress, operator: ContractAddress,
    ) -> bool;
}

#[starknet::interface]
pub trait IERC721Mintable<TContractState> {
    fn mint(ref self: TContractState, to: ContractAddress, token_id: u256);
}

#[starknet::interface]
pub trait IERC721Burnable<TContractState> {
    fn burn(ref self: TContractState, token_id: u256);
}

pub const IERC721_RECEIVER_ID: felt252 =
    0x3a0dff5f70d80458ad14ae37bb182a728e3c8cdda0402a5daa86620bdf910bc;

#[starknet::interface]
pub trait IERC721Receiver<TContractState> {
    fn on_erc721_received(
        self: @TContractState,
        operator: ContractAddress,
        from: ContractAddress,
        token_id: u256,
        data: Span<felt252>,
    ) -> felt252;
}

// The `IERC721Metadata` and `IERC721Enumerable` interfaces are included here
// as optional extensions to the ERC721 standard. While they provide additional
// functionality (such as token metadata and enumeration), they are not
// implemented in this example. Including these interfaces demonstrates how they
// can be integrated and serves as a starting point for developers who wish to
// extend the functionality.
#[starknet::interface]
pub trait IERC721Metadata<TContractState> {
    fn name(self: @TContractState) -> ByteArray;
    fn symbol(self: @TContractState) -> ByteArray;
    fn token_uri(self: @TContractState, token_id: u256) -> ByteArray;
}

#[starknet::interface]
pub trait IERC721Enumerable<TContractState> {
    fn total_supply(self: @TContractState) -> u256;
    fn token_by_index(self: @TContractState, index: u256) -> u256;
    fn token_of_owner_by_index(self: @TContractState, owner: ContractAddress, index: u256) -> u256;
}
// [!endregion interface]


