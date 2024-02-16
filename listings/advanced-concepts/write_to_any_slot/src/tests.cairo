use write_to_any_slot::contract::WriteToAnySlot;

#[starknet::interface]
trait IWriteToAnySlot<TContractState> {
    fn write_slot(ref self: TContractState, value: u32);
    fn read_slot(self: @TContractState) -> u32;
}

mod tests {
    use super::WriteToAnySlot::get_address_from_name;
    use super::WriteToAnySlot;
    use super::{IWriteToAnySlotDispatcher, IWriteToAnySlotDispatcherTrait};
    use starknet::syscalls::deploy_syscall;

    #[test]
    #[available_gas(2000000000)]
    fn test_read_write() {
        // Set up.
        let mut calldata: Array<felt252> = array![];
        let (address0, _) = deploy_syscall(
            WriteToAnySlot::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap();
        let mut contract = IWriteToAnySlotDispatcher { contract_address: address0 };

        // Write to slot.
        let value: u32 = 42;
        contract.write_slot(value);

        // Read from slot.
        let read_value = contract.read_slot();
        assert(read_value == value, 'wrong value read');
    }
}

