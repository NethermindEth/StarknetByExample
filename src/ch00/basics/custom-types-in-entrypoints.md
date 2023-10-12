# Custom types in entrypoints

Using custom types in entrypoints requires our type to implement the `Serde` trait. This is because when calling an entrypoint, the input is sent as an array of `felt252` to the entrypoint, and we need to be able to deserialize it into our custom type. Similarly, when returning a custom type from an entrypoint, we need to be able to serialize it into an array of `felt252`.
Thankfully, we can just derive the `Serde` trait for our custom type.

```rust
{{#include ../../../listings/ch00-getting-started/custom_type_serde/src/contract.cairo}}
```

Play with this contract in [Remix](https://remix.ethereum.org/?#activate=Starknet&url=https://github.com/NethermindEth/StarknetByExample/blob/main/listings/ch00-getting-started/custom_type_serde/src/contract.cairo).
