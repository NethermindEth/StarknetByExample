use starknet::ContractAddress;

// ANCHOR: interface
#[starknet::interface]
pub trait IERC721<TContractState> {
    fn balance_of(self: @TContractState, owner: ContractAddress) -> u256;
    fn owner_of(self: @TContractState, token_id: u256) -> ContractAddress;
    fn safe_transfer_from(
        ref self: TContractState,
        from: ContractAddress,
        to: ContractAddress,
        token_id: u256,
        data: Span<felt252>
    );
    fn transfer_from(
        ref self: TContractState, from: ContractAddress, to: ContractAddress, token_id: u256
    );
    fn approve(ref self: TContractState, approved: ContractAddress, token_id: u256);
    fn set_approval_for_all(ref self: TContractState, operator: ContractAddress, approved: bool);
    fn get_approved(self: @TContractState, token_id: u256) -> ContractAddress;
    fn is_approved_for_all(
        self: @TContractState, owner: ContractAddress, operator: ContractAddress
    ) -> bool;
    fn mint(ref self: TContractState, to: ContractAddress, token_id: u256);
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
        data: Span<felt252>
    ) -> felt252;
}
// ANCHOR_END: interface

// ANCHOR: erc721
#[starknet::contract]
pub mod ERC721 {
    use core::num::traits::Zero;
    use starknet::get_caller_address;
    use starknet::ContractAddress;
    use starknet::storage::{Map, StorageMapReadAccess, StorageMapWriteAccess};
    use openzeppelin_introspection::interface::{ISRC5Dispatcher, ISRC5DispatcherTrait};
    use super::{IERC721ReceiverDispatcher, IERC721ReceiverDispatcherTrait, IERC721_RECEIVER_ID};

    #[storage]
    struct Storage {
        owners: Map<u256, ContractAddress>,
        balances: Map<ContractAddress, u256>,
        approvals: Map<u256, ContractAddress>,
        operator_approvals: Map<(ContractAddress, ContractAddress), bool>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        Transfer: Transfer,
        Approval: Approval,
        ApprovalForAll: ApprovalForAll,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Transfer {
        pub from: ContractAddress,
        pub to: ContractAddress,
        pub token_id: u256
    }

    #[derive(Drop, starknet::Event)]
    pub struct Approval {
        pub owner: ContractAddress,
        pub approved: ContractAddress,
        pub token_id: u256
    }

    #[derive(Drop, starknet::Event)]
    pub struct ApprovalForAll {
        pub owner: ContractAddress,
        pub operator: ContractAddress,
        pub approved: bool
    }

    pub mod Errors {
        pub const INVALID_TOKEN_ID: felt252 = 'ERC721: invalid token ID';
        pub const INVALID_ACCOUNT: felt252 = 'ERC721: invalid account';
        pub const INVALID_OPERATOR: felt252 = 'ERC721: invalid operator';
        pub const UNAUTHORIZED: felt252 = 'ERC721: unauthorized caller';
        pub const INVALID_RECEIVER: felt252 = 'ERC721: invalid receiver';
        pub const INVALID_SENDER: felt252 = 'ERC721: invalid sender';
        pub const SAFE_TRANSFER_FAILED: felt252 = 'ERC721: safe transfer failed';
        pub const ALREADY_MINTED: felt252 = 'ERC721: token already minted';
    }

    #[abi(embed_v0)]
    impl ERC721 of super::IERC721<ContractState> {
        fn owner_of(self: @ContractState, token_id: u256) -> ContractAddress {
            self._require_owned(token_id)
        }

        fn balance_of(self: @ContractState, owner: ContractAddress) -> u256 {
            assert(!owner.is_zero(), Errors::INVALID_ACCOUNT);
            self.balances.read(owner)
        }

        fn set_approval_for_all(
            ref self: ContractState, operator: ContractAddress, approved: bool
        ) {
            assert(!operator.is_zero(), Errors::INVALID_OPERATOR);
            let owner = get_caller_address();
            self.operator_approvals.write((owner, operator), approved);
            self.emit(ApprovalForAll { owner, operator, approved });
        }

        fn approve(ref self: ContractState, approved: ContractAddress, token_id: u256) {
            let owner = self._require_owned(token_id);
            let caller = get_caller_address();
            assert(
                caller == owner || self.is_approved_for_all(owner, caller), Errors::UNAUTHORIZED
            );

            self.approvals.write(token_id, approved);
            self.emit(Approval { owner, approved, token_id });
        }

        fn get_approved(self: @ContractState, token_id: u256) -> ContractAddress {
            self._require_owned(token_id);
            self.approvals.read(token_id)
        }

        fn transfer_from(
            ref self: ContractState, from: ContractAddress, to: ContractAddress, token_id: u256
        ) {
            let previous_owner = self._require_owned(token_id);
            assert(from == previous_owner, Errors::INVALID_SENDER);
            assert(!to.is_zero(), Errors::INVALID_RECEIVER);
            assert(
                self._is_approved_or_owner(from, get_caller_address(), token_id),
                Errors::UNAUTHORIZED
            );

            self.balances.write(from, self.balances.read(from) - 1);
            self.balances.write(to, self.balances.read(to) + 1);
            self.owners.write(token_id, to);

            self.emit(Transfer { from, to, token_id });
        }

        fn safe_transfer_from(
            ref self: ContractState,
            from: ContractAddress,
            to: ContractAddress,
            token_id: u256,
            data: Span<felt252>
        ) {
            Self::transfer_from(ref self, from, to, token_id);
            assert(
                self._check_on_erc721_received(from, to, token_id, data),
                Errors::SAFE_TRANSFER_FAILED
            );
        }

        fn is_approved_for_all(
            self: @ContractState, owner: ContractAddress, operator: ContractAddress
        ) -> bool {
            self.operator_approvals.read((owner, operator))
        }

        fn mint(ref self: ContractState, to: ContractAddress, token_id: u256) {
            assert(!to.is_zero(), Errors::INVALID_RECEIVER);
            assert(self.owners.read(token_id).is_zero(), Errors::ALREADY_MINTED);

            self.balances.write(to, self.balances.read(to) + 1);
            self.owners.write(token_id, to);

            self.emit(Transfer { from: Zero::zero(), to, token_id });
        }

        fn burn(ref self: ContractState, token_id: u256) {
            let owner = self._require_owned(token_id);

            self.balances.write(owner, self.balances.read(owner) - 1);

            self.owners.write(token_id, Zero::zero());
            self.approvals.write(token_id, Zero::zero());

            self.emit(Transfer { from: owner, to: Zero::zero(), token_id });
        }
    }

    #[generate_trait]
    pub impl InternalImpl of InternalTrait {
        fn _require_owned(self: @ContractState, token_id: u256) -> ContractAddress {
            let owner = self.owners.read(token_id);
            assert(!owner.is_zero(), Errors::INVALID_TOKEN_ID);
            owner
        }

        fn _is_approved_or_owner(
            self: @ContractState, owner: ContractAddress, spender: ContractAddress, token_id: u256
        ) -> bool {
            !spender.is_zero()
                && (owner == spender
                    || self.is_approved_for_all(owner, spender)
                    || spender == self.get_approved(token_id))
        }

        fn _check_on_erc721_received(
            self: @ContractState,
            from: ContractAddress,
            to: ContractAddress,
            token_id: u256,
            data: Span<felt252>
        ) -> bool {
            let src5_dispatcher = ISRC5Dispatcher { contract_address: to };

            if src5_dispatcher.supports_interface(IERC721_RECEIVER_ID) {
                IERC721ReceiverDispatcher { contract_address: to }
                    .on_erc721_received(
                        get_caller_address(), from, token_id, data
                    ) == IERC721_RECEIVER_ID
            } else {
                src5_dispatcher.supports_interface(openzeppelin_account::interface::ISRC6_ID)
            }
        }
    }
}
// ANCHOR_END: erc721

