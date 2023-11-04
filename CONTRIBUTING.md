# Contributing

When contributing to this repository, please first discuss the change you wish to make via issue or in the telegram channel before making a change. 

Join the telegram channel: https://t.me/StarknetByExample

Please note we have a code of conduct, please follow it in all your interactions with the project.

## Adding a new chapter

To add a new chapter, create a new markdown file in the `src` directory. All the Markdown files **MUST** be edited in english. In order to add them to the book, you need to add a link to it in the `src/SUMMARY.md` file.

Do not write directly Cairo program inside the markdown files. Instead, use code blocks that import the Cairo programs from the `listing` directory. These programs are bundled into scarb projects, which makes it easier to test and build all programs. See the next section for more details.

## Adding a new Cairo program

You can add or modify examples in the `listings` directory. Each listing is a scarb project. You can use `scarb init` to create a new scarb project (You can remove the generated git repository, `rm -rf .git`). Here's the minimal `Scarb.toml` configuration:
  
```toml
[package]
name = "pkg_name"
version = "0.1.0"

[dependencies]
starknet = ">=2.2.0"

[[target.starknet-contract]]
```
Be sure to adapt it to your needs.

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
  ```
```

This will result in the following code being included in the book:

```cairo
b
```

## Pull Request

Please follow and check the pull request template requirements before submitting a pull request.

Additionally, please ensure your pull request adheres to the following guidelines:
1. Ensure any install or build dependencies are not committed to the repository.
2. Update the documentation (README.md, CONTRIBUTING.md, ...) if needed.

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
