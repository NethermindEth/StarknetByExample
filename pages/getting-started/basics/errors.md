# Error Handling in Cairo

Cairo provides robust error handling mechanisms for smart contracts. When an error occurs during contract execution, the transaction is immediately reverted and all state changes are undone.

## Basic Error Functions

Cairo offers two main functions for error handling:

### 1. `assert`

- Used for condition validation (similar to Solidity's `require`)
- Stops execution if the condition is false
- Supports two formats:

  ```cairo
  assert(condition, 'error message');           // Basic assertion
  assert!(condition, "formatted error: {}", x); // Formatted string error
  ```

### 2. `panic`

- Used for immediate execution halt (similar to Solidity's `revert`)
- Best for complex conditions or internal errors
- Supports multiple formats:

  ```cairo
  panic_with_felt252('error message');           // Basic panic
  panic!("formatted error: value={}", value);    // Formatted string error
  ```

:::warning
While Cairo provides assertion macros like `assert_eq!` and `assert_ne!`, these are **only for testing**. In contract code, always use the standard `assert` function.
:::

## Simple Example

Here's a basic example demonstrating both error handling approaches:

```cairo
// [!include ~/listings/getting-started/errors/src/simple_errors.cairo:contract]
```

## Custom Error Codes

For better organization and consistency, you can define error messages in a dedicated module:

```cairo
// [!include ~/listings/getting-started/errors/src/custom_errors.cairo:contract]
```

## Real-World Example: Vault Contract

Here's a practical example showing error handling in a vault contract that manages deposits and withdrawals:

```cairo
// [!include ~/listings/getting-started/errors/src/vault_errors.cairo:contract]
```

In this example:

1. Custom errors are defined in a separate module
2. The `withdraw` function demonstrates both `assert` and `panic` approaches
3. Balance checks protect against underflow conditions
