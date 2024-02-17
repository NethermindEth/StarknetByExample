# Storage optimisation 

A smart contract has a limited amount of **storage slots**. Each slot can store a single `felt252` value.
Writing to a storage slot has a cost, so we want to use as few storage slots as possible.

In Cairo, every type is derived from the `felt252` type, which uses 252 bits to store a value.
This design is quite simple, but it does have a drawback: it is not storage efficient. For example, if we want to store a `u8` value, we need to use an entire slot, even though we only need 8 bits.

## Packing

When storing multiple values, we can use a technique called **packing**. Packing is a technique that allows us to store multiple values in a single felt value. This is done by using the bits of the felt value to store multiple values.

For example, if we want to store two `u8` values, we can use the first 8 bits of the felt value to store the first `u8` value, and the last 8 bits to store the second `u8` value. This way, we can store two `u8` values in a single felt value.

Cairo provides a built-in store using packing that you can use with the `StorePacking` trait.

```rust
trait StorePacking<T, PackedT> {
    fn pack(value: T) -> PackedT;
    fn unpack(value: PackedT) -> T;
}
```

This allows to store the type `T` by first packing it into the type `PackedT` with the `pack` function, and then storing the `PackedT` value with it's `Store` implementation. When reading the value, we first retrieve the `PackedT` value, and then unpack it into the type `T` using the `unpack` function.

Here's an example of storing a `Time` struct with two `u8` values using the `StorePacking` trait:

```rust
{{#include ../../../listings/advanced-concepts/store_using_packing/src/contract.cairo}}
```
