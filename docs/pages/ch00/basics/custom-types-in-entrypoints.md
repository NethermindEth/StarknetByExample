---
content:
  horizontalPadding: 50px
  width: 100%
  verticalPadding: 30px
---

# Custom types in entrypoints

Using custom types in entrypoints requires our type to implement the `Serde` trait. This is because when calling an entrypoint, the input is sent as an array of `felt252` to the entrypoint, and we need to be able to deserialize it into our custom type. Similarly, when returning a custom type from an entrypoint, we need to be able to serialize it into an array of `felt252`.
Thankfully, we can just derive the `Serde` trait for our custom type.

The purpose is to only show the capability of using custom types as inputs and outputs in contract calls.
We are not employing getters and setters for managing the contract's state in this example for simplicity.

:::code-group

```rust [contract]
// [!include ~/snippets/listings/getting-started/custom_type_serde/src/contract.cairo:contract]
```

```rust [tests]
// [!include ~/snippets/listings/getting-started/custom_type_serde/src/contract.cairo:tests]
```

:::
