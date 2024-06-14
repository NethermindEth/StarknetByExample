# Crowdfunding Campaign

Crowdfunding is a method of raising capital through the collective effort of many individuals. It allows project creators to raise funds from a large number of people, usually through small contributions.

1. Contract admin creates a campaign in some user's name (i.e. creator).
2. Users can pledge, transferring their token to a campaign.
3. Users can "unpledge", retrieving their tokens.
4. The creator can at any point refund any of the users.
5. Once the total amount pledged is more than the campaign goal, the campaign funds are "locked" in the contract, meaning the users can no longer unpledge; they can still pledge though.
6. After the campaign ends, the campaign creator can claim the funds if the campaign goal is reached.
7. Otherwise, campaign did not reach it's goal, pledgers can retrieve their funds.
8. The creator can at any point cancel the campaign for whatever reason and refund all of the pledgers.
9. The contract admin can upgrade the contract implementation, refunding all of the users and reseting the campaign state.

```rust
{{#include ../../../listings/applications/crowdfunding/src/campaign.cairo:contract}}
```
