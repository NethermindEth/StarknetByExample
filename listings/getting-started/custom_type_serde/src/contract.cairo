#[starknet::interface]
pub trait ISerdeCustomType<TContractState> {
    fn person_input(ref self: TContractState, person: Person);
    fn person_output(self: @TContractState) -> Person;
}

// [!region contract]
// Deriving the `Serde` trait allows us to use
// the `Person` type as an entrypoint parameter and as a return value
#[derive(Drop, Serde)]
pub struct Person {
    pub age: u8,
    pub name: felt252,
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
// [!endregion contract]

#[cfg(test)]
mod tests {
    use super::{
        SerdeCustomType, Person, ISerdeCustomTypeDispatcher, ISerdeCustomTypeDispatcherTrait,
    };
    use starknet::syscalls::deploy_syscall;

    fn deploy() -> ISerdeCustomTypeDispatcher {
        let (contract_address, _) = deploy_syscall(
            SerdeCustomType::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false,
        )
            .unwrap();
        ISerdeCustomTypeDispatcher { contract_address }
    }

    #[test]
    fn should_deploy() {
        deploy();
    }

    #[test]
    fn should_get_person_output() {
        let contract = deploy();
        let expected_person = Person { age: 10, name: 'Joe' };
        let received_person = contract.person_output();
        let age_received = received_person.age;
        let name_received = received_person.name;

        assert(age_received == expected_person.age, 'Wrong age value');
        assert(name_received == expected_person.name, 'Wrong name value');
    }

    #[test]
    #[available_gas(2000000000)]
    fn should_call_person_input() {
        let contract = deploy();
        let expected_person = Person { age: 10, name: 'Joe' };
        contract.person_input(expected_person);
    }
}
