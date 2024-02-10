#[starknet::interface]
pub trait IExampleContract<TContractState> {
    fn set(ref self: TContractState, value: u32);
    fn get(self: @TContractState) -> u32;
}

#[starknet::contract]
pub mod ExampleContract {
    #[storage]
    struct Storage {
        value: u32
    }


    // The `abi(embed_v0)` attribute indicates that all the functions in this implementation can be called externally.
    // Omitting this attribute would make all the functions in this implementation internal.
    #[abi(embed_v0)]
    impl ExampleContract of super::IExampleContract<ContractState> {
        // The `set` function can be called externally because it is written inside an implementation marked as `#[external]`.
        // It can modify the contract's state as it is passed as a reference.
        fn set(ref self: ContractState, value: u32) {
            self.value.write(value);
        }

        // The `get` function can be called externally because it is written inside an implementation marked as `#[external]`.
        // However, it can't modify the contract's state is passed as a snapshot: it is only a "view" function.
        fn get(self: @ContractState) -> u32 {
            // We can call an internal function from any functions within the contract
            PrivateFunctionsTrait::_read_value(self)
        }
    }

    // The lack of the `external` attribute indicates that all the functions in this implementation can only be called internally.
    // We name the trait `PrivateFunctionsTrait` to indicate that it is an internal trait allowing us to call internal functions.
    #[generate_trait]
    impl PrivateFunctions of PrivateFunctionsTrait {
        // The `_read_value` function is outside the implementation that is marked as `#[abi(embed_v0)]`, so it's an _internal_ function
        // and can only be called from within the contract.
        // However, it can't modify the contract's state is passed as a snapshot: it is only a "view" function.
        fn _read_value(self: @ContractState) -> u32 {
            self.value.read()
        }
    }
}
