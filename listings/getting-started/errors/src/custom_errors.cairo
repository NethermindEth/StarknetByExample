#[starknet::interface]
pub trait ICustomErrorsExample<TContractState> {
    fn test_assert(self: @TContractState, i: u256);
    fn test_panic(self: @TContractState, i: u256);
}

// ANCHOR: contract
pub mod Errors {
    pub const NOT_POSITIVE: felt252 = 'must be greater than 0';
    pub const NOT_NULL: felt252 = 'must not be null';
}

#[starknet::contract]
pub mod CustomErrorsExample {
    use super::Errors;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl CustomErrorsExample of super::ICustomErrorsExample<ContractState> {
        fn test_assert(self: @ContractState, i: u256) {
            assert(i > 0, Errors::NOT_POSITIVE);
        }

        fn test_panic(self: @ContractState, i: u256) {
            if (i == 0) {
                core::panic_with_felt252(Errors::NOT_NULL);
            }
        }
    }
}
// ANCHOR_END: contract

#[cfg(test)]
mod test {
    use super::{
        CustomErrorsExample, ICustomErrorsExampleDispatcher, ICustomErrorsExampleDispatcherTrait
    };
    use starknet::{ContractAddress, SyscallResultTrait, syscalls::deploy_syscall};

    fn deploy() -> ICustomErrorsExampleDispatcher {
        let (contract_address, _) = deploy_syscall(
            CustomErrorsExample::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();
        ICustomErrorsExampleDispatcher { contract_address }
    }

    #[test]
    #[should_panic(expected: ('must not be null', 'ENTRYPOINT_FAILED'))]
    fn should_panic() {
        let contract = deploy();
        contract.test_panic(0);
    }

    #[test]
    #[should_panic(expected: ('must be greater than 0', 'ENTRYPOINT_FAILED'))]
    fn should_assert() {
        let contract = deploy();
        contract.test_assert(0);
    }
}
