# Contributing

When contributing to this repository, please first discuss the change you wish to make via issue or in the telegram channel before making a change. 

Join the telegram channel: https://t.me/StarknetByExample

Please note we have a code of conduct, please follow it in all your interactions with the project.

## Table of Contents

- [Contributing](#contributing)
  - [Table of Contents](#table-of-contents)
  - [Setup](#setup)
  - [MdBook](#mdbook)
  - [Adding a new chapter](#adding-a-new-chapter)
  - [Adding a new Cairo program](#adding-a-new-cairo-program)
    - [Verification script](#verification-script)
    - [Tests](#tests)
    - [Use of anchor](#use-of-anchor)
  - [Translations](#translations)
    - [Initiate a new translation for your language](#initiate-a-new-translation-for-your-language)
  - [Code of Conduct](#code-of-conduct)
    - [Our Pledge](#our-pledge)
    - [Our Standards](#our-standards)
    - [Our Responsibilities](#our-responsibilities)
    - [Scope](#scope)
    - [Enforcement](#enforcement)
    - [Attribution](#attribution)

## Setup

1. Clone this repository.

2. Rust related packages:
   - Install toolchain providing `cargo` using [rustup](https://rustup.rs/).
   - Install [mdBook](https://rust-lang.github.io/mdBook/guide/installation.html) and the required extension with `cargo install mdbook  mdbook-i18n-helpers mdbook-last-changed `.

3. Install `scarb` using [asdf](https://asdf-vm.com/) with `asdf install`. Alternatively, you can install `scarb` manually by following the instructions [here](https://docs.swmansion.com/scarb/).

## MdBook

All the Markdown files **MUST** be edited in english. To work locally in english:

- Start a local server with `mdbook serve` and visit [localhost:3000](http://localhost:3000) to view the book.
  You can use the `--open` flag to open the browser automatically: `mdbook serve --open`.

- Make changes to the book and refresh the browser to see the changes.

- Open a PR with your changes.

## Adding a new chapter

To add a new chapter, create a new markdown file in the `src` directory. All the Markdown files **MUST** be edited in english. In order to add them to the book, you need to add a link to it in the `src/SUMMARY.md` file.

Do not write directly Cairo program inside the markdown files. Instead, use code blocks that import the Cairo programs from the `listing` directory. These programs are bundled into scarb projects, which makes it easier to test and build all programs. See the next section for more details.

## Adding a new Cairo program

You can add or modify examples in the `listings` directory. Each listing is a scarb project.
You can find a template of a blank scarb project in the `listings/template` directory.
(You can also use `scarb init` to create a new scarb project, but be sure to remove the generated git repository)

Here's the required `Scarb.toml` configuration:
  
```toml
[package]
name = "pkg_name"
version.workspace = true

# Specify that this can be used as a dependency in another scarb project:
[lib]

[dependencies]
starknet.workspace = true
# Uncomment the following lines if you want to use additional dependencies:
# Starknet Foundry:
# snforge_std.workspace = true
# OpenZeppelin:
# openzeppelin.workspace = true

# If you want to use another Starknet By Example's listing, you can add it as a dependency like this:
# erc20 = { path = "../../getting-started/erc20" }

[scripts]
test.workspace = true

[[target.starknet-contract]]
casm = true
```

You also NEED to do the following:
- Remove the generated git repository, `rm -rf .git` (this is important!)
- Double check that the `pkg_name` is the same as the name of the directory

### Verification script

The current book has script that verifies the compilation of all Cairo programs in the book.
Instead of directly writing Cairo programs in the markdown files, we use code blocks that import the Cairo programs from the `listing` directory.
These programs are bundled into scarb packages, which makes it easier to test and build entire packages.

To run the script locally, ensure that you are at the root of the repository, and run:

`bash scripts/cairo_programs_verifier.sh`

This will check that all the Cairo programs in the book compile successfully using `scarb build`, that every tests passes using `scarb test`, and that the `scarb fmt -c` command does not identify any formatting issues.

You can also use `scarb fmt` to format all the Cairo programs.

### Tests

Every listing needs to have atleast integration tests:

- Integration tests are tests that deploy the contract and interact with the provided interface(s). They should be placed on a separate file/module named `tests.cairo`. At minimal make one test to deploy the contract.

- (Optional) Unit tests do not have to deploy the contract and use the interface(s). Unit tests can use mocked implementation or state to test only one specific feature. They should be placed on the same file as the example (and hidden in the book using ANCHOR).

The tests modules need to have the `#[cfg(test)]` flag.

Add your contract in a different file, you can name it `contract.cairo` or anything else. You can also add other files if needed.

Here's a sample `lib.cairo` file:

```cairo
mod contract;

#[cfg(test)]
mod tests;
```

> About Starknet Foundry: It is currently not possible to use Starknet Foundry but we are working on it.

### Use of anchor

You can add delimiting comments to select part of the code in the book.
```cairo
file.cairo:

a
// ANCHOR: anchor_name
b
// ANCHOR_END: anchor_name
c
```

Then, in the markdown file, you can use the following syntax to include only the code between the delimiting comments:

```markdown
  ```rust
  {{#include ../../listings/path/to/listing/src/contract.cairo:anchor_name}}
  \```
```

This will result in the following code being included in the book:

```cairo
b
```

## Translations

To work with translations, those are the steps to update the translated content:

- Run a local server for the language you want to edit: `./translations.sh zh-cn` for instance. If no language is provided, the script will only extract translations from english.

- Open the translation file you are interested in `po/zh-cn.po` for instance. You can also use editors like [poedit](https://poedit.net/) to help you on this task.

- When you are done, you should only have changes into the `po/xx.po` file. Commit them and open a PR.
  The PR must stars with `i18n` to let the maintainers know that the PR is only changing translation.

The translation work is inspired from [Comprehensive Rust repository](https://github.com/google/comprehensive-rust/blob/main/TRANSLATIONS.md).

You can test to build the book with all translations using the `build.sh` script and serve locally the `book` directory.

### Initiate a new translation for your language

If you wish to initiate a new translation for your language without running a local server, consider the following tips:

- Execute the command `./translations.sh new xx` (replace `xx` with your language code). This method can generate the `xx.po` file of your language for you.
- To update your `xx.po` file, execute the command `./translations.sh xx` (replace `xx` with your language code), as mentioned in the previous chapter.
- If the `xx.po` file already exists (which means you are not initiating a new translation), you should not run this command.

## Code of Conduct

### Our Pledge

In the interest of fostering an open and welcoming environment, we as
contributors and maintainers pledge to making participation in our project and
our community a harassment-free experience for everyone, regardless of age, body
size, disability, ethnicity, gender identity and expression, level of experience,
nationality, personal appearance, race, religion, or sexual identity and
orientation.

### Our Standards

Examples of behavior that contributes to creating a positive environment
include:

* Using welcoming and inclusive language
* Being respectful of differing viewpoints and experiences
* Gracefully accepting constructive criticism
* Focusing on what is best for the community
* Showing empathy towards other community members

Examples of unacceptable behavior by participants include:

* The use of sexualized language or imagery and unwelcome sexual attention or
advances
* Trolling, insulting/derogatory comments, and personal or political attacks
* Public or private harassment
* Publishing others' private information, such as a physical or electronic
  address, without explicit permission
* Other conduct which could reasonably be considered inappropriate in a
  professional setting

### Our Responsibilities

Project maintainers are responsible for clarifying the standards of acceptable
behavior and are expected to take appropriate and fair corrective action in
response to any instances of unacceptable behavior.

Project maintainers have the right and responsibility to remove, edit, or
reject comments, commits, code, wiki edits, issues, and other contributions
that are not aligned to this Code of Conduct, or to ban temporarily or
permanently any contributor for other behaviors that they deem inappropriate,
threatening, offensive, or harmful.

### Scope

This Code of Conduct applies both within project spaces and in public spaces
when an individual is representing the project or its community. Examples of
representing a project or community include using an official project e-mail
address, posting via an official social media account, or acting as an appointed
representative at an online or offline event. Representation of a project may be
further defined and clarified by project maintainers.

### Enforcement

Instances of abusive, harassing, or otherwise unacceptable behavior may be
reported. All
complaints will be reviewed and investigated and will result in a response that
is deemed necessary and appropriate to the circumstances. The project team is
obligated to maintain confidentiality with regard to the reporter of an incident.
Further details of specific enforcement policies may be posted separately.

Project maintainers who do not follow or enforce the Code of Conduct in good
faith may face temporary or permanent repercussions as determined by other
members of the project's leadership.

### Attribution

This Code of Conduct is adapted from the [Contributor Covenant][homepage], version 1.4,
available at [http://contributor-covenant.org/version/1/4][version]

[homepage]: http://contributor-covenant.org
[version]: http://contributor-covenant.org/version/1/4/
