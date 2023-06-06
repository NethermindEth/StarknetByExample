# Errors

In smart contracts, errors play an important role during the execution of transactions. When an error is thrown, it stops the execution of the contract and all changes made during the transaction are reverted.

<!-- Review this -->

In cairo, these errors refers to the unrecoverable errors. `Result` should not be viewed as a smart contract error.

<!-- ----------- -->

Errors are primarily used to validate conditions before performing specific actions. These validations can include:

- Inputs provided by the caller
- Execution requirements
- Invariants (conditions that must always be true)
- Return values from other function calls

Using errors is an effective way to catch bugs early on during development and testing!

To throw an error, use the `assert` or `panic` functions:

- `assert` is used to validate conditions.
  If the check fails, an error is thrown along with a specified value, often a message.
  It's similar to the `require` statement in Solidity.

- `panic` immediately halt the execution with the given error value.
  It should be used when the condition to check is complex and for internal errors. It's similar to the `revert` statement in Solidity.
  (Use `panic_with_felt252` to be able to directly pass a felt252 as the error value)

Here's an example that demonstrates the use of these functions:

```rust
{{#include errors.cairo}}
```

### Security Considerations

<!-- Maybe not necessary -->

Transactions in smart contracts are atomic, meaning they either succeed or fail without making any changes.

Think of smart contracts as state machines: they have a set of initial states defined by the constructor constraints, and external function represents a set of possible state transitions. A transaction is nothing more than a state transition.

Using errors to check conditions adds constraints that helps clearly define the boundaries of possible state transitions for each function in your smart contract. These checks ensure that the behavior of the contract stays within the expected limits.

By incorporating these concepts during development, you can create robust and reliable smart contracts. This reduces the chances of unexpected behavior or vulnerabilities.
