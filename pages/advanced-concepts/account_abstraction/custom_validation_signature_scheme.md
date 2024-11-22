# Custom Signature Validation Scheme

Digital signatures are a fundamental aspect of modern cryptography used to verify the authenticity and integrity of digital messages or transactions. They are based on public-key cryptography, where a pair of keys (a public key and a private key) are used to create and verify signatures.

Private keys are kept secret and secured by the owner. They are used to sign data such as messages or transactions, which can be verified by anyone with the public key.

Account Abstraction is a native feature on Starknet, this makes it possible for anyone to implement custom signature schemes and use it to validate transactions with the implementation of the signature validation logic.

### The Concepts of Accounts and Signers

i. **Account:** All accounts are smart contracts that can hold assets and execute transactions on Starknet, these account contracts however must implement some specific methods outlined in [SNIP-6.](https://github.com/starknet-io/SNIPs/blob/main/SNIPS/snip-6.md)

ii. **Signers:** These are responsible for digitally signing transactions and also provide the authorization needed to initiate transactions. Transaction signing is done offchain on Starknet.

Digital signatures are cryptographic proofs that transactions are authorized by corresponding accounts.

### Signature validation on Starknet

On Starknet transactions are signed offchain, which means that the signature process happens outside the blockchain. The signed transaction is then submitted to Starknet network for verification and execution. Read more: [Starknet-js docs](https://www.starknetjs.com/docs/guides/signature/)

All Account contracts on Starknet must implement the SNIP-6 standard as already stated. The methods outlined in the standard provide means to move offchain signatures onchain and execute them. More details below:

```cairo
// [!include ~/listings/advanced-concepts/simple_account/src/simple_account.cairo]
```

On Ethereum, only **one** signature scheme is used: ECDSA. It makes Ethereum more secure but less flexible.
Custom signature validation used on Starknet gives room for more flexibility, however, care must be taken to validate all signatures meticulously to ensure that:

a. the message has not been altered.
b. the signer owns the private key corresponding to the public key.


### Custom signature validation sample

The example below shows a sample validation of `Secp256r1` and `Secp256k1` signature schemes:

```cairo
// [!include ~/listings/advanced-concepts/custom_signature_validation/src/custom_signature.cairo:is_valid_signature]
```