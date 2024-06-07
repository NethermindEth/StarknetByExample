use core::result::ResultTrait;
use core::array::ArrayTrait;
use starknet::{ContractAddress, Store, SyscallResult};
use starknet::storage_access::{StorageBaseAddress, storage_address_from_base_and_offset};
use starknet::syscalls::{storage_read_syscall, storage_write_syscall};

impl StoreContractAddressArray of Store<Array<ContractAddress>> {
    fn read(
        address_domain: u32, base: StorageBaseAddress
    ) -> SyscallResult<Array<ContractAddress>> {
        StoreContractAddressArray::read_at_offset(address_domain, base, 0)
    }

    fn write(
        address_domain: u32, base: StorageBaseAddress, value: Array<ContractAddress>
    ) -> SyscallResult<()> {
        StoreContractAddressArray::write_at_offset(address_domain, base, 0, value)
    }

    fn read_at_offset(
        address_domain: u32, base: StorageBaseAddress, mut offset: u8
    ) -> SyscallResult<Array<ContractAddress>> {
        let mut arr: Array<ContractAddress> = array![];

        let len: u8 = Store::<u8>::read_at_offset(address_domain, base, offset)
            .expect('Storage Span too large');
        offset += 1;

        let exit = len + offset;
        loop {
            if offset >= exit {
                break;
            }

            let value = Store::<ContractAddress>::read_at_offset(address_domain, base, offset)
                .unwrap();
            arr.append(value);
            offset += Store::<ContractAddress>::size();
        };

        Result::Ok(arr)
    }

    fn write_at_offset(
        address_domain: u32,
        base: StorageBaseAddress,
        mut offset: u8,
        mut value: Array<ContractAddress>
    ) -> SyscallResult<()> {
        let len: u8 = value.len().try_into().expect('Storage - Span too large');
        Store::<u8>::write_at_offset(address_domain, base, offset, len).unwrap();
        offset += 1;

        while let Option::Some(element) = value.pop_front() {
            Store::<ContractAddress>::write_at_offset(address_domain, base, offset, element)
                .unwrap();
            offset += Store::<ContractAddress>::size();
        };

        Result::Ok(())
    }

    fn size() -> u8 {
        255 * Store::<ContractAddress>::size()
    }
}
