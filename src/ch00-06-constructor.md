# Constructor

A blockchain can be seen as a data base, made of states that corresponds to the data inside the blockchain at a certain time. Moving from a state to another is dicted by the functions inside the smart contract. But we still need to have a starting state. 
Normally, starting state is default values ( 0 for felt252, empty for mappings), but if you want, you can chose non default values as a starting point : this is the role of a constructor. 

Constructors are a special type of function that runs only once when deploying a contract, and can be used to initialize the state of the contract.

Some good practice to note:

- Your contract should not have more than one constructor.
- Your constructor function should be named constructor.
- Lastly, it should be annotated with the #[constructor] attribute.

Here's a simple example that demonstrates how to initialize the state of a contract on deployment by defining a constructor.

```rust
{{#include ../listings/ch00-introduction/constructor/src/lib.cairo}}
```