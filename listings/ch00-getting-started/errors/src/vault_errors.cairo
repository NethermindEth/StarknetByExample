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

    #[abi(per_item)]
    #[generate_trait]
    impl VaultErrorsExample of IVaultErrorsExample {
        #[external(v0)]
        fn deposit(ref self: ContractState, amount: u256) {
            let mut balance = self.balance.read();
            balance = balance + amount;
            self.balance.write(balance);
        }

        #[external(v0)]
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
