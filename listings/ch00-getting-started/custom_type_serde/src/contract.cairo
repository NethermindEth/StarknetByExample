#[starknet::interface]
trait ISerdeCustomType<TContractState> {
    fn person_input(ref self: TContractState, person: SerdeCustomType::Person);
    fn person_output(ref self: TContractState) -> SerdeCustomType::Person;
}

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

    #[abi(per_item)]
    #[generate_trait]
    impl SerdeCustomType of ISerdeCustomType {
        #[external(v0)]
        fn person_input(ref self: ContractState, person: Person) {}

        #[external(v0)]
        fn person_output(self: @ContractState) -> Person {
            Person { age: 10, name: 'Joe' }
        }
    }
}
