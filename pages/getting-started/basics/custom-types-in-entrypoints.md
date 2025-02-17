# Custom Types in Entrypoints

When using custom types in Starknet contract entrypoints, you need to handle serialization and deserialization of data. This is because:

1. Input parameters are sent to entrypoints as arrays of `felt252`
2. Return values must be converted back to arrays of `felt252`
3. Custom types need to be converted between these formats automatically

## Using the Serde Trait

The `Serde` trait provides the necessary serialization and deserialization capabilities for your custom types. For most simple types, you can derive this trait automatically:

```cairo
// [!include ~/listings/getting-started/custom_type_entrypoints/src/contract.cairo:contract]
```

:::note
For some complex types, you might need to implement the `Serde` trait manually. This gives you control over how your type is serialized and deserialized.

The `Serde` trait is distinct from the `Store` trait - `Serde` is for passing data in and out of entrypoints, while `Store` is for persisting data in contract storage.
:::
