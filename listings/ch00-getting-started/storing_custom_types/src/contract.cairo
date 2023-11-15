#[starknet::interface]
trait IStoringCustomType<TContractState> {
    fn set_person(ref self: TContractState);
    fn get_person(self: @TContractState);
}

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

    #[abi(embed_v0)]
    impl StoringCustomType of super::IStoringCustomType<ContractState> {
        fn set_person(ref self: ContractState) {
            self.person.write(Person { age: 10, name: 'Joe' });
        }

        fn get_person(self: @ContractState) {
            self.person.read();
        }
    }
}
