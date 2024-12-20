# Storage

Here's the most minimal contract you can write in Cairo:

```cairo
// [!include ~/listings/getting-started/storage/src/minimal_contract.cairo:contract]
```

Storage is a `struct` annotated with `#[storage]`. Every contract must have one and only one storage.
It's a key-value store, where each key will be mapped to a storage address of the contract's storage space.

You can define [storage variables](/getting-started/basics/variables#storage-variables) in your contract, and then use them to store and retrieve data.

```cairo
// [!include ~/listings/getting-started/storage/src/contract.cairo:contract]
```

:::note
Actually these two contracts have the same underlying Sierra program.
The Sierra code is generated only for storage variables that are actually accessed in the contract's functions. Declaring but never using a storage variable doesn't affect the compiled contract size/gas costs.
:::

You can also read about [storing custom types](/getting-started/basics/storing-custom-types).
