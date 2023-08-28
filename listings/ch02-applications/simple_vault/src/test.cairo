#[cfg(test)]
mod tests {
    use super::*;
    use starknet::{
        ContractAddress,
        array::ArrayTrait,
        traits::{Into, TryInto},
    };

    // Simulated dispatcher for the ERC20 contract.
    struct MockERC20Dispatcher;

    impl IERC20DispatcherTrait for MockERC20Dispatcher {
        // Simulated implementation of ERC20 methods for testing.
        // Replace these with actual logic in a real environment.
        fn balance_of(&self, _account: ContractAddress) -> u256 {
            // this is a simulated balance for testing
            1000 
        }

        fn transfer(&self, _recipient: ContractAddress, _amount: u256) -> bool {
            true 
        }

        fn transfer_from(&self, _sender: ContractAddress, _recipient: ContractAddress, _amount: u256) -> bool {
            true
        }
    }

    #[test]
    fn test_deposit_withdraw() {
        // Set up.
        let mut token_dispatcher = MockERC20Dispatcher {};
        let mut contract = SimpleVaultDispatcher { token: &mut token_dispatcher, total_supply: 0, balance_of: LegacyMap::new() };

        // Deposit some amount.
        contract.deposit(100);

        // Assert balances and total supply.
        assert_eq!(contract.balance_of(), 100, "Balance mismatch");
        assert_eq!(contract.total_supply(), 100, "Total supply mismatch");

        // Withdraw shares.
        contract.withdraw(50);

        // Assert balances and total supply after withdrawal.
        assert_eq!(contract.balance_of(), 50, "Balance mismatch after withdrawal");
        assert_eq!(contract.total_supply(), 50, "Total supply mismatch after withdrawal");
    }
}
