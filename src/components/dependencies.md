# Components Dependencies

A component with a dependency on a trait T can be used in a contract as long as the contract implements the trait T.

We will use a new `Countable` component as an example:

```rust
{{#include ../../listings/applications/components/src/countable.cairo}}
```

We want to add a way to enable or disable the counter, in a way that calling `increment` on a disabled counter will not increment the counter.
But we don't want to add this switch logic to the `Countable` component itself.
We instead add the trait `Switchable` as a dependency to the `Countable` component.

#### Implementation of the trait in the contract

We first define the `ISwitchable` trait:

```rust
{{#include ../../listings/applications/components/src/switchable.cairo:interface}}
```

Then we can modify the implementation of the `Countable` component to depend on the `ISwitchable` trait:

```rust
{{#rustdoc_include ../../listings/applications/components_dependencies/src/countable_dep_switch.cairo:impl}}
```

A contract that uses the `Countable` component must implement the `ISwitchable` trait:

```rust
{{#rustdoc_include ../../listings/applications/components_dependencies/src/contract_countable.cairo:contract}}
```

#### Implementation of the trait in another component

In the previous example, we implemented the `ISwitchable` trait in the contract.

We already implemented a [`Switchable`](./how_to.md) component that provide an implementation of the `ISwitchable` trait.
By using the `Switchable` component in a contract, we embed the implementation of the `ISwitchable` trait in the contract and resolve the dependency on the `ISwitchable` trait.

```rust
{{#rustdoc_include ../../listings/applications/components_dependencies/src/contract_countable_switchable.cairo:contract}}
```

#### Dependency on other components internal functions

The previous example shows how to use the `ISwitchable` trait implementation from the `Switchable` component inside the `Countable` component by embedding the implementation in the contract.
However, suppose we would like to turn off the switch after each increment. There's no `set` function in the `ISwitchable` trait, so we can't do it directly.

But the Switchable component implements the internal function `_off` from the `SwitchableInternalTrait` that set the switch to `false`.
We can't embed `SwitchableInternalImpl`, but we can add `switchable::HasComponent<TContractState>` as a dependency inside `CountableImpl`.

We make the `Countable` component depend on the `Switchable` component.
This will allow to do `switchable::ComponentState<TContractState>` -> `TContractState` -> `countable::ComponentState<TcontractState>` and access the internal functions of the `Switchable` component inside the `Countable` component:

```rust
{{#rustdoc_include ../../listings/applications/components_dependencies/src/countable_internal_dep_switch.cairo}}
```

The contract remains the same that the previous example, but the implementation of the `Countable` component is different:
```rust
{{#rustdoc_include ../../listings/applications/components_dependencies/src/contract_countable_switchable_internal.cairo:contract}}
```
