#[starknet::interface]
trait IStoringCustomType<TContractState> {
    fn set_person(ref self: TContractState, person: Person);
    fn get_person(self: @TContractState) -> Person;
}

// Deriving the starknet::Store trait
// allows us to store the `Person` struct in the contract's storage.
#[derive(Drop, Serde, Copy, starknet::Store)]
struct Person {
    age: u8,
    name: felt252
}

#[starknet::contract]
mod StoringCustomType {
    use super::Person;

    #[storage]
    struct Storage {
        person: Person
    }

    #[abi(embed_v0)]
    impl StoringCustomType of super::IStoringCustomType<ContractState> {
        fn set_person(ref self: ContractState, person: Person) {
            self.person.write(person);
        }

        fn get_person(self: @ContractState) -> Person {
            self.person.read()
        }
    }
}
