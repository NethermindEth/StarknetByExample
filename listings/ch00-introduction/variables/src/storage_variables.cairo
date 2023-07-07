#[starknet::contract]
mod StorageVariablesExample {
    // All storage variables are contained in a struct called Storage
    // annotated with the `#[storage]` attribute
    #[storage]
    struct Storage {
        // Storage variable holding a number
        value: u32
    }

    #[generate_trait]
    #[external(v0)]
    impl StorageVariablesExample of IStorageVariableExample {
        // Write to storage variables by sending a transaction that calls an external function
        fn set(ref self: ContractState, value: u32) {
            self.value.write(value);
        }

        // Read from storage variables without sending transactions
        fn get(ref self: ContractState) -> u32 {
            self.value.read()
        }
    }
}
