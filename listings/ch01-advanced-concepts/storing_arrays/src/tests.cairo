mod tests {
    use storing_arrays::contract::{
        StoreArrayContract, IStoreArrayContractDispatcher, IStoreArrayContractDispatcherTrait
    };
    use starknet::deploy_syscall;
    use starknet::class_hash::Felt252TryIntoClassHash;

    #[test]
    #[available_gas(20000000)]
    fn test_array_storage() {
        // Set up.
        let mut calldata: Array<felt252> = ArrayTrait::new();
        let (address0, _) = deploy_syscall(
            StoreArrayContract::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap();
        let mut contract = IStoreArrayContractDispatcher { contract_address: address0 };

        // Store an array.
        let mut array: Array<felt252> = ArrayTrait::new();
        array.append(1);
        array.append(2);
        contract.store_array(array);

        // Read the array.
        let read_array = contract.read_array();
        assert(read_array.len() == 2, 'Array length mismatch');
        assert(*read_array[0] == 1, 'Array element mismatch');
        assert(*read_array[1] == 2, 'Array element mismatch');
    }

    #[test]
    #[available_gas(20000000000)]
    #[should_panic(expected: ('Storage - Span too large', 'ENTRYPOINT_FAILED'))]
    fn test_array_storage_too_large() {
        // Set up.
        let mut calldata: Array<felt252> = ArrayTrait::new();
        let (address0, _) = deploy_syscall(
            StoreArrayContract::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap();
        let mut contract = IStoreArrayContractDispatcher { contract_address: address0 };

        // Store an array.
        let mut array: Array<felt252> = ArrayTrait::new();
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
        assert(read_array.len() == 2, 'Array too large');
        assert(*read_array[0] == 1, 'Array element mismatch');
        assert(*read_array[1] == 2, 'Array element mismatch');
    }
}
