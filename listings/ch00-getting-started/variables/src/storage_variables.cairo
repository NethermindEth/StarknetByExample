#[starknet::interface]
trait IStorageVariableExample<TContractState> {
    fn set(ref self: TContractState, value: u32);
    fn get(self: @TContractState) -> u32;
}
#[starknet::contract]
mod StorageVariablesExample {
    // All storage variables are contained in a struct called Storage
    // annotated with the `#[storage]` attribute
    #[storage]
    struct Storage {
        // Storage variable holding a number
        value: u32
    }

    #[abi(embed_v0)]
    impl StorageVariablesExample of super::IStorageVariableExample<ContractState> {
        // Write to storage variables by sending a transaction that calls an external function
        fn set(ref self: ContractState, value: u32) {
            self.value.write(value);
        }

        // Read from storage variables without sending transactions
        fn get(self: @ContractState) -> u32 {
            self.value.read()
        }
    }
}
