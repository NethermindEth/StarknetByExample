// [!region contract]
#[starknet::contract]
pub mod GlobalVariablesContract {
    // import the required functions from the starknet core library
    use starknet::get_caller_address;

    #[storage]
    struct Storage {}

    pub fn foo(ref self: ContractState) {
        // Call the get_caller_address function to get the sender address
        let _caller = get_caller_address();
        // ...
    }
}
// [!endregion contract]

// Not much to test


