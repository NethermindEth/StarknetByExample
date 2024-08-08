# Randomness: Dice Game using Pragma VRF

## Understanding Randomness on the Blockchain

Randomness in blockchain applications is a challenging problem due to the deterministic nature of blockchains. In a blockchain, the same input always produces the same output, which conflicts with the need for unpredictable, random numbers in many applications. This determinism is crucial for consensus and verification but presents obstacles for use cases requiring randomness, such as fair selection in consensus mechanisms, lottery systems, or gaming applications.

One approach to generate randomness on the blockchain is the use of Verifiable Random Functions (VRFs). A VRF is a cryptographic function that generates a random number along with a proof of its correct generation. This proof can be verified by anyone, ensuring transparency and fairness.

This code provides an implementation of a Dice Game contract that utilizes a [Pragma Verifiable Random Function (VRF)](https://docs.pragma.build/Resources/Cairo%201/randomness/randomness) to generate random numbers on-chain.

```rust
{{#include ../../listings/applications/dice_game_vrf/src/dice_game_vrf.cairo:DiceGameInterfaces}}
```

```rust
{{#include ../../listings/applications/dice_game_vrf/src/dice_game_vrf.cairo:DiceGameContract}}
```
