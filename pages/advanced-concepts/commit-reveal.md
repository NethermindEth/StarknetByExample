# Commit-Reveal

The Commit-Reveal pattern is a fundamental blockchain pattern that enables to:
1. Commit to a value without revealing it *(commit phase)*
2. Reveal the value later to prove they knew it in advance *(reveal phase)*

Some use cases:
- **Blind Auctions**: Bidders commit to their bids first, then reveal them after the bidding period
- **Voting Systems**: Voters commit their votes early, revealing them only after voting ends
- **Knowledge Proofs/Attestations**: Proving you knew information at a specific time without revealing it immediately
- **Fair Random Number Generation**: Players commit to random numbers that get combined later, making it harder to manipulate the outcome

## How It Works

1. **Commit Phase**:
   - User generates a value (`secret`)
   - User creates a hash of this value
   - User submits only the hash on-chain (`commit`)

2. **Reveal Phase**:
   - User submits the original value (`reveal`)
   - Contract verifies that the hash of the submitted value matches the previously committed hash
   - If it matches then it proves that the user knew the value at the commitment time

## Minimal commit-reveal contract:

```cairo
// [!include ~/listings/advanced-concepts/commit_reveal/src/commit_reveal.cairo:contract]
```

Usage example:
```cairo
// [!include ~/listings/advanced-concepts/commit_reveal/src/commit_reveal.cairo:offchain]
```

Some considerations:
- The commit phase must complete before any reveals can start
- Users might choose not to reveal if the outcome is unfavorable (consider adding stake/slashing mechanics to ensure reveals)
