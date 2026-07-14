# Contributing

Thank you for helping improve Kaidera OS. This repository owns installation
channels, release metadata, package launchers, and distribution documentation.
The public runtime source lives in
[`Kaidera-AI/kaidera-os`](https://github.com/Kaidera-AI/kaidera-os).

## Good contribution areas

- Homebrew formula correctness and platform compatibility
- npm launcher reliability and error handling
- curl installer portability and checksum verification
- macOS installation and release documentation
- accessibility, clarity, and troubleshooting documentation
- release automation and supply-chain verification
- reproducible bug reports for installation or upgrade failures

Open runtime, console, Cortex, harness, provider, or orchestration changes against
the [source repository](https://github.com/Kaidera-AI/kaidera-os). Open installer,
formula, npm-launcher, checksum, and public release changes here. If a change spans
both repositories, open linked issues first so maintainers can sequence it safely.

## Before opening a pull request

1. Search existing issues and pull requests for the same problem.
2. Open an issue for a material behavior change or new distribution channel.
3. Keep the change focused; do not combine unrelated cleanup.
4. Never commit API keys, tokens, customer data, generated runtime state, or local
   paths containing private information.
5. Preserve the product boundary: **Kaidera OS** is the product and **Cortex** is
   the permanent memory and coordination component name.

Small documentation fixes may go directly to a pull request.

## Development setup

```sh
git clone https://github.com/Kaidera-AI/homebrew-kaidera.git
cd homebrew-kaidera
git switch -c fix/short-description
```

Useful local prerequisites are Bash, Ruby, Node.js 18 or newer, and Homebrew on
macOS. Python 3.12 and Docker are required for a complete Kaidera OS install.

## Validation

Run the checks relevant to your change:

```sh
git diff --check
shellcheck install.sh
ruby -c Formula/kaidera-os.rb
actionlint .github/workflows/*.yml
(cd npm && npm pack --dry-run --json)
```

Formula changes should also pass:

```sh
brew audit --strict --online kaidera-ai/kaidera/kaidera-os
brew test kaidera-ai/kaidera/kaidera-os
```

Do not change a release URL, version, or checksum unless the matching immutable
release asset exists and you have verified the downloaded SHA-256 value.

## Pull-request expectations

A useful pull request explains:

- the user-visible problem
- why the proposed change is the smallest correct fix
- the files and installation channels affected
- the commands used to verify it
- release, compatibility, and security implications

Add or update tests where behavior changes. Update documentation when commands,
requirements, links, or installation behavior change.

By submitting a contribution, you agree that it is licensed under the repository's
GNU Affero General Public License v3.0 only. You must have the right to submit the
work. Kaidera does not require a separate contributor license agreement for these
repositories.

## Review process

Maintainers may ask for changes, suggest a smaller scope, or close a proposal that
does not fit the public distribution boundary. Reviews focus on correctness,
security, compatibility, maintainability, and evidence from tests.

Contributors should keep the branch current with `main`, resolve review comments,
and avoid force-pushing after review has begun. Rewrite reviewed history only when
it contains a secret or another serious problem.

## Security issues

Do not open a public issue containing a vulnerability exploit, credential, or
sensitive log. Use GitHub's private vulnerability reporting for this repository.
