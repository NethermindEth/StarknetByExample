# Mappings

Maps are a fundamental key-value data structure in Cairo smart contracts that allow you to store and retrieve values using unique keys. The `Map` type in `starknet::storage` is specifically designed for contract storage for this purpose.

Here's a simple example that demonstrates how to use a `Map`:

```cairo
// [!include ~/listings/getting-started/mappings/src/mappings.cairo:contract]
```

Let's break down the key components:

- **Declaration**: Maps are declared using `Map<KeyType, ValueType>` syntax
- **Storage**: Maps must be declared inside the contract's `Storage` struct
  - You need to import the `StorageMapReadAccess` and `StorageMapWriteAccess` traits from `starknet::storage`
- **Operations**:
  - `write(key, value)`: Stores a value for a given key
  - `read(key)`: Retrieves the value associated with a key
- Maps automatically initialize all values to zero
- Keys and values must be of valid storage types, see [Storing Custom Types](/getting-started/basics/storing_custom_types)

### Composite Keys

For more complex scenarios, you can use composite keys by combining multiple values:

```cairo
// Example: ERC20 allowance mapping
Map<(ContractAddress, ContractAddress), felt252>  // (owner, spender) -> amount
```

### Storage Layout (advanced)

Under the hood, Cairo maps use a deterministic storage layout:

- Each key-value pair is stored at a unique address calculated using Pedersen hashes
- The address formula is: $\text{h}(...\text{h}(\text{h}(\text{sn\_keccak}(name),k_1),k_2),...,k_n)$ mod $2^{251} - 256$
- Learn more in the [Starknet Documentation](https://docs.starknet.io/architecture-and-concepts/smart-contracts/contract-storage/#storage_variables)
