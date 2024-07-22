# Storing Custom Types

While native types can be stored in a contract's storage without any additional work, custom types require a bit more work. This is because at compile time, the compiler does not know how to store custom types in storage. To solve this, we need to implement the `Store` trait for our custom type. It is enough to just derive this trait, unless our custom type contains arrays or dictionaries.

```rust
{{#rustdoc_include ../../../listings/getting-started/storing_custom_types/src/contract.cairo:contract}}
```
