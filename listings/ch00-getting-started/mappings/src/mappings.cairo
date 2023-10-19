#[starknet::contract]
mod MapContract {
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        // The `LegacyMap` type is only available inside the `Storage` struct.
        map: LegacyMap::<ContractAddress, felt252>,
    }

    #[abi(per_item)]
    #[generate_trait]
    impl MapContractImpl of IMapContract {
        #[external(v0)]
        fn set(ref self: ContractState, key: ContractAddress, value: felt252) {
            self.map.write(key, value);
        }

        #[external(v0)]
        fn get(self: @ContractState, key: ContractAddress) -> felt252 {
            self.map.read(key)
        }
    }
}
