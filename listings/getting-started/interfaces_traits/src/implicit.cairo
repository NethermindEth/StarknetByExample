// ANCHOR: contract
#[starknet::contract]
pub mod ImplicitInterfaceContract {
    #[storage]
    struct Storage {
        value: u32
    }

    #[abi(per_item)]
    #[generate_trait]
    pub impl ImplicitInterfaceContract of IImplicitInterfaceContract {
        #[external(v0)]
        fn get_value(self: @ContractState) -> u32 {
            self.value.read()
        }

        #[external(v0)]
        fn set_value(ref self: ContractState, value: u32) {
            self.value.write(value);
        }
    }
}
// ANCHOR_END: contract

#[cfg(test)]
mod tests {
    use super::{
        ImplicitInterfaceContract, ImplicitInterfaceContract::valueContractMemberStateTrait,
        ImplicitInterfaceContract::IImplicitInterfaceContract
    };
    use starknet::{
        ContractAddress, SyscallResultTrait, syscalls::deploy_syscall, testing::set_contract_address
    };

    #[test]
    fn test_interface() {
        let (contract_address, _) = deploy_syscall(
            ImplicitInterfaceContract::TEST_CLASS_HASH.try_into().unwrap(),
            0,
            array![].span(),
            false
        )
            .unwrap_syscall();
        set_contract_address(contract_address);
        let mut state = ImplicitInterfaceContract::contract_state_for_testing();

        let value = 42;
        state.set_value(value);
        let read_value = state.get_value();

        assert_eq!(read_value, value);
    }
}
