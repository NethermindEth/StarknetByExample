#[cfg(test)]
mod tests {
    use super::*;
    use starknet::{ContractAddress, deploy_syscall};
    
    #[test]
    fn test_deposit_and_withdraw() {
        // Deploy the SimpleVault contract.
        let mut calldata: Array<felt252> = ArrayTrait::new();
        let (vault_contract_address, _) = deploy_syscall(
            SimpleVaultContract::TEST_CLASS_HASH.try_into().unwrap(),
            0,
            calldata.span(),
            false,
        )
        .unwrap();

        // Set up the contract dispatcher with the deployed contract.
        let mut token_dispatcher = MockERC20Dispatcher {}; // Replace with your ERC20 implementation.
        let mut contract = SimpleVaultDispatcher {
            token: &mut token_dispatcher,
            total_supply: 0,
            balance_of: LegacyMap::new(),
            contract_address: vault_contract_address,
        };

        // Deposit some amount.
        contract.deposit(100);

        // Assert balances and total supply after deposit.
        assert_eq!(contract.balance_of(), 100, "Balance mismatch after deposit");
        assert_eq!(contract.total_supply(), 100, "Total supply mismatch after deposit");

        // Withdraw some shares.
        contract.withdraw(50);

        // Assert balances and total supply after withdrawal.
        assert_eq!(contract.balance_of(), 50, "Balance mismatch after withdrawal");
        assert_eq!(contract.total_supply(), 50, "Total supply mismatch after withdrawal");
    }
}
