use write_to_any_slot::contract::{IWriteToAnySlotsDispatcher, IWriteToAnySlotsDispatcherTrait};
use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};

#[test]
fn test_read_write() {
    // Set up.
    let contract = declare("WriteToAnySlot").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    let mut contract = IWriteToAnySlotsDispatcher { contract_address };

    // Write to slot.
    let value = 42;
    contract.write_slot(value);

    // Read from slot.
    let read_value = contract.read_slot();
    assert_eq!(read_value, value);
}
