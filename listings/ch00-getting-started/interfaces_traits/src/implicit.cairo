#[starknet::contract]
mod ImplicitInterfaceContract {
    #[storage]
    struct Storage {
        value: u32
    }

    #[external(v0)]
    #[generate_trait]
    impl ImplicitInterfaceContract of IImplicitInterfaceContract {
        fn get_value(self: @ContractState) -> u32 {
            self.value.read()
        }

        fn set_value(ref self: ContractState, value: u32) {
            self.value.write(value);
        }
    }
}
