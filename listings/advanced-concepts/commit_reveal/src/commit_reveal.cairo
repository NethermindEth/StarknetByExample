// this is an example of how to use the commitment scheme  on a auction;

#[starknet::interface]
pub trait ICommitmentRevealTrait<T> {
    fn commit(ref self: T, name: felt252, amount: felt252) -> felt252;
    fn reveal(self: @T, name: felt252, amount: felt252) -> bool;
}

// ANCHOR: hash
#[starknet::contract]
pub mod CommitmentRevealTraits {
    use core::hash::{HashStateTrait, HashStateExTrait};
    use core::pedersen::PedersenTrait;

    #[storage]
    struct Storage {
        message_hash: felt252,
    }

    #[derive(Drop, Hash)]
    struct Auction {
        amount: felt252,
        name: felt252,
    }


    #[abi(embed_v0)]
    impl CommitmentRevealTrait of super::ICommitmentRevealTrait<ContractState> {
        fn commit(ref self: ContractState, name: felt252, amount: felt252) -> felt252 {
            let auction = Auction { amount, name };
            let pedersen_hash = PedersenTrait::new(0).update_with(auction).finalize();

            self.message_hash.write(pedersen_hash);

            pedersen_hash
        }

        fn reveal(self: @ContractState, name: felt252, amount: felt252) -> bool {
            let auction = Auction { amount, name };
            let hash = PedersenTrait::new(0).update_with(auction).finalize();
            let pedersen_hash = self.message_hash.read();

            if (pedersen_hash == hash) {
                true
            } else {
                false
            }
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
    fn commit() {
        let mut contract = deploy();

        let amount = 100;
        let name = 'lamsy';
        let test_hash = contract.commit(name, amount);
        let test_reveal = contract.reveal(name, amount);
        println!("test reveal: {}", test_reveal);
        println!("test hash: {}", test_hash);
        assert(test_reveal == true, 'false');
    }
}
