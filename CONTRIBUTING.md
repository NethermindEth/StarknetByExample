# Contributing

When contributing to this repository, please first discuss the change you wish to make via issue or in the telegram channel before making a change.

Join the telegram channel: <https://t.me/StarknetByExample>

The release branch is `main`. The development branch is `dev` and is considered stable (but not released yet).
When you want to contribute, please create a new branch from `dev` and open a pull request to merge your changes back into `dev`.
You should never open a pull request to merge your changes directly into `main`.

The `dev` branch is deployed at <https://starknet-by-example-dev.voyager.online/>

The release branch is `main`. The development branch is `dev` and is considered stable (but not released yet).
When you want to contribute, please create a new branch from `dev` and open a pull request to merge your changes back into `dev`.
You should never open a pull request to merge your changes directly into `main`.

The `dev` branch is deployed at https://starknet-by-example-dev.voyager.online/

Please note we have a code of conduct, please follow it in all your interactions with the project.

## Table of Contents

- [Contributing](#contributing)
  - [Table of Contents](#table-of-contents)
  - [Setup](#setup)
  - [Working with Markdown Files](#working-with-markdown-files)
  - [Adding a new chapter](#adding-a-new-chapter)
  - [Adding a new Cairo program](#adding-a-new-cairo-program)
    - [Verification script](#verification-script)
    - [Tests](#tests)
    - [Use of region](#use-of-region)
  - [Code of Conduct](#code-of-conduct)
    - [Our Pledge](#our-pledge)
    - [Our Standards](#our-standards)
    - [Our Responsibilities](#our-responsibilities)
    - [Scope](#scope)
    - [Enforcement](#enforcement)
    - [Attribution](#attribution)

## Setup

1. Clone this repository.

2. Install the required dependencies using pnpm:

```
pnpm i
```

3. Install `scarb` using [asdf](https://asdf-vm.com/) with `asdf install`. Alternatively, you can install `scarb` manually by following the instructions [here](https://docs.swmansion.com/scarb/).

4. Start the development server:

```
pnpm dev
```

## Repository Structure

There's both a `listings` and a `pages` directory in the repository. The `listings` directory contains all the Cairo programs used in the book, while the `pages` directory contains the Markdown files that make up the book's content.
The whole repository is a Next.js project, and the `listings` directory is a scarb project.

## Working with Markdown Files

All Markdown files (in `/pages`, \*.md/\*mdx) MUST be edited in English. Follow these steps to work locally with Markdown files:

- Make changes to the desired Markdown files in your preferred text editor.
- Save the changes, and your browser window should automatically refresh to reflect the updates.
- Once you've finished making your changes, build the application to ensure everything works as expected:

```
pnpm build
```

- If everything looks good, commit your changes and open a pull request with your modifications.

## Adding a new chapter

- To add a new chapter, create a new markdown file in the `pages` directory. All the Markdown files **MUST** be edited in english. In order to add them to the book, you need to edit the `route.ts` file.

- Do not write directly Cairo program inside the markdown files. Instead, use code blocks that import the Cairo programs from the `listings` directory. These programs are bundled into scarb projects, which makes it easier to test and build all programs. See the next section for more details.

Be sure to check for typos with `typos`:

```bash
cargo install typos-cli
typos pages/
```

## Adding a new Cairo program

You can add or modify examples in the `listings` directory. Each listing is a scarb project.
You can use `scarb init` to create a new scarb project, but be sure to remove the generated git repository with `rm -rf .git` and follow the instructions below for the correct `Scarb.toml` configuration.

We prefer to use Starknet Foundry with `snforge_std`, however you can still use `cairo-test` if desired.
Please use the appropriate `Scarb.toml` configuration. `scarb test` will automatically resolve to `snforge test` if `snforge_std` is in the dependencies.

Here's the required `Scarb.toml` configuration for **Starknet Foundry**:

```toml
[package]
name = "pkg_name"
version.workspace = true
edition.workspace = true

# Specify that this can be used as a dependency in another scarb project:
[lib]

[dependencies]
starknet.workspace = true
# Uncomment the following lines if you want to use additional dependencies:
# OpenZeppelin:
# openzeppelin_{package_name}.workspace = true

# If you want to use another Starknet By Example's listing, you can add it as a dependency like this:
# erc20 = { path = "../../getting-started/erc20" }

[dev-dependencies]
assert_macros.workspace = true
snforge_std.workspace = true

[scripts]
test.workspace = true

[[target.starknet-contract]]
```

You also **NEED** to do the following:

- Remove the generated git repository, `rm -rf .git` (this is important!)
- Double check that the package name is the same as the name of the directory

Here's the required `Scarb.toml` configuration for **cairo-test**:

```toml
[package]
name = "pkg_name"
version.workspace = true
edition.workspace = true

# Specify that this can be used as a dependency in another scarb project:
[lib]

[dependencies]
starknet.workspace = true
# Uncomment the following lines if you want to use additional dependencies:
# OpenZeppelin:
# openzeppelin_{package_name}.workspace = true

# If you want to use another Starknet By Example's listing, you can add it as a dependency like this:
# erc20 = { path = "../../getting-started/erc20" }

[dev-dependencies]
cairo_test.workspace = true

[scripts]
test.workspace = true

[[target.starknet-contract]]
```

### Verification script

The current book has script that verifies the compilation of all Cairo programs in the book.
Instead of directly writing Cairo programs in the markdown files, we use code blocks that import the Cairo programs from the `listing` directory.
These programs are bundled into scarb packages, which makes it easier to test and build entire packages.

To run the script locally, ensure that you are at the root of the repository, and run:

`./scripts/cairo_programs_verifier.sh`

This will check that all the Cairo programs in the book compile successfully using `scarb build`, that every tests passes using `scarb test`, and that the `scarb fmt -c` command does not identify any formatting issues.

You can also use `scarb fmt` to format all the Cairo programs.

### Tests

Every listing needs to have atleast integration tests:

- Integration tests are tests that deploy the contract and interact with the provided interface(s). At minimal make one test to deploy the contract.

- (Optional) Unit tests do not have to deploy the contract and use the interface(s). Unit tests can use mocked implementation or state to test only one specific feature.

Add your contract in a specific file, you can name it `contract.cairo` or anything else. You can also add other files if needed.

You should add the tests in the same file as the contract, using the `#[cfg(test)]` flag and a `tests` module.

Here's a sample `lib.cairo` file:

```cairo
mod contract;
// any other modules you want
```

And in the `contract.cairo` file:

```cairo
// [!region contract]
// Write your contract here
// [!endregion contract]

// [!region test]
#[cfg(test)]
mod tests {
  // Write your tests for the contract here
}
// [!endregion test]
```

You can use Starknet Foundry to write and run your tests.

### Use of region

You can add delimiting comments to select part of the code in the book.

```cairo
file.cairo:

a
// [!region region_name]
b
// [!endregion region_name]
c
```

Then, in the markdown file, you can use the following syntax to include only the code between the delimiting comments:

````markdown
    ```cairo
    // [!include ~/listings/src/contract.cairo:region_name]
    ```
````

This will result in the following code being included in the book:

```cairo
b
```

To render code in tabs format you can use `:::code-group`. Example you can render contract and tests in separate tabs like this:

````
    :::code-group

    ```cairo [contract]
    // [!include ~/listings/src/contract.cairo:contract]
    ```

    ```cairo [tests]
    // [!include ~/listings/src/contract.cairo:tests]
    ```

    :::
````

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

- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

Examples of unacceptable behavior by participants include:

- The use of sexualized language or imagery and unwelcome sexual attention or
  advances
- Trolling, insulting/derogatory comments, and personal or political attacks
- Public or private harassment
- Publishing others' private information, such as a physical or electronic
  address, without explicit permission
- Other conduct which could reasonably be considered inappropriate in a
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

Copyright (c) 2024 Nethermind
