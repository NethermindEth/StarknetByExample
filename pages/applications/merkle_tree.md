# Merkle Tree contract

A Merkle tree, also known as a hash tree, is a data structure used in cryptography and computer science to verify data integrity and consistency. It is a binary tree where each leaf node represents the cryptographic hash of some data (a transaction for example), and each non-leaf node represents the cryptographic hash of its child nodes. This hierarchical structure allows efficient and secure verification of the data integrity.

Here's a quick summary of how it operates and what functionalities it supports:

### How it works:

1. Leaves Creation:
    - Some data is hashed to create a leaf node.
2. Intermediate Nodes Creation:
    - Pairwise hashes of the leaf nodes are combined and hashed again to create parent nodes.
    - This process continues until only one hash remains, known as the Merkle root.
3. Merkle Root:
    - The final hash at the top of the tree, representing the entire dataset.
    - Changing any single data block will change its corresponding leaf node, which will propagate up the tree, altering the Merkle root.

### Key Features:

1. Efficient Verification:
    - Only a small subset of the tree (the Merkle proof) is needed to verify the inclusion of a particular data block, reducing the amount of data that must be processed.

2. Data Integrity:
    - The Merkle root ensures the integrity of all the underlying data blocks.
    - Any alteration in the data will result in a different root hash.

### Examples of use cases:

1. Fundamental use case: Ethereum blockchain integrity
    - Cryptocurrencies like Ethereum use Merkle trees to efficiently verify and maintain transaction integrity within blocks.
    - Each transaction in a block is hashed to form leaf nodes, and these hashes are recursively combined to form a single Merkle root, summarizing all transactions.
    - The Merkle root is stored in the block header, which is hashed to generate the block's unique identifier.
    - <u>Guaranteed Integrity:</u> Any change to a transaction alters the Merkle root, block header, and block hash, making it easy for nodes to detect tampering.
    - <u>Transaction verification:</u> Nodes can verify specific transactions via Merkle proofs without downloading the entire block.

2. Whitelist inclusion
    - Merkle trees allow efficient whitelist verification without storing the full list on-chain, reducing storage costs.
    - The Merkle root of the whitelist is stored on-chain, while the full list remains off-chain.
    - To verify if an address is on the whitelist, a user provides a Merkle proof and the address. The Merkle root is recalculated using the provided data and compared to the stored on-chain root. If they match, the address is included; if not, it's excluded.

3. Decentralized Identity Verification
    - Merkle trees can be used in decentralized identity systems to verify credentials.
    - Off-chain data: a user's credentials.
    - On-chain data: the Merkle root representing the credentials.

### Visual example

![Diagram of the Merkle Tree](/merkle_root.png)

The above diagram represents a merkle tree.\
Each leaf node is the hash of some data.\
Each other node is the hash of the combination of both children nodes.

If we were to `verify{:md}` the `hash 6{:md}`, the merkle proof would need to contain the `hash 5{:md}`, `hash 12{:md}`and `hash 13{:md}`:
  1. The `hash 5{:md}` would be combined with the `hash 6{:md}` to re-compute the `hash 11{:md}`.
  2. The newly computed `hash 11{:md}` in step 1 would be combined with `hash 12{:md}` to re-compute `hash 14{:md}`.
  3. The `hash 13{:md}` would be combined with the newly computed `hash 14{:md}` in step 2 to re-compute the merkle root.
  4. We can then compare the computed resultant merkle root with the one provided to the `verify{:md}` function.

### Code

The following implementation is the Cairo adaptation of the [Solidity by Example - Merkle Tree contract](https://solidity-by-example.org/app/merkle-tree/).

```cairo
// [!include ~/listings/applications/merkle_tree/src/contract.cairo]
```
