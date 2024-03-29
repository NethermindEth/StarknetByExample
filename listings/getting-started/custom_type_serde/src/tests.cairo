// The purpose of these tests is to demonstrate the capability of using custom types as inputs and outputs in contract calls.
// Therefore, we are not employing getters and setters for managing the contract's state.

mod tests {
    use custom_type_serde::contract::{
        SerdeCustomType, Person, ISerdeCustomTypeDispatcher, ISerdeCustomTypeDispatcherTrait
    };
    use starknet::ContractAddress;
    use starknet::syscalls::deploy_syscall;
    use starknet::SyscallResultTrait;

    fn deploy() -> ISerdeCustomTypeDispatcher {
        let calldata: Array<felt252> = array![];
        let (address0, _) = deploy_syscall(
            SerdeCustomType::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap_syscall();
        ISerdeCustomTypeDispatcher { contract_address: address0 }
    }

    #[test]
    #[available_gas(2000000000)]
    fn should_deploy() {
        deploy();
    }

    #[test]
    #[available_gas(2000000000)]
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
        let received_person = contract.person_input(expected_person);
    }
}
