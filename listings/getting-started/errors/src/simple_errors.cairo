#[starknet::interface]
trait IErrors<TContractState> {
    fn test_assert(self: @TContractState, i: u256);
    fn test_panic(self: @TContractState, i: u256);
}

// [!region contract]
#[starknet::contract]
mod ErrorsContract {
    use super::IErrors;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl ErrorsContract of IErrors<ContractState> {
        // Assert used to validate a condition
        // and abort execution if the condition is not met
        fn test_assert(self: @ContractState, i: u256) {
            assert(i > 0, 'i must be greater than 0');
            let x = 10;
            assert!(i > x, "i must be greater than {}", x);
        }

        // Panic used to abort execution directly
        fn test_panic(self: @ContractState, i: u256) {
            if (i == 0) {
                core::panic_with_felt252('i must not be 0');
            }
            if (i < 10) {
                panic!("i: {} must be greater than 10", i);
            }
        }
    }
}
// [!endregion contract]

#[cfg(test)]
mod test {
    use super::{IErrorsDispatcher, IErrorsDispatcherTrait};
    use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};

    fn deploy() -> IErrorsDispatcher {
        let contract = declare("ErrorsContract").unwrap().contract_class();
        let (contract_address, _) = contract.deploy(@array![]).unwrap();
        IErrorsDispatcher { contract_address }
    }

    #[test]
    #[should_panic(expected: 'i must be greater than 0')]
    fn should_assert_with_felt() {
        let contract = deploy();
        contract.test_assert(0);
    }

    #[test]
    #[should_panic(expected: "i must be greater than 10")]
    fn should_assert_with_byte_array() {
        let contract = deploy();
        contract.test_assert(5);
    }

    #[test]
    #[should_panic(expected: 'i must not be 0')]
    fn should_panic_with_felt() {
        let contract = deploy();
        contract.test_panic(0);
    }

    #[test]
    #[should_panic(expected: "i: 5 must be greater than 10")]
    fn should_panic_with_byte_array() {
        let contract = deploy();
        contract.test_panic(5);
    }
}
