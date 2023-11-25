use starknet::ContractAddress;
#[starknet::interface]
trait IFelt252Example<TContractState> {
    fn store_name(ref self: TContractState, name: felt252) -> felt252;
    fn view_name(self: @TContractState, address: ContractAddress) -> felt252;
}

#[starknet::contract]
mod Felt252Example {
    use starknet::{ContractAddress, get_caller_address};

    #[storage]
    struct Storage {
        user_name: LegacyMap::<ContractAddress, felt252>,
    }

    #[abi(embed_v0)]
    impl External of super::IFelt252Example<ContractState> {
        fn store_name(ref self: ContractState, name: felt252) -> felt252 {
            self.user_name.write(get_caller_address(), name);

            let welcome_msg: felt252 = 'Welcome to StarknetByExample';
            welcome_msg
        }

        fn view_name(self: @ContractState, address: ContractAddress) -> felt252 {
            self.user_name.read(address)
        }
    }
}
