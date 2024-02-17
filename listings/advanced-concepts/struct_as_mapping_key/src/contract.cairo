#[derive(Copy, Drop, Serde, Hash)]
pub struct Pet {
    pub name: felt252,
    pub age: u8,
    pub owner: felt252,
}

#[starknet::interface]
pub trait IPetRegistry<TContractState> {
    fn register_pet(ref self: TContractState, key: Pet, timestamp: u64);
    fn get_registration_date(self: @TContractState, key: Pet) -> u64;
}

#[starknet::contract]
pub mod PetRegistry {
    use core::hash::{HashStateTrait, Hash};
    use super::Pet;

    #[storage]
    struct Storage {
        registration_time: LegacyMap::<Pet, u64>,
    }

    #[abi(embed_v0)]
    impl PetRegistry of super::IPetRegistry<ContractState> {
        fn register_pet(ref self: ContractState, key: Pet, timestamp: u64) {
            self.registration_time.write(key, timestamp);
        }

        fn get_registration_date(self: @ContractState, key: Pet) -> u64 {
            self.registration_time.read(key)
        }
    }
}
