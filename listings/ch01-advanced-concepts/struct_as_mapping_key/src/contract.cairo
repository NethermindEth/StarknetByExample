#[starknet::contract]
mod PetRegistry {
    use poseidon::poseidon_hash_span;
    use serde::Serde;
    use array::ArrayTrait;

    #[storage]
    struct Storage {
        registration_time: LegacyMap::<felt252, u64>, 
    }

    #[derive(Copy, Drop, Serde)]
    struct Pet {
        name: felt252,
        age: u8,
        owner: felt252,
    }

    #[external(v0)]
    #[generate_trait]
    impl PetRegistry of PetRegistryTrait {
        fn register_pet(ref self: ContractState, key: Pet, timestamp: u64) {
            let mut serialized: Array<felt252> = ArrayTrait::new();
            Serde::<Pet>::serialize(@key, ref serialized);
            let hashed_key = poseidon_hash_span(serialized.span());
            self.registration_time.write(hashed_key, timestamp);
        }

        fn get_registration_date(self: @ContractState, key: Pet) -> u64 {
            let mut serialized: Array<felt252> = ArrayTrait::new();
            Serde::<Pet>::serialize(@key, ref serialized);
            let hashed_key = poseidon_hash_span(serialized.span());
            self.registration_time.read(hashed_key)
        }
    }
}
