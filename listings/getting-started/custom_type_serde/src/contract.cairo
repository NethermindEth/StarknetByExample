// Deriving the `Serde` trait allows us to use
// the Person type as an entrypoint parameter and return value
#[derive(Drop, Serde)]
pub struct Person {
    pub age: u8,
    pub name: felt252
}

#[starknet::interface]
pub trait ISerdeCustomType<TContractState> {
    fn person_input(ref self: TContractState, person: Person);
    fn person_output(self: @TContractState) -> Person;
}

#[starknet::contract]
pub mod SerdeCustomType {
    use super::Person;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl SerdeCustomType of super::ISerdeCustomType<ContractState> {
        fn person_input(ref self: ContractState, person: Person) {}

        fn person_output(self: @ContractState) -> Person {
            Person { age: 10, name: 'Joe' }
        }
    }
}
