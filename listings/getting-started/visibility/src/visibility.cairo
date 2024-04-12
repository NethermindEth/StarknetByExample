#[starknet::interface]
pub trait IExampleContract<TContractState> {
    fn set(ref self: TContractState, value: u32);
    fn get(self: @TContractState) -> u32;
}

// ANCHOR: contract
#[starknet::contract]
pub mod ExampleContract {
    #[storage]
    struct Storage {
        value: u32
    }

    // The `abi(embed_v0)` attribute indicates that all
    // the functions in this implementation can be called externally.
    // Omitting this attribute would make all the functions internal.
    #[abi(embed_v0)]
    impl ExampleContract of super::IExampleContract<ContractState> {
        // The `set` function can be called externally
        // because it is written inside an implementation marked as `#[external]`.
        // It can modify the contract's state as it is passed as a reference.
        fn set(ref self: ContractState, value: u32) {
            self.value.write(value);
        }

        // The `get` function can be called externally
        // because it is written inside an implementation marked as `#[external]`.
        // However, it can't modify the contract's state is passed as a snapshot
        // -> It's only a "view" function.
        fn get(self: @ContractState) -> u32 {
            // We can call an internal function from any functions within the contract
            PrivateFunctionsTrait::_read_value(self)
        }
    }

    // The lack of the `external` attribute indicates that all the functions in
    // this implementation can only be called internally.
    // We name the trait `PrivateFunctionsTrait` to indicate that it is an
    // internal trait allowing us to call internal functions.
    #[generate_trait]
    pub impl PrivateFunctions of PrivateFunctionsTrait {
        // The `_read_value` function is outside the implementation that is
        // marked as `#[abi(embed_v0)]`, so it's an _internal_ function
        // and can only be called from within the contract.
        // However, it can't modify the contract's state is passed
        // as a snapshot: it is only a "view" function.
        fn _read_value(self: @ContractState) -> u32 {
            self.value.read()
        }
    }
}
// ANCHOR_END: contract

#[cfg(test)]
mod test {
    use super::{ExampleContract, IExampleContractDispatcher, IExampleContractDispatcherTrait};
    use starknet::{ContractAddress, SyscallResultTrait, syscalls::deploy_syscall};

    // These imports will allow us to directly access and set the contract state:
    // - for `value` storage variable access
    use super::ExampleContract::valueContractMemberStateTrait;
    // - for `PrivateFunctionsTrait` internal functions access
    //   implementation need to be public to be able to access it
    use super::ExampleContract::PrivateFunctionsTrait;
    // to set the contract address for the state
    // and also be able to use the dispatcher on the same contract
    use starknet::testing::set_contract_address;

    #[test]
    fn can_call_set_and_get() {
        let (contract_address, _) = deploy_syscall(
            ExampleContract::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();

        // You can interact with the external entrypoints of the contract using the dispatcher.
        let contract = IExampleContractDispatcher { contract_address };
        // But for internal functions, you need to use the contract state.
        let mut state = ExampleContract::contract_state_for_testing();
        set_contract_address(contract_address);

        // The contract dispatcher and state refer to the same contract.
        assert_eq!(contract.get(), state.value.read());

        // We can set from the dispatcher
        contract.set(42);
        assert_eq!(contract.get(), state.value.read());
        assert_eq!(42, state.value.read());
        assert_eq!(42, contract.get());

        // Or directly from the state for more complex operations
        state.value.write(24);
        assert_eq!(contract.get(), state.value.read());
        assert_eq!(24, state.value.read());
        assert_eq!(24, contract.get());

        // We can also acces internal functions from the state
        assert_eq!(state._read_value(), state.value.read());
        assert_eq!(state._read_value(), contract.get());
    }
}
