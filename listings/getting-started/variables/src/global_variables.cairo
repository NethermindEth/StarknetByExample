#[starknet::interface]
pub trait IGlobalExample<TContractState> {
    fn foo(ref self: TContractState);
}

// ANCHOR: contract
#[starknet::contract]
pub mod GlobalExample {
    // import the required functions from the starknet core library
    use starknet::get_caller_address;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl GlobalExampleImpl of super::IGlobalExample<ContractState> {
        fn foo(ref self: ContractState) {
            // Call the get_caller_address function to get the sender address
            let _caller = get_caller_address();
        // ...
        }
    }
}
// ANCHOR_END: contract

#[cfg(test)]
mod test {
    use super::GlobalExample;
    use starknet::SyscallResultTrait;
    use starknet::syscalls::deploy_syscall;

    #[test]
    fn test_can_deploy() {
        let (_contract_address, _) = deploy_syscall(
            GlobalExample::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();
    // Not much to test
    }
}
