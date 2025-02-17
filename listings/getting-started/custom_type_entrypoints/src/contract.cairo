// [!region contract]
#[starknet::interface]
trait ISerdeCustomType<TContractState> {
    fn person_input(ref self: TContractState, person: Person);
    fn person_output(self: @TContractState) -> Person;
}

// Deriving the `Serde` trait allows us to use
// the `Person` type as an entrypoint parameter and as a return value
#[derive(Drop, Serde)]
struct Person {
    age: u8,
    name: felt252,
}

#[starknet::contract]
mod SerdeCustomType {
    use super::Person;
    use super::ISerdeCustomType;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl SerdeCustomType of ISerdeCustomType<ContractState> {
        fn person_input(ref self: ContractState, person: Person) {}

        fn person_output(self: @ContractState) -> Person {
            Person { age: 10, name: 'Joe' }
        }
    }
}
// [!endregion contract]

#[cfg(test)]
mod tests {
    use super::{ISerdeCustomTypeDispatcher, ISerdeCustomTypeDispatcherTrait, Person};
    use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};

    fn deploy() -> ISerdeCustomTypeDispatcher {
        let contract = declare("SerdeCustomType").unwrap().contract_class();
        let (contract_address, _) = contract.deploy(@array![]).unwrap();
        ISerdeCustomTypeDispatcher { contract_address }
    }

    #[test]
    fn should_get_person_output() {
        let contract = deploy();
        let expected_person = Person { age: 10, name: 'Joe' };

        let received_person = contract.person_output();
        let age_received = received_person.age;
        let name_received = received_person.name;

        assert_eq!(age_received, expected_person.age);
        assert_eq!(name_received, expected_person.name);
    }

    #[test]
    fn should_call_person_input() {
        let mut contract = deploy();
        let expected_person = Person { age: 10, name: 'Joe' };
        contract.person_input(expected_person);
    }
}
