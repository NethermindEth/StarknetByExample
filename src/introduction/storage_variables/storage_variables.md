# Storage Variables

Storage variables are persistent data stored on the blockchain. They can be accessed from one execution to another. Here's a simple example of a contract with one storage variable.
To write or update a storage variable, you need to interact with the contract through an `#[external]` entrypoint by sending a transaction.

On the other hand, you can read state variables, for free, without any transaction, simply by interacting with a node.

```rust
{{#include storage_variables.cairo}}
```
