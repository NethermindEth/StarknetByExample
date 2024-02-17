# Strings and ByteArrays

In Cairo, there's no native type for strings. Instead, you can use a single `felt252` to store a `short string` or a `ByteArray` for strings of arbitrary length.

## Short strings

Each character is encoded on 8 bits following the ASCII standard, so it's possible to store up to 31 characters in a single `felt252`.

Short strings are declared with single quotes, like this: `'Hello, World!'`.
See the [Felt](../cairo_cheatsheet/felt.md) section for more information about short strings with the `felt252` type.

> Notice that any short string only use up to 31 bytes, so it's possible to represent any short string with the `bytes31`.

## ByteArray (Long strings)

The `ByteArray` struct is used to store strings of arbitrary length. It contain a field `data` of type `Array<bytes31>` to store a sequence of short strings.

ByteArrays are declared with double quotes, like this: `"Hello, World!"`.

They can be stored in the contract's storage and passed as arguments to entrypoints.

```rust
{{#rustdoc_include ../../../listings/getting-started/bytearray/src/bytearray.cairo:contract}}
```

### Operations

ByteArrays also provide a set of operations that facilitate the manipulation of strings.
Here are the available operations on an instance of `ByteArray`:

- `append(mut other: @ByteArray)` - Append another ByteArray to the current one.
- `append_word(word: felt252, len: usize)` - Append a short string to the ByteArray. You **need to ensure** that `len` is at most 31 and that `word` can be converted to a `bytes31` with maximum `len` bytes/characters.
- `append_byte(byte: felt252)` - Append a single byte/character to the end of the ByteArray.
- `len() -> usize` - Get the length of the ByteArray.
- `at(index: usize) -> Option<u8>` - Access the character at the given index.
- `rev() -> ByteArray` - Return a new ByteArray with the characters of the original one in reverse order.
- `append_word_rev(word: felt252, len: usize)` - Append a short string to the ByteArray in reverse order. You **need to ensure** again that `len` is at most 31 and that `word` can be converted to a `bytes31` with maximum `len` bytes/characters.

Additionally, there are some operations that can be called as static functions:

- `concat(left: @ByteArray, right: @ByteArray)` - Concatenate two ByteArrays.

Concatenation of `ByteArray` (`append(mut other: @ByteArray)`) can also be done with the `+` and `+=` operators directly, and access to a specific index can be done with the `[]` operator (with the maximum index being `len() - 1`).
