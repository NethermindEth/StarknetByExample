use write_to_any_slot::write_any_slot::WriteToAnySlot;

#[starknet::interface]
trait IWriteToAnySlot<TContractState> {
    fn write_slot(ref self: TContractState, value: u32);
    fn read_slot(self: @TContractState) -> u32;
}

#[cfg(test)]
mod tests {
    use super::WriteToAnySlot::{get_address_from_name};
    use super::WriteToAnySlot;
    use super::{IWriteToAnySlotDispatcher, IWriteToAnySlotDispatcherTrait};
    use debug::PrintTrait;
    use starknet::deploy_syscall;
    use option::OptionTrait;
    use array::ArrayTrait;
    use traits::{Into, TryInto};
    use starknet::class_hash::Felt252TryIntoClassHash;
    use result::ResultTrait;

    #[test]
    #[available_gas(2000000000)]
    fn test_read_write() {
        // Set up.
        let mut calldata: Array<felt252> = ArrayTrait::new();
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

