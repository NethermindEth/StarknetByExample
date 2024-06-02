#[starknet::interface]
pub trait IVaultErrorsExample<TContractState> {
    fn deposit(ref self: TContractState, amount: u256);
    fn withdraw(ref self: TContractState, amount: u256);
}

// ANCHOR: contract
pub mod VaultErrors {
    pub const INSUFFICIENT_BALANCE: felt252 = 'insufficient_balance';
// you can define more errors here
}

#[starknet::contract]
pub mod VaultErrorsExample {
    use super::VaultErrors;

    #[storage]
    struct Storage {
        balance: u256,
    }

    #[abi(embed_v0)]
    impl VaultErrorsExample of super::IVaultErrorsExample<ContractState> {
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
// ANCHOR_END: contract

#[cfg(test)]
mod test {
    use super::{
        VaultErrorsExample, IVaultErrorsExampleDispatcher, IVaultErrorsExampleDispatcherTrait
    };
    use starknet::{ContractAddress, SyscallResultTrait, syscalls::deploy_syscall};

    fn deploy() -> IVaultErrorsExampleDispatcher {
        let (contract_address, _) = deploy_syscall(
            VaultErrorsExample::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();
        IVaultErrorsExampleDispatcher { contract_address }
    }

    #[test]
    fn should_deposit_and_withdraw() {
        let mut contract = deploy();
        contract.deposit(10);
        contract.withdraw(5);
    }

    #[test]
    #[should_panic(expected: ('insufficient_balance', 'ENTRYPOINT_FAILED'))]
    fn should_panic_on_insufficient_balance() {
        let mut contract = deploy();
        contract.deposit(10);
        contract.withdraw(15);
    }
}
