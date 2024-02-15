pub mod Errors {
    pub const NOT_POSITIVE: felt252 = 'must be greater than 0';
    pub const NOT_NULL: felt252 = 'must not be null';
}

#[starknet::interface]
trait ICustomErrorsExample<TContractState> {
    fn test_assert(self: @TContractState, i: u256);
    fn test_panic(self: @TContractState, i: u256);
}

#[starknet::contract]
mod CustomErrorsExample {
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
