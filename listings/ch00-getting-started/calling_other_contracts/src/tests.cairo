mod tests {
    use core::traits::TryInto;
use core::result::ResultTrait;
    use calling_other_contracts::callee::{Callee, ICalleeDispatcher, ICalleeDispatcherTrait};
    use calling_other_contracts::caller::{Caller, ICallerDispatcher, ICallerDispatcherTrait};
    use starknet::{deploy_syscall, ContractAddress};


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
        let (callee, caller) = deploy();

        caller.set_value_from_address(callee.contract_address, 1);
        let res = callee.get_value();
        assert(res == 1, 'Value should be 1');
    }
}
