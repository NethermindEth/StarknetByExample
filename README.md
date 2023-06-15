# CairoByExample

## Description

CairoByExample is a collection of examples of how to use the [Cairo](https://github.com/starkware-libs/cairo) programming language to create smart contracts on Starknet.

## Contribute

### Setup

1. Rust related packages:
   - Install toolchain providing `cargo` using [rustup](https://rustup.rs/).
   - Install [mdBook](https://rust-lang.github.io/mdBook/guide/installation.html)
2. Host machine packages:

   - Install [gettext](https://www.gnu.org/software/gettext/) for translations, usually available with regular package manager:
     `sudo apt install gettext`.

3. Clone this repository.

### Work locally

All the Markdown files **MUST** be edited in english. To work locally in english:

- Start a local server with `mdbook serve` and visit [localhost:3000](http://localhost:3000) to view the book.
  You can use the `--open` flag to open the browser automatically: `mdbook serve --open`.

- Make changes to the book and refresh the browser to see the changes.

- Open a PR with your changes.

### Work locally (Cairo programs verification)

The current book has a mdbook backend to extract Cairo contracts from the markdown sources.

The mdbook-cairo backend is working as following:

1. It takes every code blocks in the markdown source and parse all of them.
2. Code blocks with a main function `#[contract]` are extracted into Cairo contracts.
3. The extracted contracts are named based on the chapter they belong to, and a consecutive
   number of the `#[contract]` found in the chapter.
4. If you have a code block with a `#[contract]` function, but you know that is does not compile,
   you can add an attribute to the code block tag value as following:

   ````
   ```rust,does_not_compile
   #[contract]
   mod Contract{

   }
   ```
   ````

   This main function will still count in the consecutive number of `#[contract]` in the chapter file,
   but will not be extracted into a Cairo program.

To run the CI locally, ensure that you are at the root of the repository (same directoy of this `README.md` file),
and run:

`bash mdbook-cairo/scripts/cairo_local_verify.sh`
