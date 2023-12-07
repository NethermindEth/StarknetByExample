# Factory Pattern

The factory pattern is a well known pattern in object oriented programming. It provides an abstraction on how to instantiate a class. 

In the case of smart contracts, we can use this pattern by defining a factory contract that have the sole responsibility of creating and managing other contracts.

## Class hash and contract instance

In Starknet, there's a separation between contract's classes and instances. A contract class serves as a blueprint, defined by the underling Cairo bytecode, contract's entrypoints, ABI and Sierra program hash. The contract class is identified by a class hash. When you want to add a new class to the network, you first need to declare it.

When deploying a contract, you need to specify the class hash of the contract you want to deploy. Each instance of a contract has their own storage regardless of the class hash.

Using the factory pattern, we can deploy multiple instances of the same contract class and handle upgrades easily.

## Minimal example

Here's a minimal example of a factory contract that deploy the `SimpleCounter` contract:

```rust
{{#include ../../../listings/getting-started/factory/src/simple_factory.cairo}}
```

<!-- This is not ready for "Open in remix" because we need multiple files -->

This factory can be used to deploy multiple instances of the `SimpleCounter` contract by calling the `create_counter` and `create_counter_at` functions.

The `SimpleCounter` class hash is stored inside the factory, and can be upgraded with the `update_counter_class_hash` function which allows to reuse the same factory contract when the `SimpleCounter` contract is upgraded.

This minimal example lacks several useful features such as access control, tracking of deployed contracts, events, ...

<!-- TODO maybe add a more complete example at the end of this section or in the `Applications examples` chapter -->
