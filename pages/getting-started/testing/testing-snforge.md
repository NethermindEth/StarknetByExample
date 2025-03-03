# Testing with Starknet Foundry (Snforge)

## Overview

Starknet Foundry provides a robust testing framework specifically designed for Starknet smart contracts. Tests can be executed using the `snforge test` command.

:::info
To use snforge as your default test runner, add this to your `scarb.toml{:md}`:
```toml
[scripts]
test = "snforge test"
```
This will make `scarb test` use snforge under the hood.
:::

Let's examine a sample contract that we'll use throughout this section:

```cairo
// [!include ~/listings/getting-started/testing_how_to/src/contract.cairo:contract]
```

## Test Structure and Organization

### Test Location
There are two common approaches to organizing tests:
1. **Integration Tests**: Place in the `tests/{:md}` directory, following your `src/{:md}` structure
2. **Unit Tests**: Place directly in `src/{:md}` files within a test module

For unit tests in source files, always guard the test module with `#[cfg(test)]` to ensure tests are only compiled during testing:

```cairo
// [!include ~/listings/getting-started/testing_how_to/src/contract.cairo:tests]
```

### Basic Test Structure

Each test function requires the `#[test]` attribute. For tests that should verify error conditions, add the `#[should_panic]` attribute.

Here's a comprehensive test example:

```cairo
// [!include ~/listings/getting-started/testing_how_to/src/test_contract.cairo:tests]
```

## Testing Techniques

### Direct Storage Access

For testing specific storage scenarios, snforge provides `load` and `store` functions:

```cairo
// [!include ~/listings/getting-started/testing_how_to/src/test_contract.cairo:tests_with_direct_storage_access]
```

### Contract State Testing

Use `Contract::contract_state_for_testing` to access internal contract state:

```cairo
// [!include ~/listings/getting-started/testing_how_to/src/test_contract.cairo:tests_with_contract_state]
```

### Event Testing

To verify event emissions:

```cairo
// [!include ~/listings/getting-started/testing_how_to/src/test_contract.cairo:tests_with_events]
```

:::info
For more details about events, visit the [Events](/getting-started/basics/events) section.
:::

## Testing Best Practices

1. **Test Environment**: snforge bootstraps a minimal blockchain environment for predictable test execution
2. **Assertions**: Use built-in assertion macros for clear test conditions:
   - `assert_eq!`: Equal comparison
   - `assert_ne!`: Not equal comparison
   - `assert_gt!`: Greater than comparison
   - `assert_ge!`: Greater than or equal comparison
   - `assert_lt!`: Less than comparison
   - `assert_le!`: Less than or equal comparison
3. **Test Organization**: Group related tests in modules and use descriptive test names

## Next Steps

For more advanced testing techniques and features, consult the [Starknet Foundry Book - Testing Contracts](https://foundry-rs.github.io/starknet-foundry/testing/contracts.html).
