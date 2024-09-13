mod tests {
    use starknet::SyscallResultTrait;
    use storing_arrays::contract::{
        StoreArrayContract, IStoreArrayContractDispatcher, IStoreArrayContractDispatcherTrait
    };
    use starknet::syscalls::deploy_syscall;

    #[test]
    fn test_array_storage() {
        // Set up.
        let mut calldata: Array<felt252> = array![];
        let (address0, _) = deploy_syscall(
            StoreArrayContract::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap_syscall();
        let mut contract = IStoreArrayContractDispatcher { contract_address: address0 };

        // Store an array.
        let mut array: Array<felt252> = array![];
        array.append(1);
        array.append(2);
        contract.store_array(array);

        // Read the array.
        let read_array = contract.read_array();
        assert_eq!(read_array.len(), 2);
        assert_eq!(*read_array[0], 1);
        assert_eq!(*read_array[1], 2);
    }

    #[test]
    #[should_panic(expected: ('Storage - Span too large', 'ENTRYPOINT_FAILED'))]
    fn test_array_storage_too_large() {
        // Set up.
        let mut calldata: Array<felt252> = array![];
        let (address0, _) = deploy_syscall(
            StoreArrayContract::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap();
        let mut contract = IStoreArrayContractDispatcher { contract_address: address0 };

        // Store an array.
        let mut array: Array<felt252> = array![];
        let mut i = 0;
        loop {
            if i == 256 {
                break ();
            }
            array.append(i);
            i += 1;
        };
        contract.store_array(array);

        // Read the array.
        let read_array = contract.read_array();
        assert_eq!(read_array.len(), 2);
        assert_eq!(*read_array[0], 1);
        assert_eq!(*read_array[1], 2);
    }
}
