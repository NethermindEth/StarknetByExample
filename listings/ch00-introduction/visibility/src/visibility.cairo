#[starknet::contract]
mod VisiblityContract {
    #[storage]
    struct Storage {
        value: u32
    }


    #[generate_trait]
    #[external(v0)]
    impl VisiblityContract of IVisibilityContract {
        // The `set` function can be called externally because it is written inside an implementation marked as `#[external]`.
        // It can modify the contract's state as it is passed as a reference.
        fn set(ref self: ContractState,value: u32) {
            self.value.write(value);
        }

        // The `set` function can be called externally because it is written inside an implementation marked as `#[external]`.
        // However, it can't modify the contract's state is passed as a snapshot: it is only a "view" function.
        fn get(self: @ContractState) -> u32 {
            // We can call an internal function from any functions within the contract
            PrivateFunctionsTrait::_read_value(self)
        }
    }

    #[generate_trait]
    impl PrivateFunctions of PrivateFunctionsTrait {
        // The `_read_value` function is outside the implementation that is marked as `#[external(v0)]`, so it's an _internal_ function
        // and can only be called from within the contract.
        // It can modify the contract's state as it is passed as a reference.
        fn _read_value(self: @ContractState) -> u32 {
            self.value.read()
        }
    }
}
