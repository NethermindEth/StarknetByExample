mod VaultErrors {
    const INSUFFICIENT_BALANCE: felt252 = 'insufficient_balance';
// you can define more errors here
}

#[starknet::contract]
mod VaultErrorsExample {
    use super::VaultErrors;

    #[storage]
    struct Storage {
        balance: u256,
    }

    #[generate_trait]
    #[external(v0)]
    impl VaultErrorsExample of IVaultErrorsExample {
        fn deposit(ref self: ContractState, amount: u256) {
            let mut balance = self.balance.read();
            balance = balance + amount;
            self.balance.write(balance);
        }

        fn withdraw(ref self: ContractState, amount: u256) {
            let mut balance = self.balance.read();

            assert(balance >= amount, VaultErrors::INSUFFICIENT_BALANCE);

            // Or using panic:
            if (balance >= amount) {
                panic_with_felt252(VaultErrors::INSUFFICIENT_BALANCE);
            }

            let balance = balance - amount;

            self.balance.write(balance);
        }
    }
}
