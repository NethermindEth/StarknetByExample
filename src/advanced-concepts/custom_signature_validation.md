# Custom Signature Validation Scheme

Account Abstraction on Starknet supports various signature schemes. This means that signature schemes on Starknet are not limited to just one, any standard signature scheme can be validated, for example Starknet signature, Secp256k1, Secp256r1, Eip191 et al are some of the custom signatures that can be validated on Starknet currently. 

### The Concepts of Accounts and Signers

i. **Account:** All accounts are smart contracts that can hold assets and execute transactions on Starknet protocol, these account contracts however must implement some specific methods outlined in SNIP-6.

ii. **Signers:** These are responsible for digitally signing transactions and provide the authorization needed to initiate transactions. 
Digital signatures are cryptographic proofs that transactions are authorized by corresponding accounts.

In summary, Starknet accounts are normal blockchain accounts that hold assets and initiate transactions onchain, while signers provide the authorization required to ensure that transactions originating from these accounts are secure, valid and executed.

To implement custom validation method on Starknet you have to ensure that the contract contains these three methods: `is_valid_signature`, `__validate__` and `__execute__`. These are the building block for account contracts on Starknet as contained in the SNIP-6.



