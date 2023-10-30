# Mapping

Cairo supports a key-value like type also called the ```LegacyMap``` these can only be used in the ```storage struct``` to represent a collection of key-value pairs where a unique key always points to its registered value. For example:


```rust
{{#include ../../../listings/ch00-getting-started/cairo_cheatsheet/src/mapping_example.cairo}}
```