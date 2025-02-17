# Variables

Cairo contracts support three types of variables, each serving a different purpose:

1. **Local Variables**
   - Temporary variables within functions
   - Exist only during function execution
   - Not stored on the blockchain

2. **Storage Variables**
   - Defined in the contract's [Storage](/getting-started/basics/storage)
   - Persist between contract executions
   - Stored on the blockchain

3. **Global Variables**
   - Provide blockchain context and information
   - Accessible anywhere in the contract
   - Read-only system variables

## Local Variables

Local variables are temporary variables that exist only within their defined scope (a function or code block). Key characteristics:

- Stored in memory, not on the blockchain
- Used for intermediate calculations and temporary data
- Available only during function execution
- Help improve code readability by naming values

Here's an example demonstrating local variable scope:

```cairo
// [!include ~/listings/getting-started/variables/src/local_variables.cairo:contract]
```

## Storage Variables

Storage variables provide persistent state for your contract on the blockchain. They have these properties:

- Persist between contract executions
- Can be read for free (no transaction needed)
- Require a transaction to write to them
- Must be defined in the contract's Storage struct

Here's an example showing storage variable usage:

```cairo
// [!include ~/listings/getting-started/variables/src/storage_variables.cairo:contract]
```

:::note
**Storage Access**

- Reading: Free operation, no transaction needed
- Writing: Requires a transaction and costs gas

:::

## Global Variables

Global variables provide access to blockchain context and system information. In Starknet:

- Accessed through core library functions
- Available anywhere in the contract
- Provide critical blockchain context (e.g., caller address, block info)

Example using global variables:

```cairo
// [!include ~/listings/getting-started/variables/src/global_variables.cairo:contract]
```
