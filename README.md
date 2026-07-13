# Kaidera OS distribution

Public Homebrew, npm, and curl entry points for **Kaidera OS**. Every channel installs
the same signed `v0.1.231` source artifact and the `kaidera-os` CLI.

Requires Docker and Python 3.12 or newer. macOS and Linux are supported.

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
