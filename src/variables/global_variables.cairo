#[contract]
mod GlobalExample {
    // import the library function and types from the starknet core library 
    use starknet::get_caller_address;

    #[external]
    fn foo() {
        // Call the get_caller_address function to get the sender address
        let caller = get_caller_address();
    // ...
    }
}
