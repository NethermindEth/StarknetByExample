# Dictionary

A dictionary is a data structure used to store key-value pairs, enabling efficient data retrieval. The keys and values in a Cairo dictionary can be of various types, including Felt252. Dictionaries provide fast access to data, as they allow for quick lookups, insertions, and deletions based on the keys.The core functionality of a `Felt252Dict<T>` is implemented in the trait `Felt252DictTrait`, which includes all basic operations. Among them, we can find:

- `insert(felt252, T) -> ()` to write values to a dictionary instance.
- `get(felt252) -> T` to read values from it.

For example:

```cairo
// [!include ~/listings/cairo_cheatsheet/src/dict_example.cairo:sheet]
```
