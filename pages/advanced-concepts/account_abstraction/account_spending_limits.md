# Account Contract with Spending Limits

In this example, we will write an account contract with spending limits.

Before proceeding with this example, make sure that you read [Account Contract](/advanced-concepts/account_abstraction/account_contract) which will help you understand how Starknet account contracts work.

### Key Specifications

The account contract will have the following features:

- The account owner can set a spending limit for any specific ERC-20 token
- Each limit consists of a maximum token amount and time duration
- The owner can spend tokens freely until reaching the limit, after which any spending transactions will revert
- Once the time duration expires, the spending limit becomes inactive and the owner can spend tokens again
- Only one active limit can exist per token at a time - once set, it cannot be modified until expiration

### Transaction validation flow

When the account owner wants to send a transaction, the account contract will use `__validate__` to check if the transaction is valid. For each call, we will check if an active spending limit exists for the token (the `to` contract address).

If there is an active limit, the contract will check if the transaction is a spending transaction and if there's enough limit left.

Then, in `__execute__`, we will decrease the limit by the amount in the transaction and execute the transaction normally.

#### How to check if a transaction is a spending transaction?

The token standard (i.e. ERC-20) is defined in the [SNIP-2](https://github.com/starknet-io/SNIPs/blob/main/SNIPS/snip-2.md). The two functions that allow spending (i.e. transfering) tokens are `transfer` and `transfer_from`.
Another contract could call `transfer_from` with our account contract as the spender, but there's no way to check this in the account contract.
However, it first needs to call `approve` to allow the account contract to spend tokens on its behalf.

In this example, we will consider the `approve` and `transfer` functions as spending transactions.

:::note
This means that we consider that giving allowance to another contract counts directly as spending from the account. But the token could be transfered at a later time (or not at all).
:::

### Implementation

We start our implementation from the `SimpleAccount` contract from [Account Contract](/advanced-concepts/account_abstraction/account_contract) example and add the spending limit feature from there.

Before diving into the contract, we first define the `SpendingLimit` struct, which will hold the maximum token amount and the time duration. Note that we didn't add the `token` contract address to the struct.

```cairo
// [!include ~/listings/advanced-concepts/account_spending_limits/src/account.cairo:spending_limit]
```

Let's define our `ISpendingLimitsAccount` interface:

```cairo
// [!include ~/listings/advanced-concepts/account_spending_limits/src/account.cairo:interface]
```

Then, we add the necessary states in the storage.
We use a `Map<ContractAddress, Option<SpendingLimit>>` to keep track of the spending limits for a specific token. We use `Option` to help us differentiate between the case where there is no limit set and the case where the limit is set to a `SpendingLimit` struct.
We also need to keep track of how much the account has spent so far, so we add a `Map<ContractAddress, u256>` to the storage.

```cairo
// [!include ~/listings/advanced-concepts/account_spending_limits/src/account.cairo:storage]
```

We move on the implementation of the main `ISpendingLimitsAccount` interface, alongside some internal helper functions. We want to add most of the logic of the spending mechanism here!

```cairo
// [!include ~/listings/advanced-concepts/account_spending_limits/src/account.cairo:selectors]

#[starknet::contract(account)]
pub mod SpendingLimitsAccount {
    // ...
    // [!include ~/listings/advanced-concepts/account_spending_limits/src/account.cairo:accountimpl]

    #[generate_trait]
    impl PrivateImpl of PrivateTrait {
      // [!include ~/listings/advanced-concepts/account_spending_limits/src/account.cairo:private]
        // ...
    }
}
```

Then we can finally implement the `__validate__` and `__execute__` functions:

```cairo
// [!include ~/listings/advanced-concepts/account_spending_limits/src/account.cairo:execute_validate]
    // fn is_valid_signature() ...
  }
```

#### Full implementation

The rest of the implementation follows the same pattern as our initial [Account Contract](/advanced-concepts/account_abstraction/account_contract)

```cairo
// [!include ~/listings/advanced-concepts/account_spending_limits/src/account.cairo:execute_validate]
```
