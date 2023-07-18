use array::ArrayTrait;
use hash::LegacyHash;
use merkle_tree::merkle_tree::MerkleTree;
use debug::PrintTrait;
use starknet::deploy_syscall;
use option::OptionTrait;
use traits::{Into, TryInto};
use starknet::class_hash::Felt252TryIntoClassHash;
use result::ResultTrait;

#[starknet::interface]
trait IMerkleTree<TContractState> {
    fn verify(self: @TContractState, proof: Span<felt252>, node: felt252, root: felt252) -> bool;
}

fn setup() -> IMerkleTreeDispatcher {
    // Set up.
    let mut calldata: Array<felt252> = ArrayTrait::new();
    let (address0, _) = deploy_syscall(
        MerkleTree::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
    )
        .unwrap();
    let mut contract = IMerkleTreeDispatcher { contract_address: address0 };
    contract
}

#[test]
#[available_gas(2000000)]
fn merkle_tree_test() {
    // Create a proof.
    let mut proof = ArrayTrait::new();
    proof.append(275015828570532818958877094293872118179858708489648969448465143543997518327);
    proof.append(3081470326846576744486900207655708080595997326743041181982939514729891127832);

    let leaf = 1743721452664603547538108163491160873761573033120794192633007665066782417603;
    let expected_merkle_root =
        455571898402516024591265345720711356365422160584912150000578530706912124657;

    let contract = setup();
    let res = contract.verify(proof.span(), leaf, expected_merkle_root);
    assert(res, 'verify should succeeed')
}


#[test]
#[available_gas(2000000)]
fn merkle_tree_test_fails() {
    // Create a proof.
    let mut proof = ArrayTrait::new();
    proof.append(0x1);
    proof.append(0x2);

    let leaf = 1743721452664603547538108163491160873761573033120794192633007665066782417603;
    let expected_merkle_root =
        455571898402516024591265345720711356365422160584912150000578530706912124657;

    let contract = setup();
    let res = contract.verify(proof.span(), leaf, expected_merkle_root);
    assert(!res, 'verify should fail')
}
