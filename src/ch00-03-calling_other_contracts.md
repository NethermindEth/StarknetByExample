# Calling other contracts

There are two different ways to call other contracts in Cairo.

The easiest way to call other contracts is by using the dispatcher of the contract you want to call.
You can read more about Dispatchers in the [Cairo Book](https://cairo-book.github.io/ch99-02-02-contract-dispatcher-library-dispatcher-and-system-calls.html#contract-dispatcher)

The other way is to use the `starknet::call_contract_syscall` syscall yourself. However, this method is not recommended.

In order to call other contracts using dispatchers, you will need to define the called contract's interface as a trait annotated with the `#[abi]` attribute, and then import the `IContractDispatcher` and `IContractDispatcherTrait` items in your contract.

```rust
{{#include ../listings/ch00-introduction/calling_other_contracts/src/callee.cairo}}
```

```rust
{{#include ../listings/ch00-introduction/calling_other_contracts/src/caller.cairo}}
```
