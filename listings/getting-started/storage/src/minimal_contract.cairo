// ANCHOR: contract
#[starknet::contract]
pub mod Contract {
    #[storage]
    struct Storage {}
}
// ANCHOR_END: contract

#[cfg(test)]
mod test {
    use super::Contract;
    use starknet::{SyscallResultTrait, syscalls::deploy_syscall};

    #[test]
    fn test_can_deploy() {
        let (_contract_address, _) = deploy_syscall(
            Contract::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();
    // Not much to test
    }
}

