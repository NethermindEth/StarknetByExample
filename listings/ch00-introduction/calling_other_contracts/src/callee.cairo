#[starknet::contract]
mod Callee {
    #[storage]
    struct Storage {
        value: u128, 
    }

    #[external(v0)]
    #[generate_trait]
    impl ICalleeImpl of ICallee {
        fn set_value(ref self: ContractState, value: u128) -> u128 {
            self.value.write(value);
            value
        }
    }
}
