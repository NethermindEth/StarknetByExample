#[starknet::contract]
mod StoringCustomType {
    #[storage]
    struct Storage {
        person: Person
    }

    // Deriving the starknet::Store trait
    // allows us to store the `Person` struct in the contract's storage.
    #[derive(Drop, starknet::Store)]
    struct Person {
        age: u8,
        name: felt252
    }

    #[external(v0)]
    #[generate_trait]
    impl StoringCustomType of IStoringCustomType {
        fn set_person(ref self: ContractState) {
            self.person.write(Person { age: 10, name: 'Joe' });
        }
        fn get_person(self: @ContractState) {
            self.person.read();
        }
    }
}
