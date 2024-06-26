use starknet::ContractAddress;

#[starknet::interface]
pub trait IERC721<TContractState> {
    fn get_name(self: @TContractState) -> felt252;
    fn get_symbol(self: @TContractState) -> felt252;
    fn get_token_uri(self: @TContractState, token_id: u256) -> felt252;
    fn balance_of(self: @TContractState, account: ContractAddress) -> u256;
    fn owner_of(self: @TContractState, token_id: u256) -> ContractAddress;
    fn get_approved(self: @TContractState, token_id: u256) -> ContractAddress;
    fn is_approved_for_all(self: @TContractState, owner: ContractAddress, operator: ContractAddress) -> bool;
    fn approve(self: @TContractState, to: ContractAddress, token_id: u256);
    fn set_approval_for_all(self: @TContractState, operator: ContractAddress, approved: bool);
    fn transfer_from(self: @TContractState, from: ContractAddress, to: ContractAddress, token_id: u256);
    fn mint(ref self: TContractState, to: ContractAddress, token_id: u256);
}

#[starknet::contract]
mod ERC721 {

    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use core::num::traits::zero::Zero;

    #[storage]
    struct Storage {
        name: felt252,
        symbol: felt252,
        owners: LegacyMap::<u256, ContractAddress>,
        balances: LegacyMap::<ContractAddress, u256>,
        token_approvals: LegacyMap::<u256, ContractAddress>,
        operator_approvals: LegacyMap::<(ContractAddress, ContractAddress), bool>,
        token_uri: LegacyMap::<u256, felt252>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Approval: Approval,
        Transfer: Transfer,
        ApprovalForAll: ApprovalForAll
    }

    #[derive(Drop, starknet::Event)]
    struct Approval {
        owner: ContractAddress,
        to: ContractAddress,
        token_id: u256
    }

    #[derive(Drop, starknet::Event)]
    struct Transfer {
        from: ContractAddress,
        to: ContractAddress,
        token_id: u256
    }

    #[derive(Drop, starknet::Event)]
    struct ApprovalForAll {
        owner: ContractAddress,
        operator: ContractAddress,
        approved: bool
    }

    #[constructor]
    fn constructor(ref self: ContractState, _name: felt252, _symbol: felt252) {
        self.name.write(_name);
        self.symbol.write(_symbol);
    }

    #[generate_trait]
    impl IERC721Impl of IERC721Trait {
        // Returns the name of the token collection
        fn get_name(self: @ContractState) -> felt252 {
            self.name.read()
        }

        // Returns the symbol of the token collection
        fn get_symbol(self: @ContractState) -> felt252 {
            self.symbol.read()
        }

        // Returns the metadata URI for a given token ID
        fn get_token_uri(self: @ContractState, token_id: u256) -> felt252 {
            assert(self._exists(token_id), 'ERC721: invalid token ID');
            self.token_uri.read(token_id)
        }

        // Returns the number of tokens owned by a specific address
        fn balance_of(self: @ContractState, account: ContractAddress) -> u256 {
            assert(account.is_non_zero(), 'ERC721: address zero');
            self.balances.read(account)
        }

        // Returns the owner of the specified token ID
        fn owner_of(self: @ContractState, token_id: u256) -> ContractAddress {
            let owner = self.owners.read(token_id);
            assert(owner.is_non_zero(), 'ERC721: invalid token ID');
            owner
        }

        // Returns the approved address for a specific token ID
        fn get_approved(self: @ContractState, token_id: u256) -> ContractAddress {
            assert(self._exists(token_id), 'ERC721: invalid token ID');
            self.token_approvals.read(token_id)
        }

        // Checks if an operator is approved to manage all of the assets of an owner
        fn is_approved_for_all(self: @ContractState, owner: ContractAddress, operator: ContractAddress) -> bool {
            self.operator_approvals.read((owner, operator))
        }

        // Approves another address to transfer the given token ID
        fn approve(ref self: ContractState, to: ContractAddress, token_id: u256) {
            let owner = self.owner_of(token_id);
            assert(to != owner, 'Approval to current owner');
            assert(get_caller_address() == owner || self.is_approved_for_all(owner, get_caller_address()), 'Not token owner');
            self.token_approvals.write(token_id, to);
            self.emit(
                Approval{ owner: self.owner_of(token_id), to: to, token_id: token_id }
            );
        }

        // Sets or unsets the approval of a given operator
        fn set_approval_for_all(ref self: ContractState, operator: ContractAddress, approved: bool) {
            let owner = get_caller_address();
            assert(owner != operator, 'ERC721: approve to caller');
            self.operator_approvals.write((owner, operator), approved);
            self.emit(
                ApprovalForAll{ owner: owner, operator: operator, approved: approved }
            );
        }

        // Transfers a specific token ID to another address
        fn transfer_from(ref self: ContractState, from: ContractAddress, to: ContractAddress, token_id: u256) {
            assert(self._is_approved_or_owner(get_caller_address(), token_id), 'neither owner nor approved');
            self._transfer(from, to, token_id);
        }
    }

    #[generate_trait]
    impl ERC721HelperImpl of ERC721HelperTrait {
        // Checks if a specific token ID exists
        fn _exists(self: @ContractState, token_id: u256) -> bool {
            self.owner_of(token_id).is_non_zero()
        }

        // Checks if a spender is the owner or an approved operator of a specific token ID
        fn _is_approved_or_owner(self: @ContractState, spender: ContractAddress, token_id: u256) -> bool {
            let owner = self.owners.read(token_id);
            spender == owner
                || self.is_approved_for_all(owner, spender) 
                || self.get_approved(token_id) == spender
        }

        // Sets the metadata URI for a specific token ID
        fn _set_token_uri(ref self: ContractState, token_id: u256, token_uri: felt252) {
            assert(self._exists(token_id), 'ERC721: invalid token ID');
            self.token_uri.write(token_id, token_uri)
        }

        // Transfers a specific token ID from one address to another
        fn _transfer(ref self: ContractState, from: ContractAddress, to: ContractAddress, token_id: u256) {
            assert(from == self.owner_of(token_id), 'ERC721: Caller is not owner');
            assert(to.is_non_zero(), 'ERC721: transfer to 0 address');

            self.token_approvals.write(token_id, Zero::zero());

            self.balances.write(from, self.balances.read(from) - 1.into());
            self.balances.write(to, self.balances.read(to) + 1.into());

            self.owners.write(token_id, to);

            self.emit(
                Transfer{ from: from, to: to, token_id: token_id }
            );
        }

        // Mints a new token with a specific ID to a specified address
        fn _mint(ref self: ContractState, to: ContractAddress, token_id: u256) {
            assert(to.is_non_zero(), 'TO_IS_ZERO_ADDRESS');
            assert(!self.owner_of(token_id).is_non_zero(), 'ERC721: Token already minted');

            let receiver_balance = self.balances.read(to);
            self.balances.write(to, receiver_balance + 1.into());

            self.owners.write(token_id, to);

            self.emit(
                Transfer{ from: Zero::zero(), to: to, token_id: token_id }
            );
        }

        // Burns a specific token ID, removing it from existence
        fn _burn(ref self: ContractState, token_id: u256) {
            let owner = self.owner_of(token_id);

            self.token_approvals.write(token_id, Zero::zero());

            let owner_balance = self.balances.read(owner);
            self.balances.write(owner, owner_balance - 1.into());

            self.owners.write(token_id, Zero::zero());

            self.emit(
                Transfer{ from: owner, to: Zero::zero(), token_id: token_id }
            );
        }
    }
}