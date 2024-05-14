# Dice Game using Pragma VRF

This code provides an implementation of a Dice Game contract that utilizes a [Pragma Verifiable Random Function (VRF)](https://docs.pragma.build/Resources/Cairo%201/randomness/randomness) to generate random numbers on-chain.

```rust
{{#include ../../listings/applications/dice_game_vrf/src/dice_game_vrf.cairo:DiceGameInterfaces}}
```

```rust
{{#include ../../listings/applications/dice_game_vrf/src/dice_game_vrf.cairo:DiceGameContract}}
```
