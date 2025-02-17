#[starknet::interface]
trait ICustomErrors<TContractState> {
    fn test_assert(self: @TContractState, i: u256);
    fn test_panic(self: @TContractState, i: u256);
}

// [!region contract]
mod Errors {
    pub const NOT_POSITIVE: felt252 = 'must be greater than 0';
    pub const NOT_NULL: felt252 = 'must not be null';
}

#[starknet::contract]
mod CustomErrorsContract {
    use super::{Errors, ICustomErrors};

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl CustomErrorsContract of ICustomErrors<ContractState> {
        fn test_assert(self: @ContractState, i: u256) {
            assert(i > 0, Errors::NOT_POSITIVE);
        }

        fn test_panic(self: @ContractState, i: u256) {
            if (i == 0) {
                core::panic_with_felt252(Errors::NOT_NULL);
            }
        }
    }
}
// [!endregion contract]

#[cfg(test)]
mod test {
    use super::{ICustomErrorsDispatcher, ICustomErrorsDispatcherTrait};
    use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};

    fn deploy() -> ICustomErrorsDispatcher {
        let contract = declare("CustomErrorsContract").unwrap().contract_class();
        let (contract_address, _) = contract.deploy(@array![]).unwrap();
        ICustomErrorsDispatcher { contract_address }
    }

    #[test]
    #[should_panic(expected: 'must not be null')]
    fn should_panic() {
        let contract = deploy();
        contract.test_panic(0);
    }

    #[test]
    #[should_panic(expected: 'must be greater than 0')]
    fn should_assert() {
        let contract = deploy();
        contract.test_assert(0);
    }
}
