# Simple Defi Vault

This is the Cairo adaptation of the [Solidity by example Vault](https://solidity-by-example.org/defi/vault/).
Here's how it works:

- When a user deposits a token, the contract calculates the amount of shares to mint.

- When a user withdraws, the contract burns their shares, calculates the yield, and withdraw both the yield and the initial amount of token deposited.

```rust
{{#include ../../listings/applications/simple_vault/src/simple_vault.cairo}}
```

Play with this contract in [Remix](https://remix.ethereum.org/?#activate=Starknet&url=https://github.com/NethermindEth/StarknetByExample/blob/main/listings/applications/simple_vault/src/simple_vault.cairo).