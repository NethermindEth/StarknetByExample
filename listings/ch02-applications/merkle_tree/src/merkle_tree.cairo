#[starknet::contract]
mod MerkleTree {
    use hash::LegacyHash;
    use starknet::ContractAddress;
    use array::{SpanTrait};
    use traits::Into;

    #[storage]
    struct Storage {}

    #[generate_trait]
    #[external(v0)]
    impl MerkleTree of IMerkleTree {
        // Verifies the given Merkle proof.
        fn verify(
            self: @ContractState, mut proof: Span<felt252>, mut node: felt252, root: felt252
        ) -> bool {
            loop {
                match proof.pop_front() {
                    Option::Some(proof_element) => {
                        // Compute the hash of the current node and the current element of the proof.
                        // We need to check if the current node is smaller than the current element of the proof.
                        // If it is, we need to swap the order of the hash.
                        if Into::<felt252, u256>::into(node) < (*proof_element).into() {
                            node = LegacyHash::hash(node, *proof_element);
                        } else {
                            node = LegacyHash::hash(*proof_element, node);
                        }
                    },
                    Option::None(()) => {
                        break node;
                    },
                };
            };
            node == root
        }
    }
}
