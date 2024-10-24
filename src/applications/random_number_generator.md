# Random Number Generator

Randomness plays a crucial role in blockchain and smart contract development. In the context of blockchain, randomness is about generating unpredictable values using some source of entropy that is fair and resistant to manipulation. 

In blockchain and smart contracts, randomness is needed for:

- **Gaming:** Ensuring fair outcomes in games of chance.
- **Lotteries:** Selecting winners in a verifiable and unbiased manner.
- **Security:** Generating cryptographic keys and nonces that are hard to predict.
- **Consensus Protocols:** Selecting validators or block producers in some proof-of-stake systems.

However, achieving true randomness on a decentralized platform poses significant challenges. There are numerous sources of entropy, each with its strengths and weaknesses.

### Sources of Entropy

#### 1. Block Properties

- **Description:** Using properties of the blockchain itself, like the hash of a block, or a block timestamp, as a source of randomness.
- **Example:** A common approach is to use the hash of a recent block as a seed for random number generation.
- **Risks:**
    - **Predictability:** Miners can influence future block hashes by controlling the nonce they use during mining.
    - **Manipulation:** Many of the blockchain properties (block hash, timestamp etc.) can be manipulated by some entities, especially if they stand to gain from a specific random outcome.

#### 2. User-Provided Inputs

- **Description:** Allowing users to provide entropy directly, often combined with other sources to generate a random number.
- **Example:** Users submitting their own random values which are then hashed together with other inputs.
- **Risks:**
    - **Collusion:** Users may collude to provide inputs that skew the randomness in their favor.
    - **Front-Running:** Other participants might observe a user's input and act on it before it gets included in the block, affecting the outcome.

#### 3. External Oracles

- **Description:** Using a trusted third-party service to supply randomness. Oracles are off-chain services that provide data to smart contracts.
- **Example:** Pragma VRF (Verifiable Random Function) is a service that provides cryptographically secure randomness.
- **Risks:**
    - **Trust:** Reliance on a third party undermines the trustless nature of blockchain.
    - **Centralization:** If the oracle service is compromised or shut down, so is the randomness it provides.
    - **Cost:** Using an oracle often involves additional transaction fees.

#### 4. Commit-Reveal Schemes

- **Description:** A multi-phase protocol where participants commit to a value in the first phase and reveal it in the second.
- **Example:** Participants submit a hash of their random value (commitment) first and reveal the actual value later. The final random number is derived from all revealed values.
- **Risks:**
    - **Dishonest Behavior:** Participants may choose not to reveal their values if the outcome is unfavorable.
    - **Coordination:** Requires honest participation from multiple parties, which can be hard to guarantee.
    <!-- TODO: link to Commit-Reveal chapter once implemented: https://github.com/NethermindEth/StarknetByExample/issues/77 -->

> There are other ways to generate randomness on-chain, for more information read the ["Public Randomness and Randomness Beacons"](https://a16zcrypto.com/posts/article/public-randomness-and-randomness-beacons/) article.

## CoinFlip using Pragma VRF

Below is an implementation of a `CoinFlip` contract that utilizes a [Pragma Verifiable Random Function (VRF)](https://docs.pragma.build/Resources/Cairo%201/randomness/randomness) to generate random numbers on-chain.

- Players can flip a virtual coin and receive a random outcome of `Heads` or `Tails`
- The contract needs to be funded with enough ETH to perform the necessary operations, including paying fees to Pragma's Randomness Oracle which returns a random value
- When the coin is "flipped", the contract makes a call to the Randomness Oracle to request a random value and the `Flipped` event is emitted
- Randomness is generated off-chain, and then submitted to the contract using the `receive_random_words` callback
- Based on this random value, the contract determines whether the coin "landed" on `Heads` or on `Tails`, and the `Landed` event is emitted

```cairo
{{#include ../../listings/applications/coin_flip/src/contract.cairo}}
```
