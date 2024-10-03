---
content:
  horizontalPadding: 50px
  width: 100%
  verticalPadding: 30px
---

# Storage

Here's the most minimal contract you can write in Cairo:

<<<<<<<< HEAD:src/getting-started/basics/storage.md
```cairo
{{#rustdoc_include ../../../listings/getting-started/storage/src/minimal_contract.cairo:contract}}
========
:::code-group

```rust [contract]
// [!include ~/listings/getting-started/storage/src/minimal_contract.cairo:contract]
>>>>>>>> 261b110 (feat: migrate frontend framework from mdbook to vocs  (#185)):pages/ch00/basics/storage.md
```

```rust [tests]
// [!include ~/listings/getting-started/storage/src/minimal_contract.cairo:tests]
```

:::

Storage is a `struct` annotated with `#[storage]`. Every contract must have one and only one storage.
It's a key-value store, where each key will be mapped to a storage address of the contract's storage space.

You can define [storage variables](./variables.md#storage-variables) in your contract, and then use them to store and retrieve data.

<<<<<<<< HEAD:src/getting-started/basics/storage.md
```cairo
{{#rustdoc_include ../../../listings/getting-started/storage/src/contract.cairo:contract}}
```

> Actually these two contracts have the same underlying Sierra program.
========
:::code-group

```rust [contract]
// [!include ~/listings/getting-started/storage/src/contract.cairo:contract]
```

```rust [tests]
// [!include ~/listings/getting-started/storage/src/contract.cairo:tests]
```

:::

> Actually these two contracts have the same underlying sierra program.
>>>>>>>> 261b110 (feat: migrate frontend framework from mdbook to vocs  (#185)):pages/ch00/basics/storage.md
> From the compiler's perspective, the storage variables don't exist until they are used.

You can also read about [storing custom types](./storing-custom-types.md).
