// [!region contract]
#[starknet::contract]
pub mod ExampleConstructor {
    use starknet::ContractAddress;
    use starknet::storage::{Map, StorageMapWriteAccess};

    #[storage]
    struct Storage {
        pub names: Map::<ContractAddress, felt252>,
    }

    // The constructor is decorated with a `#[constructor]` attribute.
    // It is not inside an `impl` block.
    #[constructor]
    fn constructor(ref self: ContractState, name: felt252, address: ContractAddress) {
        self.names.write(address, name);
    }
}
// [!endregion contract]

// [!region tests]
#[cfg(test)]
mod tests {
    use super::ExampleConstructor;
    use starknet::{ContractAddress, syscalls::deploy_syscall};
    use starknet::{contract_address_const, testing::{set_contract_address}};
    use starknet::storage::StorageMapReadAccess;

    #[test]
    fn should_deploy_with_constructor_init_value() {
        let name: felt252 = 'bob';
        let address: ContractAddress = contract_address_const::<'caller'>();

        let (contract_address, _) = deploy_syscall(
            ExampleConstructor::TEST_CLASS_HASH.try_into().unwrap(),
            0,
            array![name, address.into()].span(),
            false,
        )
            .unwrap();

        let state = @ExampleConstructor::contract_state_for_testing();
        set_contract_address(contract_address);

        let name = state.names.read(address);
        assert_eq!(name, 'bob');
    }
}
// [!endregion tests]


