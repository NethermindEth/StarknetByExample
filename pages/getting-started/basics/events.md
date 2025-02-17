# Events

Events in Cairo smart contracts allow you to emit and record data on the Starknet blockchain. They are essential for tracking important state changes and providing transparency to users and other contracts. Events are also useful when building interfaces, to be notified about important state changes.

To use events in your contract:

1. Create event structs that derive the `starknet::Event` trait
2. Define an `Event` enum in the contract, annotated with `#[event]`, where each variant is linked to an event struct
3. Emit events with the `emit` function

You can make events searchable by adding the `#[key]` attribute to specific fields, which indexes them for efficient querying later.

Events variant names and structs are recommended to be named consistently, even if it create some redundancy when emitting events.

Here's a practical example of a contract that emits events when incrementing a counter:

```cairo
// [!include ~/listings/getting-started/events/src/counter.cairo:contract]
```

:::note

For better code organization, especially in larger contracts, you can define event structs outside of the contract module, as shown in the example here.
While this allows you to group related events in separate modules or files, remember that you must still include all event variants in the contract's `Event` enum.

:::
