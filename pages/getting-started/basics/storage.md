# Storage

Here's the most minimal contract you can write in Cairo:

```rust
// [!include ~/listings/getting-started/storage/src/minimal_contract.cairo:contract]
```

Storage is a `struct` annotated with `#[storage]`. Every contract must have one and only one storage.
It's a key-value store, where each key will be mapped to a storage address of the contract's storage space.

You can define [storage variables](/getting-started/basics/variables#storage-variables) in your contract, and then use them to store and retrieve data.

```rust
// [!include ~/listings/getting-started/storage/src/contract.cairo:contract]
```

:::note
Actually these two contracts have the same underlying Sierra program.
From the compiler's perspective, the storage variables don't exist until they are used.
:::

You can also read about [storing custom types](/getting-started/basics/storing-custom-types).
