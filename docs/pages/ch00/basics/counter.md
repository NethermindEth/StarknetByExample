---
content:
  horizontalPadding: 50px
  width: 100%
  verticalPadding: 30px
---

# Simple Counter

We now understand how to create a contract with state variables and functions. Let's create a simple counter contract that increments and decrements a counter.

Here's how it works:

- The contract has a state variable `counter` that is initialized to `0`.

- When a user calls the `increment` entrypoint, the contract increments `counter` by `1`.

- When a user calls the `decrement`, the contract decrements `counter` by `1`.

:::code-group

```rust [contract]
// [!include ~/snippets/listings/getting-started/counter/src/counter.cairo:contract]
```

```rust [tests]
// [!include ~/snippets/listings/getting-started/counter/src/counter.cairo:tests]
```

:::
