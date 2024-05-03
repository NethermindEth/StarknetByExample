// ANCHOR: contract
#[starknet::interface]
pub trait IImplicitInternalContract<TContractState> {
    fn add(ref self: TContractState, nb: u32);
    fn get_value(self: @TContractState) -> u32;
    fn get_const(self: @TContractState) -> u32;
}

#[starknet::contract]
pub mod ImplicitInternalContract {
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

    #[abi(embed_v0)]
    impl ImplicitInternalContract of super::IImplicitInternalContract<ContractState> {
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
// ANCHOR_END: contract

#[cfg(test)]
mod tests {
    use super::{
        IImplicitInternalContract, ImplicitInternalContract, IImplicitInternalContractDispatcher,
        IImplicitInternalContractDispatcherTrait
    };
    use starknet::{ContractAddress, SyscallResultTrait, syscalls::deploy_syscall};

    #[test]
    fn test_interface() {
        // Set up.
        let (contract_address, _) = deploy_syscall(
            ImplicitInternalContract::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();
        let mut contract = IImplicitInternalContractDispatcher { contract_address };

        let initial_value: u32 = 0;
        assert_eq!(contract.get_value(), initial_value);

        let add_value: u32 = 10;
        contract.add(add_value);

        assert_eq!(contract.get_value(), initial_value + add_value);
    }
}
