#[cfg(test)]
mod tests {
    use super::*;
    use starknet::{
        deploy_syscall,
        array::ArrayTrait,
        traits::{Into, TryInto},
    };

    // simulated dispatcher for the contract
    struct MockContractDispatcher {
        contract_address: u32,
    }

    impl MockContractDispatcher {
        fn store_array(&self, array: Array<felt252>) {
            // Simulate storing the array
        }

        fn read_array(&self) -> Array<felt252> {
            
        }
    }

    #[test]
    fn test_array_storage() {
        // Set up.
        let mut contract = MockContractDispatcher { contract_address: 0 };

        // store an array
        let mut array: Array<felt252> = ArrayTrait::new();
        array.append(1);
        array.append(2);
        contract.store_array(array);

        // reading the array
        let read_array = contract.read_array();
        assert_eq!(read_array.len(), 2, "Array length mismatch");
        assert_eq!(*read_array[0], 1, "Array element mismatch");
        assert_eq!(*read_array[1], 2, "Array element mismatch");
    }

    #[test]
    #[should_panic(expected = "('Storage - Span too large', 'ENTRYPOINT_FAILED')")]
    fn test_array_storage_too_large() {
        // Set up.
        let mut contract = MockContractDispatcher { contract_address: 0 };

        // store an array too large
        let mut array: Array<felt252> = ArrayTrait::new();
        for i in 0..256 {
            array.append(i);
        }
        contract.store_array(array);

        // Read the array (simulated logic).
        let _read_array = contract.read_array();
    }
}
