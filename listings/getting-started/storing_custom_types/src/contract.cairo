#[starknet::interface]
pub trait IStoringCustomType<TContractState> {
    fn set_person(ref self: TContractState, person: Person);
}

// Deriving the starknet::Store trait
// allows us to store the `Person` struct in the contract's storage.
#[derive(Drop, Serde, Copy, starknet::Store)]
pub struct Person {
    pub age: u8,
    pub name: felt252
}

#[starknet::contract]
pub mod StoringCustomType {
    use super::Person;

    #[storage]
    pub struct Storage {
        pub person: Person
    }

    #[abi(embed_v0)]
    impl StoringCustomType of super::IStoringCustomType<ContractState> {
        fn set_person(ref self: ContractState, person: Person) {
            self.person.write(person);
        }
    }
}
