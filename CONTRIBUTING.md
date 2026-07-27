# Contributing to mindee-api-ruby

:+1::tada: First off, thanks for taking the time to contribute! :tada::+1:

The following is a set of guidelines for contributing to mindee-api-ruby which are hosted on GitHub.
These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

## Code of Conduct

This project and everyone participating in it is governed by the following [Code of Conduct](CODE_OF_CONDUCT.md).
By participating, you are expected to uphold this code.
Please report unacceptable behavior to [contact@mindee.com](mailto:contact@mindee.com).

## How Can I Contribute

### Reporting Bugs

Bugs are tracked as [GitHub issues](https://guides.github.com/features/issues/).

To help maintainers and the community to be efficient, follow these guidelines:

* **Use a clear and descriptive title** for the issue to identify the problem.
* **Describe the exact steps which reproduce the problem** in as many details as possible.
    When listing steps, **don't just say what you did, but explain how you did it**.
    For example, with canvas related problem, explain if you used the mouse or a keyboard shortcut, what kind of image input it is etc...
* **Provide specific examples to demonstrate the steps**.
    Include links to files or GitHub projects, or copy/pasteable snippets, which you use in those examples.
    If you're providing snippets in the issue, use [Markdown code blocks](https://help.github.com/articles/markdown-basics/#multiple-lines).
* **Describe the behavior you observed after following the steps** and point out what exactly is the problem with that behavior.
* **Explain which behavior you expected to see instead and why.**
* **If the problem wasn't triggered by a specific action**, describe what you were doing before the problem happened and share more information using the guidelines below.
* **Can you reliably reproduce the issue?** If not, provide details about how often the problem happens and under which conditions it normally happens.

> **Note:** If you find a **Closed** issue that seems like it is the same thing that you're experiencing, open a new issue and include a link to the original issue in the body of your new one.

Include details about your configuration and environment:

* **Which version of  mindee-api-ruby are you using?**
* **What's the name and version of the browser you're using, on which OS**?

### Suggesting Enhancements

Enhancement suggestions are tracked as [GitHub issues](https://guides.github.com/features/issues/).

Make sure to provide the following information:

* **Use a clear and descriptive title** for the issue to identify the suggestion.
* **Provide a step-by-step description of the suggested enhancement** in as many details as possible.
* **Provide specific examples to demonstrate the steps**. Include copy/pasteable snippets which you use in those examples, as [Markdown code blocks](https://help.github.com/articles/markdown-basics/#multiple-lines).
* **Describe the current behavior** and **explain which behavior you expected to see instead** and why.
* **Include screenshots and animated GIFs** which help you demonstrate the steps or point out the part of the sdk which the suggestion is related to. You can use [this tool](https://www.cockos.com/licecap/) to record GIFs on macOS and Windows, and [this tool](https://github.com/colinkeenan/silentcast) or [this tool](https://github.com/GNOME/byzanz) on Linux.
* **Specify which version of  mindee-api-ruby you're using.**
* **Specify the name and version of the browser and OS you're using.**

### Pull Requests

The process described here has several goals:

- Maintain mindee SDK quality
- Fix problems that are important to users
- Engage the community in working toward the best possible SDK
- Enable a sustainable system for mindee's maintainers to review contributions

Please follow these steps to have your contribution considered by the maintainers:

1. Follow all instructions in [the template](.github/PULL_REQUEST_TEMPLATE.md)
2. Follow the [styleguides](#styleguides)

While the prerequisites above must be satisfied prior to having your pull request reviewed, the reviewer(s) may ask you to complete additional design work, tests, or other changes before your pull request can be ultimately accepted.

## Development Setup

### 1. Ruby

[`rbenv`](https://github.com/rbenv/rbenv) is the recommended way to manage Ruby versions:

```shell
# Finalize the rbenv install (should work with both bash & zsh)
~/.rbenv/bin/rbenv init
# And then run
eval "$(~/.rbenv/bin/rbenv init - bash)"
```

### 2. Clone the repository

Test data lives in a submodule, so make sure to clone recursively:

```shell
git clone --recurse-submodules git@github.com:mindee/mindee-api-ruby.git ~/work/mindee/mindee-api-ruby
cd ~/work/mindee/mindee-api-ruby
```

If you already cloned without `--recurse-submodules`, run `git submodule update --init --recursive`.

### 3. Install dependencies

On Debian/Ubuntu:

```shell
sudo apt install zlib1g-dev libssl-dev libreadline-dev libedit-dev libyaml-dev imagemagick
```

`imagemagick` is required at runtime by `mini_magick`, the rest are needed to build Ruby itself.

```shell
# Ruby 3.3.0 is the minimum version supported by the SDK
rbenv install 3.3.0
rbenv global 3.3.0
```

### 4. Install code dependencies

```shell
bundle config set --local path vendor
bundle install
```

### 5. Validate the install works by running unit tests

```shell
bundle exec rake spec
```

## Local Quality Checks

We use [`overcommit`](https://github.com/sds/overcommit) to run quality and security checks before
changes are committed and pushed. It is a development dependency of the gem, so `bundle install`
already installed it. The hooks are configured in [`.overcommit.yml`](.overcommit.yml), and
repository-local custom hooks live in [`.git-hooks`](.git-hooks).

The same checks run in CI, see
[`.github/workflows/_static-analysis.yml`](.github/workflows/_static-analysis.yml).

### Install `gitleaks`

The `Gitleaks` pre-commit hook shells out to the
[`gitleaks`](https://github.com/gitleaks/gitleaks) binary, which is not a gem and must be installed
separately:

```shell
brew install gitleaks
```

Otherwise, grab a binary from the
[releases page](https://github.com/gitleaks/gitleaks/releases) and put it on your `PATH`.

### Install the hooks

Run this once, after cloning:

```shell
bundle exec overcommit --install
bundle exec overcommit --sign
bundle exec overcommit --sign pre-commit
```

`--install` writes the git hook stubs into `.git/hooks`, and the `--sign` calls tell overcommit you
trust the current contents of `.overcommit.yml` and of the custom hooks in `.git-hooks`.

### What runs, and when

* **pre-commit:** merge conflict markers, YAML syntax, trailing whitespace, file size, `rubocop`,
  `steep check` (type checking) and `gitleaks` (secret scanning).
* **pre-push:** `bundle-audit` (dependency vulnerability check).

### Run the hooks manually

```shell
bundle exec overcommit --list-hooks         # show which hooks are enabled
bundle exec overcommit --run                # run the pre-commit hooks on all tracked files
bundle exec overcommit --run pre_push       # run the pre-push hooks
bundle exec overcommit --diff main          # run the pre-commit hooks on the diff against main
```

### Skipping hooks

Skip one or more hooks for a single run, by name:

```shell
SKIP=Gitleaks,Steep git commit
```

To bypass overcommit entirely (please use sparingly, CI runs the same checks):

```shell
OVERCOMMIT_DISABLE=1 git commit
```

### Troubleshooting

If overcommit refuses to run and warns that the configuration or the hooks have changed, review the
diff and then re-sign:

```shell
bundle exec overcommit --sign
bundle exec overcommit --sign pre-commit
```

## Styleguides

### Git Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
* Limit the first line to 72 characters or less
* Reference issues and pull requests liberally after the first line
* Consider starting the commit message with an applicable emoji, see [gitmoji](https://gitmoji.carloscuesta.me/) as a reference.

Examples:

* :memo: Add usage section in README
* :sparkles: Add CONTRIBUTING file in repository
* :bug: MyComponent - Prevent MouseEvent from firing unexpectedly

### Code Styleguide

We keep our code base consistent and expect Ruby code to adhere to our Rubocop styleguide,
see the `.rubocop` file.

### Local Quality Checks

We use [`pre-commit`](https://pre-commit.com/) hooks to run quality and security checks before
changes are pushed:

1. Install `pre-commit`, either using `pip` or `brew`:
   - `pip install pre-commit`
   - `brew install pre-commit`
2. Install project hooks:
   - `pre-commit install`
   - `pre-commit install --hook-type pre-push`

Run hooks manually:

* `pre-commit run --all-files`
* `pre-commit run --all-files --hook-stage pre-push`
