# Account Contract

A smart contract must follow the Standard Account Interface specification defined in the [SNIP-6](https://github.com/starknet-io/SNIPs/blob/main/SNIPS/snip-6.md).
In practice, this means that the contract must implement the `SRC6` and `SRC5` interfaces to be considered an account contract.

## SNIP-6: SRC6 + SRC5

```cairo
/// @title Represents a call to a target contract
/// @param to The target contract address
/// @param selector The target function selector
/// @param calldata The serialized function parameters
struct Call {
    to: ContractAddress,
    selector: felt252,
    calldata: Array<felt252>
}
```

The `Call` struct is used to represent a call to a function (`selector`) in a target contract (`to`) with parameters (`calldata`). It is available under the `starknet::account` module.

```cairo
/// @title SRC-6 Standard Account
trait ISRC6 {
    /// @notice Execute a transaction through the account
    /// @param calls The list of calls to execute
    /// @return The list of each call's serialized return value
    fn __execute__(calls: Array<Call>) -> Array<Span<felt252>>;

    /// @notice Assert whether the transaction is valid to be executed
    /// @param calls The list of calls to execute
    /// @return The string 'VALID' represented as felt when is valid
    fn __validate__(calls: Array<Call>) -> felt252;

    /// @notice Assert whether a given signature for a given hash is valid
    /// @param hash The hash of the data
    /// @param signature The signature to validate
    /// @return The string 'VALID' represented as felt when the signature is valid
    fn is_valid_signature(hash: felt252, signature: Array<felt252>) -> felt252;
}
```

A transaction can be represented as a list of calls `Array<Call>` to other contracts, with atleast one call.

- `__execute__`: Executes a transaction after the validation phase. Returns an array of the serialized return of value (`Span<felt252>`) of each call.

- `__validate__`: Validates a transaction by verifying some predefined rules, such as the signature of the transaction. Returns the `VALID` short string (as a felt252) if the transaction is valid.

- `is_valid_signature`: Verify that a given signature is valid. This is mainly used by applications for authentication purposes.

Both `__execute__` and `__validate__` functions are exclusively called by the Starknet protocol.

 <!-- TODO replace with link to SRC5 example #109 -->

```cairo
/// @title SRC-5 Standard Interface Detection
trait ISRC5 {
    /// @notice Query if a contract implements an interface
    /// @param interface_id The interface identifier, as specified in SRC-5
    /// @return `true` if the contract implements `interface_id`, `false` otherwise
    fn supports_interface(interface_id: felt252) -> bool;
}
```

The interface identifiers of both `SRC5` and `SRC6` must be published with `supports_interface`.

## Minimal account contract Executing Transactions

In this example, we will implement a minimal account contract that can validate and execute transactions.

```cairo
// [!include ~/listings/advanced-concepts/simple_account/src/simple_account.cairo]
```