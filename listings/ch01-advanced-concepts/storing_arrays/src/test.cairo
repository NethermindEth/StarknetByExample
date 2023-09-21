#[cfg(test)]
mod tests {
    use super::*;
    use starknet::{
        deploy_syscall,
        array::ArrayTrait,
        traits::{Into, TryInto},
    };

    #[test]
    fn test_array_storage() {
        // Deploy the StoreArrayContract to get a contract address.
        let mut calldata: Array<felt252> = ArrayTrait::new();
        let (contract_address, _) = deploy_syscall(
            StoreArrayContract::TEST_CLASS_HASH.try_into().unwrap(),
            0,
            calldata.span(),
            false,
        )
        .unwrap();

        // Create a dispatcher for the contract.
        let mut contract_dispatcher = IStoreArrayContractDispatcher {
            contract_address: contract_address,
        };

        // Store an array.
        let mut array: Array<felt252> = ArrayTrait::new();
        array.append(1);
        array.append(2);
        contract_dispatcher.store_array(array);

        // Read the array.
        let read_array = contract_dispatcher.read_array();
        assert_eq!(read_array.len(), 2, "Array length mismatch");
        assert_eq!(*read_array[0], 1, "Array element mismatch");
        assert_eq!(*read_array[1], 2, "Array element mismatch");
    }

    #[test]
    #[should_panic(expected = "('Storage - Span too large', 'ENTRYPOINT_FAILED')")]
    fn test_array_storage_too_large() {
        // Deploy the StoreArrayContract to get a contract address.
        let mut calldata: Array<felt252> = ArrayTrait::new();
        let (contract_address, _) = deploy_syscall(
            StoreArrayContract::TEST_CLASS_HASH.try_into().unwrap(),
            0,
            calldata.span(),
            false,
        )
        .unwrap();

        // Create a dispatcher for the contract.
        let mut contract_dispatcher = IStoreArrayContractDispatcher {
            contract_address: contract_address,
        };

        // Store an array that's too large.
        let mut array: Array<felt252> = ArrayTrait::new();
        for i in 0..256 {
            array.append(i);
        }
        contract_dispatcher.store_array(array);

        // Read the array (simulated logic).
        let _read_array = contract_dispatcher.read_array();
    }
}
