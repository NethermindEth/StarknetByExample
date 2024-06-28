use starknet::account::Call;
use starknet::crypto::hash::starknet_keccak;
use core::array::Array;
use core::array::ArrayTrait;

#[starknet::interface]
trait ISRC6<TContractState> {
    fn execute_calls(self: @TContractState, calls: Array<Call>) -> Array<Span<felt252>>;
    fn validate_calls(self: @TContractState, calls: Array<Call>) -> felt252;
    fn is_valid_signature(
        self: @TContractState, hash: felt252, signature: Array<felt252>
    ) -> felt252;
}

#[starknet::interface]
trait ISRC5<TContractState> {
    fn supports_interface(self: @TContractState, interface_id: felt252) -> bool;
}

#[starknet::contract]
mod simpleAccount {
    use super::{ISRC5, ISRC6};
    use starknet::account::Call;
    use core::num::traits::Zero;
    use core::ecdsa::check_ecdsa_signature;

    #[storage]
    struct Storage {
        public_key: felt252,
    }

    // Define interface IDs as constants
    const ISRC5_ID: felt252 = starknet_keccak("supports_interface(felt252)->E((),())");
    const ISRC6_ID_1: felt252 = starknet_keccak("execute_calls(Array<(ContractAddress,felt252,Array<felt252>)>)->Array<(@Array<felt252>)>");
    const ISRC6_ID_2: felt252 = starknet_keccak("validate_calls(Array<(ContractAddress,felt252,Array<felt252>)>)->felt252");
    const ISRC6_ID_3: felt252 = starknet_keccak("is_valid_signature(felt252,Array<felt252>)->felt252");
    const ISRC6_ID: felt252 = ISRC6_ID_1 ^ ISRC6_ID_2 ^ ISRC6_ID_3;

    #[constructor]
    fn constructor(ref self: ContractState, public_key: felt252) {
        self.public_key.write(public_key);
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
            self: @ContractState, hash: felt252, signature: Array<felt252>
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
            self: @ContractState, hash: felt252, signature: Span<felt252>
        ) -> bool {
            check_ecdsa_signature(
                hash, self.public_key.read(), *signature.at(0_u32), *signature.at(1_u32)
            )
        }
    }

    #[abi(embed_v0)]
    impl SRC5 of ISRC5<ContractState> {
        fn supports_interface(self: @ContractState, interface_id: felt252) -> bool {
            let supported_interfaces = array![ISRC5_ID, ISRC6_ID];

            for id in supported_interfaces {
                if id == interface_id {
                    return true;
                }
            }
            false
        }
    }
}