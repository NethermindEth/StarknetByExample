# Starknet by Example

Starknet By Example is a collection of examples of how to use the Cairo programming language to create smart contracts on Starknet.

Starknet is a permissionless Validity-Rollup that supports general computation. It is currently used as an Ethereum layer-2. Starknet use the STARK cryptographic proof system to ensure high safety and scalability.

Starknet smart contracts are written in the Cairo language. Cairo is a Turing-complete programming language designed to write provable programs, abstracting the zk-STARK proof system away from the programmer.

> ⚠️ The examples have not been audited and are not intended for production use.
> The authors are not responsible for any damages caused by the use of the code provided in this book.

## For whom is this for?

Starknet By Example is for anyone who wants to quickly learn how to write smart contracts on Starknet using Cairo with some technical background in programming and blockchain.

The first chapters will give you a basic understanding of the Cairo programming language and how to write, deploy and use smart contracts on Starknet.
The later chapters will cover more advanced topics and show you how to write more complex smart contracts.

## How to use this book?

Each chapter is a standalone example that demonstrates a specific feature or common use case of smart contracts on Starknet. If you are new to Starknet, it is recommended to read the chapters in order.

Most examples contains interfaces and tests that are hidden by default. You can hover over the code blocks and click on the "Show hidden lines" (eyes icon) to see the hidden code.

You can run each examples online by using the [Starknet Remix Plugin](https://remix.ethereum.org/?#activate=Starknet).

## Further reading

If you want to learn more about the Cairo programming language, you can read the [Cairo Book](https://book.cairo-lang.org).
If you want to learn more about Starknet, you can read the [Starknet documentation](https://docs.starknet.io/) and the [Starknet Book](https://book.starknet.io).

For more resources, check [Awesome Starknet](https://github.com/keep-starknet-strange/awesome-starknet).

## Versions

The current version of this book use:
```
cairo 2.6.3
edition = '2023_11'
{{#include ../.tool-versions}}
```
