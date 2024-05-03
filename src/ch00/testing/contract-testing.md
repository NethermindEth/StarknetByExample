# Contract Testing

Testing plays a crucial role in software development, especially for smart contracts. In this section, we'll guide you through the basics of testing a smart contract on Starknet with `scarb`.

Let's start with a simple smart contract as an example:

```rust
{{#include ../../../listings/getting-started/testing_how_to/src/contract.cairo:contract}}
```

Now, take a look at the tests for this contract:

```rust
{{#include ../../../listings/getting-started/testing_how_to/src/contract.cairo:tests}}
```

To define our test, we use scarb, which allows us to create a separate module guarded with `#[cfg(test)]`. This ensures that the test module is only compiled when running tests using `scarb test`.

Each test is defined as a function with the `#[test]` attribute. You can also check if a test panics using the `#[should_panic]` attribute.

As we are in the context of a smart contract, you can also set up the gas limit for a test by using the `#[available_gas(X)]`. This is a great way to ensure that some of your contract's features stay under a certain gas limit!

> Note: The term "gas" here refers to Sierra gas, not L1 gas

Now, let's move on to the testing process:

- Use the `deploy` function logic to declare and deploy your contract.
- Use `assert` to verify that the contract behaves as expected in the given context.
  - You can also use assertions macros: `assert_eq`, `assert_ne`, `assert_gt`, `assert_ge`, `assert_lt`, `assert_le`

If you didn't noticed yet, every examples in this book have hidden tests, you can see them by clicking on the "Show hidden lines" (eyes icon) on the top right of code blocks.
You can also find a detailed explanation of testing in cairo in the [Cairo book - Chapter 10](https://book.cairo-lang.org/ch10-00-testing-cairo-programs.html).

## Using the contract state

You can use the `Contract::contract_state_for_testing` function to access the contract state. This function is only available in the test environment and allows you to mutate and read the contract state directly.

This can be useful for testing internal functions, or specific state mutations that are not exposed to the contract's interface. You can either use it with a deployed contract or as a standalone state.

Here is an example of how to do the same previous test using the contract state:

```rust
{{#include ../../../listings/getting-started/testing_how_to/src/contract.cairo:tests_with_state}}
```

## Testing events

In order to test events, you need to use the `starknet::pop_log` function. If the contract did not emit any events, the function will return `Option::None`.

See the test for the [Events](../events.md) section:

```rust
{{#rustdoc_include ../../../listings/getting-started/events/src/counter.cairo:test_events}}
```

## Starknet Corelib Testing Module

To make testing more convenient, the `testing` module of the corelib provides some helpful functions:

- `set_caller_address(address: ContractAddress)`
- `set_contract_address(address: ContractAddress)`
- `set_block_number(block_number: u64)`
- `set_block_timestamp(block_timestamp: u64)`
- `set_account_contract_address(address: ContractAddress)`
- `set_sequencer_address(address: ContractAddress)`
- `set_version(version: felt252)`
- `set_transaction_hash(hash: felt252)`
- `set_chain_id(chain_id: felt252)`
- `set_nonce(nonce: felt252)`
- `set_signature(signature: felt252)`
- `set_max_fee(fee: u128)`
- `pop_log_raw(address: ContractAddress) -> Option<(Span<felt252>, Span<felt252>)>`
- `pop_log<T, +starknet::Event<T>>(address: ContractAddress) -> Option<T>`
- `pop_l2_to_l1_message(address: ContractAddress) -> Option<(felt252, Span<felt252>)>`

You may also need the `info` module from the corelib, which allows you to access information about the current execution context (see [syscalls](../basics/syscalls.md)):

- `get_caller_address() -> ContractAddress`
- `get_contract_address() -> ContractAddress`
- `get_block_info() -> Box<BlockInfo>`
- `get_tx_info() -> Box<TxInfo>`
- `get_block_timestamp() -> u64`
- `get_block_number() -> u64`

You can found the full list of functions in the [Starknet Corelib repo](https://github.com/starkware-libs/cairo/tree/main/corelib/src/starknet).

## Starknet Foundry

Starknet Foundry is a powerful toolkit for developing smart contracts on Starknet. It offers support for testing Starknet smart contracts on top of `scarb` with the `Forge` tool.

Testing with `snforge` is similar to the process we just described but simplified. Moreover, additional features are on the way, including cheatcodes or parallel tests execution. We highly recommend exploring Starknet Foundry and incorporating it into your projects.

For more detailed information about testing contracts with Starknet Foundry, check out the [Starknet Foundry Book - Testing Contracts](https://foundry-rs.github.io/starknet-foundry/testing/contracts.html).
