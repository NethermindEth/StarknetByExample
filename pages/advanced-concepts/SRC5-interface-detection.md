# SRC5 Interface Detection

## Introduction

SRC5 is Starknet's standard interface detection mechanism, similar to [ERC165](https://eips.ethereum.org/EIPS/eip-165) in
Ethereum. It provides a standardized way for contracts to declare which
interfaces they implement and allows other contracts to query this information.

## What is SRC5?

SRC5 is a standard that enables smart contracts to:

- Declare which interfaces they support
- Query other contracts to check if they support specific interfaces
- Provide a consistent way to handle interface detection across the Starknet
  ecosystem

## How it Works

The SRC5 standard defines one main function:

1. `supports_interface`: Returns `true` if the contract implements the specified interface

### Interface ID Calculation

Interface IDs are calculated as the XOR of all function selectors in the
interface. A function selector is the first four bytes of the keccak256 hash of
the function signature.

## Implementation Example

Here's an openzeppelin example of how to implement SRC5:

```cairo
// [!include ~/listings/advanced-concepts/src5_interface_detection/src/src5.cairo:contract]
```


## Usage Example

Here's how to query if a contract supports a specific interface:

```cairo
// [!include ~/listings/advanced-concepts/src5_interface_detection/src/src5.cairo:offchain]
```

## Common Use Cases

- Checking if a contract implements specific token standards (SRC20, SRC721, etc.)
- Verifying contract compatibility before interaction
- Implementing upgradeable contracts with interface verification
- Building interface-agnostic contract systems

## Best Practices

1. **Always implement SRC5** in your contracts if they implement any standard interfaces
2. **Register interfaces** in the constructor
3. **Handle unknown interfaces** gracefully by returning `false` for `supports_interface`
4. **Test interface detection** thoroughly before deployment


## Additional Resources

- [SRC5 Standard Specification](https://github.com/starknet-io/SNIPs/blob/main/SNIPS/snip-5.md)
- [Starknet Standards Repository](https://github.com/starknet-io/SNIPs)