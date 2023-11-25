#[starknet::interface]
trait IErrorsExample<TContractState> {
    fn test_assert(self: @TContractState, i: u256);
    fn test_panic(self: @TContractState, i: u256);
}
#[starknet::contract]
mod ErrorsExample {
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
                panic_with_felt252('i must not be 0');
            }
        }
    }
}
