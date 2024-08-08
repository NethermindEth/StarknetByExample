use starknet::ContractAddress;

#[starknet::interface]
pub trait IERC721<TContractState> {
    fn balance_of(self: @TContractState, account: ContractAddress) -> u256;
    fn owner_of(self: @TContractState, token_id: u256) -> ContractAddress;
    fn get_approved(self: @TContractState, token_id: u256) -> ContractAddress;
    fn is_approved_for_all(
        self: @TContractState, owner: ContractAddress, operator: ContractAddress
    ) -> bool;
    fn approve(self: @TContractState, to: ContractAddress, token_id: u256);
    fn set_approval_for_all(self: @TContractState, operator: ContractAddress, approved: bool);
    fn transfer_from(
        self: @TContractState, from: ContractAddress, to: ContractAddress, token_id: u256
    );
    fn mint(ref self: TContractState, to: ContractAddress, token_id: u256);
}


#[starknet::interface]
pub trait IERC721Metadata<TContractState> {
    fn name(self: @TContractState) -> ByteArray;
    fn symbol(self: @TContractState) -> ByteArray;
    fn token_uri(self: @TContractState, token_id: u256) -> ByteArray;
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

    mod Errors {
        // Error messages for each function
        pub const ADDRESS_ZERO: felt252 = 'ERC721: balance is zero';
        pub const INVALID_OWNER: felt252 = 'ERC721: invalid owner';
        pub const INVALID_TOKEN_ID: felt252 = 'ERC721: invalid token ID';
        pub const APPROVAL_TO_CURRENT_OWNER: felt252 = 'ERC721: approval to owner';
        pub const NOT_TOKEN_OWNER: felt252 = 'ERC721:  not token owner';
        pub const APPROVE_TO_CALLER: felt252 = 'ERC721: approve to caller';
        pub const CALLER_NOT_APPROVED: felt252 = 'ERC721: caller is not approved';
        pub const CALLER_IS_NOT_OWNER: felt252 = 'ERC721: caller is not owner';
        pub const TRANSFER_TO_ZERO_ADDRESS: felt252 = 'ERC721: invalid receiver';
        pub const TOKEN_ALREADY_MINTED: felt252 = 'ERC721: token already minted';
    }

    #[constructor]
    fn constructor(ref self: ContractState, _name: felt252, _symbol: felt252) {
        self.name.write(_name);
        self.symbol.write(_symbol);
    }

    #[generate_trait]
    impl IERC721Impl of IERC721Trait {
        fn balance_of(self: @ContractState, account: ContractAddress) -> u256 {
            assert(account.is_non_zero(), Errors::ADDRESS_ZERO);
            self.balances.read(account)
        }

        fn owner_of(self: @ContractState, token_id: u256) -> ContractAddress {
            let owner = self.owners.read(token_id);
            assert(owner.is_non_zero(), Errors::INVALID_OWNER);
            owner
        }

        fn get_approved(self: @ContractState, token_id: u256) -> ContractAddress {
            assert(self._exists(token_id), Errors::INVALID_TOKEN_ID);
            self.token_approvals.read(token_id)
        }

        fn is_approved_for_all(
            self: @ContractState, owner: ContractAddress, operator: ContractAddress
        ) -> bool {
            self.operator_approvals.read((owner, operator))
        }

        fn approve(ref self: ContractState, to: ContractAddress, token_id: u256) {
            let owner = self.owner_of(token_id);
            assert(to != owner, Errors::APPROVAL_TO_CURRENT_OWNER);

            // Split the combined assert into two separate asserts
            assert(get_caller_address() == owner, Errors::NOT_TOKEN_OWNER);
            assert(
                self.is_approved_for_all(owner, get_caller_address()), Errors::CALLER_NOT_APPROVED
            );

            self.token_approvals.write(token_id, to);
            self.emit(Approval { owner: self.owner_of(token_id), to: to, token_id: token_id });
        }


        fn set_approval_for_all(
            ref self: ContractState, operator: ContractAddress, approved: bool
        ) {
            let owner = get_caller_address();
            // assert(owner != operator, Errors::APPROVE_TO_CALLER);
            self.operator_approvals.write((owner, operator), approved);
            self.emit(ApprovalForAll { owner: owner, operator: operator, approved: approved });
        }

        fn transfer_from(
            ref self: ContractState, from: ContractAddress, to: ContractAddress, token_id: u256
        ) {
            assert(
                self._is_approved_or_owner(get_caller_address(), token_id),
                Errors::CALLER_NOT_APPROVED
            );
            self._transfer(from, to, token_id);
        }
    }

    #[generate_trait]
    impl ERC721HelperImpl of ERC721HelperTrait {
        fn _exists(self: @ContractState, token_id: u256) -> bool {
            self.owner_of(token_id).is_non_zero()
        }

        fn _is_approved_or_owner(
            self: @ContractState, spender: ContractAddress, token_id: u256
        ) -> bool {
            let owner = self.owners.read(token_id);
            spender == owner
                || self.is_approved_for_all(owner, spender)
                || self.get_approved(token_id) == spender
        }

        fn _transfer(
            ref self: ContractState, from: ContractAddress, to: ContractAddress, token_id: u256
        ) {
            assert(from == self.owner_of(token_id), Errors::CALLER_IS_NOT_OWNER);
            assert(to.is_non_zero(), Errors::TRANSFER_TO_ZERO_ADDRESS);

            self.token_approvals.write(token_id, Zero::zero());

            self.balances.write(from, self.balances.read(from) - 1.into());
            self.balances.write(to, self.balances.read(to) + 1.into());

            self.owners.write(token_id, to);

            self.emit(Transfer { from: from, to: to, token_id: token_id });
        }

        fn _mint(ref self: ContractState, to: ContractAddress, token_id: u256) {
            assert(to.is_non_zero(), 'TO_IS_ZERO_ADDRESS');
            assert(!self.owner_of(token_id).is_non_zero(), Errors::TOKEN_ALREADY_MINTED);

            let receiver_balance = self.balances.read(to);
            self.balances.write(to, receiver_balance + 1.into());

            self.owners.write(token_id, to);

            self.emit(Transfer { from: Zero::zero(), to: to, token_id: token_id });
        }

        fn _burn(ref self: ContractState, token_id: u256) {
            let owner = self.owner_of(token_id);

            self.token_approvals.write(token_id, Zero::zero());

            let owner_balance = self.balances.read(owner);
            self.balances.write(owner, owner_balance - 1.into());

            self.owners.write(token_id, Zero::zero());

            self.emit(Transfer { from: owner, to: Zero::zero(), token_id: token_id });
        }
    }
}
