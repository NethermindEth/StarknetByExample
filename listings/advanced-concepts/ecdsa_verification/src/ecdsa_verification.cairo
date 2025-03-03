// [!region contract]
use core::starknet::eth_address::EthAddress;
use starknet::secp256_trait::{Signature};

// How to Sign and Verify
// # Signing
// 1. Create message to sign
// 2. Hash the message
// 3. Sign the hash (off chain, keep your private key secret)
#[starknet::interface]
trait IVerifySignature<TContractState> {
    fn get_signature(self: @TContractState, r: u256, s: u256, v: u32) -> Signature;
    fn verify_eth_signature(
        self: @TContractState, eth_address: EthAddress, msg_hash: u256, r: u256, s: u256, v: u32,
    );
    fn recover_public_key(
        self: @TContractState, eth_address: EthAddress, msg_hash: u256, r: u256, s: u256, v: u32,
    );
}

#[starknet::contract]
mod verifySignature {
    use super::IVerifySignature;
    use core::starknet::eth_address::EthAddress;
    use starknet::secp256k1::Secp256k1Point;
    use starknet::secp256_trait::{Signature, signature_from_vrs, recover_public_key};
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
        fn get_signature(self: @ContractState, r: u256, s: u256, v: u32) -> Signature {
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
            self: @ContractState, eth_address: EthAddress, msg_hash: u256, r: u256, s: u256, v: u32,
        ) {
            let signature = self.get_signature(r, s, v);
            verify_eth_signature(:msg_hash, :signature, :eth_address);
        }

        /// Recovers the public key from an Ethereum signature and verifies that it matches the
        /// given Ethereum address.
        ///
        /// # Arguments
        ///
        /// * `eth_address` - The Ethereum address to verify the signature against.
        /// * `msg_hash` - The hash of the message that was signed.
        /// * `r` - The R component of the signature.
        /// * `s` - The S component of the signature.
        /// * `v` - The V component of the signature.
        fn recover_public_key(
            self: @ContractState, eth_address: EthAddress, msg_hash: u256, r: u256, s: u256, v: u32,
        ) {
            let signature = self.get_signature(r, s, v);
            let public_key_point = recover_public_key::<Secp256k1Point>(msg_hash, signature)
                .unwrap();
            let calculated_eth_address = public_key_point_to_eth_address(:public_key_point);
            assert(calculated_eth_address == eth_address, 'Invalid Address');
        }
    }
}
// [!endregion contract]

#[cfg(test)]
mod tests {
    use starknet::secp256_trait::{Signature, signature_from_vrs, recover_public_key};
    use starknet::EthAddress;
    use starknet::secp256k1::{Secp256k1Point};
    use starknet::eth_signature::{verify_eth_signature, public_key_point_to_eth_address};

    fn get_message_and_signature() -> (u256, Signature, EthAddress) {
        let msg_hash = 0x546ec3fa4f7d3308931816fafd47fa297afe9ac9a09651f77acc13c05a84734f;
        let r = 0xc0f30bcef72974dedaf165cf7848a83b0b9eb6a65167a14643df96698d753efb;
        let s = 0x7f189e3cb5eb992d8cd26e287a13e900326b87f58da2b7fb48fbd3977e3cab1c;
        let v = 27;

        let eth_address = 0x5F04693482cfC121FF244cB3c3733aF712F9df02_u256.into();
        let signature: Signature = signature_from_vrs(v, r, s);

        (msg_hash, signature, eth_address)
    }

    #[test]
    fn test_verify_eth_signature() {
        let (msg_hash, signature, eth_address) = get_message_and_signature();
        verify_eth_signature(msg_hash, signature, eth_address);
    }

    #[test]
    fn test_secp256k1_recover_public_key() {
        let (msg_hash, signature, eth_address) = get_message_and_signature();
        let public_key_point = recover_public_key::<Secp256k1Point>(msg_hash, signature).unwrap();
        let calculated_eth_address = public_key_point_to_eth_address(public_key_point);
        assert_eq!(calculated_eth_address, eth_address);
    }
}
