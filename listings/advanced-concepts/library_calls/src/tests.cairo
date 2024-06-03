mod tests {
    use starknet::syscalls::{deploy_syscall};
    use starknet::SyscallResultTrait;
    use library_calls::library_call::{
        MathUtils, MathUtilsLibraryCall, IMathUtilsDispatcher, IMathUtilsDispatcherTrait
    };

    #[test]
    #[available_gas(20000000)]
    fn test_library_dispatcher() {
        let math_utils_class_hash: starknet::ClassHash = MathUtils::TEST_CLASS_HASH
            .try_into()
            .unwrap();
        let mut calldata: Array<felt252> = array![];
        let (address, _) = deploy_syscall(
            MathUtilsLibraryCall::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap_syscall();
        let mut contract = IMathUtilsDispatcher { contract_address: address };

        contract.set_class_hash(math_utils_class_hash);
        let mut result = contract.add(30, 5);
        assert_eq!(result, 35, "Wrong result");
    }
}
