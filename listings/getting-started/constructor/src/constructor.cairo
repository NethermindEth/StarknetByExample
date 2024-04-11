// ANCHOR: contract
#[starknet::contract]
pub mod ExampleConstructor {
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        names: LegacyMap::<ContractAddress, felt252>,
    }

    // The constructor is decorated with a `#[constructor]` attribute.
    // It is not inside an `impl` block.
    #[constructor]
    fn constructor(ref self: ContractState, name: felt252, address: ContractAddress) {
        self.names.write(address, name);
    }
}
// ANCHOR_END: contract

#[cfg(test)]
mod tests {
    use starknet::testing::set_contract_address;
    use starknet::{ContractAddress, contract_address_const};
    use starknet::SyscallResultTrait;
    use starknet::syscalls::deploy_syscall;

    use super::{ExampleConstructor, ExampleConstructor::namesContractMemberStateTrait};

    #[test]
    fn should_deploy_with_constructor_init_value() {
        let name: felt252 = 'bob';
        let address: ContractAddress = contract_address_const::<'caller'>();

        let mut calldata: Array::<felt252> = array![];
        calldata.append(name);
        calldata.append(address.into());

        let (address_0, _) = deploy_syscall(
            ExampleConstructor::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap_syscall();

        let state = ExampleConstructor::unsafe_new_contract_state();
        set_contract_address(address_0);

        let name = state.names.read(address);

        assert(name == 'bob', 'name should be bob');
    }
}
