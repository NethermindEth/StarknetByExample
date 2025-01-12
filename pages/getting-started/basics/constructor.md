# Constructor

A constructor is a special function that initializes a contract's state during deployment. It has several key characteristics:

- Runs exactly once when the contract is deployed
- Must be annotated with `#[constructor]`
- Up to one constructor per contract
- Function is conventionally named `constructor`

Here's an example that shows how to initialize storage variables during contract deployment:

```cairo
// [!include ~/listings/getting-started/constructor/src/constructor.cairo:contract]
```

In this example:

- The constructor takes three parameters: `a`, `b`, and `c`
- Each parameter corresponds to a storage variable of the same name, but you can specify any argument variable name
- The values are written to storage using the `write()` method. You need to import the `StoragePointerWriteAccess` trait to be able to write to a specific storage pointer

:::note
**Best Practice**

Constructors are ideal for:

- Setting initial contract state
- Storing deployment-time parameters
- Initializing access control (e.g., setting an owner)

:::

:::warning
**Constructor values cannot be changed after deployment unless you specifically implement functions to modify them.**
:::
