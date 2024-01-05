use hash_trait::hash_trait::HashTraits;

#[starknet::interface]
trait IHashTrait<T> {
    fn save_user_with_poseidon(ref self: T, username: felt252, password: felt252) -> felt252;
    fn save_user_with_pedersen(ref self: T, username: felt252, password: felt252) -> felt252;
}


mod tests {
    use core::result::ResultTrait;
    use core::option::OptionTrait;
    use super::{IHashTrait, HashTraits};
    use super::{IHashTraitDispatcher, IHashTraitDispatcherTrait};
    use starknet::{deploy_syscall};
    use starknet::{class_hash::Felt252TryIntoClassHash, ClassHash};

    #[test]
    #[available_gas(20000000)]
    fn test_pedersen_hash() {
        //set up
        let hash_pedersen: felt252 = 0x7d4d4820d7dc0acc14395e2834db01adf13df81a3ef293c7d9b712847123dc0;

        let username = 'Evans.stark';
        let password = 'password.stark';

        let mut calldata = ArrayTrait::new();
        let (address, _) = deploy_syscall(
            HashTraits::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap();
        let mut contract = IHashTraitDispatcher { contract_address: address };
        let test_hash = contract.save_user_with_pedersen(username, password);

        assert(test_hash == hash_pedersen, 'Incorrect hash output');
    }

    #[test]
    #[available_gas(20000000)]
    fn test_poseidon_hash() {
        //set up
        let hash_poseidon: felt252 = 0x7b1a71844e218633f87ebca3d945b77ada8de817ade9a29c2820e536ef62637;

        let username = 'Evans.stark';
        let password = 'password.stark';

        let mut calldata = ArrayTrait::new();
        let (address, _) = deploy_syscall(
            HashTraits::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap();
        let mut contract = IHashTraitDispatcher { contract_address: address };
        let test_hash = contract.save_user_with_poseidon(username, password);

        assert(test_hash == hash_poseidon, 'Incorrect hash output');
    }

}
