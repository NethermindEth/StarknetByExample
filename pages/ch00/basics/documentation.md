---
showOutline: false
content:
  horizontalPadding: 50px
  width: 100%
  verticalPadding: 30px
---

# Documentation

It's important to take the time to document your code. It will helps developers and users to understand the contract and its functionalities.

In Cairo, you can add comments with `//`.

### Best Practices:

Since Cairo 1, the community has adopted a [Rust-like documentation style](https://doc.rust-lang.org/rust-by-example/meta/doc.html).

### Contract Interface:

In smart contracts, you will often have a trait that defines the contract's interface (with `#[starknet::interface]`).
This is the perfect place to include detailed documentation explaining the purpose and functionality of the contract entry points. You can follow this template:

```rust
#[starknet::interface]
trait IContract<TContractState> {
    /// High-level description of the function
    ///
    /// # Arguments
    ///
    /// * `arg_1` - Description of the argument
    /// * `arg_n` - ...
    ///
    /// # Returns
    ///
    /// High-level description of the return value
    fn do_something(ref self: TContractState, arg_1: T_arg_1) -> T_return;
}
```

Keep in mind that this should not describe the implementation details of the function, but rather the high-level purpose and functionality of the contract from the perspective of a user.

### Implementation Details:

When writing the logic of the contract, you can add comments to describe the technical implementation details of the functions.

> Avoid over-commenting: Comments should provide additional value and clarity.
