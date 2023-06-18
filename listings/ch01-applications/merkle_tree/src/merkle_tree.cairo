#[contract]
mod MerkleTree {
    use hash::LegacyHash;
    use starknet::ContractAddress;
    use array::ArrayTrait;
    use traits::Into;
    
    struct Storage {
        root: felt252 // root hash should be pedersen hash. keccak256 is not fitting into felt252
    }

    #[constructor]
    fn constructor(_root: felt252) {
        root::write(_root);
    }

    // Checks is merkle proof verified or not.
    #[view]
    fn verify(account: ContractAddress, mut proof: Array::<felt252>) -> bool {
        let account_as_felt: felt252 = account.into();
        let leaf = LegacyHash::hash(account_as_felt, account_as_felt);
        _verify(root::read(), leaf, ref proof)
    }

    fn _verify(root:felt252, leaf: felt252, ref proof: Array::<felt252>) -> bool {
        let proof_len = proof.len();
        let calc_root = _verify_body(leaf, ref proof, proof_len, 0_u32);
        if (calc_root == root) {
            return true;
        } else {
            return false;
        }
    }

    fn _verify_body(
        leaf: felt252, ref proof: Array::<felt252>, proof_len: u32, index: u32
    ) -> felt252 {
        if (proof_len == 0_u32) {
            return leaf;
        }
        let n = _sort_hashes(leaf, *proof.at(index));
        return _verify_body(n, ref proof, proof_len - 1_u32, index + 1_u32);
    }

    // sorts hashes
    fn _sort_hashes(a: felt252, b: felt252) -> felt252 {
        // to sort hashes, convert them to u256.
        // We can also write partialeq impl for felt252 to do this conversion.
        let a_u256: u256 = a.into();
        let b_u256: u256 = b.into();

        if (a_u256 < b_u256) {
            // returns pedersen hash of sorted hashes
            return LegacyHash::hash(a, b);
        } else {
            return LegacyHash::hash(b, a);
        }
    }
}