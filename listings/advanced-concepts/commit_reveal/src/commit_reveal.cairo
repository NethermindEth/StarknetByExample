// this is an example of how to use the commitment scheme  on a auction;
// it is based on the pedersen commitment scheme


#[starknet::interface]
pub trait ICommitmentRevealTrait<T> {
    fn commit(ref self: T, commitment: felt252) -> felt252;
    fn reveal(self: @T, name: felt252, amount: felt252) -> bool;
}

#[starknet::contract]
pub mod CommitmentRevealTraits {
    use core::hash::{HashStateTrait, HashStateExTrait};
    use core::pedersen::PedersenTrait;

    #[storage]
    struct Storage {
        commitment: felt252,
    }

    #[derive(Drop, Hash)]
    struct Auction {
        amount: felt252,
        name: felt252,
    }

    #[abi(embed_v0)]
    impl CommitmentRevealTrait of super::ICommitmentRevealTrait<ContractState> {
        fn commit(ref self: ContractState, commitment: felt252) -> felt252 {
            self.commitment.write(commitment);
            commitment
        }

        fn reveal(self: @ContractState, name: felt252, amount: felt252) -> bool {
            // let auction = Auction { amount, name };
            let mut pedersen = PedersenTrait::new(0);
            let hash = pedersen.update_with(amount).update_with(name).finalize();
            let stored_commitment = self.commitment.read();

            stored_commitment == hash
        }
    }
}
// ANCHOR_END: hash
#[cfg(test)]
mod tests {
    use starknet::SyscallResultTrait;
    use super::{
        CommitmentRevealTraits, ICommitmentRevealTraitDispatcher,
        ICommitmentRevealTraitDispatcherTrait
    };

    use core::hash::{HashStateTrait, HashStateExTrait};
    use core::pedersen::PedersenTrait;
    use starknet::syscalls::deploy_syscall;

    fn deploy() -> ICommitmentRevealTraitDispatcher {
        let mut calldata = array![];
        let (address, _) = deploy_syscall(
            CommitmentRevealTraits::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
        .unwrap_syscall();
        ICommitmentRevealTraitDispatcher { contract_address: address }
    }

    #[test]
    #[available_gas(20000000)]
    fn commit_and_reveal() {
        let mut contract = deploy();

        // Off-chain, compute the commitment hash for (name, amount)
        let name: felt252 = 'lamsy'.try_into().unwrap();
        let amount: felt252 = 100.try_into().unwrap();
        let mut pedersen = PedersenTrait::new(0);
        let offchain_commitment = pedersen.update_with(amount).update_with(name).finalize();

        // Commit on-chain
        contract.commit(offchain_commitment);

        // Reveal on-chain and assert the result
        let reveal_result = contract.reveal(name, amount);
        assert!(reveal_result, "Incorrect auction details");
    }
}

