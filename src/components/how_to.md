# Components How-To

Components are like modular addons that can be snapped into contracts to add reusable logic, storage, and events.
They are used to separate the core logic from common functionalities, simplifying the contract's code and making it easier to read and maintain.
It also reduces the risk of bugs and vulnerabilities by using well-tested components.

Key characteristics:
- Modularity: Easily pluggable into multiple contracts.
- Reusable Logic: Encapsulates specific functionalities.
- Not Standalone: Cannot be declared or deployed independently.

## How to create a component

The following example shows a simple `Switchable` component that can be used to add a switch that can be either on or off.
It contains a storage variable `switchable_value`, a function `switch` and an event `Switch`.

> It is a good practice to prefix the component storage variables with the component name to [avoid collisions](./collisions.md).

```rust
{{#include ../../listings/applications/components/src/switchable.cairo}}
```

A component in itself is really similar to a contract, it *can* also have:
- An interface defining entrypoints (`ISwitchableComponent<TContractState>`)
- A Storage struct
- Events
- Internal functions

It don't have a constructor, but you can create a `_init` internal function and call it from the contract's constructor. In the previous example, the `_off` function is used this way.

> It's currently not possible to use the same component multiple times in the same contract.
> This is a known limitation that may be lifted in the future.
> 
> For now, you can view components as an implementation of a specific interface/feature (`Ownable`, `Upgradeable`, ... `~able`).
> This is why we called it `Switchable` and not `Switch`; The contract *is switchable*, not *has a switch*.

## How to use a component

Now that we have a component, we can use it in a contract.
The following contract incorporates the `Switchable` component:

```rust
{{#include ../../listings/applications/components/src/contracts/switch.cairo:contract}}
```

## Deep dive into components

You can find more in-depth information about components in the [Cairo book - Components](https://book.cairo-lang.org/ch99-01-05-00-components.html).
