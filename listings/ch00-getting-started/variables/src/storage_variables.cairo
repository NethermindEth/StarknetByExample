#[starknet::contract]
mod StorageVariablesExample {
    // All storage variables are contained in a struct called Storage
    // annotated with the `#[storage]` attribute
    #[storage]
    struct Storage {
        // Storage variable holding a number
        value: u32
    }

    #[abi(per_item)]
    #[generate_trait]
    impl StorageVariablesExample of IStorageVariableExample {
        // Write to storage variables by sending a transaction that calls an external function
        #[external(v0)]
        fn set(ref self: ContractState, value: u32) {
            self.value.write(value);
        }

        // Read from storage variables without sending transactions
        #[external(v0)]
        fn get(ref self: ContractState) -> u32 {
            self.value.read()
        }
    }
}
