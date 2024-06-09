# NFT Dutch Auction

This is the Cairo adaptation (with some modifications) of the [Solidity by example NFT Dutch Auction](https://solidity-by-example.org/app/dutch-auction/).

Here's how it works:
- The seller of the NFT deploys this contract with a startingPrice.
- The auction lasts for a specified duration.
- The price decreases over time.
- Participants can purchase NFTs at any time as long as the totalSupply has not been reached.
- The auction ends when either the totalSupply is reached or the duration has elapsed.

```rust
{{#include ../../listings/applications/nft_auction/src/nft_auction.cairo}}
```