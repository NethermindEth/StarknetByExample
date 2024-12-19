# L1 <> L2 Token Bridge

In Starknet, it is possible to interact with Ethereum by using the L1 <> L2 messaging system.

In this example, we will demonstrate the usage of this messaging system to send and receive messages from L1 to L2 for a token bridge.

It will require creating two contracts, one on Starknet and one on Ethereum, that will communicate cross-chain, and notify each other
how many tokens to mint and who to assign them to. We will also create very simple mock token implementations that will simply emit
appropriate events on burning and minting. This will allow us to verify that the cross-chain communication actually succeeded.

First, we create the `TokenBridge` contract on Starknet:

```cairo
// [!include ~/listings/applications/l1_l2_token_bridge/src/contract.cairo]
```

The `IMintableToken` interface represents any mintable/burnable token, and will allow our contract to perform these operations without
regard for the actual token it's working with.

Let's immediately create the mock token implementation that we'll use with the contract:

```cairo
// [!include ~/listings/applications/l1_l2_token_bridge/src/mintable_token_mock.cairo]
```

Next, we'll implement the mock token on the Ethereum side, which behaves more or less the same as its Starknet counterpart.

Let's just quickly define the interfaces we'll need:

```solidity
// [!include ~/listings/applications/l1_l2_token_bridge/solidity/src/IMintableTokenEvents.sol]
```

```solidity
// [!include ~/listings/applications/l1_l2_token_bridge/solidity/src/IMintableToken.sol]
```

Now we can create a mock token implementation:

```solidity
// [!include ~/listings/applications/l1_l2_token_bridge/solidity/src/MintableTokenMock.sol]
```

Finally, we will implement the `TokenBridge` contract on Ethereum:

```solidity
// [!include ~/listings/applications/l1_l2_token_bridge/solidity/src/TokenBridge.sol]
```

> Note: Bridging tokens from Ethereum to Starknet usually takes a couple of minutes, and the `#[l1_handler]` function is automatically
invoked by the Sequencer, minting tokens to our Starknet wallet address. On the other hand, for bridging transactions to be
successfully sent from Starknet to Ethereum can take a couple of hours, and will require us to _manually consume the withdrawal_ in
order for the tokens to be sent to our Ethereum wallet address. 
