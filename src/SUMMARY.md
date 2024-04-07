Summary

[Introduction](./starknet-by-example.md)

<!-- ch00 -->

# Getting Started

  <!-- - [Local environment setup](./ch00/env_setup.md) -->

- [Basics of a Starknet contract](./ch00/basics/introduction.md)
  - [Storage](./ch00/basics/storage.md)
  - [Constructor](./ch00/basics/constructor.md)
  - [Variables](./ch00/basics/variables.md)
  - [Visibility and Mutability](./ch00/basics/visibility-mutability.md)
  - [Counter Example](./ch00/basics/counter.md)
  - [Mappings](./ch00/basics/mappings.md)
  - [Errors](./ch00/basics/errors.md)
  - [Events](./ch00/basics/events.md)
  - [Syscalls](./ch00/basics/syscalls.md)
  - [Strings and ByteArrays](./ch00/basics/bytearrays-strings.md)
  - [Storing Custom Types](./ch00/basics/storing-custom-types.md)
  - [Custom types in entrypoints](./ch00/basics/custom-types-in-entrypoints.md)
  - [Documentation](./ch00/basics/documentation.md)
- [Deploy and interact with contracts](./ch00/interacting/interacting.md)
  - [Contract interfaces and Traits generation](./ch00/interacting/interfaces-traits.md)
  - [Calling other contracts](./ch00/interacting/calling_other_contracts.md)
  - [Factory pattern](./ch00/interacting/factory.md)
- [Testing contracts](./ch00/testing/contract-testing.md)
- [Cairo cheatsheet](./ch00/cairo_cheatsheet/cairo_cheatsheet.md)
  - [Felt](./ch00/cairo_cheatsheet/felt.md)
  - [LegacyMap](./ch00/cairo_cheatsheet/mapping.md)
  - [Arrays](./ch00/cairo_cheatsheet/arrays.md)
  - [loop](./ch00/cairo_cheatsheet/loop.md)
  - [while](./ch00/cairo_cheatsheet/while.md)
  - [if let](./ch00/cairo_cheatsheet/if_let.md)
  - [while let](./ch00/cairo_cheatsheet/while_let.md)
  - [Match](./ch00/cairo_cheatsheet/match.md)
  - [Tuples](./ch00/cairo_cheatsheet/tuples.md)
  - [Struct](./ch00/cairo_cheatsheet/struct.md)
  - [Type casting](./ch00/cairo_cheatsheet/type_casting.md)

# Components

- [Components How-To](./components/how_to.md)
- [Components Dependencies](./components/dependencies.md)
- [Storage Collisions](./components/collisions.md)
- [Ownable](./components/ownable.md)

<!-- ch01 -->

# Applications

- [Upgradeable Contract](./ch01/upgradeable_contract.md)
- [Defi Vault](./ch01/simple_vault.md)
- [ERC20 Token](./ch01/erc20.md)
- [Constant Product AMM](./ch01/constant-product-amm.md)

<!-- ch02 -->

# Advanced concepts

- [Writing to any storage slot](./ch02/write_to_any_slot.md)
- [Storing Arrays](./ch02/storing_arrays.md)
- [Struct as mapping key](./ch02/struct-mapping-key.md)
- [Hashing](./ch02/hashing.md)
  <!-- Hidden until #123 is solved -->
  <!-- - [Hash Solidity Compatible](./ch02/hash-solidity-compatible.md) -->
- [Optimisations](./ch02/optimisations/optimisations.md)
  - [Storage Optimisations](./ch02/optimisations/store_using_packing.md)
- [List](./ch02/list.md)
- [Plugins](./ch02/plugins.md)
- [Signature Verification](./ch02/signature_verification.md)
