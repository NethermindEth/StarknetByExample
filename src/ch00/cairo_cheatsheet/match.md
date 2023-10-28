# Match

Cairo supports Match as an extremely powerful control flow construct thats used to compare a value against different patterns and execute code based on the matching pattern, note that match is only available on the enum and felt252 data type also using the felt252 data type, match is only available on the (0) and (_) type. For example:

## Minimal example

Here's a minimal example of a Match expression:


```rust
{{#include ../../../listings/ch00-getting-started/cairo_cheatsheet/src/match_example.cairo}}
```