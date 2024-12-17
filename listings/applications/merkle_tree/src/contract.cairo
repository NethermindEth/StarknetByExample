#[generate_trait]
pub impl ByteArrayHashTraitImpl of ByteArrayHashTrait {
    fn hash(self: @ByteArray) -> felt252 {
        let mut serialized_byte_arr: Array<felt252> = ArrayTrait::new();
        self.serialize(ref serialized_byte_arr);

        core::poseidon::poseidon_hash_span(serialized_byte_arr.span())
    }
}

#[starknet::interface]
pub trait IMerkleTree<TContractState> {
    fn build_tree(ref self: TContractState, data: Array<ByteArray>) -> Array<felt252>;
    fn get_root(self: @TContractState) -> felt252;
    // function to verify if leaf node exists in the merkle tree
    fn verify(
        self: @TContractState, proof: Array<felt252>, root: felt252, leaf: felt252, index: usize,
    ) -> bool;
}

mod errors {
    pub const NOT_POW_2: felt252 = 'Data length is not a power of 2';
    pub const NOT_PRESENT: felt252 = 'No element in merkle tree';
}

#[starknet::contract]
pub mod MerkleTree {
    use core::poseidon::PoseidonTrait;
    use core::hash::{HashStateTrait, HashStateExTrait};
    use starknet::storage::{
        StoragePointerWriteAccess, StoragePointerReadAccess, Vec, MutableVecTrait, VecTrait,
    };
    use super::ByteArrayHashTrait;

    #[storage]
    struct Storage {
        pub hashes: Vec<felt252>,
    }

    #[derive(Drop, Serde, Copy)]
    struct Vec2 {
        x: u32,
        y: u32,
    }

    #[abi(embed_v0)]
    impl IMerkleTreeImpl of super::IMerkleTree<ContractState> {
        fn build_tree(ref self: ContractState, mut data: Array<ByteArray>) -> Array<felt252> {
            let data_len = data.len();
            assert(data_len > 0 && (data_len & (data_len - 1)) == 0, super::errors::NOT_POW_2);

            let mut _hashes: Array<felt252> = ArrayTrait::new();

            // first, hash every leaf
            for value in data {
                _hashes.append(value.hash());
            };

            // then, hash all levels above leaves
            let mut current_nodes_lvl_len = data_len;
            let mut hashes_offset = 0;

            while current_nodes_lvl_len > 0 {
                let mut i = 0;
                while i < current_nodes_lvl_len - 1 {
                    let left_elem = *_hashes.at(hashes_offset + i);
                    let right_elem = *_hashes.at(hashes_offset + i + 1);

                    let hash = PoseidonTrait::new().update_with((left_elem, right_elem)).finalize();
                    _hashes.append(hash);

                    i += 2;
                };

                hashes_offset += current_nodes_lvl_len;
                current_nodes_lvl_len /= 2;
            };

            // write to the contract state (useful for the get_root function)
            for hash in _hashes.span() {
                self.hashes.append().write(*hash);
            };

            _hashes
        }

        fn get_root(self: @ContractState) -> felt252 {
            let merkle_tree_length = self.hashes.len();
            assert(merkle_tree_length > 0, super::errors::NOT_PRESENT);

            self.hashes.at(merkle_tree_length - 1).read()
        }

        fn verify(
            self: @ContractState,
            mut proof: Array<felt252>,
            root: felt252,
            leaf: felt252,
            mut index: usize,
        ) -> bool {
            let mut current_hash = leaf;

            while let Option::Some(value) = proof.pop_front() {
                current_hash =
                    if index % 2 == 0 {
                        PoseidonTrait::new().update_with((current_hash, value)).finalize()
                    } else {
                        PoseidonTrait::new().update_with((value, current_hash)).finalize()
                    };

                index /= 2;
            };

            current_hash == root
        }
    }
}
