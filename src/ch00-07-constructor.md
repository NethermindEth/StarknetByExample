# Constructor

Constructors are a special type of function that runs only once when deploying a contract, and can be used to initialize the state of the contract. Your contract must not have more than one constructor, and that constructor function must be annotated with the `#[constructor]` attribute. Also, a good practice consists in naming that function `constructor`.

Here's a simple example that demonstrates how to initialize the state of a contract on deployment by defining logic inside a constructor.

```rust
{{#include ../listings/ch00-introduction/constructor/src/lib.cairo}}
```
Visit contract on [Voyager](https://goerli.voyager.online/contract/0x017fd6558e67451dA583d123D77F4e2651E91502D08F8F8432355293b11e1f8F) or play with it in [Remix](https://remix.ethereum.org/?#activate=Starknet-cairo1-compiler&url=https://github.com/NethermindEth/StarknetByExample/blob/main/listings/ch00-introduction/constructor/src/lib.cairo).
