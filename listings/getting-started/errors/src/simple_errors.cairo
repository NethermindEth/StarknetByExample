#[starknet::interface]
pub trait IErrorsExample<TContractState> {
    fn test_assert(self: @TContractState, i: u256);
    fn test_panic(self: @TContractState, i: u256);
}

// ANCHOR: contract
#[starknet::contract]
pub mod ErrorsExample {
    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl ErrorsExample of super::IErrorsExample<ContractState> {
        fn test_assert(self: @ContractState, i: u256) {
            // Assert used to validate a condition
            // and abort execution if the condition is not met
            assert(i > 0, 'i must be greater than 0');
        }

        fn test_panic(self: @ContractState, i: u256) {
            if (i == 0) {
                // Panic used to abort execution directly
                core::panic_with_felt252('i must not be 0');
            }
        }
    }
}
// ANCHOR_END: contract

#[cfg(test)]
mod test {
    use super::{ErrorsExample, IErrorsExampleDispatcher, IErrorsExampleDispatcherTrait};
    use starknet::{ContractAddress, SyscallResultTrait, syscalls::deploy_syscall};

    fn deploy() -> IErrorsExampleDispatcher {
        let (contract_address, _) = deploy_syscall(
            ErrorsExample::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();
        IErrorsExampleDispatcher { contract_address }
    }

    #[test]
    #[should_panic(expected: ('i must not be 0', 'ENTRYPOINT_FAILED'))]
    fn should_panic() {
        let contract = deploy();
        contract.test_panic(0);
    }

    #[test]
    #[should_panic(expected: ('i must be greater than 0', 'ENTRYPOINT_FAILED'))]
    fn should_assert() {
        let contract = deploy();
        contract.test_assert(0);
    }
}
