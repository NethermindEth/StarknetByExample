# Merkle Tree

A Merkle tree is a hash-based data structure that is a generalization of the hash list. It is a tree structure in which each leaf node is a hash of a block of data, and each non-leaf node is a hash of its children. Typically, Merkle trees have a branching factor of 2, meaning that each node has up to 2 children.

If you are familiar with developing whitelists, Merkle trees actively used. In Solidity we use Keccak256 for hashing leaves. As felt252 range is not able to fit a keccak256 hash, we use Pedersen as hash function in this example. 

```rust
{{#include ../listings/ch01-applications/merkle_tree/src/merkle_tree.cairo}}
```