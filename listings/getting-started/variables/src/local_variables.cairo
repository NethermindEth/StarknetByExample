#[starknet::interface]
pub trait ILocalVariablesExample<TContractState> {
    fn do_something(self: @TContractState, value: u32) -> u32;
}

// ANCHOR: contract
#[starknet::contract]
pub mod LocalVariablesExample {
    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl LocalVariablesExample of super::ILocalVariablesExample<ContractState> {
        fn do_something(self: @ContractState, value: u32) -> u32 {
            // This variable is local to the current block.
            // It can't be accessed once it goes out of scope.
            let increment = 10;

            {
                // The scope of a code block allows for local variable declaration
                // We can access variables defined in higher scopes.
                let sum = value + increment;
                sum
            }
        // We can't access the variable `sum` here, as it's out of scope.
        }
    }
}
// ANCHOR_END: contract

#[cfg(test)]
mod test {
    use super::{
        LocalVariablesExample, ILocalVariablesExampleDispatcher,
        ILocalVariablesExampleDispatcherTrait
    };
    use starknet::SyscallResultTrait;
    use starknet::syscalls::deploy_syscall;

    #[test]
    fn test_can_deploy_and_do_something() {
        let (contract_address, _) = deploy_syscall(
            LocalVariablesExample::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false
        )
            .unwrap_syscall();

        let contract = ILocalVariablesExampleDispatcher { contract_address };
        let value = 10;
        let res = contract.do_something(value);
        assert_eq!(res, value + 10);
    }
}
