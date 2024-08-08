# Custom Signature Validation Scheme

Digital signatures are a fundamental aspect of modern cryptography, used to verify the authenticity and integrity of digital messages or transactions. They are based on public-key cryptography, where a pair of keys (a public key and a private key) are used to create and verify signatures.
Private keys are kept secret and secure by the owner, and are used to sign the message or transaction, while the public key can be used by anyone to verify the signature.

Account Abstraction is a native feature on Starknet, this makes it possible for anyone to implement custom signature schemes. The implication is that signature schemes on Starknet are not limited to just one, any standard signature scheme can be validated, for example Starknet signature, Secp256k1, Secp256r1, Eip191 etc are some of the custom signatures that can be validated on Starknet currently.

### The Concepts of Accounts and Signers

i. **Account:** All accounts are smart contracts that can hold assets and execute transactions on Starknet, these account contracts however must implement some specific methods outlined in SNIP-6. For further reading: [Account contract](https://starknet-by-example.voyager.online/advanced-concepts/account_abstraction/account_contract.html).

ii. **Signers:** These are responsible for digitally signing transactions and provide the authorization needed to initiate transactions.
Digital signatures are cryptographic proofs that transactions are authorized by corresponding accounts.

### Signature validation on Starknet

On Starknet transactions are signed offchain, which means that the signature process happens outside the blockchain. The signed transaction is then submitted to Starknet network for verification and execution. Read more: [Starknet-js docs](https://www.starknetjs.com/docs/guides/signature/)

All Account contracts on Starknet must implement the SNIP-6 standard as mentioned earlier. The methods implemented in the SNIP-6 standard provide means to move offchain signatures onchain and execute them.

`is_valid_signature` returns true if the signature is valid, `__validate__` validates the signature and marks them as 'VALIDATED', while `__execute__` executes the validated transaction. Sample implementation of SNIP-6 standard: [Sample SNIP-6 Implementation](https://starknet-by-example.voyager.online/advanced-concepts/account_abstraction/account_contract.html#minimal-account-contract-executing-transactions)

On Ethereum, only **one** signature scheme is used for signing messages and transactions, and also for signature authentications: the Elliptic Curve Digital Signature Algorithm (ECDSA). That means that no other signature algorithms can be validated on Ethereum, making it more secure but less flexible.
Custom signature validation employed on Starknet gives room for more flexibility, however, care must be taken to validate all signatures meticulously to ensure that:

a. the message has not been altered.
b. the signer owns the private key corresponding to the public key.

In summary, Starknet accounts are normal blockchain accounts that hold assets and initiate transactions onchain, while signers provide the authorization required to ensure that transactions originating from these accounts are secure and valid.

### Custom signature validation sample

The example below shows a sample implementation of `Secp256r1` and `Secp256k1` signature schemes:

```rust
{{#rustdoc_include ../../listings/advanced-concepts/custom_signature_validation/src/custom_signature.cairo:custom_signature_scheme}}
```
