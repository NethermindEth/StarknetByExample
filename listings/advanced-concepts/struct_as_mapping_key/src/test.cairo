use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};
use struct_as_mapping_key::contract::{Pet, IPetRegistryDispatcher, IPetRegistryDispatcherTrait};

#[test]
fn test_e2e() {
    // Set up.
    let contract = declare("PetRegistry").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    let contract = IPetRegistryDispatcher { contract_address };

    let pet = Pet { name: 'Cute Labrador', age: 5, owner: 'Louis' };

    // Store a pet.
    contract.register_pet(pet, 1234);

    // Read the array.
    let registration_date = contract.get_registration_date(pet);
    assert_eq!(registration_date, 1234);
}
