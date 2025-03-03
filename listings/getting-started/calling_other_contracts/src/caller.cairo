// [!region callee_contract]
// This will automatically generate ICalleeDispatcher and ICalleeDispatcherTrait
#[starknet::interface]
trait ICallee<TContractState> {
    fn set_value(ref self: TContractState, value: u128);
    fn get_value(self: @TContractState) -> u128;
}

#[starknet::contract]
mod Callee {
    use starknet::storage::{StoragePointerWriteAccess, StoragePointerReadAccess};
    use super::ICallee;

    #[storage]
    struct Storage {
        value: u128,
    }

    #[abi(embed_v0)]
    impl ICalleeImpl of ICallee<ContractState> {
        fn set_value(ref self: ContractState, value: u128) {
            self.value.write(value);
        }
        fn get_value(self: @ContractState) -> u128 {
            self.value.read()
        }
    }
}
// [!endregion callee_contract]

// Interface for the contract that will make the calls
#[starknet::interface]
trait ICaller<TContractState> {
    // Call another contract to set its value
    fn set_value_from_address(
        ref self: TContractState, addr: starknet::ContractAddress, value: u128,
    );
}

// [!region caller_contract]
#[starknet::contract]
mod Caller {
    // Import the generated dispatcher types for the Callee contract
    use super::{ICalleeDispatcher, ICalleeDispatcherTrait};
    use super::ICaller;
    use starknet::ContractAddress;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl ICallerImpl of ICaller<ContractState> {
        fn set_value_from_address(ref self: ContractState, addr: ContractAddress, value: u128) {
            // Create a dispatcher instance and call the target contract
            ICalleeDispatcher { contract_address: addr }.set_value(value);
        }
    }
}
// [!endregion caller_contract]

#[cfg(test)]
mod tests {
    use super::{
        ICalleeDispatcher, ICalleeDispatcherTrait, ICallerDispatcher, ICallerDispatcherTrait,
    };
    use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};

    fn deploy() -> (ICalleeDispatcher, ICallerDispatcher) {
        let contract = declare("Callee").unwrap().contract_class();
        let (callee_contract_address, _) = contract.deploy(@array![]).unwrap();

        let contract = declare("Caller").unwrap().contract_class();
        let (caller_contract_address, _) = contract.deploy(@array![]).unwrap();
        (
            ICalleeDispatcher { contract_address: callee_contract_address },
            ICallerDispatcher { contract_address: caller_contract_address },
        )
    }

    #[test]
    fn test_caller() {
        let (callee, caller) = deploy();
        let value: u128 = 42;

        caller.set_value_from_address(callee.contract_address, value);

        assert_eq!(callee.get_value(), value);
    }
}
