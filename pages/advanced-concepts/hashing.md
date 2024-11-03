# Hashing

Hashing is a cryptographic technique that allows you to transform a variable length input into a fixed length output.
The resulting output is called a hash and it's completely different from the input.
Hash functions are deterministic, meaning that the same input will always produce the same output.

The two hash functions provided by the Cairo library are `Poseidon` and `Pedersen`.
Pedersen hashes were used in the past (but are still used in some scenarios for backward compatibility), while Poseidon hashes are the standard nowadays since they were designed to be very efficient for Zero Knowledge proof systems.

In Cairo, it's possible to hash all types that can be converted to `felt252` since they natively implement the `Hash` trait. It's also possible to hash more complex types, like structs, by deriving the Hash trait with the `#[derive(Hash)]` attribute, but only if all the struct's fields are themselves hashable.

To hash a value, you first need to initialize a hash state with the `new` method of the `HashStateTrait`. Then, you can update the hash state with the `update` method. You can accumulate multiple updates if necessary. Finally, the `finalize` method returns the final hash value as a `felt252`.

```cairo
// [!include ~/listings/advanced-concepts/hash_trait/src/hash_trait.cairo:hash]
```
