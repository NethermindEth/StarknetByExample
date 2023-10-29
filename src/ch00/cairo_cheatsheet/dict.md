# Dictionaries

Cairo supports a dictionary like type also called the ```Felt252Dict<T>``` which is used to represent a collection of key-value pairs. for now the key is restricted to a felt252 type while the value is represented by (T). For example:

## Minimal example

Here's a minimal example of a Dictionary type, used to track users and their age:


```rust
{{#include ../../../listings/ch00-getting-started/cairo_cheatsheet/src/dict_example.cairo}}
```