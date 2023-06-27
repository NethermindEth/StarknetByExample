# Events

An event is defined as function with the #[event] attribute. The parameters of the function correspond to data that will be emitted. An event is to be logged for easy and fast access to querying the data at a later time.

Here's a simple example of a contract using events that emit an event each time a counter is incremented by the "increment" function:

```rust
{{#include ../listings/ch00-introduction/events/src/counter.cairo}}
```
