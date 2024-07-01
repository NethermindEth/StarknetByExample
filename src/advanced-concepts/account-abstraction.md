# Account Abstraction

### Understanding Ethereum Account System

Traditionally, there are two types of account on Ethereum: Externally Owned Accounts known as EOAs and smart contract Accounts.

EOAs are normal accounts used by individuals, they have private keys and can sign transactions. Smart contract accounts do not have private keys, therefore they cannot initiate or sign transactions. All transactions on Ethereum must be initiated by an EOA.

Ethereum accounts have many challenges such as:

i. Key Management: Users must secure and never lose their seed phrase and private keys, otherwise they risk losing access to their accounts and assets forever. 

Also, once a thief gains access to your private keys or seed phrase, he gains complete access to your account and its assets.

ii. Bad User Experience: The account system used on Ethereum makes it difficult for newbies to use crypto applications as they are always complicated to use. 
Lack of account recovery options also makes it unappealing to users.

iii. Lack of Flexibility: Ethereum account system restricts custom transaction validation schemes, limiting potential enhancements on access control and security.


### What is Account Abstraction?

Account Abstraction is the concept of modifying accounts and enhancing transactions on blockchain networks. 
Account Abstraction replaces EOAs with a broader model where all accounts are smart contracts, each with its own unique rules and behaviors. 

Account Abstraction makes it possible for innovative account management system such as custom signature types, session keys, 2 Factor Authentication (2FA), fingerprint or facial recognition account signing, ability to pay for gas using other tokens such as USDT, ability to recover accounts without seed phrase, email recovery of accounts and so on.

### The Most Important Concepts

i. **Account:** All accounts are smart contracts that can hold assets and execute transactions on Starknet protocol, these account contracts however must implement some specific methods outlined in SNIP-6.

ii. **Signers:** These are responsible for digitally signing transactions and provide the authorization needed to initiate transactions. 
Digital signatures are cryptographic proofs that transactions are authorized by corresponding accounts.

In summary, Starknet accounts are normal blockchain accounts that hold assets and initiate transactions onchain, while signers provide the authorization required to ensure that transactions originating from these accounts are secure, valid and executed.

To implement custom validation method on Starknet you have to ensure that the contract contains these three methods: `is_valid_signature`, `__validate__` and `__execute__`. These are the building block for account contracts on Starknet as contained in the SNIP-6.



