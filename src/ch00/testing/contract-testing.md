# Contract Testing

Testing plays a crucial role in software development, especially for smart contracts. In this section, we'll guide you through the basics of testing a smart contract on Starknet with `scarb`.

Let's start with a simple smart contract as an example:
```rust
{{#include ../../../listings/getting-started/testing_how_to/src/contract.cairo}}
```

Now, take a look at the tests for this contract:
```rust
{{#include ../../../listings/getting-started/testing_how_to/src/tests.cairo}}
```

To define our test, we use scarb, which allows us to create a separate module guarded with `#[cfg(test)]`. This ensures that the test module is only compiled when running tests using `scarb test`.

Each test is defined as a function with the `#[test]` attribute. You can also check if a test panics using the `#[should_panic]` attribute.

As we are in the context of a smart contract, it's essential to set up the gas limit. You do this by using the `#[available_gas(X)]` attribute to specify the gas limit for a test. This is also a great way to ensure that your contract's features stay under a certain gas limit!

> Note: The term "gas" here refers to Sierra gas, not L1 gas

Now, let's move on to the testing process:
- Use the `deploy` function logic to declare and deploy your contract.
- Use `assert` to verify that the contract behaves as expected in the given context.

To make testing more convenient, the `testing` module of the corelib provides some helpful functions:
- `set_caller_address(address: ContractAddress)`
- `set_contract_address(address: ContractAddress)`
- `set_block_number(block_number: u64)`
- `set_block_timestamp(block_timestamp: u64)`
- `set_account_contract_address(address: ContractAddress)`
- `set_max_fee(fee: u128)`

You may also need the `info` module from the corelib, which allows you to access information about the current execution context (see [syscalls](../basics/syscalls.md)):
- `get_caller_address() -> ContractAddress`
- `get_contract_address() -> ContractAddress`
- `get_block_info() -> Box<BlockInfo>`
- `get_tx_info() -> Box<TxInfo>`
- `get_block_timestamp() -> u64`
- `get_block_number() -> u64`


You can found the full list of functions in the [Starknet Corelib repo](https://github.com/starkware-libs/cairo/tree/main/corelib/src/starknet).
You can also find a detailed explanation of testing in cairo in the [Cairo book - Chapter 9](https://book.cairo-lang.org/ch09-01-how-to-write-tests.html).

## Starknet Foundry

<!-- TODO update this when Starknet Foundry is more mature. -->

Starknet Foundry is a powerful toolkit for developing smart contracts on Starknet. It offers support for testing Starknet smart contracts on top of `scarb` with the `Forge` tool.

Testing with `snforge` is similar to the process we just described but simplified. Moreover, additional features are on the way, including cheatcodes or parallel tests execution. We highly recommend exploring Starknet Foundry and incorporating it into your projects.

For more detailed information about testing contracts with Starknet Foundry, check out the [Starknet Foundry Book - Testing Contracts](https://foundry-rs.github.io/starknet-foundry/testing/contracts.html).
