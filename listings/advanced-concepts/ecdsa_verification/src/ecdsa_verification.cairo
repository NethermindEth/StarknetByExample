// How to Sign and Verify
// # Signing
// 1. Create message to sign
// 2. Hash the message
// 3. Sign the hash (off chain, keep your private key secret)

use core::starknet::eth_address::EthAddress;
use starknet::secp256_trait::{Signature};
#[starknet::interface]
trait IVerifySignature<TContractState> {
    fn get_signature(self: @TContractState, r: u256, s: u256, v: u32,) -> Signature;
    fn verify_eth_signature(
        self: @TContractState, eth_address: EthAddress, msg_hash: u256, r: u256, s: u256, v: u32,
    );
    fn recover_public_key(
        self: @TContractState, eth_address: EthAddress, msg_hash: u256, r: u256, s: u256, v: u32
    );
}

#[starknet::contract]
mod verifySignature {
    use super::IVerifySignature;
    use core::starknet::eth_address::EthAddress;
    use starknet::get_caller_address;
    use starknet::secp256_trait;
    use starknet::secp256k1::{Secp256k1Point};
    use starknet::{SyscallResult, SyscallResultTrait};
    use starknet::secp256_trait::{
        Secp256Trait, Secp256PointTrait, Signature, signature_from_vrs, recover_public_key,
        is_signature_entry_valid
    };
    use core::traits::{TryInto, Into};
    use starknet::eth_signature::{verify_eth_signature, public_key_point_to_eth_address};

    #[storage]
    struct Storage {
        msg_hash: u256,
        signature: Signature,
        eth_address: EthAddress,
    }

    #[abi(embed_v0)]
    impl VerifySignature of IVerifySignature<ContractState> {
        /// This function returns the signature struct for the given parameters.
        ///
        /// # Arguments
        ///
        /// * `r` - The R component of the signature.
        /// * `s` - The S component of the signature.
        /// * `v` - The V component of the signature.
        ///
        /// # Returns
        ///
        /// * `Signature` - The signature struct.
        fn get_signature(self: @ContractState, r: u256, s: u256, v: u32,) -> Signature {
            // Create a Signature object from the given v, r, and s values.
            let signature: Signature = signature_from_vrs(v, r, s);
            signature
        }


        /// Verifies an Ethereum signature.
        ///
        /// # Arguments
        ///
        /// * `eth_address` - The Ethereum address to verify the signature against.
        /// * `msg_hash` - The hash of the message that was signed.
        /// * `r` - The R component of the signature.
        /// * `s` - The S component of the signature.
        /// * `v` - The V component of the signature.
        fn verify_eth_signature(
            self: @ContractState, eth_address: EthAddress, msg_hash: u256, r: u256, s: u256, v: u32
        ) {
            let signature = self.get_signature(r, s, v);
            verify_eth_signature(:msg_hash, :signature, :eth_address);
        }

        /// Recovers the public key from an Ethereum signature and verifies that it matches the given Ethereum address.
        ///
        /// # Arguments
        ///
        /// * `eth_address` - The Ethereum address to verify the signature against.
        /// * `msg_hash` - The hash of the message that was signed.
        /// * `r` - The R component of the signature.
        /// * `s` - The S component of the signature.
        /// * `v` - The V component of the signature.
        fn recover_public_key(
            self: @ContractState, eth_address: EthAddress, msg_hash: u256, r: u256, s: u256, v: u32
        ) {
            let signature = self.get_signature(r, s, v);
            let public_key_point = recover_public_key::<Secp256k1Point>(msg_hash, signature)
                .unwrap();
            let calculated_eth_address = public_key_point_to_eth_address(:public_key_point);
            assert(calculated_eth_address == eth_address, 'Invalid Address');
        }
    }
}

