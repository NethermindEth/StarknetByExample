# Upgradeable Contract

Starknet distinguishes between a contract and its implementation by separating contracts into classes and instances.

A contract class is the definition of the contract: Cairo byte code, hint information, entry point names, and everything that defines its semantics unambiguously.

Each class is identified by its class hash, which is analogous to a class name in an object-oriented programming language. A contract instance is a deployed contract corresponding to a class.

You can upgrade the class hash of a deployed contract by calling the `replace_class_syscall`. This example shows two contracts and how you can make them upgradeable. Try to deploy `UpgradeableContract_V0`, and then upgrade it to `UpgradeableContract_V1`.
Then, call the `version` function to see that the contract was upgraded to the V1 version.

```rust
{{#include upgradeable_contract.cairo}}
```
