#[starknet::contract]
mod MapContract {
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        // The `LegacyMap` type is only available inside the `Storage` struct.
        map: LegacyMap::<ContractAddress, felt252>,
    }

    #[generate_trait]
    #[external(v0)]
    impl MapContractImpl of IMapContract {
        fn set(ref self: ContractState, key: ContractAddress, value: felt252) {
            self.map.write(key, value);
        }

        fn get(self: @ContractState, key: ContractAddress) -> felt252 {
            self.map.read(key)
        }
    }
}
