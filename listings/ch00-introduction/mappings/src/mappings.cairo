#[contract]
mod MapContract {
    use starknet::ContractAddress;

    struct Storage {
        _map: LegacyMap::<ContractAddress, felt252>, 
    }

    #[external]
    fn set(key: ContractAddress, value: felt252) {
        _map::write(key, value);
    }

    #[view]
    fn get(key: ContractAddress) -> felt252 {
        _map::read(key)
    }
}
