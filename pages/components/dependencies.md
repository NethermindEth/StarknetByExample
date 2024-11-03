# Component Dependencies

A component with a dependency on a trait `T` can be used in a contract as long as the contract implements the trait `T`.

We will use a new `Countable` component as an example:

```cairo
// [!include ~/listings/applications/components/src/countable.cairo:component]
```

We want to add a way to enable or disable the counter, in a way that calling `increment` on a disabled counter will not increment it.
But we don't want to add this switch logic to the `Countable` component itself.
Instead, we add the trait `Switchable` as a dependency to the `Countable` component.

#### Implementation of the trait in the contract

First, we import the `ISwitchable` trait defined in chapter ["Components How-To"](/components/how_to):

```cairo
// [!include ~/listings/applications/components/src/switchable.cairo:interface]
```

Then we can modify the implementation of the `Countable` component to depend on the `ISwitchable` trait:

```cairo
// [!include ~/listings/applications/components_dependencies/src/countable_dep_switch.cairo:impl]
```

A contract that uses the `Countable` component must implement the `ISwitchable` trait:

```cairo
// [!include ~/listings/applications/components_dependencies/src/contract_countable.cairo:contract]
```

#### Implementation of the trait in another component

In the previous example, we implemented the `ISwitchable` trait in the contract.

We already implemented a [`Switchable`](/components/how_to) component that provides an implementation of the `ISwitchable` trait.
By using the `Switchable` component in a contract, we can embed the implementation of the `ISwitchable` trait in the contract and resolve the dependency on the `ISwitchable` trait.

```cairo
// [!include ~/listings/applications/components_dependencies/src/contract_countable_switchable.cairo:contract]
```

#### Dependency on other component's internal functions

The previous example shows how to use the `ISwitchable` trait implementation from the `Switchable` component inside the `Countable` component by embedding the implementation in the contract.
However, suppose we would like to turn off the switch after each increment. There's no `set` function in the `ISwitchable` trait, so we can't do it directly.

But the `Switchable` component implements the internal function `_off` from the `SwitchableInternalTrait` that set the switch to `false`.
We can't embed `SwitchableInternalImpl`, but we can add `switchable::HasComponent<TContractState>` as a dependency inside `CountableImpl`.

We make the `Countable` component depend on the `Switchable` component.
This will allow to do `switchable::ComponentState<TContractState>` -> `TContractState` -> `countable::ComponentState<TcontractState>` and access the internal functions of the `Switchable` component inside the `Countable` component:

```cairo
// [!include ~/listings/applications/components_dependencies/src/countable_internal_dep_switch.cairo:contract]
```

The `CountableContract` contract remains the same as in the previous example, only the implementation of the `Countable` component is different.
