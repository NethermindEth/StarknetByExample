---
content:
  horizontalPadding: 50px
  width: 100%
  verticalPadding: 30px
---

# Storing Custom Types

While native types can be stored in a contract's storage without any additional work, custom types require a bit more work. This is because at compile time, the compiler does not know how to store custom types in storage. To solve this, we need to implement the `Store` trait for our custom type. Hopefully, we can just derive this trait for our custom type - unless it contains arrays or dictionaries.

:::code-group

```rust [contract]
// [!include ~/snippets/listings/getting-started/storing_custom_types/src/contract.cairo:contract]
```

```rust [tests]
// [!include ~/snippets/listings/getting-started/storing_custom_types/src/contract.cairo:tests]
```

:::
