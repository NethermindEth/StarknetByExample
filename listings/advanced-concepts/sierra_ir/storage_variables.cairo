#[starknet::interface]
pub trait IStorageVariableExample<TContractState> {
    fn set(ref self: TContractState, value: u32);
    fn get(self: @TContractState) -> u32;
}

// [!region contract]
#[starknet::contract]
pub mod StorageVariablesExample {
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    struct Storage {
        pub value: u32
    }

    #[abi(embed_v0)]
    impl StorageVariablesExample of super::IStorageVariableExample<ContractState> {
        fn set(ref self: ContractState, value: u32) {
            self.value.write(value);
        }

        fn get(self: @ContractState) -> u32 {
            self.value.read()
        }
    }
}
// [!endregion contract]

#[cfg(test)]
mod test {
    use super::{
        StorageVariablesExample, IStorageVariableExampleDispatcher,
        IStorageVariableExampleDispatcherTrait
    };
    use starknet::{SyscallResultTrait, syscalls::deploy_syscall};
    use starknet::testing::set_contract_address;
    use starknet::storage::StoragePointerReadAccess;

    #[test]
    fn test_can_deploy_and_mutate_storage() {
        let (contract_address, _) = deploy_syscall(
            StorageVariablesExample::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();

        let contract = IStorageVariableExampleDispatcher { contract_address };

        let initial_value = 10;

        contract.set(initial_value);
        assert_eq!(contract.get(), initial_value);

        // With contract state directly
        let state = @StorageVariablesExample::contract_state_for_testing();
        set_contract_address(contract_address);
        assert_eq!(state.value.read(), initial_value);
    }
}
