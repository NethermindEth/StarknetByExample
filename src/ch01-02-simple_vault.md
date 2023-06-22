# Simple Defi Vault

This is the Cairo adaptation of the [Solidity by example Vault](https://solidity-by-example.org/defi/vault/).
Here's how it works:

- When a user deposits a token, the contract calculates the amount of shares to mint.

- When a user withdraws, the contract burns their shares, calculates the yield, and withdraw both the yield and the initial amount of token deposited.

```rust
{{#include ../listings/ch01-applications/simple_vault/src/simple_vault.cairo}}
```

> **Note**
> As of version v1.1.0, we need to enable `experimental_v0.1.0` libfuncs to use `u256_divmod_safe` as it hasn't been audited yet.
> It'll be included in v2.0.0.