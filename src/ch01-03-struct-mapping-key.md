# Structs as mapping keys

It is currently impossible to use structs as mapping keys. However, a workaround consists in hashing the values of all the struct's fields, and use this hash as a key in the `LegacyMap` type.

Consider the following example in which we would like to use an object of
type `Pet` as a key in a `LegacyMap`. The `Pet` struct has three fields: `name`, `age` and `owner`. We consider that the combination of these three fields uniquely identifies a pet.

```rust
{{#include ../listings/ch01-advanced-concepts/struct_as_mapping_key/src/contract.cairo}}
```

Play with this contract in [Remix](https://remix.ethereum.org/?#activate=Starknet-cairo1-compiler&url=https://github.com/NethermindEth/StarknetByExample/blob/main/listings/ch01-advanced-concepts/struct_as_mapping_key/src/contract.cairo).