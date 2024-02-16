mod tests { // TODO
}

mod explicit_interface_contract_tests {
    use interfaces_traits::explicit::{
        IExplicitInterfaceContract, ExplicitInterfaceContract, IExplicitInterfaceContractDispatcher,
        IExplicitInterfaceContractDispatcherTrait
    };
    use starknet::ContractAddress;
    use starknet::SyscallResultTrait;
    use starknet::syscalls::deploy_syscall;

    #[test]
    #[available_gas(2000000000)]
    fn test_interface() {
        let (contract_address, _) = deploy_syscall(
            ExplicitInterfaceContract::TEST_CLASS_HASH.try_into().unwrap(),
            0,
            array![].span(),
            false
        )
            .unwrap_syscall();

        let mut contract = IExplicitInterfaceContractDispatcher { contract_address };

        let value: u32 = 20;
        contract.set_value(value);

        let read_value = contract.get_value();

        assert(read_value == value, 'wrong value');
    }
}

mod implicit_internal_contract_tests {
    use interfaces_traits::implicit_internal::{
        IImplicitInternalContract, ImplicitInternalContract, IImplicitInternalContractDispatcher,
        IImplicitInternalContractDispatcherTrait
    };
    use starknet::ContractAddress;
    use starknet::SyscallResultTrait;
    use starknet::syscalls::deploy_syscall;

    #[test]
    #[available_gas(2000000000)]
    fn test_interface() {
        // Set up.
        let (contract_address, _) = deploy_syscall(
            ImplicitInternalContract::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();

        let mut contract = IImplicitInternalContractDispatcher { contract_address };

        let initial_value: u32 = 0;
        assert(contract.get_value() == initial_value, 'wrong value');

        let add_value: u32 = 10;
        contract.add(add_value);

        assert(contract.get_value() == initial_value + add_value, 'wrong value after add');
    }
}
