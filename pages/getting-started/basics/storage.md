# Storage

## Basic Contract Structure

Every Starknet contract must be defined as a module with the `#[starknet::contract]` attribute. Here's the simplest possible Cairo contract:

```cairo
// [!include ~/listings/getting-started/storage/src/minimal_contract.cairo:contract]
```

## Contract Storage Basics

Storage in Cairo contracts is implemented as a key-value store using a struct marked with the `#[storage]` attribute. Every contract must have exactly one storage definition, which serves as the contract's persistent state on the blockchain and is kept between contract executions.

### Storage Variables

You can define [Storage Variables](/getting-started/basics/variables#storage-variables) to store and retrieve data in your contract:

```cairo
// [!include ~/listings/getting-started/storage/src/contract.cairo:contract]
```

:::note
💡 **Optimization Tip**: Both contracts above generate identical Sierra code. The compiler only generates code for storage variables that are actually used in contract functions. Declaring unused storage variables has no impact on contract size or gas costs.
:::

For more complex data structures, see [Storing Custom Types](/getting-started/basics/storing-custom-types).
