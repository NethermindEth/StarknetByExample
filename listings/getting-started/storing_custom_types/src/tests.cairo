// The purpose of these tests is to demonstrate the capability to store custom types in the contract's state.

mod tests {
    use storing_custom_types::contract::{
        IStoringCustomType, StoringCustomType, Person,
        StoringCustomType::personContractMemberStateTrait
    };

    use starknet::{ContractAddress, contract_address_const, testing::{set_contract_address}};

    fn setup() -> StoringCustomType::ContractState {
        let mut state = StoringCustomType::contract_state_for_testing();
        let contract_address = contract_address_const::<0x1>();
        set_contract_address(contract_address);
        state
    }

    #[test]
    #[available_gas(2000000000)]
    fn can_call_set_person() {
        let mut state = setup();
        let person = Person { age: 10, name: 'Joe' };

        state.set_person(person);
        let read_person = state.person.read();

        assert(person.age == read_person.age, 'wrong age');
        assert(person.name == read_person.name, 'wrong name');
    }
}
