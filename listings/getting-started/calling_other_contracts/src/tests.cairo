mod tests {
    use calling_other_contracts::callee::{
        Callee, ICalleeDispatcher, ICalleeDispatcherTrait, Callee::valueContractMemberStateTrait
    };
    use calling_other_contracts::caller::{Caller, ICallerDispatcher, ICallerDispatcherTrait};
    use starknet::{ContractAddress, contract_address_const};
    use starknet::testing::{set_contract_address};
    use starknet::syscalls::deploy_syscall;
    use starknet::SyscallResultTrait;


    fn deploy() -> (ICalleeDispatcher, ICallerDispatcher) {
        let calldata: Span<felt252> = array![].span();
        let (address_callee, _) = deploy_syscall(
            Callee::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata, false
        )
            .unwrap_syscall();
        let (address_caller, _) = deploy_syscall(
            Caller::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();
        (
            ICalleeDispatcher { contract_address: address_callee },
            ICallerDispatcher { contract_address: address_caller }
        )
    }

    #[test]
    #[available_gas(2000000000)]
    fn test_caller() {
        let init_value: u128 = 42;

        let (callee, caller) = deploy();
        caller.set_value_from_address(callee.contract_address, init_value);

        let state = Callee::contract_state_for_testing();
        set_contract_address(callee.contract_address);

        let value_read: u128 = state.value.read();

        assert(value_read == init_value, 'Wrong value read');
    }
}
