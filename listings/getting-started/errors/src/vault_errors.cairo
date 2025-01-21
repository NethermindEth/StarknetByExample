#[starknet::interface]
trait IVaultErrors<TContractState> {
    fn deposit(ref self: TContractState, amount: u256);
    fn withdraw(ref self: TContractState, amount: u256);
}

// [!region contract]
mod VaultErrors {
    pub const INSUFFICIENT_BALANCE: felt252 = 'insufficient_balance';
    // you can define more errors here
}

#[starknet::contract]
mod VaultErrorsContract {
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use super::{VaultErrors, IVaultErrors};

    #[storage]
    struct Storage {
        balance: u256,
    }

    #[abi(embed_v0)]
    impl VaultErrorsContract of IVaultErrors<ContractState> {
        fn deposit(ref self: ContractState, amount: u256) {
            let mut balance = self.balance.read();
            balance = balance + amount;
            self.balance.write(balance);
        }

        fn withdraw(ref self: ContractState, amount: u256) {
            let mut balance = self.balance.read();

            assert(balance >= amount, VaultErrors::INSUFFICIENT_BALANCE);

            // Or using panic:
            if (balance < amount) {
                core::panic_with_felt252(VaultErrors::INSUFFICIENT_BALANCE);
            }

            let balance = balance - amount;

            self.balance.write(balance);
        }
    }
}
// [!endregion contract]

#[cfg(test)]
mod test {
    use super::{IVaultErrorsDispatcher, IVaultErrorsDispatcherTrait};
    use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};

    fn deploy() -> IVaultErrorsDispatcher {
        let contract = declare("VaultErrorsContract").unwrap().contract_class();
        let (contract_address, _) = contract.deploy(@array![]).unwrap();
        IVaultErrorsDispatcher { contract_address }
    }

    #[test]
    fn should_deposit_and_withdraw() {
        let mut contract = deploy();
        contract.deposit(10);
        contract.withdraw(5);
    }

    #[test]
    #[should_panic(expected: 'insufficient_balance')]
    fn should_panic_on_insufficient_balance() {
        let mut contract = deploy();
        contract.deposit(10);
        contract.withdraw(15);
    }
}
