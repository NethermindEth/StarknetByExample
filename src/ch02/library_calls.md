# Library Dispatcher

External calls can be made on Starknet by two means: Contract dispatchers or Library dispatchers. Dispatchers are automatically created and exported by the compiler when a contract interface is defined.

With Contract dispatcher we are calling an already deployed contract (with associated state), therefore contract address is passed to the dispatcher to make the call. However, with library dispatcher we are simply making function calls to declared contract **classes** (stateless).

Contract dispatcher call is synonymous to external calls in Solidity, while library dispatcher call is synonymous to delegate call.

For further reading: [Cairo book](https://book.cairo-lang.org/ch15-02-contract-dispatchers-library-dispatchers-and-system-calls.html?highlight=library%20dispatchers#library-dispatcher).

```rust
{{#rustdoc_include ../../listings/advanced-concepts/library_calls/src/library_call.cairo:library_dispatcher}}
```



