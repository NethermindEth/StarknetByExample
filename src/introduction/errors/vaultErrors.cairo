mod VaultErrors {
    const OVERFLOW: felt252 = 'overflow';
    const UNDERFLOW: felt252 = 'underflow';
    const INSUFFICIENT_BALANCE: felt252 = 'insufficient_balance';
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

        assert(new_balance >= old_balance, VaultErrors::OVERFLOW);

        balance::write(new_balance);
    }

    #[external]
    fn withdraw(amount: u256) {
        let old_balance = balance::read();
        let new_balance = old_balance - amount;

        assert(old_balance >= amount, VaultErrors::INSUFFICIENT_BALANCE);

        if (new_balance > old_balance) {
            panic_with_felt252(VaultErrors::OVERFLOW);
        }

        balance::write(new_balance);
    }
}
