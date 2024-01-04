# Hashing

The hashing process is a deterministic transformation that allows converting input data of any length into a fixed-size value referred as "hash". There are a plenty of hashing algorithms: in Cairo we have Pedersen and Poseidon hashes. Pedersen hashes were used in the past (but still used in some scenario for backward compatibility) while Poseidon hashes are the standard nowadays since they were designed to be very efficient for Zero Knowledge proof systems. More details [here](https://book.cairo-lang.org/ch11-03-hash.html#hash-functions-in-cairo).

In Cairo it's possibile to hash all the types that can be converted to `felt252` since they implement natively the `Hash` trait. It's also possible to hash more complex types like structs by deriving the Hash trait with the attribute `#[derive(Hash)]` but only if all the struct's fields are themselves hashable.

Steps for producing a Pedersen or Poseidon hash of a struct are:
1. Import the needed modules
2. Create a struct that contains all hashable fields and derive for it the Hash trait
3. Generate a new HashState using the `new()` method of the PedersenTrait or PoseidonTrait. This is like creating a blank object to be filled next
2. Update the HashState with the computed data (the hash of the struct) using the `update_with()` method, passing to it our struct instance
3. Finalize the HashState: namely returning the HashState final value as a `felt252`

Pratical example is shown below.

```rust
{{#include ../../../listings/getting-started/cairo_cheatsheet/src/hashing_example.cairo}}
```

