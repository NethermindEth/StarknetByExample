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

The SRC5 standard defines two main functions:

1. `supports_interface`: Returns `true` if the contract implements the specified
   interface
2. `get_implementation`: Returns the class hash that implements the specified
   interface

### Interface ID Calculation

Interface IDs are calculated as the XOR of all function selectors in the
interface. A function selector is the first four bytes of the keccak256 hash of
the function signature.

## Implementation Example

Here's a basic example of how to implement SRC5:

```cairo
#[starknet::interface]
trait ISRC5<TContractState> {
    fn supports_interface(self: @TContractState, interface_id: felt252) -> bool;
    fn get_implementation(self: @TContractState, interface_id: felt252) -> Option<ClassHash>;
}

#[starknet::contract]
mod MySRC5Contract {
    use starknet::ClassHash;

    #[storage]
    struct Storage {
        supported_interfaces: LegacyMap<felt252, bool>,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        // Register the SRC5 interface ID
        self.supported_interfaces.write(0x3f918d17e5ee77373, true);
    }

    #[external(v0)]
    impl ISRC5Impl of ISRC5<ContractState> {
        fn supports_interface(self: @ContractState, interface_id: felt252) -> bool {
            self.supported_interfaces.read(interface_id)
        }

        fn get_implementation(self: @ContractState, interface_id: felt252) -> Option<ClassHash> {
            if self.supports_interface(interface_id) {
                Option::Some(starknet::get_class_hash())
            } else {
                Option::None
            }
        }
    }
}
```


## Usage Example

Here's how to query if a contract supports a specific interface:

```cairo
#[starknet::interface]
trait IContractA<TContractState> {
    fn check_interface(self: @TContractState, target: ContractAddress, interface_id: felt252) -> bool;
}

#[starknet::contract]
mod ContractA {
    use super::ISRC5DispatcherTrait;
    use super::ISRC5Dispatcher;

    #[external(v0)]
    fn check_interface(self: @ContractState, target: ContractAddress, interface_id: felt252) -> bool {
        // Create a dispatcher to interact with the target contract
        let src5_dispatcher = ISRC5Dispatcher { contract_address: target };
        // Query if the target contract supports the interface
        src5_dispatcher.supports_interface(interface_id)
    }
}

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