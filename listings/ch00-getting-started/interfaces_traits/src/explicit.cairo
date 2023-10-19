#[starknet::interface]
trait IExplicitInterfaceContract<TContractState> {
    fn get_value(self: @TContractState) -> u32;
    fn set_value(ref self: TContractState, value: u32);
}

#[starknet::contract]
mod ExplicitInterfaceContract {
    #[storage]
    struct Storage {
        value: u32
    }

    #[abi(embed_v0)]
    impl ExplicitInterfaceContract of super::IExplicitInterfaceContract<ContractState> {
        fn get_value(self: @ContractState) -> u32 {
            self.value.read()
        }

        fn set_value(ref self: ContractState, value: u32) {
            self.value.write(value);
        }
    }
}
