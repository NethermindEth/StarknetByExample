# Component-Contract Storage Collisions

Components can declare their own storage variables.

When a contract uses a component, the component storage is merged with the contract storage.
The storage layout is only determined by the variables names, so variables with the same name will collide.

:::note
In a future release, the `#[substorage(v1)]` will determine the storage layout based on the component as well, so collisions will be avoided.
:::

A good practice is to prefix the component storage variables with the component name, as shown in the [Switchable component example](/components/how_to).

#### Example

Here's an example of a collision on the `switchable_value` storage variable of the `Switchable` component.

Interface:

```cairo
// [!include ~/listings/applications/components/src/others/switch_collision.cairo:interface]
```

Here's the storage of the contract:

```cairo
// [!include ~/listings/applications/components/src/others/switch_collision.cairo:storage]
```

Both the contract and the component have a `switchable_value` storage variable, so they collide:

```cairo
// [!include ~/listings/applications/components/src/others/switch_collision.cairo:collision]
```
