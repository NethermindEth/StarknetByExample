# Interfaces, Visibility and Mutability

## Function Visibility

In Starknet contracts, functions can have two types of visibility:

- **External Functions**: Can be called by anyone, including other contracts and users
- **Internal Functions**: Can only be called by other functions within the same contract

## State Mutability

Every function in a contract can either modify or just read the contract's state. This behavior is determined by how we pass the `ContractState` parameter:

- **State-Modifying Functions**: Use `ref self: ContractState`
  - Can read and write to storage
  - Require a transaction to execute
  - Cost gas to run

- **View Functions**: Use `self: @ContractState`
  - Can only read from storage
  - Can be called directly through an RPC node
  - Free to call (no transaction needed)

:::note
Internal functions follow the same state mutability rules as external functions. The only difference is who can call them.
:::

## Implementation

### External Functions

For external functions (both state-modifying and view), you need:

1. **Interface Definition**
   - Defined with `#[starknet::interface]` attribute
   - Lists all functions that can be called externally
   - Functions can be called as transactions or view calls
   - Part of the contract's public API

2. **Interface Implementation**
   - Uses `#[abi(embed_v0)]` attribute
   - Becomes part of the contract's ABI (Application Binary Interface)
   - ABI defines how to interact with the contract from outside
   - Must implement all functions defined in the interface

### Internal Functions

For internal functions, there are two options:

1. **Implementation Block**
    - Can use `#[generate_trait]` attribute
    - Recommended for functions that need `ContractState` access
    - Sometimes prefixed with `_` to indicate internal use

2. **Direct Contract Body**
    - Functions defined directly in the contract
    - Recommended for pure functions
        - Useful for helper functions and calculations

## Example

Here's a complete example demonstrating these concepts:

```cairo
// [!include ~/listings/getting-started/visibility/src/visibility.cairo:contract]
```

:::note
**Multiple Implementations**

Cairo contracts can implement multiple interfaces and have multiple internal implementation blocks. This is not only possible but recommended because it:

- Keeps each implementation block focused on a single responsibility
- Makes the code more maintainable and easier to test
- Simplifies the implementation of standard interfaces
- Allows for better organization of related functionality

:::
