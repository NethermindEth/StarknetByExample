use starknet::ContractAddress;

#[starknet::interface]
pub trait ISimpleContract<TContractState> {
    fn get_value(self: @TContractState) -> u32;
    fn get_owner(self: @TContractState) -> ContractAddress;
    fn set_value(ref self: TContractState, value: u32);
}

#[starknet::contract]
pub mod SimpleContract {
    use starknet::{get_caller_address, ContractAddress};

    #[storage]
    struct Storage {
        value: u32,
        owner: ContractAddress
    }

    #[constructor]
    fn constructor(ref self: ContractState, initial_value: u32) {
        self.value.write(initial_value);
        self.owner.write(get_caller_address());
    }

    #[abi(embed_v0)]
    impl SimpleContract of super::ISimpleContract<ContractState> {
        fn get_value(self: @ContractState) -> u32 {
            self.value.read()
        }

        fn get_owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }

        fn set_value(ref self: ContractState, value: u32) {
            assert(self.owner.read() == get_caller_address(), 'Not owner');
            self.value.write(value);
        }
    }
}
