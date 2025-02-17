// [!region contract]
#[starknet::contract]
mod Contract {
    #[storage]
    struct Storage {}
}
// [!endregion contract]

// [!region tests]
#[cfg(test)]
mod test {
    use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};

    #[test]
    fn test_can_deploy() {
        let contract = declare("Contract").unwrap().contract_class();
        let (_contract_address, _) = contract.deploy(@array![]).unwrap();
        // Not much to test
    }
}
// [!endregion tests]


