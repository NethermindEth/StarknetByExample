# Visibility and Mutability

## Visibility

There are two types of functions in Starknet contracts:

- Functions that are accessible externally and can be called by anyone.
- Functions that are only accessible internally and can only be called by other functions in the contract.

These functions are also typically divided into two different implementations blocks. The first `impl` block for externally accessible functions is explicitly annotated with an `#[external(v0)]` attribute. This indicates that all the functions inside this block can be called either as a transaction or as a view function. The second `impl` block for internally accessible functions is not annotated with any attribute, which means that all the functions inside this block are private by default.

## State Mutability

Regardless of whether a function is internal or external, it can either modify the contract's state or not. When we declare functions that interact with storage variables inside a smart contract,
we need to explicitly state that we are accessing the `ContractState` by adding it as the first parameter of the function. This is can be done in two different ways:

- If we want our function to be able to mutate the state of the contract, we pass it by reference like this: `ref self: ContractState`.
- If we want our function to be read-only and not mutate the state of the contract, we pass it by snapshot like this: `self: @ContractState`.

Read-only functions, also called view functions, can be directly called without making a transaction. You can interact with them directly through a RPC node to read the contract's state, and they're free to call!
External functions, that modify the contract's state, on the other side can only be called by making a transaction.

Internal functions can't be called externally, but the same principle applies regarding state mutability.

Let's take a look at a simple example contract to see these in action:

```rust
{{#include ../listings/ch00-introduction/visibility/src/visibility.cairo}}
```
Visit contract on [Voyager](https://goerli.voyager.online/contract/0x0071dE3093AB58053b0292C225aa0eED40293e7694A0042685FF6D813d39889F) or play with it in [Remix](https://remix.ethereum.org/?#activate=Starknet-cairo1-compiler&url=https://github.com/NethermindEth/StarknetByExample/blob/main/listings/ch00-introduction/visibility/src/visibility.cairo).
