# Enums

Just like other programming languages, enums (enumerations) are used in cairo to define variables that can only hold a set of predefined variants (= enum options), enhancing code readability and safety. They facilitate strong type checking and are ideal for organizing related options and supporting structured logic through pattern matching for example, which is also described in the next chapter.

In cairo, `enum variants` can hold different data types (the unit type, structs, other enums, tuples, default core library types, arrays, dictionaries, ...), as shown in the code snippet below. Furthermore, as a quick reminder, enums are expressions, meaning they can return values.

```cairo
// [!include ~/listings/cairo_cheatsheet/src/enum_example.cairo:enums]
```

Enums can be declared both inside and outside a contract. If declared outside, they need to be imported inside using the `use` keyword, just like other imports.

1. Storing enums in contract

    - It is possible to store `enums` in the contract storage. But unlike most of the core library types which implement the `Store` trait, enums are custom types and therefore do not automatically implement the `Store` trait. The enum as well as all of its variants have to explicitly implement the `Store` trait in order for it to be stored inside a contract storage.

    - If all of its variants implement the `Store` trait, implementing the `Store` trait on the enum is as simple as deriving it, using `#[derive(starknet::Store)]` (as shown in example above). If not, the `Store` trait has to be manually implemented.
    <!-- -- see an example of manually implementing the `Store` trait for a complex type in chapter [Storing Arrays](/advanced-concepts/storing_arrays). -->

2. Enums as parameters and return values to entrypoints

    - It is possible to pass `enums` to contract entrypoints as parameters, as well as return them from entrypoints. For that purpose, the enum needs to be serializable and droppable, hence the derivation of traits `Serde` and `Drop` in the above code snippet.

Here is an example of a contract illustrating the above statements :

```cairo
// [!include ~/listings/cairo_cheatsheet/src/enum_example.cairo:enum_contract]
```
