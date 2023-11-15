// The purpose of these tests is to demonstrate the capability to store custom types in the contract's state.
// However, because Serde trait is not implemented for the custom type, we can't use custom types as parameters or return values.

mod tests {
    use storing_custom_types::contract::IStoringCustomTypeDispatcherTrait;
    use storing_custom_types::contract::{
        StoringCustomType, IStoringCustomTypeDispatcher, StoringCustomType::Person
    };
    use core::result::ResultTrait;
    use starknet::{deploy_syscall, ContractAddress};
    use starknet::class_hash::Felt252TryIntoClassHash;

    fn deploy() -> IStoringCustomTypeDispatcher {
        let calldata: Array<felt252> = array![];
        let (address0, _) = deploy_syscall(
            StoringCustomType::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap();
        IStoringCustomTypeDispatcher { contract_address: address0 }
    }

    #[test]
    #[available_gas(2000000000)]
    fn should_deploy() {
        let init_value = 10;
        let contract = deploy();
    }

    #[test]
    #[available_gas(2000000000)]
    fn can_call_set_person() {
        let contract = deploy();
        let received_person = contract.set_person();
    }

    #[test]
    #[available_gas(2000000000)]
    fn can_call_get_person() {
        let contract = deploy();
        contract.get_person();
    }
}
