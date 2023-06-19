# Constructor

Constructors are a special type of function that runs only once when deploying a contract, and can be used to initialize the state of the contract.

Some important rules to note:

- Your contract can't have more than one constructor.
- Your constructor function must be named constructor.
- Lastly, it must be annotated with the #[constructor] attribute.

Here's a simple example that demonstrates the use of constructor:

```rust
{{#include ../listings/ch00-introduction/constructor/src/constructor.cairo}}
```