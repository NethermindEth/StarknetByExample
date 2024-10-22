use starknet::{ContractAddress, EthAddress};

#[starknet::interface]
pub trait IMintableToken<TContractState> {
    fn mint(ref self: TContractState, account: ContractAddress, amount: u256);
    fn burn(ref self: TContractState, account: ContractAddress, amount: u256);
}

#[starknet::interface]
pub trait ITokenBridge<TContractState> {
    /// Initiates a withdrawal of tokens on the L1 contract.
    ///
    /// # Arguments
    ///
    /// * `l1_recipient` - Contract address on L1.
    /// * `amount` - Amount of tokens to withdraw.
    fn bridge_to_l1(ref self: TContractState, l1_recipient: EthAddress, amount: u256);
    fn set_l1_bridge(ref self: TContractState, l1_bridge_address: EthAddress);
    fn set_l2_token(ref self: TContractState, l2_token_address: ContractAddress);
    fn governor(self: @TContractState) -> ContractAddress;
    fn l1_bridge(self: @TContractState) -> felt252;
    fn l2_token(self: @TContractState) -> ContractAddress;
}

#[starknet::contract]
pub mod TokenBridge {
    use core::num::traits::Zero;
    use starknet::{ContractAddress, EthAddress, get_caller_address, syscalls, SyscallResultTrait};
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use super::{IMintableTokenDispatcher, IMintableTokenDispatcherTrait};

    #[storage]
    pub struct Storage {
        // The address of the L2 governor of this contract. Only the governor can set the other
        // storage variables.
        pub governor: ContractAddress,
        // The L1 bridge address. Zero when unset.
        pub l1_bridge: felt252,
        // The L2 token contract address. Zero when unset.
        pub l2_token: ContractAddress,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        WithdrawInitiated: WithdrawInitiated,
        DepositHandled: DepositHandled,
        L1BridgeSet: L1BridgeSet,
        L2TokenSet: L2TokenSet,
    }

    // An event that is emitted when bridge_to_l1 is called.
    // * l1_recipient is the l1 recipient address.
    // * amount is the amount to withdraw.
    // * caller_address is the address from which the call was made.
    #[derive(Drop, starknet::Event)]
    pub struct WithdrawInitiated {
        pub l1_recipient: EthAddress,
        pub amount: u256,
        pub caller_address: ContractAddress,
    }

    // An event that is emitted when handle_deposit is called.
    // * account is the recipient address.
    // * amount is the amount to deposit.
    #[derive(Drop, starknet::Event)]
    pub struct DepositHandled {
        pub account: ContractAddress,
        pub amount: u256,
    }

    // An event that is emitted when set_l1_bridge is called.
    // * l1_bridge_address is the new l1 bridge address.
    #[derive(Drop, starknet::Event)]
    struct L1BridgeSet {
        l1_bridge_address: EthAddress,
    }

    // An event that is emitted when set_l2_token is called.
    // * l2_token_address is the new l2 token address.
    #[derive(Drop, starknet::Event)]
    struct L2TokenSet {
        l2_token_address: ContractAddress,
    }

    pub mod Errors {
        pub const EXPECTED_FROM_BRIDGE_ONLY: felt252 = 'EXPECTED_FROM_BRIDGE_ONLY';
        pub const INVALID_ADDRESS: felt252 = 'Invalid address';
        pub const INVALID_AMOUNT: felt252 = 'Invalid amount';
        pub const GOVERNOR_ONLY: felt252 = 'GOVERNOR_ONLY';
        pub const ZERO_BRIDGE_ADDRESS: felt252 = 'ZERO_BRIDGE_ADDRESS';
    }

    #[constructor]
    fn constructor(ref self: ContractState, governor: ContractAddress, l2_token: ContractAddress,) {
        assert(governor.is_non_zero(), Errors::INVALID_ADDRESS);
        assert(l2_token.is_non_zero(), Errors::INVALID_ADDRESS);
        self.governor.write(governor);
        self.l2_token.write(l2_token);
    }

    #[abi(embed_v0)]
    impl TokenBridge of super::ITokenBridge<ContractState> {
        fn bridge_to_l1(ref self: ContractState, l1_recipient: EthAddress, amount: u256) {
            assert(l1_recipient.is_non_zero(), Errors::INVALID_ADDRESS);
            assert(amount.is_non_zero(), Errors::INVALID_AMOUNT);

            // burn tokens on L2
            let caller_address = get_caller_address();
            IMintableTokenDispatcher { contract_address: self.l2_token.read() }
                .burn(caller_address, amount);

            // Send the message to L1.
            let mut payload: Array<felt252> = array![
                l1_recipient.into(), amount.low.into(), amount.high.into()
            ];
            syscalls::send_message_to_l1_syscall(self.l1_bridge.read(), payload.span())
                .unwrap_syscall();

            self.emit(WithdrawInitiated { l1_recipient, amount, caller_address });
        }

        fn set_l1_bridge(ref self: ContractState, l1_bridge_address: EthAddress) {
            assert(get_caller_address() == self.governor.read(), Errors::GOVERNOR_ONLY);
            assert(l1_bridge_address.is_non_zero(), Errors::ZERO_BRIDGE_ADDRESS);

            self.l1_bridge.write(l1_bridge_address.into());
            self.emit(L1BridgeSet { l1_bridge_address });
        }

        fn set_l2_token(ref self: ContractState, l2_token_address: ContractAddress) {
            assert(get_caller_address() == self.governor.read(), Errors::GOVERNOR_ONLY);
            assert(l2_token_address.is_non_zero(), Errors::INVALID_ADDRESS);

            self.l2_token.write(l2_token_address);
            self.emit(L2TokenSet { l2_token_address });
        }

        fn governor(self: @ContractState) -> ContractAddress {
            self.governor.read()
        }

        fn l1_bridge(self: @ContractState) -> felt252 {
            self.l1_bridge.read()
        }

        fn l2_token(self: @ContractState) -> ContractAddress {
            self.l2_token.read()
        }
    }

    #[l1_handler]
    pub fn handle_deposit(
        ref self: ContractState, from_address: felt252, account: ContractAddress, amount: u256,
    ) {
        assert(from_address == self.l1_bridge.read(), Errors::EXPECTED_FROM_BRIDGE_ONLY);
        assert(account.is_non_zero(), Errors::INVALID_ADDRESS);
        assert(amount.is_non_zero(), Errors::INVALID_AMOUNT);

        // Call mint on l2_token contract.
        IMintableTokenDispatcher { contract_address: self.l2_token.read() }.mint(account, amount);

        self.emit(Event::DepositHandled(DepositHandled { account, amount }));
    }
}
