#[starknet::interface]
trait IExplicitInterfaceContract<TContractState> {
    fn get_value(self: @TContractState) -> u32;
    fn set_value(ref self: TContractState, value: u32);
}

#[starknet::contract]
mod ExplicitInterfaceContract {
    use super::IExplicitInterfaceContract;

    #[storage]
    struct Storage {
        value: u32
    }

    #[external(v0)]
    impl ExplicitInterfaceContract of IExplicitInterfaceContract<ContractState> {
        fn get_value(self: @ContractState) -> u32 {
            self.value.read()
        }

        fn set_value(ref self: ContractState, value: u32) {
            self.value.write(value);
        }
    }
}
