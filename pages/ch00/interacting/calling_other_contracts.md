---
content:
  horizontalPadding: 50px
  width: 100%
  verticalPadding: 30px
---

# Calling other contracts

There are two different ways to call other contracts in Cairo.

The easiest way to call other contracts is by using the dispatcher of the contract you want to call.
You can read more about Dispatchers in the [Cairo Book](https://book.cairo-lang.org/ch15-02-interacting-with-another-contract.html#calling-contracts-using-the-contract-dispatcher).

The other way is to use the `starknet::call_contract_syscall` syscall yourself. However, this method is not recommended and will not be covered in this chapter.

In order to call other contracts using dispatchers, you will need to define the called contract's interface as a trait annotated with the `#[starknet::interface]` attribute, and then import the `IContractDispatcher` and `IContractDispatcherTrait` items in your contract.

Here's the `Callee` contract interface and implementation:

<<<<<<<< HEAD:src/getting-started/interacting/calling_other_contracts.md
```cairo
{{#rustdoc_include ../../../listings/getting-started/calling_other_contracts/src/caller.cairo:callee_contract}}
```

The following `Caller` contract uses the `Callee` dispatcher to call the `Callee` contract:

```cairo
{{#rustdoc_include ../../../listings/getting-started/calling_other_contracts/src/caller.cairo:caller_contract}}
========
:::code-group

```rust [contract]
// [!include ~/listings/getting-started/calling_other_contracts/src/caller.cairo:callee_contract]
```

```rust [tests]
// [!include ~/listings/getting-started/calling_other_contracts/src/caller.cairo:tests]
```

:::

The following `Caller` contract use the `Callee` interface to call the `Callee` contract:

:::code-group

```rust [contract]
// [!include ~/listings/getting-started/calling_other_contracts/src/caller.cairo:caller_contract]
>>>>>>>> 261b110 (feat: migrate frontend framework from mdbook to vocs  (#185)):pages/ch00/interacting/calling_other_contracts.md
```

```rust [tests]
// [!include ~/listings/getting-started/calling_other_contracts/src/caller.cairo:tests]
```

:::
