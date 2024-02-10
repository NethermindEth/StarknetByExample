mod tests {
    use core::traits::Into;
    use core::result::ResultTrait;
    use starknet::testing::set_contract_address;
    use starknet::{ContractAddress, contract_address_const};
    use starknet::syscalls::deploy_syscall;

    use constructor::constructor::ExampleConstructor;
    // use constructor::constructor::ExampleConstructor::namesContractMemberStateTrait;
    use constructor::constructor::ExampleConstructor::__member_module_names::InternalContractMemberStateTrait;

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

        let state = ExampleConstructor::unsafe_new_contract_state();
        set_contract_address(address_0);

        let name = state.names.read(address);

        assert(name == 'bob', 'name should be bob');
    }
}

