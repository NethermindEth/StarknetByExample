# ERC20 Token

Contracts that follow the [ERC20 Standard](https://eips.ethereum.org/EIPS/eip-20) are called ERC20 tokens. They are used to represent fungible assets, and are fundamental in decentralized applications for representing tradable assets, such as currencies or utility tokens.

To create an ERC20 contract, it must implement the following interface:

```
{{#include ../../listings/applications/erc20/src/token.cairo:interface}}
```

In Starknet, function names should be written in _snake_case_. This is not the case in Solidity, where function names are written in _camelCase_. As a result, the Starknet ERC20 interface is slightly different from the Solidity ERC20 interface, though it maintains the same core functionalities for minting, transferring, and approving tokens.

### ERC20 Implementation in Cairo

Here's an implementation of the ERC20 interface in Cairo:

```
{{#include ../../listings/applications/erc20/src/token.cairo:erc20}}
```

The above implementation showcases the basic structure required for ERC20 tokens on Starknet. Starknet's native Cairo language enables handling token functionalities in a highly scalable and efficient manner, benefiting from Cairo's zero-knowledge architecture.

## Token Streaming Extension

In addition to basic ERC20 functionality, the contract can also be extended with additional features such as token streaming. Token streaming allows gradual distribution of tokens over time, making it suitable for vesting scenarios. 

This extension includes:

1. **Setting Up Token Streams**: Defining a recipient and total amount, along with start and end times for the token distribution.
2. **Vesting Period Management**: Automatically calculates the vested amount of tokens based on time.
3. **Releasing Tokens**: Allows users to withdraw tokens as they become vested.

Here is a basic function used to calculate the amount of tokens available for release:

```
fn releasable_amount(&self, stream: Stream) -> felt252 {
    let current_time = starknet::get_block_timestamp();
    let time_elapsed = current_time - stream.start_time;
    let vesting_duration = stream.end_time - stream.start_time;
    let vested_amount = stream.total_amount * min(time_elapsed, vesting_duration) / vesting_duration;
    vested_amount - stream.released_amount
}
```

This function dynamically calculates the amount of tokens that have vested and are available for release based on the elapsed time since the start of the stream.

## Further Resources

For other implementations and variations of ERC20, there are several notable libraries and examples:
- The [OpenZeppelin Cairo ERC20](https://docs.openzeppelin.com/contracts-cairo/0.7.0/erc20) library provides battle-tested contracts for ERC20 functionality in Starknet.
- The [Cairo By Example](https://cairo-by-example.com/examples/erc20/) repository offers detailed explanations and examples of ERC20 implementation in Cairo.
