# AdvancedFactory: Crowdfunding

This is an example of an advanced factory contract that manages crowdfunding Campaign contracts created in the ["Crowdfunding" chapter](/applications/crowdfunding). The advanced factory allows for a centralized creation and management of `Campaign` contracts on the Starknet blockchain, ensuring that they adhere to a standard interface and can be easily upgraded.

Key Features
1. **Campaign Creation**: Users can create new crowdfunding campaigns with specific details such as title, description, goal, and duration.
2. **Campaign Management**: The factory contract stores and manages the campaigns, allowing for upgrades and tracking.
3. **Upgrade Mechanism**: The factory owner can update the implementation of the campaign contract, ensuring that all campaigns benefit from improvements and bug fixes.
    - the factory only updates it's `Campaign` class hash and emits an event to notify any listeners, but the `Campaign` creators are in the end responsible for actually upgrading their contracts.

```cairo
// [!include ~/listings/applications/advanced_factory/src/contract.cairo:contract]
```
