use library_calls::library_call::{IMathUtilsDispatcher, IMathUtilsDispatcherTrait};
use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};

#[test]
fn test_library_dispatcher() {
    let math_utils = declare("MathUtils").unwrap().contract_class();

    let contract = declare("MathUtilsLibraryCall").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    let contract = IMathUtilsDispatcher { contract_address };

    contract.set_class_hash(*math_utils.class_hash);

    let mut result = contract.add(30, 5);
    assert_eq!(result, 35, "Wrong result");
}
