---
content:
  horizontalPadding: 50px
  width: 100%
  verticalPadding: 30px
---

# Simple Defi Vault

This is the Cairo adaptation of the [Solidity by Example - Vault](https://solidity-by-example.org/defi/vault/).
Here's how it works:

- When a user deposits a token, the contract calculates the amount of shares to mint.

- When a user withdraws, the contract burns their shares, calculates the yield, and withdraws both the yield and the initial amount of tokens deposited.

<<<<<<<< HEAD:src/applications/simple_vault.md
```cairo
{{#include ../../listings/applications/simple_vault/src/simple_vault.cairo}}
========
```rust
// [!include ~/listings/applications/simple_vault/src/simple_vault.cairo]
>>>>>>>> 261b110 (feat: migrate frontend framework from mdbook to vocs  (#185)):pages/ch01/simple_vault.md
```
