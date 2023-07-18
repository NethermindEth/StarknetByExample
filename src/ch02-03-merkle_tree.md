# Merkle Tree

A Merkle tree is a hash-based data structure that is a generalization of the hash list. It is a tree structure in which each leaf node is a hash of a block of data, and each non-leaf node is a hash of its children. Typically, Merkle trees have a branching factor of 2, meaning that each node has up to 2 children.

Merkle trees are particularly used to create whitelists. In Solidity, we use Keccak256 to hash the nodes - but in Cairo, we will prefer using Pedersen or Poseidon as they are cheaper to execute.

```rust
{{#include ../listings/ch02-applications/merkle_tree/src/merkle_tree.cairo}}
```
