#[starknet::interface]
trait IHashTrait<T> {
    fn save_user_with_poseidon(
        ref self: T, id: felt252, username: felt252, password: felt252
    ) -> felt252;
    fn save_user_with_pedersen(
        ref self: T, id: felt252, username: felt252, password: felt252
    ) -> felt252;
}

// ANCHOR: hash
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
    struct LoginDetails {
        username: felt252,
        password: felt252,
    }

    #[derive(Drop, Hash)]
    struct UserDetails {
        id: felt252,
        login: LoginDetails,
    }

    #[abi(embed_v0)]
    impl HashTrait of super::IHashTrait<ContractState> {
        fn save_user_with_poseidon(
            ref self: ContractState, id: felt252, username: felt252, password: felt252
        ) -> felt252 {
            let login = LoginDetails { username, password };
            let user = UserDetails { id, login };

            let poseidon_hash = PoseidonTrait::new().update_with(user).finalize();

            self.user_hash_poseidon.write(poseidon_hash);
            poseidon_hash
        }

        fn save_user_with_pedersen(
            ref self: ContractState, id: felt252, username: felt252, password: felt252
        ) -> felt252 {
            let login = LoginDetails { username, password };
            let user = UserDetails { id, login };

            let pedersen_hash = PedersenTrait::new(0).update_with(user).finalize();

            self.user_hash_pedersen.write(pedersen_hash);
            pedersen_hash
        }
    }
}
// ANCHOR_END: hash

#[cfg(test)]
mod tests {
    use core::starknet::SyscallResultTrait;
    use super::{HashTraits, IHashTraitDispatcher, IHashTraitDispatcherTrait};

    use core::hash::{HashStateTrait, HashStateExTrait};
    use core::{pedersen::PedersenTrait, poseidon::PoseidonTrait};
    use starknet::syscalls::deploy_syscall;

    fn deploy() -> IHashTraitDispatcher {
        let mut calldata = ArrayTrait::new();
        let (address, _) = deploy_syscall(
            HashTraits::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap_syscall();
        IHashTraitDispatcher { contract_address: address }
    }


    #[test]
    #[available_gas(20000000)]
    fn test_pedersen_hash() {
        let mut contract = deploy();

        let id = 0x1;
        let username = 'A.stark';
        let password = 'password.stark';
        let test_hash = contract.save_user_with_pedersen(id, username, password);

        assert(
            test_hash == 0x6da4b4d0489989f5483d179643dafb3405b0e3b883a6c8efe5beb824ba9055a,
            'Incorrect hash output'
        );
    }

    #[test]
    #[available_gas(20000000)]
    fn test_poseidon_hash() {
        let mut contract = deploy();

        let id = 0x1;
        let username = 'A.stark';
        let password = 'password.stark';

        let test_hash = contract.save_user_with_poseidon(id, username, password);

        assert(
            test_hash == 0x4d165e1d398ae4864854518d3c58c3d7a21ed9c1f8f3618fbb0031d208aab7b,
            'Incorrect hash output'
        );
    }
}
