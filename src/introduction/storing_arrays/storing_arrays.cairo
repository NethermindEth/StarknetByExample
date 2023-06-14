use traits::{Into, TryInto};
use result::ResultTrait;
use option::OptionTrait;
use array::ArrayTrait;
use array::SpanTrait;
use starknet::{
    StorageBaseAddress, StorageAccess, SyscallResult, storage_read_syscall, storage_write_syscall,
    storage_address_from_base_and_offset
};

impl StorageAccessFelt252Array of StorageAccess<Span<felt252>> {
    fn read(address_domain: u32, base: StorageBaseAddress) -> SyscallResult<Span<felt252>> {
        let mut arr: Array<felt252> = ArrayTrait::new();

        // Read the stored array's length.
        let len: u8 = StorageAccess::<u8>::read(address_domain, base)
            .expect('Failed to read array length');

        assert(len <= 255, 'Storage Span too large');

        // Read the array elements.
        let mut i: u8 = 1;
        loop {
            if i > len {
                break ();
            }

            match storage_read_syscall(
                :address_domain, address: storage_address_from_base_and_offset(base, i)
            ) {
                Result::Ok(value) => {
                    arr.append(value);
                },
                Result::Err(_) => {
                    panic_with_felt252('Storage - Span read error')
                }
            }
            i += 1;
        };

        Result::Ok(arr.span())
    }

    fn write(
        address_domain: u32, base: StorageBaseAddress, mut value: Span<felt252>
    ) -> SyscallResult<()> {
        // Store the length of the array.
        let len: u8 = value.len().try_into().expect('Storage - Span too large');
        StorageAccess::<felt252>::write(address_domain, base, len.into());

        // Store the array elements
        let mut i = 1;
        loop {
            match value.pop_front() {
                Option::Some(element) => {
                    storage_write_syscall(
                        :address_domain,
                        address: storage_address_from_base_and_offset(base, i),
                        value: *element
                    );
                },
                Option::None(_) => {
                    break ();
                }
            }
            i += 1;
        };
        Result::Ok(())
    }
}

// TODO remove this once corelib updated
use serde::Serde;
impl SpanSerde<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>> of Serde<Span<T>> {
    fn serialize(self: @Span<T>, ref output: Array<felt252>) {
        (*self).len().serialize(ref output);
        serialize_array_helper(*self, ref output)
    }

    fn deserialize(ref serialized: Span<felt252>) -> Option<Span<T>> {
        let length = *serialized.pop_front()?;
        let mut arr = ArrayTrait::new();
        Option::Some(deserialize_array_helper(ref serialized, arr, length)?.span())
    }
}

fn serialize_array_helper<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(
    mut input: Span<T>, ref output: Array<felt252>
) {
    match input.pop_front() {
        Option::Some(value) => {
            value.serialize(ref output);
            serialize_array_helper(input, ref output);
        },
        Option::None(_) => {},
    }
}

fn deserialize_array_helper<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(
    ref serialized: Span<felt252>, mut curr_output: Array<T>, remaining: felt252
) -> Option<Array<T>> {
    if remaining == 0 {
        return Option::Some(curr_output);
    }
    curr_output.append(TSerde::deserialize(ref serialized)?);
    deserialize_array_helper(ref serialized, curr_output, remaining - 1)
}
//

#[abi]
trait IStoreArrayContract {
    fn store_array(array: Array<felt252>);
    fn read_array() -> Span<felt252>;
}

#[contract]
mod StoreArrayContract {
    use array::ArrayTrait;
    use super::StorageAccessFelt252Array;
    use super::SpanSerde;
    struct Storage {
        _array: Span<felt252>
    }

    #[external]
    fn store_array(array: Array<felt252>) {
        _array::write(array.span());
    }

    #[view]
    fn read_array() -> Span<felt252> {
        _array::read()
    }
}

#[cfg(test)]
mod tests {
    use super::StoreArrayContract;
    use super::{IStoreArrayContractDispatcher, IStoreArrayContractDispatcherTrait};
    use debug::PrintTrait;
    use starknet::deploy_syscall;
    use option::OptionTrait;
    use array::ArrayTrait;
    use traits::{Into, TryInto};
    use starknet::class_hash::Felt252TryIntoClassHash;
    use result::ResultTrait;
    use array::SpanTrait;

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
