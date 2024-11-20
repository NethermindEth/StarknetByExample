# Constant Product AMM

This is the Cairo adaptation of the 
[Solidity by Example - Constant Product AMM](https://solidity-by-example.org/defi/constant-product-amm/).

In this contract, we implement a simple Automated Market Maker (AMM) following
the **constant product formula**: $( x \cdot y = k )$. This formula ensures
that the product of the two token reserves ($x$ and $y$ representing the tokens
being swapper) remains constant, regardless of trades. Here, we provide
liquidity pools that allow users to trade between two tokens or add and remove
liquidity from the pool.

## Key Concepts

1. **approve() before swap or adding liquidity**:
   Before interacting with the AMM (whether through swaps or adding liquidity),
   the user must approve the contract to spend their tokens. This is done by
   calling the `approve()` function on the ERC20 token contracts, allowing the
   AMM to transfer the required tokens on behalf of the user.

2. **Constant Product Formula for Swaps**:
   The swap function operates based on the constant product formula $( x \cdot
   y = k )$, where $x$ and $y$ are the token reserves. When a user swaps one
   token for another, the product of the reserves remains constant, which
   determines how much of the other token the user will receive.

3. **Shares and Token Ratios for Liquidity**:
   When adding liquidity, users provide both tokens in the ratio of the current
   reserves. The number of shares (liquidity tokens) the user receives
   represents their contribution to the pool. Similarly, when removing
   liquidity, users receive back tokens proportional to the number of shares
   they burn.

```cairo
// [!include ~/listings/applications/constant_product_amm/src/contracts.cairo:ConstantProductAmmContract]
```
