#[starknet::contract]
mod ImplicitInterfaceContract {
    #[storage]
    struct Storage {
        value: u32
    }

    #[abi(per_item)]
    #[generate_trait]
    impl ImplicitInterfaceContract of IImplicitInterfaceContract {
        #[external(v0)]
        fn get_value(self: @ContractState) -> u32 {
            self.value.read()
        }

        #[external(v0)]
        fn set_value(ref self: ContractState, value: u32) {
            self.value.write(value);
        }
    }
}
