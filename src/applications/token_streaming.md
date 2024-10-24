# Token Streaming 

Token streaming is a mechanism where tokens are distributed gradually over a specified vesting period. This ensures that the recipient of the tokens cannot access the entire token balance upfront but will receive portions of it gradually:
- **Setting up Token Streams**: Create a stream that specifies the recipient, total tokens, start time, and vesting duration.
- **Vesting Period Specification**: The contract calculates the vested amount over time based on the start and end time of the vesting period.
- **Token Release**: Only the vested amount can be released at any point, ensuring the tokens are gradually unlocked.
  
```cairo
{{#include ..listings/applications/erc20/src/erc20_streaming.cairo}}

```
