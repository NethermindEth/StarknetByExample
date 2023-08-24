# Calling other contracts

There are two different ways to call other contracts in Cairo.

The easiest way to call other contracts is by using the dispatcher of the contract you want to call.
You can read more about Dispatchers in the [Cairo Book](https://cairo-book.github.io/ch99-02-02-contract-dispatcher-library-dispatcher-and-system-calls.html#contract-dispatcher)

The other way is to use the `starknet::call_contract_syscall` syscall yourself. However, this method is not recommended.

In order to call other contracts using dispatchers, you will need to define the called contract's interface as a trait annotated with the `#[starknet::interface]` attribute, and then import the `IContractDispatcher` and `IContractDispatcherTrait` items in your contract.

```rust
{{#include ../listings/ch00-introduction/calling_other_contracts/src/callee.cairo}}
```
Visit contract on [Voyager](https://goerli.voyager.online/contract/0x015c3Bb6D0DE26b64FEAF9A8f4655CfADb5c128bF4510398972704ee12775DB1) or play with it in [Remix](https://remix.ethereum.org/?#activate=Starknet-cairo1-compiler&url=https://github.com/NethermindEth/StarknetByExample/blob/main/listings/ch00-introduction/calling_other_contracts/src/callee.cairo).

```rust
{{#include ../listings/ch00-introduction/calling_other_contracts/src/caller.cairo}}
```
Visit contract on [Voyager](https://goerli.voyager.online/contract/0x05fa8aF796343d2f22c53C17149386b67B7AC4aB52D9e308Aa507C185aA44778) or play with it in [Remix](https://remix.ethereum.org/?#activate=Starknet-cairo1-compiler&url=https://github.com/NethermindEth/StarknetByExample/blob/main/listings/ch00-introduction/calling_other_contracts/src/caller.cairo).