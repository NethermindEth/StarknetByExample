# Hash Solidity Compatible

This StarkNet smart contract showcases a method to hash values using cairo Keccak in a way that aligns with Solidity's keccak256 hash function. The key distinction lies in handling the endianness: Solidity operates with big-endian format, while Cairo uses little-endian. The contract uses keccak_u256s_be_inputs for hashing and then addresses the endianness mismatch by dividing the 256-bit hash into two 128-bit segments, reversing each segment, and recombining them. This ensures the final hash is compatible with Solidity's expectations.

```rust
{{#include ../../listings/ch02-advanced-concepts/hash_solidity_compatible/src/hash_solidity_compatible.cairo}}
```
Visit contract on [Voyager](#) or play with it in [Remix](#).
