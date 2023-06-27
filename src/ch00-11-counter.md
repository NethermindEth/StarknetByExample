# Simple Counter

This is the Cairo adaptation of the [Solidity by example First Application](https://solidity-by-example.org/first-app/).
Here's how it works:

- The contract has a state variable called 'counter' that is initialized to 0.

- When a user calls 'increment', the contract increments the counter by 1.

- When a user calls 'decrement', the contract decrements the counter by 1.

```rust
{{#include ../listings/ch00-introduction/counter/src/counter.cairo}}
```
