mod Errors {
    const NOT_POSITIVE: felt252 = 'must be greater than 0';
    const NOT_NULL: felt252 = 'must not be null';
}

#[contract]
mod CustomErrorsExample {
    use super::Errors;

    #[view]
    fn test_assert(i: u256) {
        assert(i > 0, Errors::NOT_POSITIVE);
    }

    #[view]
    fn test_panic(i: u256) {
        if (i == 0) {
            panic_with_felt252(Errors::NOT_NULL);
        }
    }
}
