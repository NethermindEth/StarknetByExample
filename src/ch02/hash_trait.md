# Hash trait

Hashing is a process of converting data of any lenght into a fixed-size value (output). In essence, the hashing process involves passing data of arbitrary length through a hash function to produce a fixed-size output that is totally different from the input data.
Hashing process is deterministic, meaning that when a particular data is hashed a number of times, it always produces the same value. This output is known as a hash.

The two hash functions provided by the Cairo library are `Poseidon` and `Pedersen`.
Pedersen hash functions are cryptographic algorithms that rely on elliptic curve cryptography, while Poseidon was designed particularly for Zero-Knowledge proof systems such as STARKs. 

Pedersen is used on Starknet to compute the addresses of storage variables, however, Poseidon is recommended for use in Cairo programs because it's cheaper and faster when working with proof systems. More details on Starknet hash functions can be found in the [Cairo book](https://book.cairo-lang.org/ch11-03-hash.html)


To use the hashes in programs, we have to first import the relevant traits and functions, then we can have access to the hash functions. The hash trait is accompanied by the `HashStateTrait` that defines the basic methods to work with hashes. These methods include `update` and `finalize`. 
Update allows you to initialize a hash state that will contain the temporary values of the hash after each application of the hash function, while finalize is called when the computation is completed.

```rust
{{#include ../../listings/advanced-concepts/hash_trait/src/lib.cairo}}
```
Checkout the contract on [Voyager] (https://goerli.voyager.online/contract/0x038e5a116cb52b7fb704c383704f6c6ed9f7571a679444fd3c74aaf62983cb7f) to interact with it and see how the final outputs look like.
