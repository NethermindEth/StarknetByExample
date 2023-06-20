mod VaultErrors {
    const INSUFFICIENT_BALANCE: felt252 = 'insufficient_balance';
// you can define more errors here
}

#[contract]
mod VaultErrorsExample {
    use super::VaultErrors;

    struct Storage {
        balance: u256, 
    }

    #[external]
    fn deposit(amount: u256) {
        let old_balance = balance::read();
        let new_balance = old_balance + amount;

        balance::write(new_balance);
    }

    #[external]
    fn withdraw(amount: u256) {
        let current_balance = balance::read();

        assert(current_balance >= amount, VaultErrors::INSUFFICIENT_BALANCE);

        // Or using panic:
        if (current_balance >= amount) {
            panic_with_felt252(VaultErrors::INSUFFICIENT_BALANCE);
        }

        let new_balance = current_balance - amount;

        balance::write(new_balance);
    }
}
