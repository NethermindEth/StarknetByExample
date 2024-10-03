---
content:
  horizontalPadding: 50px
  width: 100%
  verticalPadding: 30px
---

# Ownable

The following `Ownable` component is a simple component that allows the contract to set an owner and provides an `_assert_is_owner` function that can be used to ensure that the caller is the owner.

It can also be used to renounce ownership of a contract, meaning that no one will be able to satisfy the `_assert_is_owner` function.

<<<<<<< HEAD:src/components/ownable.md
```cairo
{{#include ../../listings/applications/components/src/ownable.cairo:component}}
=======
```rust
// [!include ~/listings/applications/components/src/ownable.cairo]
>>>>>>> 261b110 (feat: migrate frontend framework from mdbook to vocs  (#185)):pages/components/ownable.md
```

A mock contract that uses the `Ownable` component:

<<<<<<< HEAD:src/components/ownable.md
```cairo
{{#rustdoc_include ../../listings/applications/components/src/ownable.cairo:contract}}
=======
:::code-group

```rust [contract]
// [!include ~/listings/applications/components/src/contracts/owned.cairo:contract]
>>>>>>> 261b110 (feat: migrate frontend framework from mdbook to vocs  (#185)):pages/components/ownable.md
```

```rust [tests]
// [!include ~/listings/applications/components/src/contracts/owned.cairo:tests]
```

:::
