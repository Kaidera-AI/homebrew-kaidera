# Kaidera OS distribution

Public Homebrew, npm, and curl entry points for **Kaidera OS**. Every channel installs
the same signed `v0.1.231` source artifact and the `kaidera-os` CLI.

Requires Docker and Python 3.12 or newer. macOS and Linux are supported.

## macOS

- [Download the full Kaidera OS Console DMG](https://github.com/Kaidera-AI/homebrew-kaidera/releases/download/v0.1.231/kaidera-os-console-v0.1.231.dmg)
- [Download the optional Kaidera OS Operator DMG](https://github.com/Kaidera-AI/homebrew-kaidera/releases/download/v0.1.231/kaidera-os-operator-v0.1.231.dmg)

Install the Console DMG first. It contains the full runtime and requires macOS 14+,
Docker, and Python 3. The Operator DMG is an optional native menu-bar controller
for an existing installation. Both images are Developer ID signed, notarized, and
stapled; this release is validated on Apple Silicon.

## Homebrew

```sh
brew install kaidera-ai/kaidera/kaidera-os
kaidera-os install
kaidera-os start
```

## npm

```sh
npm install --global @kaidera/kaidera-os
kaidera-os install
```

Future package releases are configured for npm trusted publishing from GitHub
Actions. Complete the one-time package trust binding in `RELEASING.md` before the
next release; the workflow itself does not use a long-lived npm token.

## curl

```sh
curl -fsSL https://raw.githubusercontent.com/Kaidera-AI/homebrew-kaidera/main/install.sh | bash
```

The curl and npm launchers verify the release SHA-256 before extracting. Homebrew
verifies the same digest from the formula. Configure providers and licensing in the
Kaidera OS console; the license environment key is `KAIDERA_OS_LICENSE_KEY`.

## Upgrade

```sh
brew update && brew upgrade kaidera-os
npm update --global @kaidera/kaidera-os
```

The runtime keeps Cortex data in persistent storage while the application payload is
updated.
