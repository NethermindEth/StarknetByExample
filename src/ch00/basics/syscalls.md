# Syscalls

At the protocol level, the Starknet Operating System (OS) is the program that manages the whole Starknet network.

Some of the OS functionalities are exposed to smart contracts through the use of syscalls (system calls). Syscalls can be used to get information about the state of the Starknet network, to interact with/deploy contracts, emit events, send messages, and perform other low-level operations.

Syscalls return a `SyscallResult` which is either `Sucess` of `Failure`, allowing the contract to handle errors.

Here's the available syscalls:
- [get_block_hash](#get_block_hash)
- [get_execution_info](#get_execution_info)
- [call_contract](#call_contract)
- [deploy](#deploy)
- [emit_event](#emit_event)
- [library_call](#library_call)
- [send_message_to_L1](#send_message_to_L1)
- [replace_class](#replace_class)
- [storage_read](#storage_read)
- [storage_write](#storage_write)
<!-- - keccak_syscall ? -->

#### get_block_hash

```rust
fn get_block_hash_syscall(block_number: u64) -> SyscallResult<felt252>
```

Get the hash of the block number `block_number`.

Only within the range `[first_v0_12_0_block, current_block - 10]`.

#### get_execution_info

```rust
fn get_execution_info_syscall() -> SyscallResult<Box<starknet::info::ExecutionInfo>>
```

Get information about the current execution context.
The returned `ExecutionInfo` is defined as :

```rust
#[derive(Copy, Drop, Debug)]
pub struct ExecutionInfo {
    pub block_info: Box<BlockInfo>,
    pub tx_info: Box<TxInfo>,
    pub caller_address: ContractAddress,
    pub contract_address: ContractAddress,
    pub entry_point_selector: felt252,
}

#[derive(Copy, Drop, Debug, Serde)]
pub struct BlockInfo {
    pub block_number: u64,
    pub block_timestamp: u64,
    pub sequencer_address: ContractAddress,
}

#[derive(Copy, Drop, Debug, Serde)]
pub struct TxInfo {
    // The version of the transaction. Always fixed (1)
    pub version: felt252,
    // The account contract from which this transaction originates.
    pub account_contract_address: ContractAddress,
    // The max_fee field of the transaction.
    pub max_fee: u128,
    // The signature of the transaction.
    pub signature: Span<felt252>,
    // The hash of the transaction.
    pub transaction_hash: felt252,
    // The identifier of the chain.
    // This field can be used to prevent replay of testnet transactions on mainnet.
    pub chain_id: felt252,
    // The transaction's nonce.
    pub nonce: felt252,
    // A span of ResourceBounds structs.
    pub resource_bounds: Span<ResourceBounds>,
    // The tip.
    pub tip: u128,
    // If specified, the paymaster should pay for the execution of the tx.
    // The data includes the address of the paymaster sponsoring the transaction, followed by
    // extra data to send to the paymaster.
    pub paymaster_data: Span<felt252>,
    // The data availability mode for the nonce.
    pub nonce_data_availability_mode: u32,
    // The data availability mode for the account balance from which fee will be taken.
    pub fee_data_availability_mode: u32,
    // If nonempty, will contain the required data for deploying and initializing an account
    // contract: its class hash, address salt and constructor calldata.
    pub account_deployment_data: Span<felt252>,
}
```

`starknet::info` provides helper functions to access the `ExecutionInfo` fields in a more convenient way:
- `get_execution_info() -> Box<ExecutionInfo>`
- `get_caller_address() -> ContractAddress`
- `get_contract_address() -> ContractAddress`
- `get_block_info() -> Box<BlockInfo>`
- `get_tx_info() -> Box<TxInfo>`
- `get_block_timestamp() -> u64`
- `get_block_number() -> u64`

#### call_contract

```rust
fn call_contract_syscall(
    address: ContractAddress, entry_point_selector: felt252, calldata: Span<felt252>
) -> SyscallResult<Span<felt252>>
```

Call a contract at `address` with the given `entry_point_selector` and `calldata`.
Failure can't be caught for this syscall, if the call fails, the whole transaction will revert.

This is not the recommended way to call a contract. Instead, use the dispatcher generated from the contract interface as shown in the [Calling other contracts](../interacting/calling_other_contracts.md).

<!-- TODO Add example ? / with interact chapter -->

#### deploy

```rust
fn deploy_syscall(
    class_hash: ClassHash,
    contract_address_salt: felt252,
    calldata: Span<felt252>,
    deploy_from_zero: bool,
) -> SyscallResult<(ContractAddress, Span::<felt252>)>
```

Deploy a new contract of the predeclared class `class_hash` with `calldata`.
The success result is a tuple containing the deployed contract address and the return value of the constructor.

`contract_address_salt` and `deploy_from_zero` are used to compute the contract address.

Example of the usage of the `deploy` syscall from the [Factory pattern](../interacting/factory.md):

```rust
{{#rustdoc_include ../../../listings/getting-started/factory/src/simple_factory.cairo:deploy}}
```

#### emit_event

```rust
fn emit_event_syscall(
    keys: Span<felt252>, data: Span<felt252>
) -> SyscallResult<()>
```

Emit an event with the given `keys` and `data`.

Example of the usage of the `emit_event` syscall from the [Events](../basics/events.md) chapter:

```rust
{{#rustdoc_include ../../../listings/getting-started/events/src/counter.cairo:emit}}
```

<!-- TODO Add a more low-level example ? -->
<!-- ```
let keys = array![];
keys.append('key');
keys.append('deposit');
let values = array![];
values.append(1);
values.append(2);
values.append(3);
emit_event_syscall(keys, values).unwrap_syscall();
``` -->

#### library_call

```rust
fn library_call_syscall(
    class_hash: ClassHash, function_selector: felt252, calldata: Span<felt252>
) -> SyscallResult<Span<felt252>>
```

Call the function `function_selector` of the class `class_hash` with `calldata`.
This is analogous to a delegate call in Ethereum, but only a single class is called.

<!-- TODO Add example: issue #41 -->

#### send_message_to_L1

```rust
fn send_message_to_l1_syscall(
    to_address: felt252, payload: Span<felt252>
) -> SyscallResult<()>
```

Send a message to the L1 contract at `to_address` with the given `payload`.

<!-- TODO - Link to message example page: issue #9 -->

#### replace_class

```rust
fn replace_class_syscall(
    class_hash: ClassHash
) -> SyscallResult<()>
```

Replace the class of the calling contract with the class `class_hash`.

This is used for contract upgrades. Here's an example from the [Upgradeable Contract](../../ch01/upgradeable_contract.md):

```rust
{{#rustdoc_include ../../../listings/applications/upgradeable_contract/src/upgradeable_contract_v0.cairo:upgrade}}
```

The new class code will only be used for future calls to the contract.
The current transaction containing the `replace_class` syscall will continue to use the old class code. (You can explicitly use the new class code by calling `call_contract` after the `replace_class` syscall in the same transaction)

#### storage_read

```rust
fn storage_read_syscall(
    address_domain: u32, address: StorageAddress,
) -> SyscallResult<felt252>
```

This low-level syscall is used to get the value in the storage of a specific key at `address` in the `address_domain`.

`address_domain` is used to distinguish between data availability modes.
Currently, only mode `ONCHAIN` (`0`) is supported.

#### storage_write

```rust
fn storage_write_syscall(
    address_domain: u32, address: StorageAddress, value: felt252
) -> SyscallResult<()>
```

Similar to `storage_read`, this low-level syscall is used to write the value `value` in the storage of a specific key at `address` in the `address_domain`.

## Documentation

Syscalls are defined in [`starknet::syscall`](https://github.com/starkware-libs/cairo/blob/ec14a5e2c484190ff40811c973a72a53739cedb7/corelib/src/starknet/syscalls.cairo)

You can also read the [official documentation page](https://docs.starknet.io/documentation/architecture_and_concepts/Smart_Contracts/system-calls-cairo1/) for more details.

<!--

#### Gas cost

```rust
mod gas_costs {
    const STEP: usize = 100;
    const RANGE_CHECK: usize = 70;

    /// Entry point initial gas cost enforced by the compiler.
    const ENTRY_POINT_INITIAL_BUDGET: usize = 100 * STEP;

    /// OS gas costs.
    const ENTRY_POINT: usize = ENTRY_POINT_INITIAL_BUDGET + 500 * STEP;
    // The required gas for each syscall minus the base amount that was pre-charged (by the
    // compiler).
    pub const CALL_CONTRACT: usize = 10 * STEP + ENTRY_POINT;
    pub const DEPLOY: usize = 200 * STEP + ENTRY_POINT;
    pub const EMIT_EVENT: usize = 10 * STEP;
    pub const GET_BLOCK_HASH: usize = 50 * STEP;
    pub const GET_EXECUTION_INFO: usize = 10 * STEP;
    pub const LIBRARY_CALL: usize = CALL_CONTRACT;
    pub const REPLACE_CLASS: usize = 50 * STEP;
    pub const SEND_MESSAGE_TO_L1: usize = 50 * STEP;
    pub const STORAGE_READ: usize = 50 * STEP;
    pub const STORAGE_WRITE: usize = 50 * STEP;
    /// ...
}
```

Specific gas cost are defined in this [file](https://github.com/starkware-libs/cairo/blob/ec14a5e2c484190ff40811c973a72a53739cedb7/crates/cairo-lang-runner/src/casm_run/mod.rs#L333) 
-->
