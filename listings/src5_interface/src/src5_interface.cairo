use openzeppelin::account::interface;
use openzeppelin::introspection::src5::SRC5Component;
use starknet::{ContractAddress, get_caller_address, get_contract_address, contract_address_const};
use super::interface::ISRC5_ID;
use super::request::SocialRequest;
use super::transfer::Transfer;

/// @title User Account Contract
/// @notice This contract implements an interface for user accounts with SRC5 introspection.
/// @dev This contract utilizes OpenZeppelin and StarkNet libraries for SRC5 introspection.
#[starknet::interface]
pub trait IUserAccount<TContractState> {
    /// @notice Retrieves the public key associated with the account.
    /// @return The public key of the account.
    fn get_public_key(self: @TContractState) -> u256;

    /// @notice Handles a transfer request.
    /// @param request The social request containing transfer details.
    fn handle_transfer(ref self: TContractState, request: SocialRequest<Transfer>);

    /// @notice Checks if a specific interface is supported by the contract.
    /// @param interface_id The ID of the interface to check.
    /// @return True if the interface is supported, false otherwise.
    fn is_supported_interface(self: @TContractState, interface_id: felt252) -> bool;
}

#[starknet::contract]
pub mod UserAccount {
    use openzeppelin::introspection::src5::SRC5Component;
    use super::interface::ISRC5_ID;
    use super::request::{SocialRequest, Transfer};
    use super::{IUserAccountDispatcher, IUserAccountDispatcherTrait};

    component!(path: SRC5Component, storage: src5, event: SRC5Event);

    #[abi(embed_v0)]
    impl SRC5Impl = SRC5Component::SRC5Impl<ContractState>;
    impl InternalImpl = SRC5Component::InternalImpl<ContractState>;

    /// @dev Storage structure for the User Account contract.
    #[storage]
    struct Storage {
        #[key]
        public_key: u256,
        #[substorage(v0)]
        src5: SRC5Component::Storage,
    }

    /// @dev Events emitted by the User Account contract.
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        /// @notice Emitted when a new account is created.
        /// @param public_key The public key of the newly created account.
        AccountCreated { public_key: u256 },
        /// @notice Emitted for SRC5 events.
        #[flat]
        SRC5Event: SRC5Component::Event,
    }

    /// @notice Constructor function for the User Account contract.
    /// @param public_key The public key to be associated with the account.
    #[constructor]
    fn constructor(ref self: ContractState, public_key: u256) {
        self.public_key.write(public_key);
        self.emit(AccountCreated { public_key });
        self.src5.register_interface(ISRC5_ID);
    }

    /// @dev Implementation of the IUserAccount interface.
    #[abi(embed_v0)]
    impl IUserAccountImpl for ContractState {
        /// @notice Retrieves the public key associated with the account.
        /// @return The public key of the account.
        fn get_public_key(self: @ContractState) -> u256 {
            self.public_key.read()
        }

        /// @notice Handles a transfer request.
        /// @param request The social request containing transfer details.
        fn handle_transfer(ref self: ContractState, request: SocialRequest<Transfer>) {
            let erc20 = ERC20ABIDispatcher::at(request.content.token_address);
            erc20.transfer(request.content.recipient_address, request.content.amount);
        }

        /// @notice Checks if a specific interface is supported by the contract.
        /// @param interface_id The ID of the interface to check.
        /// @return True if the interface is supported, false otherwise.
        fn is_supported_interface(self: @ContractState, interface_id: felt252) -> bool {
            self.src5.supports_interface(interface_id)
        }
    }
}
