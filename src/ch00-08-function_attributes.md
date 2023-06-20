# Function Attributes

When you write functions in a contract using Cairo, you need to provide special annotations to inform the compiler about the nature of each function. These annotations are written as `#[attribute]` just before the function definition.

Let's explore the three main types of functions you can use:

- `#[external]`: These functions can be called from anywhere and have the ability to modify the contract's state. However, it's important to note that interacting with external functions requires sending a transaction, which incurs a gas cost.

- `#[view]`: These functions can also be called from anywhere, but they are read-only and cannot modify the contract's state. The advantage of using view functions is that they can also be invoked without making a transaction. You can interact with them directly through a RPC node, making them essentially free to call!

- Internal: These functions are only accessible within the contract itself and have the ability to modify the contract's state. They are private by default, unlike external and view functions. To mark a function as internal, you simply don't add any annotation to them.

Let's take a look at a simple example contract to see these attributes in action:

```rust
{{#include ../listings/ch00-introduction/function_attributes/src/function_attributes.cairo}}
```
