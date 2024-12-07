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

:::note
It is a good practice to prefix the component storage variables with the component name to [avoid collisions](/components/collisions).
:::

```cairo
// [!include ~/listings/applications/components/src/switchable.cairo:component]
```

A component is really similar to a contract and can also have:

- An interface defining entrypoints (`ISwitchableComponent<TContractState>`)
- A Storage struct
- Events
- Internal functions

It doesn't have a constructor, but you can create an `_init` internal function and call it from the contract's constructor. In the previous example, the `_off` function will be used this way.

:::note
It's currently not possible to use the same component multiple times in the same contract.
This is a known limitation that may be lifted in the future.

For now, you can view components as implementations of specific interfaces or features (`Ownable`, `Upgradeable`, ... ~`able`).
This is why we called the component in the above example `Switchable`, and not `Switch`; the contract _is switchable_, it does not _have a switch_.
:::

## How to use a component

Now that we have a component, we can use it in a contract.
The following contract incorporates the `Switchable` component:

```cairo
// [!include ~/listings/applications/components/src/switchable.cairo:contract]
```

## How to test a component

In order to effectively test a component, you need to test it in the context of a contract.
A common practice is to declare a `Mock` contract that has the only purpose of testing the component.

To test the `Switchable` component, we can use the previous `SwitchableContract`:

```cairo
// [!include ~/listings/applications/components/src/switchable.cairo:tests]
```

## Deep dive into components

You can find more in-depth information about components in [The Cairo book - Components](https://book.cairo-lang.org/ch16-02-00-composability-and-components.html).
