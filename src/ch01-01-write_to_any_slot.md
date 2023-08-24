# Writing to any storage slot

On Starknet, a contract's storage is a map with 2^251 slots, where each slot is a felt which is initialized to 0.
The address of storage variables is computed at compile time using the formula: `storage variable address := pedersen(keccak(variable name), keys)`. Interactions with storage variables are commonly performed using the `self.var.read()` and `self.var.write()` functions.

Nevertheless, we can use the `storage_write_syscall` and `storage_read_syscall` syscalls, to write to and read from any storage slot.
This is useful when writing to storage variables that are not known at compile time, or to ensure that even if the contract is upgraded and the computation method of storage variable addresses changes, they remain accessible.

In the following example, we use the Poseidon hash function to compute the address of a storage variable. Poseidon is a ZK-friendly hash function that is cheaper and faster than Pedersen, making it an excellent choice for onchain computations. Once the address is computed, we use the storage syscalls to interact with it.

```rust
{{#include ../listings/ch01-advanced-concepts/write_to_any_slot/src/write_any_slot.cairo}}
```
Visit contract on [Voyager](https://goerli.voyager.online/contract/0x033943CB781A4E63C9dcE0A1A09eAa3b617AA43CC61637C08c043a67f3fe0087) or play with it in [Remix](https://remix.ethereum.org/?#activate=Starknet-cairo1-compiler&url=https://github.com/NethermindEth/StarknetByExample/blob/main/listings/ch01-advanced-concepts/write_to_any_slot/src/write_any_slot.cairo).
