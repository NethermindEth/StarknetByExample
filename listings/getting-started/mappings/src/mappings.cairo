use starknet::ContractAddress;

#[starknet::interface]
pub trait IMapContract<TContractState> {
    fn set(ref self: TContractState, key: ContractAddress, value: felt252);
    fn get(self: @TContractState, key: ContractAddress) -> felt252;
}

// ANCHOR: contract
#[starknet::contract]
pub mod MapContract {
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        // The `LegacyMap` type is only available inside the `Storage` struct.
        map: LegacyMap::<ContractAddress, felt252>,
    }

    #[abi(embed_v0)]
    impl MapContractImpl of super::IMapContract<ContractState> {
        fn set(ref self: ContractState, key: ContractAddress, value: felt252) {
            self.map.write(key, value);
        }

        fn get(self: @ContractState, key: ContractAddress) -> felt252 {
            self.map.read(key)
        }
    }
}
// ANCHOR_END: contract

#[cfg(test)]
mod test {
    use super::{MapContract, IMapContractDispatcher, IMapContractDispatcherTrait};
    use starknet::ContractAddress;
    use starknet::SyscallResultTrait;
    use starknet::syscalls::deploy_syscall;

    #[test]
    fn test_deploy_and_set_get() {
        let mut calldata: Array<felt252> = array![];
        let (address0, _) = deploy_syscall(
            MapContract::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap_syscall();

        let mut contract = IMapContractDispatcher { contract_address: address0 };

        // Write to map.
        let value: felt252 = 1;
        let contract_address: ContractAddress = address0;

        contract.set(key: contract_address, value: value);

        // Read from map.
        let read_value = contract.get(contract_address);
        assert(read_value == 1, 'wrong value read');
    }
}
