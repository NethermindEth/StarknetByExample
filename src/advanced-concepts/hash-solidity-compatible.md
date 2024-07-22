# Hash Solidity Compatible

This contract demonstrates Keccak hashing in Cairo to match Solidity's keccak256. While both use Keccak, their endianness differs: Cairo is little-endian, Solidity big-endian. The contract achieves compatibility by hashing in big-endian using `keccak_u256s_be_inputs`, and reversing the bytes of the result with `u128_byte_reverse`.

For example:

```rust
{{#include ../../listings/advanced-concepts/hash_solidity_compatible/src/contract.cairo}}
```
