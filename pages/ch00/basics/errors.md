# Errors

Errors can be used to handle validation and other conditions that may occur during the execution of a smart contract.
If an error is thrown during the execution of a smart contract call, the execution is stopped and any changes made during the transaction are reverted.

To throw an error, use the `assert` or `panic` functions:

- `assert` is used to validate conditions.
  If the check fails, an error is thrown along with a specified value, often a message.
  It's similar to the `require` statement in Solidity.

- `panic` immediately halts the execution with the given error value.
  It should be used for complex condition checks and for internal errors. It's similar to the `revert` statement in Solidity.
  You can use `panic_with_felt252` to directly pass a `felt252` as the error value.

The `assert_eq!`, `assert_ne!`, `assert_lt!`, `assert_le!`, `assert_gt!` and `assert_ge!` macros can be used as an `assert` shorthand to compare two values, but **only** in tests. In contracts, you should only use the `assert` function.

Here's a simple example that demonstrates the use of these functions:

<<<<<<<< HEAD:src/getting-started/basics/errors.md
```cairo
{{#rustdoc_include ../../../listings/getting-started/errors/src/simple_errors.cairo:contract}}
========
:::code-group

```rust [contract]
// [!include ~/listings/getting-started/errors/src/simple_errors.cairo:contract]
>>>>>>>> 261b110 (feat: migrate frontend framework from mdbook to vocs  (#185)):pages/ch00/basics/errors.md
```

```rust [tests]
// [!include ~/listings/getting-started/errors/src/simple_errors.cairo:tests]
```

:::

## Custom errors

You can make error handling easier by defining your error codes in a specific module.

<<<<<<<< HEAD:src/getting-started/basics/errors.md
```cairo
{{#rustdoc_include ../../../listings/getting-started/errors/src/custom_errors.cairo:contract}}
========
:::code-group

```rust [contract]
// [!include ~/listings/getting-started/errors/src/custom_errors.cairo:contract]
>>>>>>>> 261b110 (feat: migrate frontend framework from mdbook to vocs  (#185)):pages/ch00/basics/errors.md
```

```rust [tests]
// [!include ~/listings/getting-started/errors/src/custom_errors.cairo:tests]
```

:::

## Vault example

Here's another example that demonstrates the use of errors in a more complex contract:

<<<<<<<< HEAD:src/getting-started/basics/errors.md
```cairo
{{#rustdoc_include ../../../listings/getting-started/errors/src/vault_errors.cairo:contract}}
========
:::code-group

```rust [contract]
// [!include ~/listings/getting-started/errors/src/vault_errors.cairo:contract]
>>>>>>>> 261b110 (feat: migrate frontend framework from mdbook to vocs  (#185)):pages/ch00/basics/errors.md
```

```rust [tests]
// [!include ~/listings/getting-started/errors/src/vault_errors.cairo:tests]
```

:::
