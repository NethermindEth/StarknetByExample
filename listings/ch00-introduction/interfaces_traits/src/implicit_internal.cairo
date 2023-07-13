// ANCHOR: code
#[starknet::interface]
trait IImplicitInternalContract<TContractState> {
    fn add(ref self: TContractState, nb: u32);
    fn get_value(self: @TContractState) -> u32;
    fn get_const(self: @TContractState) -> u32;
}

#[starknet::contract]
mod ImplicitInternalContract {
    use super::IImplicitInternalContract;

    #[storage]
    struct Storage {
        value: u32
    }

    #[generate_trait]
    impl InternalFunctions of InternalFunctionsTrait {
        fn set_value(ref self: ContractState, value: u32) {
            self.value.write(value);
        }
        fn get_const() -> u32 {
            42
        }
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.set_value(0);
    }

    #[external(v0)]
    impl ImplicitInternalContract of IImplicitInternalContract<ContractState> {
        fn add(ref self: ContractState, nb: u32) {
            self.set_value(self.value.read() + nb);
        }
        fn get_value(self: @ContractState) -> u32 {
            self.value.read()
        }
        fn get_const(self: @ContractState) -> u32 {
            self.get_const()
        }
    }
}
// ANCHOR_END: code

#[cfg(test)]
mod implicit_internal_contract_tests {
    use super::{
        IImplicitInternalContract, ImplicitInternalContract, IImplicitInternalContractDispatcher,
        IImplicitInternalContractDispatcherTrait
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
        // Set up.
        let (contract_address, _) = deploy_syscall(
            ImplicitInternalContract::TEST_CLASS_HASH.try_into().unwrap(),
            0,
            ArrayTrait::new().span(),
            false
        )
            .unwrap();
        let mut contract = IImplicitInternalContractDispatcher { contract_address };

        let initial_value: u32 = 0;
        assert(contract.get_value() == initial_value, 'wrong value');

        let add_value: u32 = 10; 
        contract.add(add_value);

        assert(contract.get_value() == initial_value + add_value, 'wrong value after add');
    }
}