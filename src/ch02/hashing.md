# Hashing

Hashing is a cryptographic technique that allows you to transform a variable length input into a fixed length output.
The resulting output is called a hash and it's completely different from the input.
Hash functions are deterministic, meaning that the same input will always produce the same output.

The two hash functions provided by the Cairo library are `Poseidon` and `Pedersen`.
Pedersen hashes were used in the past (but still used in some scenario for backward compatibility) while Poseidon hashes are the standard nowadays since they were designed to be very efficient for Zero Knowledge proof systems.

In Cairo it's possible to hash all the types that can be converted to `felt252` since they implement natively the `Hash` trait. It's also possible to hash more complex types like structs by deriving the Hash trait with the attribute `#[derive(Hash)]` but only if all the struct's fields are themselves hashable.

You first need to initialize a hash state with the `new` method of the `HashStateTrait` and then you can update it with the `update` method. You can accumulate multiple updates. Then, the `finalize` method returns the final hash value as a `felt252`.

```rust
{{#rustdoc_include ../../listings/advanced-concepts/hash_trait/src/hash_trait.cairo:hash}}
```
