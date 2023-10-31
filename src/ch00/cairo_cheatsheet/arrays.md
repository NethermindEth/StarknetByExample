# Arrays

Arrays are collections of elements of the same type.
The possible operations on arrays are defined with the `array::ArrayTrait` of the corelib:

```rust
trait ArrayTrait<T> {
    fn new() -> Array<T>;
    fn append(ref self: Array<T>, value: T);
    fn pop_front(ref self: Array<T>) -> Option<T> nopanic;
    fn pop_front_consume(self: Array<T>) -> Option<(Array<T>, T)> nopanic;
    fn get(self: @Array<T>, index: usize) -> Option<Box<@T>>;
    fn at(self: @Array<T>, index: usize) -> @T;
    fn len(self: @Array<T>) -> usize;
    fn is_empty(self: @Array<T>) -> bool;
    fn span(self: @Array<T>) -> Span<T>;
}
```

For example:

```rust
{{#include ../../../listings/ch00-getting-started/cairo_cheatsheet/src/array_example.cairo}}
```
