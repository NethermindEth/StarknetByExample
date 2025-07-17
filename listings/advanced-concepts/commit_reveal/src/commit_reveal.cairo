#[starknet::interface]
pub trait ICommitmentRevealTrait<T> {
    fn commit(ref self: T, commitment: felt252);
    fn reveal(self: @T, secret: felt252) -> bool;
}

// [!region contract]
#[starknet::contract]
mod CommitmentRevealTraits {
    use starknet::storage::{StoragePointerWriteAccess, StoragePointerReadAccess};
    use core::hash::HashStateTrait;
    use core::pedersen::PedersenTrait;

    #[storage]
    struct Storage {
        commitment: felt252,
    }

    #[abi(embed_v0)]
    impl CommitmentRevealTrait of super::ICommitmentRevealTrait<ContractState> {
        fn commit(ref self: ContractState, commitment: felt252) {
            self.commitment.write(commitment);
        }

        fn reveal(self: @ContractState, secret: felt252) -> bool {
            let hash = PedersenTrait::new(secret).finalize();
            self.commitment.read() == hash
        }
    }
}
// [!endregion contract]

#[cfg(test)]
mod tests {
    use super::{ICommitmentRevealTraitDispatcher, ICommitmentRevealTraitDispatcherTrait};
    use core::hash::HashStateTrait;
    use core::pedersen::PedersenTrait;
    use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};

    fn deploy() -> ICommitmentRevealTraitDispatcher {
        let contract = declare("CommitmentRevealTraits").unwrap().contract_class();
        let (contract_address, _) = contract.deploy(@array![]).unwrap();
        ICommitmentRevealTraitDispatcher { contract_address }
    }

    #[test]
    fn commit_and_reveal() {
        let contract = deploy();

        // [!region offchain]
        // Off-chain, compute the commitment hash for secret
        let secret = 'My secret';
        let offchain_commitment = PedersenTrait::new(secret).finalize();

        // Commit on-chain
        contract.commit(offchain_commitment);

        // Reveal on-chain and assert the result
        let reveal_result = contract.reveal(secret);
        // [!endregion offchain]
        assert_eq!(reveal_result, true);
    }
}

