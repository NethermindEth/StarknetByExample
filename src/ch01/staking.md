# Staking contract

The following staking contract is designed to allow users to stake tokens in exchange for reward tokens over a specified duration. Here's a quick summary of how it operates and what functionalities it supports:

### Key Features:

1. Token staking and unstaking:
    - Users can take a specific (determined at deployment) ERC20 token into the contract.
    - Users can withdraw their staked tokens at any time.

2. Reward calculation and distribution:
    - The contract distributes another type (determined at deployment) of ERC20 token as rewards.
    - Rewards are calculated based on the duration of staking and the amount the user staked relative to the total staked amount by all users.
    - A user’s reward accumulates over time up until the reward period's end and can be claimed anytime by the user.

3. Dynamic reward rates:
    - The reward rate is determined by the total amount of reward tokens over a set period (duration).
    - The reward rate can be adjusted during the rewards period if new rewards are added before the current reward period finishes.
    - Even after a reward period finishes, a new reward duration and new rewards can be setup if desired.

4. Ownership and administration:
    - Only the owner of the contract can set the rewards amount and duration.

> The reward mechanism ensures that rewards are distributed fairly based on the amount and duration of tokens staked by each user.

The following implementation is the Cairo adaptation of the [Solidity by example Staking Rewards contract](https://solidity-by-example.org/defi/staking-rewards/), with a little adaptation allowing to keep track of the amount of total distributed reward tokens in order to emit an event when the remaining reward tokens amount falls down to 0.

```rust
{{#include ../../listings/applications/staking/src/contract.cairo}}
```

