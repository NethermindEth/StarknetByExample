#[starknet::contract]
mod StructExample {
    use starknet::{ContractAddress, get_caller_address};

    #[storage]
    struct Storage {
        userData: data
    }

    #[derive(Drop, starknet::Store)]
    struct data {
        Add: ContractAddress,
        Age: u8
    }

    #[external(v0)]
    #[generate_trait]
    impl StoreStructImpl of IStoreStructContract {
        fn store_struct(ref self: ContractState, age: u8) {
            let newStruct = data { Add: get_caller_address(), Age: age };
            self.userData.write(newStruct);
        }

        fn read_struct(self: @ContractState) -> (ContractAddress, u8) {
            let lastUser = self.userData.read();
            let add = lastUser.Add;
            let age = lastUser.Age;
            (add, age)
        }
    }
}
