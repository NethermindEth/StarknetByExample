# ERC20 Token

Contracts that follow the [ERC20 Standard](https://eips.ethereum.org/EIPS/eip-20) are called ERC20 tokens. They are used to represent fungible assets.

To create an ERC20 conctract, it must implement the following interface:

```rust
{{#include ../../listings/applications/erc20/src/token.cairo:interface}}
```

In Starknet, function names should be written in *snake_case*. This is not the case in Solidity, where function names are written in *camelCase*.
The Starknet ERC20 interface is therefore slightly different from the Solidity ERC20 interface.

Here's an implementation of the ERC20 interface in Cairo:

```rust
{{#include ../../listings/applications/erc20/src/token.cairo:erc20}}
```

There's several other implementations, such as the [Open Zeppelin](https://docs.openzeppelin.com/contracts-cairo/0.7.0/erc20) or the [Cairo By Example](https://cairo-by-example.com/examples/erc20/) ones.
