# Errors

Errors can be used to handle validation and other conditions that may occur during the execution of a smart contract.
If an error is thrown during the execution of a smart contract call, the execution is stopped and any changes made during the transaction are reverted.

To throw an error, use the `assert` or `panic` functions:

- `assert` is used to validate conditions.
  If the check fails, an error is thrown along with a specified value, often a message.
  It's similar to the `require` statement in Solidity.

- `panic` immediately halt the execution with the given error value.
  It should be used when the condition to check is complex and for internal errors. It's similar to the `revert` statement in Solidity.
  (Use `panic_with_felt252` to be able to directly pass a felt252 as the error value)

Here's a simple example that demonstrates the use of these functions:

```rust
{{#include ../../../listings/ch00-getting-started/errors/src/simple_errors.cairo}}
```
Visit contract on [Voyager](https://goerli.voyager.online/contract/0x0022664463FF0b711CC9B549a9E87d65A0882bB1D29338C4108696B8F2216a40) or play with it in [Remix](https://remix.ethereum.org/?#activate=Starknet&url=https://github.com/NethermindEth/StarknetByExample/blob/main/listings/ch00-getting-started/errors/src/simple_errors.cairo).

## Custom errors

You can make error handling easier by defining your error codes in a specific module.

```rust
{{#include ../../../listings/ch00-getting-started/errors/src/custom_errors.cairo}}
```
Visit contract on [Voyager](https://goerli.voyager.online/contract/0x0501CD5da5B453a18515B5A20b8029bd7583DFE7a399ad9f79c284F7829e4A57) or play with it in [Remix](https://remix.ethereum.org/?#activate=Starknet&url=https://github.com/NethermindEth/StarknetByExample/blob/main/listings/ch00-getting-started/errors/src/custom_errors.cairo).

## Vault example

Here's another example that demonstrates the use of errors in a more complex contract:

```rust
{{#include ../../../listings/ch00-getting-started/errors/src/vault_errors.cairo}}
```
Visit contract on [Voyager](https://goerli.voyager.online/contract/0x020C2da26F42A28Ef54ED428eF1810FE433784b055f9bF315C5d992b1579C268) or play with it in [Remix](https://remix.ethereum.org/?#activate=Starknet&url=https://github.com/NethermindEth/StarknetByExample/blob/main/listings/ch00-getting-started/errors/src/vault_errors.cairo).
