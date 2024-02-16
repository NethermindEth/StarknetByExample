#[starknet::interface]
pub trait IGlobalExample<TContractState> {
    fn foo(ref self: TContractState);
}
#[starknet::contract]
pub mod GlobalExample {
    // import the required functions from the starknet core library
    use starknet::get_caller_address;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl GlobalExampleImpl of super::IGlobalExample<ContractState> {
        fn foo(ref self: ContractState) {
            // Call the get_caller_address function to get the sender address
            let _caller = get_caller_address();
        // ...
        }
    }
}
