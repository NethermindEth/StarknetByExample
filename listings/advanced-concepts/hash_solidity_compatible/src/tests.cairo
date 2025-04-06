use hash_solidity_compatible::contract::{
    ISolidityHashExampleDispatcher, ISolidityHashExampleDispatcherTrait,
};
use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};

fn setup() -> ISolidityHashExampleDispatcher {
    let contract = declare("SolidityHashExample").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    ISolidityHashExampleDispatcher { contract_address }
}

#[test]
fn get_same_hash_solidity() {
    let contract = setup();
    let hash_expected: u256 = 0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6;
    assert_eq!(contract.hash_data(array![1].span()), hash_expected);
}
