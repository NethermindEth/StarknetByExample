#[starknet::contract]
mod feltExample {
    use starknet::{ContractAddress, get_caller_address};

    #[storage]
    struct Storage {
        userName: LegacyMap::<ContractAddress, felt252>,
    }

    #[external(v0)]
    #[generate_trait]
    impl external of externlalTrait {
        fn storeName(ref self: ContractState, name: felt252) -> felt252 {
            self.userName.write(get_caller_address(), name);

            let welcomeMsg: felt252 = 'Welcome to StarknetByExample';
            welcomeMsg
        }

        fn viewName(self: @ContractState, Add: ContractAddress) -> felt252 {
            self.userName.read(Add)
        }
    }
}
