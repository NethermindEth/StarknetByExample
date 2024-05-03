// ANCHOR: contract
#[starknet::interface]
pub trait IExplicitInterfaceContract<TContractState> {
    fn get_value(self: @TContractState) -> u32;
    fn set_value(ref self: TContractState, value: u32);
}

#[starknet::contract]
pub mod ExplicitInterfaceContract {
    #[storage]
    struct Storage {
        value: u32
    }

    #[abi(embed_v0)]
    impl ExplicitInterfaceContract of super::IExplicitInterfaceContract<ContractState> {
        fn get_value(self: @ContractState) -> u32 {
            self.value.read()
        }

        fn set_value(ref self: ContractState, value: u32) {
            self.value.write(value);
        }
    }
}
// ANCHOR_END: contract

#[cfg(test)]
mod tests {
    use super::{
        IExplicitInterfaceContract, ExplicitInterfaceContract, IExplicitInterfaceContractDispatcher,
        IExplicitInterfaceContractDispatcherTrait
    };
    use starknet::{ContractAddress, SyscallResultTrait, syscalls::deploy_syscall};

    #[test]
    fn test_interface() {
        let (contract_address, _) = deploy_syscall(
            ExplicitInterfaceContract::TEST_CLASS_HASH.try_into().unwrap(),
            0,
            array![].span(),
            false
        )
            .unwrap_syscall();
        let mut contract = IExplicitInterfaceContractDispatcher { contract_address };

        let value: u32 = 20;
        contract.set_value(value);

        let read_value = contract.get_value();

        assert_eq!(read_value, value);
    }
}
