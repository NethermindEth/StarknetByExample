#[contract]
mod ErrorsExample {
    #[view]
    fn test_assert(i: u256) {
        // Assert used to validate a condition
        // and abort execution if the condition is not met
        assert(i > 0, 'i must be greater than 0');
    }

    #[view]
    fn test_panic(i: u256) {
        if (i == 0) {
            // Panic used to abort execution directly
            panic_with_felt252('i must not be 0');
        }
    }
}
