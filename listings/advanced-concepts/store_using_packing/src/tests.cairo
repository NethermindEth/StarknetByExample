mod tests {
    use store_using_packing::contract::{TimeContract, Time, ITimeDispatcher, ITimeDispatcherTrait};

    use starknet::syscalls::deploy_syscall;

    #[test]
    fn test_packing() {
        // Set up.
        let mut calldata: Array<felt252> = array![];
        let (address0, _) = deploy_syscall(
            TimeContract::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false,
        )
            .unwrap();
        let mut contract = ITimeDispatcher { contract_address: address0 };

        // Store a Time struct.
        let time = Time { hour: 1, minute: 2 };
        contract.set(time);

        // Read the stored struct.
        let read_time: Time = contract.get();
        assert_eq!(read_time.hour, time.hour);
        assert_eq!(read_time.minute, time.minute);
    }
}
