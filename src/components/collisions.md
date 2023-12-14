# Component-Contract Storage Collisions

Components can declare their own storage variables.

When a contract use a component, the component storage is merged with the contract storage.
The storage layout is only determined by the variables names, so variables with the same name will collide.

> In a future release, the `#[substorage(v1)]` will determine the storage layout based on the component as well, so collisions will be avoided.

A good practice is to prefix the component storage variables with the component name, as shown in the [Switchable component example](./how_to.md).

#### Example

Here's an example of a collision on the `switchable_value` storage variable of the `Switchable` component.

Interface:
```rust
{{#include ../../listings/applications/components/src/contracts/switch_collision.cairo:interface}}
```

Here's the storage of the contract (you can expand the code snippet to see the full contract):
```rust
{{#rustdoc_include ../../listings/applications/components/src/contracts/switch_collision.cairo:storage}}
```

Both the contract and the component have a `switchable_value` storage variable, so they collide:

```rust
{{#rustdoc_include ../../listings/applications/components/src/contracts/tests/switch_collision_tests.cairo:collision}}
```
