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

The current book has script that verifies the compilation of all Cairo programs in the book.
Instead of directly writing Cairo programs in the markdown files, we use code blocks that import the Cairo programs from the `listing` directory.
These programs are bundled into scarb packages, which makes it easier to test and build entire packages.

To run the script locally, ensure that you are at the root of the repository (same directory as this `README.md` file),
and run:

`bash scripts/cairo_programs_verifier.sh`
