#[contract]
mod WriteToAnySlot {
    use starknet::syscalls::{storage_read_syscall, storage_write_syscall};
    use array::ArrayTrait;
    use option::OptionTrait;
    use traits::{Into, TryInto};
    use poseidon::poseidon_hash_span;
    use starknet::storage_access::Felt252TryIntoStorageAddress;
    use starknet::StorageAddress;

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
