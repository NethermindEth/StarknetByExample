#[starknet::contract]
mod PetRegistry {
    use hash::{HashStateTrait, Hash};

    #[storage]
    struct Storage {
        registration_time: LegacyMap::<Pet, u64>,
    }

    #[derive(Copy, Drop, Serde, Hash)]
    struct Pet {
        name: felt252,
        age: u8,
        owner: felt252,
    }

    #[external(v0)]
    #[generate_trait]
    impl PetRegistry of PetRegistryTrait {
        fn register_pet(ref self: ContractState, key: Pet, timestamp: u64) {
            self.registration_time.write(key, timestamp);
        }

        fn get_registration_date(self: @ContractState, key: Pet) -> u64 {
            self.registration_time.read(key)
        }
    }
}
