#[starknet::contract]
mod SerdeCustomType {
    #[storage]
    struct Storage {}

    // Deriving the `Serde` trait allows us to use
    // the Person type as an entrypoint parameter and return value
    #[derive(Drop, Serde)]
    struct Person {
        age: u8,
        name: felt252
    }
    #[external(v0)]
    #[generate_trait]
    impl SerdeCustomType of ISerdeCustomType {
        fn person_input(ref self: ContractState, person: Person) {}
        fn person_output(self: @ContractState) -> Person {
            Person { age: 10, name: 'Joe' }
        }
    }
}
