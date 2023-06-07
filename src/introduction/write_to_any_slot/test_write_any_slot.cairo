#[abi]
trait IWriteToAnySlot {
    fn write_slot(value: u32);
    fn read_slot() -> u32;
}

#[contract]
mod WriteToAnySlot {
    use starknet::syscalls::{storage_read_syscall, storage_write_syscall};
    use array::ArrayTrait;
    use option::OptionTrait;
    use traits::{Into, TryInto};
    use poseidon::poseidon_hash_span;
    use starknet::storage_access::Felt252TryIntoStorageAddress;

    struct Storage {}

    const SLOT_NAME: felt252 = 'test_slot';

    #[external]
    fn write_slot(value: u32) {
        storage_write_syscall(0, get_address_from_name(SLOT_NAME), value.into());
    }

    #[view]
    fn read_slot() -> u32 {
        storage_read_syscall(0, get_address_from_name(SLOT_NAME))
            .unwrap_syscall()
            .try_into()
            .unwrap()
    }

    fn get_address_from_name(variable_name: felt252) -> StorageAddress {
        let mut data: Array<felt252> = ArrayTrait::new();
        data.append(variable_name);
        let hashed_name: felt252 = poseidon_hash_span(data.span());
        let MASK_250: u256 = 0x03ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        // By taking the 250 least significant bits of the hash output, we get a valid 250bits storage address.
        let result: felt252 = (hashed_name.into() & MASK_250).try_into().unwrap();
        let result: StorageAddress = result.try_into().unwrap();
        result
    }
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

