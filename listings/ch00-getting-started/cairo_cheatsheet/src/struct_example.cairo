use starknet::ContractAddress;

#[starknet::interface]
trait IStructExample<TContractState> {
    fn store_struct(ref self: TContractState, age: u8);
    fn read_struct(self: @TContractState) -> (ContractAddress, u8);
}

#[starknet::contract]
mod StructExample {
    use starknet::{ContractAddress, get_caller_address};

    #[storage]
    struct Storage {
        user_data: Data
    }

    #[derive(Drop, starknet::Store)]
    struct Data {
        address: ContractAddress,
        age: u8
    }

    #[abi(embed_v0)]
    impl StoreStructImpl of super::IStructExample<ContractState> {
        fn store_struct(ref self: ContractState, age: u8) {
            let new_struct = Data { address: get_caller_address(), age: age };
            self.user_data.write(new_struct);
        }

        fn read_struct(self: @ContractState) -> (ContractAddress, u8) {
            let last_user = self.user_data.read();
            let add = last_user.address;
            let age = last_user.age;
            (add, age)
        }
    }
}
