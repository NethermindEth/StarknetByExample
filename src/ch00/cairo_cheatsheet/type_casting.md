# Type casting

Cairo supports the conversion from one scalar types to another by using the into and try_into methods.
`traits::Into` is used for conversion from a smaller data type to a larger data type, while `traits::TryInto` is used when converting from a larger to a smaller type that might not fit. 
For example:

```rust
{{#include ../../../listings/ch00-getting-started/cairo_cheatsheet/src/type_casting_example.cairo}}
```
