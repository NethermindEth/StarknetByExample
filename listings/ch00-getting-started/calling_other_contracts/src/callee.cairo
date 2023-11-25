#[starknet::interface]
trait ICallee<TContractState> {
    fn set_value(ref self: TContractState, value: u128) -> u128;
}

#[starknet::contract]
mod Callee {
    #[storage]
    struct Storage {
        value: u128,
    }

    #[abi(embed_v0)]
    impl ICalleeImpl of super::ICallee<ContractState> {
        fn set_value(ref self: ContractState, value: u128) -> u128 {
            self.value.write(value);
            value
        }
    }
}
