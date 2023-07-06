#[starknet::contract]
mod LocalVariablesExample {
    #[storage]
    struct Storage {}

    #[generate_trait]
    #[external(v0)]
    impl LocalVariablesExampleImpl of ILocalVariablsExample {
        fn do_something(self: @ContractState, value: u32) -> u32 {
            // Declare a new local variable in the function
            let increment = 10;

            {
                // The scope of a code block allows for local variable declaration
                let sum = value + increment;
                sum
            }
        }
    }
}
