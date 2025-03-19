use core::poseidon::PoseidonTrait;
use core::hash::{HashStateTrait, HashStateExTrait};
use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};
use merkle_tree::contract::IMerkleTreeDispatcherTrait;
use merkle_tree::contract::{IMerkleTreeDispatcher, ByteArrayHashTrait};

fn setup() -> IMerkleTreeDispatcher {
    let contract = declare("MerkleTree").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    IMerkleTreeDispatcher { contract_address }
}

#[test]
fn should_deploy() {
    setup();
}

#[test]
fn build_tree_succeeds() {
    /// Set up
    let contract = setup();

    let data_1 = "alice -> bob: 2";
    let data_2 = "bob -> john: 5";
    let data_3 = "alice -> john: 1";
    let data_4 = "john -> alex: 8";
    let arguments = array![data_1.clone(), data_2.clone(), data_3.clone(), data_4.clone()];

    /// When
    let actual_hashes = contract.build_tree(arguments);

    /// Then
    let mut expected_hashes: Array<felt252> = array![];

    // leaves' hashes
    expected_hashes.append(data_1.hash());
    expected_hashes.append(data_2.hash());
    expected_hashes.append(data_3.hash());
    expected_hashes.append(data_4.hash());

    // hashes for level above leaves
    let hash_0 = PoseidonTrait::new()
        .update_with((*expected_hashes.at(0), *expected_hashes.at(1)))
        .finalize();
    let hash_1 = PoseidonTrait::new()
        .update_with((*expected_hashes.at(2), *expected_hashes.at(3)))
        .finalize();
    expected_hashes.append(hash_0);
    expected_hashes.append(hash_1);

    // root hash
    let root_hash = PoseidonTrait::new().update_with((hash_0, hash_1)).finalize();
    expected_hashes.append(root_hash);

    // verify returned result
    assert_eq!(actual_hashes, expected_hashes);

    // verify get_root
    assert_eq!(contract.get_root(), root_hash);
}

#[test]
#[should_panic(expected: 'Data length is not a power of 2')]
fn build_tree_fails() {
    /// Set up
    let contract = setup();

    let data_1 = "alice -> bob: 2";
    let data_2 = "bob -> john: 5";
    let data_3 = "alice -> john: 1";
    // number of arguments not a power of 2
    let arguments = array![data_1, data_2, data_3];

    /// When
    contract.build_tree(arguments);
}

#[test]
fn verify_leaf_succeeds() {
    /// Set up
    let contract = setup();

    let data_1 = "bob -> alice: 1";
    let data_2 = "alex -> john: 3";
    let data_3 = "alice -> alex: 8";
    let data_4 = "alex -> bob: 8";
    let arguments = array![data_1.clone(), data_2.clone(), data_3.clone(), data_4.clone()];

    let hashes = contract.build_tree(arguments);

    //       ----> hashes tree :
    //
    //              hashes[6]
    //            /         \
    //        hashes[4]    hashes[5]
    //       /     \          /      \
    //  hashes[0] hashes[1]  hashes[2] hashes[3]

    let res = contract
        .verify(
            array![*hashes.at(3), *hashes.at(4)], // proof
            *hashes.at(6), // root
            data_3.hash(), // leaf
            2 // leaf index
        );

    assert!(res, "Leaf should be in merkle tree");
}

#[test]
fn verify_leaf_fails() {
    /// Set up
    let contract = setup();

    let data_1 = "bob -> alice: 1";
    let data_2 = "alex -> john: 3";
    let data_3 = "alice -> alex: 8";
    let data_4 = "alex -> bob: 8";
    let arguments = array![data_1.clone(), data_2.clone(), data_3.clone(), data_4.clone()];

    let hashes = contract.build_tree(arguments);

    //       ----- hashes tree -----
    //              hashes[6]
    //            /          \
    //        hashes[4]     hashes[5]
    //       /     \          /       \
    //  hashes[0] hashes[1]  hashes[2] hashes[3]

    let wrong_leaf: ByteArray = "alice -> alex: 9";
    let res = contract
        .verify(
            array![*hashes.at(3), *hashes.at(4)], // proof
            *hashes.at(6), // root
            wrong_leaf.hash(), // leaf
            2 // leaf index
        );
    assert!(!res, "1- Leaf should NOT be in tree");

    let wrong_proof = array![*hashes.at(4), *hashes.at(3)];
    let res = contract
        .verify(
            wrong_proof, // proof
            *hashes.at(6), // root
            data_3.hash(), // leaf
            2 // leaf index
        );
    assert!(!res, "2- Leaf should NOT be in tree");
}

