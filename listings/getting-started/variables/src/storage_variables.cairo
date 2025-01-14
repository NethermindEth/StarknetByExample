// [!region contract]
#[starknet::interface]
trait IStorageVariable<TContractState> {
    fn set(ref self: TContractState, value: u32);
    fn get(self: @TContractState) -> u32;
}

#[starknet::contract]
mod StorageVariablesContract {
    // You need to import these storage functions to read and write to storage variables
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use super::IStorageVariable;

    // All storage variables are contained in a struct called Storage
    // annotated with the `#[storage]` attribute
    #[storage]
    struct Storage {
        // Storage variable holding a number
        value: u32,
    }

    #[abi(embed_v0)]
    impl StorageVariables of IStorageVariable<ContractState> {
        // Write to storage variables by sending a transaction
        // that calls an external function
        fn set(ref self: ContractState, value: u32) {
            self.value.write(value);
        }

        // Read from storage variables without sending transactions
        fn get(self: @ContractState) -> u32 {
            self.value.read()
        }
    }
}
// [!endregion contract]

#[cfg(test)]
mod test {
    use super::{IStorageVariableDispatcher, IStorageVariableDispatcherTrait};
    use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};

    #[test]
    fn test_can_deploy_and_mutate_storage() {
        let contract = declare("StorageVariablesContract").unwrap().contract_class();
        let (contract_address, _) = contract.deploy(@array![]).unwrap();
        let contract = IStorageVariableDispatcher { contract_address };

        let initial_value = 10;

        contract.set(initial_value);
        assert_eq!(contract.get(), initial_value);
    }
}
