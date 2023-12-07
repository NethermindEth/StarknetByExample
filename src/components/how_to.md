# Components How-To

Components are like modular addons that can be snapped into contracts to add reusable logic, storage, and events.
They are used to separate the core logic from common functionalities, simplifying the contract's code and making it easier to read and maintain.
It also reduces the risk of bugs and vulnerabilities by using well-tested components.

Key characteristics:
- Modularity: Easily pluggable into multiple contracts.
- Reusable Logic: Encapsulates specific functionalities.
- Not Standalone: Cannot be declared or deployed independently.

## How to create a component

The following example shows a simple `Switch` component that can be used to turn a boolean on or off.
It contains a storage variable `value`, a function `switch` and an event `Switch`.

```rust
{{#include ../../listings/applications/components/src/switch.cairo}}
```

A component in itself is really similar to a contract, it *can* also have:
- An interface defining entrypoints (`ISwitchComponent<TContractState>`)
- A Storage struct
- Events
- Internal functions

It don't have a constructor, but you can create a `_init` internal function and call it from the contract's constructor. In the previous example, the `_off` function is used this way.

## How to use a component

Now that we have a component, we can use it in a contract.
The following contract incorporates the `Switch` component:

```rust
{{#include ../../listings/applications/components/src/contracts/switch.cairo:contract}}
```

## Deep dive into components

You can find more in-depth information about components in the [Cairo book - Components](https://book.cairo-lang.org/ch99-01-05-00-components.html).
