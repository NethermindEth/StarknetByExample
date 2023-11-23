mod tests {
    use core::traits::Into;
    use core::result::ResultTrait;
    use constructor::constructor::ExampleConstructor;
    use constructor::constructor::ExampleConstructor::{names};
    use debug::PrintTrait;
    use starknet::{deploy_syscall, ContractAddress, contract_address_const};
    use starknet::testing::{set_contract_address};
    use starknet::class_hash::Felt252TryIntoClassHash;

    #[test]
    #[available_gas(2000000000)]
    fn should_deploy_and_init() {
        let name: felt252 = 'bob';
        let address: ContractAddress = contract_address_const::<'caller'>();

        let mut calldata: Array::<felt252> = array![];
        calldata.append(name);
        calldata.append(address.into());

        let (address_0, _) = deploy_syscall(
            ExampleConstructor::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap();

        let mut state = ExampleConstructor::unsafe_new_contract_state();
        set_contract_address(address_0);

        let name: felt252 = names::InternalContractMemberStateTrait::read(@state.names, address);

        assert(name == 'bob', 'name should be bob');
    }
}

