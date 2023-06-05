#[contract]
mod GlobalExample {
    // import the library function and types from the starknet core library 
    use starknet::get_caller_address;
    use starknet::ContractAddress;

    #[external]
    fn transfer(recipient: ContractAddress, amount: u256) {
        // Call the get_caller_address function to get the sender address
        let sender = get_caller_address();
    // ...
    }
}
