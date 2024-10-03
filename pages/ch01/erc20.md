---
content:
  horizontalPadding: 50px
  width: 100%
  verticalPadding: 30px
---

# ERC20 Token

Contracts that follow the [ERC20 Standard](https://eips.ethereum.org/EIPS/eip-20) are called ERC20 tokens. They are used to represent fungible assets.

To create an ERC20 contract, it must implement the following interface:

<<<<<<<< HEAD:src/applications/erc20.md
```cairo
{{#include ../../listings/applications/erc20/src/token.cairo:interface}}
========
```rust
// [!include ~/listings/applications/erc20/src/token.cairo:interface]
>>>>>>>> 261b110 (feat: migrate frontend framework from mdbook to vocs  (#185)):pages/ch01/erc20.md
```

In Starknet, function names should be written in _snake_case_. This is not the case in Solidity, where function names are written in _camelCase_.
The Starknet ERC20 interface is therefore slightly different from the Solidity ERC20 interface.

Here's an implementation of the ERC20 interface in Cairo:

<<<<<<<< HEAD:src/applications/erc20.md
```cairo
{{#include ../../listings/applications/erc20/src/token.cairo:erc20}}
========
```rust
// [!include ~/listings/applications/erc20/src/token.cairo:erc20]
>>>>>>>> 261b110 (feat: migrate frontend framework from mdbook to vocs  (#185)):pages/ch01/erc20.md
```

There's several other implementations, such as the [Open Zeppelin](https://docs.openzeppelin.com/contracts-cairo/0.7.0/erc20) or the [Cairo By Example](https://cairo-by-example.com/examples/erc20/) ones.
