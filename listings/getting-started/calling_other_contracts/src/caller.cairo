// ANCHOR: callee_contract
// This will automatically generate ICalleeDispatcher and ICalleeDispatcherTrait
#[starknet::interface]
pub trait ICallee<TContractState> {
    fn set_value(ref self: TContractState, value: u128) -> u128;
}

#[starknet::contract]
pub mod Callee {

    #[storage]
    struct Storage {
        value: u128,
    }

    #[abi(embed_v0)]
    impl ICalleeImpl of super::ICallee<ContractState> {
        fn set_value(ref self: ContractState, value: u128) -> u128 {
            self.value.write(value);
            value
        }
    }
}
// ANCHOR_END: callee_contract

#[starknet::interface]
pub trait ICaller<TContractState> {
    fn set_value_from_address(
        ref self: TContractState, addr: starknet::ContractAddress, value: u128
    );
}

// ANCHOR: caller_contract
#[starknet::contract]
pub mod Caller {
    // We need to import the dispatcher of the callee contract
    // If you don't have a proper import, you can redefine the interface by yourself
    use super::{ICalleeDispatcher, ICalleeDispatcherTrait};
    use starknet::ContractAddress;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl ICallerImpl of super::ICaller<ContractState> {
        fn set_value_from_address(ref self: ContractState, addr: ContractAddress, value: u128) {
            ICalleeDispatcher { contract_address: addr }.set_value(value);
        }
    }
}
// ANCHOR_END: caller_contract

#[cfg(test)]
mod tests {
    use super::{
        Callee, ICalleeDispatcher, ICalleeDispatcherTrait, Callee::valueContractMemberStateTrait,
        Caller, ICallerDispatcher, ICallerDispatcherTrait
    };
    use starknet::{
        ContractAddress, contract_address_const, testing::set_contract_address,
        syscalls::deploy_syscall, SyscallResultTrait
    };

    fn deploy() -> (ICalleeDispatcher, ICallerDispatcher) {
        let (address_callee, _) = deploy_syscall(
            Callee::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();
        let (address_caller, _) = deploy_syscall(
            Caller::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();
        (
            ICalleeDispatcher { contract_address: address_callee },
            ICallerDispatcher { contract_address: address_caller }
        )
    }

    #[test]
    fn test_caller() {
        let init_value: u128 = 42;

        let (callee, caller) = deploy();
        caller.set_value_from_address(callee.contract_address, init_value);

        let state = Callee::contract_state_for_testing();
        set_contract_address(callee.contract_address);

        let value_read: u128 = state.value.read();

        assert_eq!(value_read, init_value);
    }
}
