#[cfg(test)]
mod tests {
    use starknet::secp256_trait::{
        Secp256Trait, Secp256PointTrait, Signature, signature_from_vrs, recover_public_key,
        is_signature_entry_valid
    };

    use starknet::EthAddress;
    use starknet::secp256k1::{Secp256k1Point};
    use core::traits::{TryInto, Into};
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
    #[available_gas(100000000)]
    fn test_verify_eth_signature() {
        let (msg_hash, signature, eth_address) = get_message_and_signature();
        verify_eth_signature(:msg_hash, :signature, :eth_address);
    }

    #[test]
    #[available_gas(100000000)]
    fn test_secp256k1_recover_public_key() {
        let (msg_hash, signature, eth_address) = get_message_and_signature();
        let public_key_point = recover_public_key::<Secp256k1Point>(msg_hash, signature).unwrap();
        let calculated_eth_address = public_key_point_to_eth_address(:public_key_point);
        assert(calculated_eth_address == eth_address, 'Invalid Address');
    }
}
