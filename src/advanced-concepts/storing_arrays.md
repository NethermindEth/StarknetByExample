# Storing Arrays

On Starknet, complex values (e.g. tuples or structs) are stored in a continuous segment starting from the address of the storage variable. There is a limitation in Cairo that restricts complex storage values to a maximum of 256 field elements. This means that to store arrays with more than 255 elements, you would have to split them into segments of size `n <= 255` and store these segments at multiple storage addresses. There is currently no native support for storing arrays in Cairo, so you would need to write your own implementation of the `Store` trait for the array type you wish to store.

However, the `ByteArray` struct can be used to store `Array<bytes31>` in storage without additional implementation. Before implementing your own `Store` trait, consider wether the `ByteArray` struct can be used to store the data you need! See the [ByteArray](../getting-started/basics/bytearrays-strings.md#bytearray-long-strings) section for more information.

> Note: While storing arrays in storage is possible, it is not always recommended, as the read and write operations can get very costly. For example, reading an array of size `n` requires `n` storage reads, and writing to an array of size `n` requires `n` storage writes. If you only need to access a single element of the array at a time, it is recommended to use a `Map` and store the length in another variable instead.

The following example demonstrates how to write a simple implementation of the `StorageAccess` trait for the `Array<felt252>` type, allowing us to store arrays of up to 255 `felt252` elements.

```rust
{{#include ../../listings/advanced-concepts/storing_arrays/src/contract.cairo:StorageAccessImpl}}
```

You can then import this implementation in your contract and use it to store arrays in storage:

```rust
{{#include ../../listings/advanced-concepts/storing_arrays/src/contract.cairo:StoreArrayContract}}
```
