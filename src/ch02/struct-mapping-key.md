# Structs as mapping keys

In order to use structs as mapping keys, you can use `#[derive(Hash)]` on the struct definition. This will automatically generate a hash function for the struct that can be used to represent the struct as a key in a `LegacyMap`.

Consider the following example in which we would like to use an object of
type `Pet` as a key in a `LegacyMap`. The `Pet` struct has three fields: `name`, `age` and `owner`. We consider that the combination of these three fields uniquely identifies a pet.

```rust
{{#include ../../listings/advanced-concepts/struct_as_mapping_key/src/contract.cairo}}
```
