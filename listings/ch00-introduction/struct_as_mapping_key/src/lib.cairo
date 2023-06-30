#[contract]
mod StructAsMappingKey {
    use starknet::get_caller_address;
    use starknet::ContractAddress;
    use poseidon::poseidon_hash_span;
    use serde::Serde;
    use array::ArrayTrait;

    struct Storage {
        _map: LegacyMap::<felt252, felt252>, 
    }

    #[derive(Serde)]
    struct User {
        name : felt252,
        age : felt252,
        address : ContractAddress,
    }

    #[external]
    fn set(key: User, value: felt252) {
        let mut calldata: Array<felt252> = ArrayTrait::new();
        Serde::<User>::serialize(@key, ref calldata);
        _map::write(poseidon_hash_span(calldata.span()), value);
    }

    #[view]
    fn get(key: User) -> felt252 {
        let mut calldata: Array<felt252> = ArrayTrait::new();
        Serde::<User>::serialize(@key, ref calldata);
        _map::read(poseidon_hash_span(calldata.span()))
    }
}