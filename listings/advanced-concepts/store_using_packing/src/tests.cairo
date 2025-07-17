use store_using_packing::contract::{Time, ITimeDispatcher, ITimeDispatcherTrait};
use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};

#[test]
fn test_packing() {
    // Set up.
    let contract = declare("TimeContract").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    let contract = ITimeDispatcher { contract_address };

    // Store a Time struct.
    let time = Time { hour: 1, minute: 2 };
    contract.set(time);

    // Read the stored struct.
    let read_time: Time = contract.get();
    assert_eq!(read_time.hour, time.hour);
    assert_eq!(read_time.minute, time.minute);
}
