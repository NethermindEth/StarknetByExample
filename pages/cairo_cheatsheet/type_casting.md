# Type casting

Cairo supports the conversion from one scalar type to another by using the `into` and `try_into` methods.
The `into` method is used for conversion from a smaller data type to a larger data type, while `try_into` is used when converting from a larger to a smaller type that might not fit.

For example:

```cairo
// [!include ~/listings/cairo_cheatsheet/src/type_casting_example.cairo:sheet]
```
