// ANCHOR: code
#[starknet::interface]
trait IExplicitInterfaceContract<TContractState> {
    fn get_value(self: @TContractState) -> u32;
    fn set_value(ref self: TContractState, value: u32);
}

#[starknet::contract]
mod ExplicitInterfaceContract {
    use super::IExplicitInterfaceContract;

    #[storage]
    struct Storage {
        value: u32
    }

    #[external(v0)]
    impl ExplicitInterfaceContract of IExplicitInterfaceContract<ContractState> {
        fn get_value(self: @ContractState) -> u32 {
            self.value.read()
        }

        fn set_value(ref self: ContractState, value: u32) {
            self.value.write(value);
        }
    }
}
// ANCHOR_END: code

#[cfg(test)]
mod explicit_interface_contract_tests {
    use super::{
        IExplicitInterfaceContract, ExplicitInterfaceContract, IExplicitInterfaceContractDispatcher,
        IExplicitInterfaceContractDispatcherTrait
    };
    use debug::PrintTrait;
    use starknet::{deploy_syscall, ContractAddress};
    use option::OptionTrait;
    use array::ArrayTrait;
    use traits::{Into, TryInto};
    use starknet::class_hash::Felt252TryIntoClassHash;
    use result::ResultTrait;

    #[test]
    #[available_gas(2000000000)]
    fn test_interface() {
        let (contract_address, _) = deploy_syscall(
            ExplicitInterfaceContract::TEST_CLASS_HASH.try_into().unwrap(),
            0,
            ArrayTrait::new().span(),
            false
        )
            .unwrap();
        let mut contract = IExplicitInterfaceContractDispatcher { contract_address };

        let value: u32 = 20;
        contract.set_value(value);

        let read_value = contract.get_value();
        read_value.print();

        assert(read_value == value, 'wrong value');
    }
}
