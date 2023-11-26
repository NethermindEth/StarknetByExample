use starknet::ContractAddress;

#[starknet::interface]
trait ITupleExample<TContractState> {
    fn store_tuple(self: @TContractState, address: ContractAddress, age: u64, active: bool);
    fn read_tuple(self: @TContractState) -> (ContractAddress, u64, bool);
}

#[starknet::contract]
mod TupleExample {
    use starknet::{ContractAddress, get_caller_address};

    #[storage]
    struct Storage {
        user_data: (ContractAddress, u64, bool)
    }

    #[abi(embed_v0)]
    impl TupleExampleImpl of super::ITupleExample<ContractState> {
        fn store_tuple(ref self: ContractState, address: ContractAddress, age: u64, active: bool) {
            let user_tuple = (address, age, active);
            self.user_data.write(user_tuple);
        }

        fn read_tuple(self: @ContractState) -> (ContractAddress, u64, bool) {
            let stored_tuple = self.user_data.read();
            let (address, age, active) = stored_tuple;
            (address, age, active)
        }
    }
}
