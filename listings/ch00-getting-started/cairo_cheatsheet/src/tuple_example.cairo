#[starknet::contract]
mod TupleExample {
    use starknet::{ContractAddress, get_caller_address};

    #[storage]
    struct Storage {
        user_data: (ContractAddress, u64, bool)
    }

    #[external(v0)]
    #[generate_trait]
    impl TupleExampleImpl of ITupleExampleImpl {
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
