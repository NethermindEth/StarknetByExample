#[starknet::contract]
mod LocalVariablesExample {
    #[storage]
    struct Storage {}

    #[generate_trait]
    #[external(v0)]
    impl LocalVariablesExample of ILocalVariablesExample {
        fn do_something(self: @ContractState, value: u32) -> u32 {
            // This variable is local to the current block. It can't be accessed once it goes out of scope.
            let increment = 10;

            {
                // The scope of a code block allows for local variable declaration
                // We can access variables defined in higher scopes.
                let sum = value + increment;
                sum
            }
        }
    }
}
