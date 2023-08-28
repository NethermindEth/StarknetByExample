mod Errors {
    const NOT_POSITIVE: felt252 = 'must be greater than 0';
    const NOT_NULL: felt252 = 'must not be null';
}

#[starknet::contract]
mod CustomErrorsExample {
    use super::Errors;

    #[storage]
    struct Storage {}

    #[generate_trait]
    #[external(v0)]
    impl CustomErrorsExample of ICustomErrorsExample {
        fn test_assert(self: @ContractState, i: u256) {
            assert(i > 0, Errors::NOT_POSITIVE);
        }

        #[view]
        fn test_panic(self: @ContractState, i: u256) {
            if (i == 0) {
                panic_with_felt252(Errors::NOT_NULL);
            }
        }
    }
}
