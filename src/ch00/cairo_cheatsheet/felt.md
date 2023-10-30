# Felt252

Felt252 is a fundamental data type in Cairo from which all other data types are derived. Felt252 are used to store short-string representations with a maximim length of 31 characters. This is because 252 bits can only comfortably contain 31 ASCII characters (each character has a 7 - 8 bits size). For example:



```rust
{{#include ../../../listings/ch00-getting-started/cairo_cheatsheet/src/felt_example.cairo}}
```