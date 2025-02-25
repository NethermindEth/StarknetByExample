use starknet::account::Call;

#[starknet::interface]
trait ISRC6<TContractState> {
    fn execute_calls(self: @TContractState, calls: Array<Call>) -> Array<Span<felt252>>;
    fn validate_calls(self: @TContractState, calls: Array<Call>) -> felt252;
    fn is_valid_signature(
        self: @TContractState, hash: felt252, signature: Array<felt252>,
    ) -> felt252;
}

#[starknet::contract]
mod simpleAccount {
    use super::ISRC6;
    use starknet::account::Call;
    use core::num::traits::Zero;
    use core::ecdsa::check_ecdsa_signature;
    use starknet::storage::{StoragePointerWriteAccess, StoragePointerReadAccess};

    // Implement SRC5 with openzeppelin
    use openzeppelin_account::interface;
    use openzeppelin_introspection::src5::SRC5Component;
    component!(path: SRC5Component, storage: src5, event: SRC5Event);

    #[abi(embed_v0)]
    impl SRC5Impl = SRC5Component::SRC5Impl<ContractState>;
    impl SRC5InternalImpl = SRC5Component::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        src5: SRC5Component::Storage,
        public_key: felt252,
    }

    #[constructor]
    fn constructor(ref self: ContractState, public_key: felt252) {
        self.src5.register_interface(interface::ISRC6_ID);
        self.public_key.write(public_key);
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        SRC5Event: SRC5Component::Event,
    }

    #[abi(embed_v0)]
    impl SRC6 of ISRC6<ContractState> {
        fn execute_calls(self: @ContractState, calls: Array<Call>) -> Array<Span<felt252>> {
            assert(starknet::get_caller_address().is_zero(), 'Not Starknet Protocol');
            let Call { to, selector, calldata } = calls.at(0);
            let res = starknet::syscalls::call_contract_syscall(*to, *selector, *calldata).unwrap();
            array![res]
        }

        fn validate_calls(self: @ContractState, calls: Array<Call>) -> felt252 {
            assert(starknet::get_caller_address().is_zero(), 'Not Starknet Protocol');
            let tx_info = starknet::get_tx_info().unbox();
            let tx_hash = tx_info.transaction_hash;
            let signature = tx_info.signature;
            if self._is_valid_signature(tx_hash, signature) {
                starknet::VALIDATED
            } else {
                0
            }
        }

        fn is_valid_signature(
            self: @ContractState, hash: felt252, signature: Array<felt252>,
        ) -> felt252 {
            if self._is_valid_signature(hash, signature.span()) {
                starknet::VALIDATED
            } else {
                0
            }
        }
    }

    #[generate_trait]
    impl SignatureVerificationImpl of SignatureVerification {
        fn _is_valid_signature(
            self: @ContractState, hash: felt252, signature: Span<felt252>,
        ) -> bool {
            check_ecdsa_signature(
                hash, self.public_key.read(), *signature.at(0_u32), *signature.at(1_u32),
            )
        }
    }
}
