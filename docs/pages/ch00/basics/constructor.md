---
content:
  horizontalPadding: 50px
  width: 100%
  verticalPadding: 30px
---

# Constructor

Constructors are a special type of function that runs only once when deploying a contract, and can be used to initialize the state of the contract. Your contract must not have more than one constructor, and that constructor function must be annotated with the `#[constructor]` attribute. Also, a good practice consists in naming that function `constructor`.

Here's a simple example that demonstrates how to initialize the state of a contract on deployment by defining logic inside a constructor.

:::code-group

```rust [contract]
// [!include ~/snippets/listings/getting-started/constructor/src/constructor.cairo:contract]
```

```rust [tests]
// [!include ~/snippets/listings/getting-started/constructor/src/constructor.cairo:tests]
```

:::
