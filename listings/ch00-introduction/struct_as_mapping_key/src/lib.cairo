#[contract]
mod StructAsMappingKey {
    use starknet::get_caller_address;
    use starknet::ContractAddress;
    use poseidon::poseidon_hash_span;

    struct Storage {
        _map: LegacyMap::<ContractAddress, felt252>, 
    }

    struct User {
        name : felt252,
        age : felt252,
        address : ContractAddress,
    }

    #[external]
    fn set(key: User, value: felt252) {
        _map::write(poseidon_hash_span(key.span()), value);
    }

    #[view]
    fn get(key: User) -> felt252 {
        _map::read(poseidon_hash_span(key.span()))
    }
}