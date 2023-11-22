# Starknet by Example

## Description

Starknet by Example is a collection of examples of how to use the [Cairo](https://github.com/starkware-libs/cairo) programming language to create smart contracts on Starknet.

## Contribute

### Setup

1. Clone this repository.
2. Rust related packages:
   - Install toolchain providing `cargo` using [rustup](https://rustup.rs/).
   - Install [mdBook](https://rust-lang.github.io/mdBook/guide/installation.html) and the required extension with `cargo install mdbook mdbook-last-changed`.
3. Install `scarb` using [asdf](https://asdf-vm.com/) with `asdf install`. Alternatively, you can install `scarb` manually by following the instructions [here](https://docs.swmansion.com/scarb/).

### Local development

#### MdBook

All the Markdown files **MUST** be edited in english. To work locally in english:

- Start a local server with `mdbook serve` and visit [localhost:3000](http://localhost:3000) to view the book.
  You can use the `--open` flag to open the browser automatically: `mdbook serve --open`.

- Make changes to the book and refresh the browser to see the changes.

- Open a PR with your changes.

#### Cairo programs

The current book has script that verifies the compilation of all Cairo programs in the book.
Instead of directly writing Cairo programs in the markdown files, we use code blocks that import the Cairo programs from the `listing` directory.
These programs are bundled into scarb packages, which makes it easier to test and build entire packages.

To run the script locally, ensure that you are at the root of the repository (same directory as this `README.md` file),
and run:

`bash scripts/cairo_programs_verifier.sh`

This will check that all the Cairo programs in the book compile successfully using `scarb build`, that every tests passes using `scarb test`, and that the `scarb fmt -c` command does not identify any formatting issues.

You can also use `bash scripts/cairo_programs_format.sh` to format all the Cairo programs in the book using `scarb fmt` automatically.

If you want to add a new smart contract to the book, you can follow these steps:
1. Create a new directory in the `listing` directory.
2. Initialize a scarb project in the new directory with `scarb init`.
3. Add `[[target.starknet-contract]]` and the starknet dependency to the `Scarb.toml` file.
