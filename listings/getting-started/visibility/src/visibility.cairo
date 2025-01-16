// [!region contract]
// This trait defines the public interface of our contract
// All functions declared here will be accessible externally
#[starknet::interface]
trait ContractInterface<TContractState> {
    fn set(ref self: TContractState, value: u32);
    fn get(self: @TContractState) -> u32;
}

#[starknet::contract]
mod Contract {
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use super::ContractInterface;

    #[storage]
    pub struct Storage {
        pub value: u32,
    }

    // External Functions Implementation
    // The `#[abi(embed_v0)]` attribute makes these functions callable from outside the contract
    // This is where we implement our public interface defined in ContractInterface
    #[abi(embed_v0)]
    pub impl ContractImpl of ContractInterface<ContractState> {
        // External function that can modify state
        // - Takes `ref self` to allow state modifications
        // - Calls internal `increment` function to demonstrate internal function usage
        fn set(ref self: ContractState, value: u32) {
            self.value.write(increment(value));
        }

        // External view function (cannot modify state)
        // - Takes `@self` (snapshot) to prevent state modifications
        // - Demonstrates calling an internal function (_read_value)
        fn get(self: @ContractState) -> u32 {
            self._read_value()
        }
    }

    // Internal Functions Implementation
    // These functions can only be called from within the contract
    // The #[generate_trait] attribute creates a trait for these internal functions
    #[generate_trait]
    pub impl Internal of InternalTrait {
        // Internal view function
        // - Takes `@self` as it only needs to read state
        // - Can only be called by other functions within the contract
        fn _read_value(self: @ContractState) -> u32 {
            self.value.read()
        }
    }

    // Pure Internal Function
    // - Doesn't access contract state
    // - Defined directly in the contract body
    // - Considered good practice to keep pure functions outside impl blocks
    // It's also possible to use ContractState here, but it's not recommended
    // as it'll require to pass the state as a parameter
    pub fn increment(value: u32) -> u32 {
        value + 1
    }
}
// [!endregion contract]

#[cfg(test)]
mod test {
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};
    use super::{ContractInterfaceDispatcher, ContractInterfaceDispatcherTrait};
    use super::Contract;
    use super::Contract::{InternalTrait, increment};

    #[test]
    fn test_external_functions() {
        // Deploy the contract
        let contract = declare("Contract").unwrap().contract_class();
        let (contract_address, _) = contract.deploy(@array![]).unwrap();

        // Create contract interface for external calls
        let contract = ContractInterfaceDispatcher { contract_address };

        // Test external function that modifies state
        contract.set(42);
        assert_eq!(43, contract.get()); // Value is incremented
    }

    #[test]
    fn test_internal_functions() {
        // Create contract state for internal function access
        let mut state = Contract::contract_state_for_testing();

        // Test direct state modification
        state.value.write(24);
        assert_eq!(24, state.value.read());

        // Test internal function access
        assert_eq!(state._read_value(), state.value.read());
        assert_eq!(25, increment(24));
    }
}
