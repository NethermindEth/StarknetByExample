---
content:
  horizontalPadding: 50px
  width: 100%
  verticalPadding: 30px
---

# Arrays

Arrays are collections of elements of the same type.
The possible operations on arrays are defined with the `array::ArrayTrait` of the corelib:

```cairo
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

<<<<<<<< HEAD:src/getting-started/cairo_cheatsheet/arrays.md
```cairo
{{#include ../../../listings/getting-started/cairo_cheatsheet/src/array_example.cairo}}
========
```rust
// [!include ~/listings/getting-started/cairo_cheatsheet/src/array_example.cairo]
>>>>>>>> 261b110 (feat: migrate frontend framework from mdbook to vocs  (#185)):pages/ch00/cairo_cheatsheet/arrays.md
```
