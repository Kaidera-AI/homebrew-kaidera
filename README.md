# Kaidera Homebrew Tap

Public delivery metadata for the open-source and commercial editions of
[Kaidera OS](https://kaidera.ai/downloads/kaidera-os).

**[Open-source code](https://github.com/Kaidera-AI/kaidera-os)** |
**[Commercial downloads](https://kaidera.ai/downloads/kaidera-os)** |
**[Documentation](https://docs.kaidera.ai)** |
**[Contribute](CONTRIBUTING.md)**

Kaidera OS connects project workspaces, AI harnesses, Kaidera Manifold, and
**Cortex** so AI workers can plan, execute, review, and resume work with durable
project context. Cortex is included and permanently remains named Cortex.

## Editions

- **Open source:** `kaidera-os`, from `Kaidera-AI/kaidera-os`; AGPLv3,
  without warranty or liability.
- **Commercial server/runtime:** `kaidera-os-commercial`, from `kaidera.ai`;
  nine-day trial, then a signed license.
- **Commercial macOS operator:** `kaidera-os-commercial-operator`, from
  `kaidera.ai`; controls the commercial runtime.

This tap contains formulae, casks, launchers, checksums, and release workflow
documentation. It contains no commercial product source or private credentials.

## Open-Source Install

```sh
brew install kaidera-ai/kaidera/kaidera-os
kaidera-os install
kaidera-os start
```

The open-source edition is also available through npm and curl:

```sh
npm install --global @kaidera/kaidera-os
kaidera-os install

repo=Kaidera-AI/homebrew-kaidera
curl -fsSL "https://raw.githubusercontent.com/$repo/main/install.sh" | bash
```

The open-source product is Manifold-only. It has no commercial trial or license
activation runtime and contains no direct-provider implementation. A supported commercial
edition is available from `sales@kaidera.ai`.

## Commercial Install

The commercial formula is published only after the matching website archive is
live and checksum-verified:

```sh
brew install kaidera-ai/kaidera/kaidera-os-commercial
kaidera-os-commercial install
kaidera-os-commercial start
```

On macOS, the optional menu-bar controller can then be installed with:

```sh
brew install --cask kaidera-ai/kaidera/kaidera-os-commercial-operator
```

The full signed and notarized Console DMG remains available directly from the
[Kaidera OS macOS page](https://kaidera.ai/downloads/kaidera-os/macos#install).
Commercial artifacts are hosted by `kaidera.ai`, not GitHub, and include a
nine-day trial. Continued use requires a signed license.

Commercial formula/cask files do not appear in the tap until real artifacts are
published. This prevents Homebrew from advertising an install command backed by
a missing or mutable URL.

## Channel Ownership

- [`Kaidera-AI/kaidera-os`](https://github.com/Kaidera-AI/kaidera-os)
  owns the AGPL source and open-source release payload.
- [`Kaidera-AI/kaideraos`](https://github.com/Kaidera-AI/kaideraos)
  is the private internal/commercial source repository.
- This repository owns the public Homebrew tap plus the open-source npm/curl
  launchers.
- [`kaidera.ai`](https://kaidera.ai/downloads/kaidera-os) owns commercial
  archives and macOS downloads.

## Updates

```sh
brew update
brew upgrade kaidera-os
brew upgrade kaidera-os-commercial
npm update --global @kaidera/kaidera-os
```

## Contributing

Bug reports, focused fixes, tests, documentation, accessibility improvements,
and portable installer enhancements are welcome. See [Contributing](CONTRIBUTING.md)
and the [maintainer guide](docs/MAINTAINER_GUIDE.md).

## License

The open-source material in this repository is licensed under the
[GNU Affero General Public License v3.0 only](LICENSE) and is provided without
warranty or liability. Contributions are accepted under the same license.
Kaidera names and logos are not granted for use by the software license; see
[`NOTICE`](NOTICE). Commercial licensing and support are available from
`sales@kaidera.ai`.
