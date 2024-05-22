# List

By default, there is no list type supported in Cairo, but you can use Alexandria. You can refer to the [Alexandria documentation](https://github.com/keep-starknet-strange/alexandria/tree/main/src/storage) for more details.

## What is `List`?

An ordered sequence of values that can be used in Starknet storage:

```rust
#[storage]
struct Storage {
  amounts: List<u128>
}
```

### Interface

```rust
trait ListTrait<T> {
  fn len(self: @List<T>) -> u32;
  fn is_empty(self: @List<T>) -> bool;
  fn append(ref self: List<T>, value: T) -> u32;
  fn get(self: @List<T>, index: u32) -> Option<T>;
  fn set(ref self: List<T>, index: u32, value: T);
  fn pop_front(ref self: List<T>) -> Option<T>;
  fn array(self: @List<T>) -> Array<T>;
}
```

`List` also implements `IndexView` so you can use the familiar bracket notation to access its members:

```rust
let second = self.amounts.read()[1];
```

Note that unlike `get`, using this bracket notation panics when accessing an out of bounds index.

### Support for custom types

`List` supports most of the corelib types out of the box. If you want to store a your own custom type in a `List`, it has to implement the `Store` trait. You can have the compiler derive it for you using the `#[derive(starknet::Store)]` attribute.

### Caveats

There are two idiosyncacies you should be aware of when using `List`

1. The `append` operation costs 2 storage writes - one for the value itself and another one for updating the List's length
2. Due to a compiler limitation, it is not possible to use mutating operations with a single inline statement. For example, `self.amounts.read().append(42);` will not work. You have to do it in 2 steps:

```rust
let mut amounts = self.amounts.read();
amounts.append(42);
```

### Dependencies

Update your project dependencies by in the `Scarb.toml` file:

```rust
[dependencies]
(...)
alexandria_storage = { git = "https://github.com/keep-starknet-strange/alexandria.git" }
```

For example, let's use `List` to create a contract that tracks a list of amounts and tasks:

```rust
// [!include ~/snippets/listings/advanced-concepts/using_lists/src/contract.cairo]
```

istings/advanced-concepts/using_lists/src/contract.cairo
