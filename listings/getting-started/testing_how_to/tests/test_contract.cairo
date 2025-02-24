// [!region tests]
// Import the interface and dispatcher to be able to interact with the contract.
use testing_how_to::{IInventoryContractDispatcher, IInventoryContractDispatcherTrait};

// Import the required traits and functions from Snforge
use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};
// And additionally the testing utilities
use snforge_std::{start_cheat_caller_address_global, stop_cheat_caller_address_global, load};

// Declare and deploy the contract and return its dispatcher.
fn deploy(max_capacity: u32) -> IInventoryContractDispatcher {
    let contract = declare("InventoryContract").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![max_capacity.into()]).unwrap();

    // Return the dispatcher.
    // It allows to interact with the contract based on its interface.
    IInventoryContractDispatcher { contract_address }
}

#[test]
fn test_deploy() {
    let max_capacity: u32 = 100;
    let contract = deploy(max_capacity);

    assert_eq!(contract.get_max_capacity(), max_capacity);
    assert_eq!(contract.get_inventory_count(), 0);
}

#[test]
fn test_as_owner() {
    let owner = starknet::contract_address_const::<'owner'>();
    start_cheat_caller_address_global(owner);

    // When deploying the contract, the caller is owner.
    let contract = deploy(100);

    // Owner can call update inventory successfully
    contract.update_inventory(10);
    assert_eq!(contract.get_inventory_count(), 10);

    // additionally, you can directly test the storage
    let loaded = load(
        contract.contract_address, // the contract address
        selector!("owner"), // field marking the start of the memory chunk being read from
        1 // length of the memory chunk (seen as an array of felts) to read. Here, `u32` fits in 1 felt.
    );
    assert_eq!(loaded, array!['owner']);
}

#[test]
#[should_panic]
fn test_as_not_owner() {
    let owner = starknet::contract_address_const::<'owner'>();
    start_cheat_caller_address_global(owner);
    let contract = deploy(100);

    // Change the caller address to a not owner
    stop_cheat_caller_address_global();

    // As the current caller is not the owner, the value cannot be set.
    contract.update_inventory(20);
    // Panic expected
}
// [!endregion tests]

// [!region tests_with_contract_state]
use core::starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
use testing_how_to::InventoryContract;
// To be able to call the contract methods on the state
use InventoryContract::InventoryContractImpl;
#[test]
fn test_with_contract_state() {
    let owner = starknet::contract_address_const::<'owner'>();
    start_cheat_caller_address_global(owner);

    // Initialize the contract state and call the constructor
    let mut state = InventoryContract::contract_state_for_testing();
    InventoryContract::constructor(ref state, 10);

    // Read storage values
    assert_eq!(state.max_capacity.read(), 10);
    assert_eq!(state.inventory_count.read(), 0);
    assert_eq!(state.owner.read(), owner);

    // Update the inventory count by calling the contract method
    let update_inventory = 10;
    state.update_inventory(update_inventory);
    assert_eq!(state.inventory_count.read(), update_inventory);

    // Or directly write to the storage
    let user = starknet::contract_address_const::<'user'>();
    state.owner.write(user);
    assert_eq!(state.owner.read(), user);
}
// [!endregion tests_with_contract_state]

// [!region tests_with_direct_storage_access]
#[test]
fn test_as_owner_with_direct_storage_access() {
    let owner = starknet::contract_address_const::<'owner'>();
    start_cheat_caller_address_global(owner);
    let contract = deploy(100);
    let update_inventory = 10;
    contract.update_inventory(update_inventory);

    // You can directly test the storage
    let owner_storage = load(
        contract.contract_address, // the contract address
        selector!("owner"), // field marking the start of the memory chunk being read from
        1 // length of the memory chunk (seen as an array of felts) to read. Here, `u32` fits in 1 felt.
    );
    assert_eq!(owner_storage, array!['owner']);

    // Same for the inventory count:
    // Here we showcase how to deserialize the value from it's raw felts representation to it's
    // original type.
    let mut inventory_count = load(contract.contract_address, selector!("inventory_count"), 1)
        .span();
    let inventory_count: u32 = Serde::deserialize(ref inventory_count).unwrap();
    assert_eq!(inventory_count, update_inventory);
}
// [!endregion tests_with_direct_storage_access]

// [!region tests_with_events]
use snforge_std::{spy_events, EventSpyAssertionsTrait};
#[test]
fn test_events() {
    let contract = deploy(100);

    let mut spy = spy_events();

    // This emits an event
    contract.update_inventory(10);

    spy
        .assert_emitted(
            @array![
                (
                    contract.contract_address,
                    InventoryContract::Event::InventoryUpdated(
                        InventoryContract::InventoryUpdated { new_count: 10 },
                    ),
                ),
            ],
        )
}
// [!endregion tests_with_events]


