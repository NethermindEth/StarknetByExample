---
content:
  horizontalPadding: 50px
  width: 100%
  verticalPadding: 30px
---

# Ownable

The following `Ownable` component is a simple component that allows the contract to set an owner and provides a `_assert_is_owner` function that can be used to ensure that the caller is the owner.

It can also be used to renounce ownership of a contract, meaning that no one will be able to satisfy the `_assert_is_owner` function.

```rust
// [!include ~/snippets/listings/applications/components/src/ownable.cairo]
```

A mock contract that uses the `Ownable` component:

:::code-group

```rust [contract]
// [!include ~/snippets/listings/applications/components/src/contracts/owned.cairo:contract]
```

```rust [tests]
// [!include ~/snippets/listings/applications/components/src/contracts/owned.cairo:tests]
```

:::
