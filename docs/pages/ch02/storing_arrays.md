---
content:
  horizontalPadding: 50px
  width: 100%
  verticalPadding: 30px
---

# Storing Arrays

On Starknet, complex values (e.g., tuples or structs), are stored in a continuous segment starting from the address of the storage variable. There is a 256 field elements limitation to the maximal size of a complex storage value, meaning that to store arrays of more than 255 elements in storage, we would need to split it into segments of size `n <= 255` and store these segments in multiple storage addresses. There is currently no native support for storing arrays in Cairo, so you will need to write your own implementation of the `Store` trait for the type of array you wish to store.

However, the `ByteArray` struct can be used to store `Array<bytes31>` in storage without additional implementation. Before implementing your own `Store` trait, consider wether the `ByteArray` struct can be used to store the data you need! See the [ByteArray](../ch00/basics/bytearrays-strings.md#bytearray-long-strings) section for more information.

> Note: While storing arrays in storage is possible, it is not always recommended, as the read and write operations can get very costly. For example, reading an array of size `n` requires `n` storage reads, and writing to an array of size `n` requires `n` storage writes. If you only need to access a single element of the array at a time, it is recommended to use a `LegacyMap` and store the length in another variable instead.

The following example demonstrates how to write a simple implementation of the `StorageAccess` trait for the `Array<felt252>` type, allowing us to store arrays of up to 255 `felt252` elements.

```rust
// [!include ~/snippets/listings/advanced-concepts/storing_arrays/src/contract.cairo:StorageAccessImpl]
```

You can then import this implementation in your contract and use it to store arrays in storage:

```rust
// [!include ~/snippets/listings/advanced-concepts/storing_arrays/src/contract.cairo:StoreArrayContract]
```
