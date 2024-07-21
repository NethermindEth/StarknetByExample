// ANCHOR: custom_signature_scheme
use starknet::secp256_trait::{
    Secp256PointTrait, Signature as Secp256Signature, recover_public_key, is_signature_entry_valid
};
use starknet::secp256r1::Secp256r1Point;
use starknet::secp256k1::Secp256k1Point;
use starknet::{ EthAddress, eth_signature::is_eth_signature_valid };
use core::traits::TryInto;


const SECP256R1_SIGNER_TYPE: felt252 = 'Secp256r1 Signer';
const SECP256K1_SIGNER_TYPE: felt252 = 'Secp256k1 Signer';
const SECP_256_R1_HALF: u256 = 0xffffffff00000000ffffffffffffffffbce6faada7179e84f3b9cac2fc632551 / 2;
const SECP_256_K1_HALF: u256 = 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141 / 2;



#[derive(Drop, Copy, PartialEq, Serde, Default)]
enum SignerType {
    #[default]
    Secp256r1,
    Secp256k1,
}

#[derive(Drop, Copy, Serde)]
enum SignerSignature {
    Secp256r1: (Secp256r1Signer, Secp256Signature),
    Secp256k1: (Secp256k1Signer, Secp256Signature),
}

#[derive(Drop, Copy, Serde)]
enum Signer {
    Secp256r1: Secp256r1Signer,
    Secp256k1: Secp256k1Signer,
}

#[derive(Drop, Copy, Serde, PartialEq)]
struct Secp256r1Signer {
    pubkey: NonZero<u256>
}

#[derive(Drop, Copy, PartialEq)] 
struct Secp256k1Signer {
    pubkey_hash: EthAddress
}


// To ensure the pubkey hash is not zero
impl Secp256k1SignerSerde of Serde<Secp256k1Signer> {
    #[inline(always)]
    fn serialize(self: @Secp256k1Signer, ref output: Array<felt252>) {
        self.pubkey_hash.serialize(ref output);
    }

    #[inline(always)]
    fn deserialize(ref serialized: Span<felt252>) -> Option<Secp256k1Signer> {
        let pubkey_hash = Serde::<EthAddress>::deserialize(ref serialized)?;
        assert(pubkey_hash.address != 0, 'zero pub key hash' );
        Option::Some(Secp256k1Signer { pubkey_hash })
    }
}

// To check if secp256k1 and secp256r1 signatures are valid
trait Secp256SignatureTrait {
    fn is_valid_signature(self: SignerSignature, hash: felt252) -> bool;
    fn signer(self: SignerSignature) -> Signer;
}

impl Secp256SignatureImpl of Secp256SignatureTrait {
    #[inline(always)]
    fn is_valid_signature(self: SignerSignature, hash: felt252) -> bool {
        match self {
            SignerSignature::Secp256r1((
                signer, signature
            )) => is_valid_secp256r1_signature(hash.into(), signer, signature),
            SignerSignature::Secp256k1((
                signer, signature
            )) => is_valid_secp256k1_signature(hash.into(), signer.pubkey_hash.into(), signature),
        }
    }

    #[inline(always)]
    fn signer(self: SignerSignature) -> Signer {
        match self {
            SignerSignature::Secp256k1((signer, _)) => Signer::Secp256k1(signer),
            SignerSignature::Secp256r1((signer, _)) => Signer::Secp256r1(signer),
        }
    }
}

// To validate secp256k1 signature
#[inline(always)]
fn is_valid_secp256k1_signature(hash: u256, pubkey_hash: EthAddress, signature: Secp256Signature) -> bool {
    assert(signature.s <= SECP_256_K1_HALF, 'malleable signature');
    is_eth_signature_valid(hash, signature, pubkey_hash).is_ok()
}

// To validate secp256r1 signature
#[inline(always)]
fn is_valid_secp256r1_signature(hash: u256, signer: Secp256r1Signer, signature: Secp256Signature) -> bool {
    assert(is_signature_entry_valid::<Secp256r1Point>(signature.s), 'invalid s-value');   
    assert(is_signature_entry_valid::<Secp256r1Point>(signature.r), 'invalid r-value');
    assert(signature.s <= SECP_256_R1_HALF, 'malleable signature');
    let recovered_pubkey = recover_public_key::<Secp256r1Point>(hash, signature).expect('invalid sign format');
    let (recovered_signer, _) = recovered_pubkey.get_coordinates().expect('invalid sig format');
    recovered_signer == signer.pubkey.into()
}

// impl to convert signer type into felt252 using into()
impl SignerTypeIntoFelt252 of Into<SignerType, felt252> {
    #[inline(always)]
    fn into(self: SignerType) -> felt252 {
        match self {
            SignerType::Secp256k1 => 1,
            SignerType::Secp256r1 => 2,
        }
    }
}


// impl to convert u256 type into SignerType using try_into()
impl U256TryIntoSignerType of TryInto<u256, SignerType> {
    #[inline(always)]
    fn try_into(self: u256) -> Option<SignerType> {
        if self == 1 {
            Option::Some(SignerType::Secp256k1)
        } else if self == 2 {
            Option::Some(SignerType::Secp256r1)
        } else {
            Option::None
        }
    }
}

// ANCHOR_END: custom_signature_scheme