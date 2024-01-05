#[starknet::contract]
mod HashTraits {
    use core::hash::{HashStateTrait, HashStateExTrait};
    use core::{pedersen::PedersenTrait, poseidon::PoseidonTrait};

    #[storage]
    struct Storage {
        user_hash_poseidon: felt252,
        user_hash_pedersen: felt252,
    }

    #[derive(Drop, Hash)]
    struct UserDetails {
        username: felt252,
        password: felt252,
    }

    #[external(v0)]
    fn save_user_with_poseidon(
        ref self: ContractState, username: felt252, password: felt252
    ) -> felt252 {
        let user_detail: UserDetails = UserDetails { username, password };

        let poseidon_hash = PoseidonTrait::new().update_with(user_detail).finalize();
        self.user_hash_poseidon.write(poseidon_hash);
        poseidon_hash
    }

    #[external(v0)]
    fn save_user_with_pedersen(
        ref self: ContractState, username: felt252, password: felt252
    ) -> felt252 {
        let user_detail: UserDetails = UserDetails { username, password };

        let pedersen_hash = PedersenTrait::new(0).update_with(user_detail).finalize();
        self.user_hash_pedersen.write(pedersen_hash);
        pedersen_hash
    }
}
