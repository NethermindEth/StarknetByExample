# Contract interfaces and Traits generation

Contract interfaces define the structure and behavior of a contract, serving as the contract's public ABI. They list all the function signatures that a contract exposes. For a detailed explanation of interfaces, you can refer to the [Cairo Book](https://book.cairo-lang.org/ch99-01-02-a-simple-contract.html).

In cairo, to specify the interface you need to define a trait annotated with `#[starknet::interface]` and then implement that trait in the contract.

When a function needs to access the contract state, it must have a `self` parameter of type `ContractState`. This implies that the corresponding function signature in the interface trait must also take a `TContractState` type as a parameter. It's important to note that every function in the contract interface must have this `self` parameter of type `TContractState`.

You can use the `#[generate_trait]` attribute to implicitly generate the trait for a specific implementation block. This attribute automatically generates a trait with the same functions as the ones in the implemented block, replacing the `self` parameter with a generic `TContractState` parameter. However, this will only work for internal functions, and not for functions that are part of the contract's public interface - as embedding an impl inside the abi of a contract requires this impl to implement an interface.

In summary, there's only one way to handle interfaces, which is explicitly, by defining a trait annoted with `#[starknet::interface]`. You cannot define an interface implicitly, by annotating an `#[abi(embed_v0)]` impl inside a contract with `#[generate_trait]`.

## Explicit interface

```rust
{{#include ../../../listings/ch00-getting-started/interfaces_traits/src/explicit.cairo}}
```

Play with this contract in [Remix](https://remix.ethereum.org/?#activate=Starknet&url=https://github.com/NethermindEth/StarknetByExample/blob/main/listings/ch00-getting-started/interfaces_traits/src/explicit.cairo).

## Internal functions

You can also use `#[generate_trait]` for your internal functions.
Since this trait is generated in the context of the contract, you can define pure functions as well (functions without the `self` parameter).

```rust
{{#include ../../../listings/ch00-getting-started/interfaces_traits/src/implicit_internal.cairo}}
```

Play with this contract in [Remix](https://remix.ethereum.org/?#activate=Starknet&url=https://github.com/NethermindEth/StarknetByExample/blob/main/listings/ch00-getting-started/interfaces_traits/src/implicit_internal.cairo).
