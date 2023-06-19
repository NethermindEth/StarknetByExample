use starknet::ContractAddress;

struct Storage {
    names: LegacyMap::<ContractAddress, felt252>, 
}

#[constructor]
fn constructor(_name: felt252, _address: ContractAddress) {
    names::write(_address, _name);
}