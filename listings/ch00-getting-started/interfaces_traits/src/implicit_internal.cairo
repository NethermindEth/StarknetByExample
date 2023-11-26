#[starknet::interface]
trait IImplicitInternalContract<TContractState> {
    fn add(ref self: TContractState, nb: u32);
    fn get_value(self: @TContractState) -> u32;
    fn get_const(self: @TContractState) -> u32;
}

#[starknet::contract]
mod ImplicitInternalContract {
    #[storage]
    struct Storage {
        value: u32
    }

    #[generate_trait]
    impl InternalFunctions of InternalFunctionsTrait {
        fn set_value(ref self: ContractState, value: u32) {
            self.value.write(value);
        }
        fn get_const() -> u32 {
            42
        }
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.set_value(0);
    }

    #[abi(embed_v0)]
    impl ImplicitInternalContract of super::IImplicitInternalContract<ContractState> {
        fn add(ref self: ContractState, nb: u32) {
            self.set_value(self.value.read() + nb);
        }
        fn get_value(self: @ContractState) -> u32 {
            self.value.read()
        }
        fn get_const(self: @ContractState) -> u32 {
            self.get_const()
        }
    }
}
