# Errors

In smart contracts, errors play an important role during the execution of transactions. When an error is thrown, it stops the execution of the contract and all changes made during the transaction are reverted.

To throw an error, use the `assert` or `panic` functions:

- `assert` is used to validate conditions.
  If the check fails, an error is thrown along with a specified value, often a message.
  It's similar to the `require` statement in Solidity.

- `panic` immediately halt the execution with the given error value.
  It should be used when the condition to check is complex and for internal errors. It's similar to the `revert` statement in Solidity.
  (Use `panic_with_felt252` to be able to directly pass a felt252 as the error value)

Here's a simple example that demonstrates the use of these functions:

```rust
{{#include simpleErrors.cairo}}
```

## Custom errors

You can make errors handling easier by defining your own error in a specific module.

```rust
{{#include customErrors.cairo}}
```

## Vault example

Here's another example that demonstrates the use of errors in a more complex contract:

```rust
{{#include vaultErrors.cairo}}
```
