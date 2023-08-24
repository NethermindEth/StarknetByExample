# Events

Events are a way to emit data from a contract. All events must be defined in the `Event` enum, which must be annotated with the `#[event]` attribute.
An event is defined as struct that derives the `#[starknet::Event]` trait. The fields of that struct correspond to the data that will be emitted. An event can be indexed for easy and fast access when querying the data at a later time. Events data can be indexed by adding a `#[key]` attribute to a field member.

Here's a simple example of a contract using events that emit an event each time a counter is incremented by the "increment" function:

```rust
{{#include ../listings/ch00-introduction/events/src/counter.cairo}}
```
Visit contract on [Voyager](https://goerli.voyager.online/contract/0x022e3B59518EA04aBb5da671ea04ecC3a154400f226d2Df38eFE146741b9E2F6) or play with it in [Remix](https://remix.ethereum.org/?#activate=Starknet-cairo1-compiler&url=https://github.com/NethermindEth/StarknetByExample/blob/main/listings/ch00-introduction/events/src/counter.cairo).
