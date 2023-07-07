#[starknet::contract]
mod GlobalExample {
    // import the required functions from the starknet core library 
    use starknet::get_caller_address;

    #[storage]
    struct Storage {}

    #[generate_trait]
    #[external(v0)]
    impl GlobalExampleImpl of IGlobalExample {
        fn foo(ref self: ContractState) {
            // Call the get_caller_address function to get the sender address
            let caller = get_caller_address();
        // ...
        }
    }
}
