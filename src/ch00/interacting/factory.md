# Factory Pattern

The factory pattern is a well known pattern in object oriented programming. It provides an abstraction on how to instantiate a class. 

In the case of smart contracts, we can use this pattern by defining a factory contract that have the sole responsibility of creating and managing other contracts.

Here's a minimal example of a factory contract that deploy the `SimpleCounter` contract:

```rust
{{#include ../../../listings/ch00-getting-started/factory/src/simple_factory.cairo}}
```

<!-- This is not ready for "Open in remix" because we need multiple files -->

This factory can be used to deploy multiple instances of the `SimpleCounter` contract by calling the `create_counter` and `create_counter_at` functions.

The `SimpleCounter` class hash is stored inside the factory, and can be upgraded with the `update_counter_class_hash` function which allows to reuse the same factory contract when the `SimpleCounter` contract is upgraded.

This minimal example lacks several useful features such as access control, tracking of deployed contracts, events, ...

<!-- TODO maybe add a more complete example at the end of this section or in the `Applications examples` chapter -->
