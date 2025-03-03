# Storing Custom Types

In Starknet contracts, storing custom types in contract storage requires implementing the `Store` trait. While native types (like `felt252`, `u128`, etc.) can be stored directly, custom types need this additional step to generate the necessary implementation on how to handle their storage.

To make a custom type storable:

1. Derive the `starknet::Store` trait for your struct
2. Add any other necessary traits like `Drop`, `Serde`, and `Copy`
3. Define your storage variables using the custom type

Here's an example showing how to store a custom `Person` struct:

```cairo
// [!include ~/listings/getting-started/storing_custom_types/src/contract.cairo:contract]
```

:::note

For more complex types, you might need to implement the `Store` trait manually instead of deriving it.

:::

## Accessing Struct Members

When you derive the `Store` trait, Cairo automatically generates the necessary storage pointers for each struct member. This allows you to access and modify individual fields of your stored struct directly:

```cairo
// [!include ~/listings/getting-started/storing_custom_types/src/contract.cairo:set_name]
```
