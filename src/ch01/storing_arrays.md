# Storing Arrays

On Starknet, complex values (e.g., tuples or structs), are stored in a continuous segment starting from the address of the storage variable. There is a 256 field elements limitation to the maximal size of a complex storage value, meaning that to store arrays of more than 255 elements in storage, we would need to split it into segments of size `n <= 255` and store these segments in multiple storage addresses. There is currently no native support for storing arrays in Cairo, so you will need to write your own implementation of the `Store` trait for the type of array you wish to store.

> Note: While storing arrays in storage is possible, it is not always recommended, as the read and write operations can get very costly. For example, reading an array of size `n` requires `n` storage reads, and writing to an array of size `n` requires `n` storage writes. If you only need to access a single element of the array at a time, it is recommended to use a `LegacyMap` and store the length in another variable instead.

The following example demonstrates how to write a simple implementation of the `StorageAccess` trait for the `Array<felt252>` type, allowing us to store arrays of up to 255 `felt252` elements.

```rust
{{#include ../../listings/ch01-advanced-concepts/storing_arrays/src/contract.cairo:StorageAccessImpl}}
```

You can then import this implementation in your contract and use it to store arrays in storage:

```rust
{{#include ../../listings/ch01-advanced-concepts/storing_arrays/src/contract.cairo:StoreArrayContract}}
```
Visit contract on [Voyager](https://goerli.voyager.online/contract/0x008F8069a3Fcd7691Db46Dc3b6F9D2C0436f9200E861330957Fd780A3595da86) or play with it in [Remix](https://remix.ethereum.org/?#activate=Starknet&url=https://github.com/NethermindEth/StarknetByExample/blob/main/listings/ch01-advanced-concepts/storing_arrays/src/contract.cairo).
