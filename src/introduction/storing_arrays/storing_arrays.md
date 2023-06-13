# Storing Arrays

There is currently no native support for storing arrays in Cairo.
The following example demonstrates how to write a simple implementation of the `StorageAccess` trait
for the `Array<felt252>` type, allowing us to store arrays of up to 255 felt252 elements.

On Starknet, complex values (e.g., tuples or structs), are stored in a continuous segment starting from the address of the storage variable. There is a 256 field elements limitation to the maximal size of a complex storage value, meaning that to store arrays of more than 255 elements in storage, we would need to split it into segments of size `n <= 255` and store these segments in multiple storage addresses.
