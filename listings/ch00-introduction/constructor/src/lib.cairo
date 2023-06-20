#[contract]
mod constructor {
    use starknet::ContractAddress;

    struct Storage {
        _names: LegacyMap::<ContractAddress, felt252>, 
    }

    #[constructor]
    fn constructor(name: felt252, address: ContractAddress) {
        _names::write(address, name);
    }
}
