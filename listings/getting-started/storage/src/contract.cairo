// ANCHOR: contract
#[starknet::contract]
pub mod Contract {
    #[storage]
    struct Storage {
        a: u128,
        b: u8,
        c: u256
    }
}
// ANCHOR_END: contract

#[cfg(test)]
mod test {
    use super::Contract;
    use starknet::SyscallResultTrait;
    use starknet::syscalls::deploy_syscall;
    use storage::contract::Contract::__member_module_a::InternalContractMemberStateTrait as InternalA;
    use storage::contract::Contract::__member_module_b::InternalContractMemberStateTrait as InternalB;
    use storage::contract::Contract::__member_module_c::InternalContractMemberStateTrait as InternalC;

    #[starknet::interface]
    trait ITestContract<T> {}

    #[test]
    fn test_can_deploy() {
        let (_contract_address, _) = deploy_syscall(
            Contract::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();
    }

    #[test]
    fn test_storage_members() {
        let state = Contract::contract_state_for_testing();
        assert_eq!(state.a.read(), 0_u128);
        assert_eq!(state.b.read(), 0_u8);
        assert_eq!(state.c.read(), 0_u256);
    }
}
