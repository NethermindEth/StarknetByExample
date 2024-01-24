mod tests {
    use core::traits::TryInto;
    use core::result::ResultTrait;
    use calling_other_contracts::callee::{
        Callee, ICalleeDispatcher, ICalleeDispatcherTrait, Callee::valueContractMemberStateTrait
    };
    use calling_other_contracts::caller::{Caller, ICallerDispatcher, ICallerDispatcherTrait};
    use starknet::{deploy_syscall, ContractAddress, contract_address_const};
    use starknet::testing::{set_contract_address};


    fn deploy() -> (ICalleeDispatcher, ICallerDispatcher) {
        let calldata: Span<felt252> = ArrayTrait::new().span();
        let (address_callee, _) = deploy_syscall(
            Callee::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata, false
        )
            .unwrap();
        let (address_caller, _) = deploy_syscall(
            Caller::TEST_CLASS_HASH.try_into().unwrap(), 0, ArrayTrait::new().span(), false
        )
            .unwrap();
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

        let mut state = Callee::unsafe_new_contract_state();
        set_contract_address(callee.contract_address);

        let value_read: u128 = valueContractMemberStateTrait::read(@state.value);

        assert(value_read == init_value, 'Wrong value read');
    }
}
