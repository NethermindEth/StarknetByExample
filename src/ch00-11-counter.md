# Simple Counter

This is a simple counter contract.

Here's how it works:

- The contract has a state variable called 'counter' that is initialized to 0.

- When a user calls 'increment', the contract increments the counter by 1.

- When a user calls 'decrement', the contract decrements the counter by 1.

```rust
{{#include ../listings/ch00-introduction/counter/src/counter.cairo}}
```
Visit contract on [Voyager](https://goerli.voyager.online/contract/0x01664a69Fe701a1df7Bb0ae4A353792d0cf4E27146ee860075cbf6108b1D5718) or play with it in [Remix](https://remix.ethereum.org/?#activate=Starknet-cairo1-compiler&url=https://github.com/NethermindEth/StarknetByExample/blob/main/listings/ch00-introduction/counter/src/counter.cairo).
