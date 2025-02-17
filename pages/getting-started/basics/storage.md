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
**Optimization Tip**

Both contracts above generate identical Sierra code. The compiler only generates code for storage variables that are actually used in contract functions. Declaring unused storage variables has no impact on contract size or gas costs.
:::

For more complex data structures, see [Storing Custom Types](/getting-started/basics/storing_custom_types).

### Storage Space (advanced)

The contract's storage space consists of $2^{251}$ *storage slots*, where each slot:

- Can store a single `felt252` value
- Is initialized to 0

### Storage Pointers

Storage variables are stored in storage slots using Starknet's memory model abstraction called **Storage Pointers**. A storage pointer is a tuple `(base_address, offset)` where:

- `base_address` is the address of the first slot where the variable is stored
- `offset` is the distance from the base address where the variable is stored

To get the base address of a storage variable, you can use the `selector!` macro to derive it from the variable name: for example, `selector!("variable_name")`.

### Storage Layout Example

In our previous contract example:

- Variable `a` (u128):
  - Base address: `selector!("a")`
  - Uses lowest 128 bits of the slot at offset 0
  - Leaves 124 bits unused
- Variable `b` (u8):
  - Base address: `selector!("b")`
  - Uses lowest 8 bits of the slot at offset 0
  - Leaves 244 bits unused
- Variable `c` (u256):
  - Base address: `selector!("c")`
  - Too large for a single slot, uses two consecutive slots:
    - First slot: lower 128 bits at offset 0
    - Second slot: lower 128 bits at offset 1
  - Leaves 248 bits unused, 124 in each slot

:::note
**Storage Optimization**

Notice how many bits are left unused in each slot? This can make storage operations expensive. To optimize storage usage, you can pack multiple variables together. Learn more in [Storage Optimisation](/advanced-concepts/optimisations/store_using_packing).
:::
