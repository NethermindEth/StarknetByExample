#[starknet::interface]
pub trait IStoringCustomType<TContractState> {
    fn set_person(ref self: TContractState, person: Person);
}

// ANCHOR: contract
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
// ANCHOR_END: contract

#[cfg(test)]
mod tests {
    use super::{
        IStoringCustomType, StoringCustomType, Person,
        StoringCustomType::personContractMemberStateTrait
    };

    #[test]
    fn can_call_set_person() {
        let mut state = StoringCustomType::contract_state_for_testing();

        let person = Person { age: 10, name: 'Joe' };

        state.set_person(person);
        let read_person = state.person.read();

        assert(person.age == read_person.age, 'wrong age');
        assert(person.name == read_person.name, 'wrong name');
    }
}
