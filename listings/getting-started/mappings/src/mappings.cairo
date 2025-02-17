use starknet::ContractAddress;

#[starknet::interface]
trait IMapContract<TContractState> {
    fn set(ref self: TContractState, key: ContractAddress, value: felt252);
    fn get(self: @TContractState, key: ContractAddress) -> felt252;
}

// [!region contract]
#[starknet::contract]
mod MapContract {
    use super::IMapContract;
    use starknet::ContractAddress;
    use starknet::storage::{Map, StorageMapReadAccess, StorageMapWriteAccess};

    #[storage]
    struct Storage {
        map: Map<ContractAddress, felt252>,
    }

    #[abi(embed_v0)]
    impl MapContractImpl of IMapContract<ContractState> {
        fn set(ref self: ContractState, key: ContractAddress, value: felt252) {
            self.map.write(key, value);
        }

        fn get(self: @ContractState, key: ContractAddress) -> felt252 {
            self.map.read(key)
        }
    }
}
// [!endregion contract]

#[cfg(test)]
mod test {
    use super::{IMapContractDispatcher, IMapContractDispatcherTrait};
    use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};
    use starknet::contract_address_const;

    fn deploy() -> IMapContractDispatcher {
        let contract = declare("MapContract").unwrap().contract_class();
        let (contract_address, _) = contract.deploy(@array![]).unwrap();
        IMapContractDispatcher { contract_address }
    }

    #[test]
    fn test_deploy_and_set_get() {
        let contract = deploy();

        // Write to map.
        let key = contract_address_const::<'key'>();
        let value: felt252 = 1;
        contract.set(key, value);

        // Read from map.
        let read_value = contract.get(key);
        assert_eq!(read_value, value);
    }
}
