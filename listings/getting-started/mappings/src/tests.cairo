use starknet::ContractAddress;
#[starknet::interface]
trait IMapContract<TContractState> {
    fn set(ref self: TContractState, key: ContractAddress, value: felt252);

    fn get(self: @TContractState, key: ContractAddress) -> felt252;
}

mod tests {
    use super::super::mappings::MapContract;
    use super::{IMapContract, IMapContractDispatcher, IMapContractDispatcherTrait};
    use starknet::{deploy_syscall, ContractAddress};
    use starknet::class_hash::Felt252TryIntoClassHash;

    #[test]
    #[available_gas(2000000000)]
    fn test_set_get() {
        // Set up.
        let mut calldata: Array<felt252> = ArrayTrait::new();
        let (address0, _) = deploy_syscall(
            MapContract::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap();
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

