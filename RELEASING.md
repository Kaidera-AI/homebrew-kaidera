# Releasing distribution channels

`@kaidera/kaidera-os` publishes through npm trusted publishing. GitHub Actions
uses a short-lived OIDC credential; no npm write token belongs in GitHub secrets.

## One-time npm configuration

In the package settings on npmjs.com, configure this trusted publisher:

- Provider: GitHub Actions
- Organization: `Kaidera-AI`
- Repository: `homebrew-kaidera`
- Workflow filename: `publish-npm.yml`
- Allowed action: `npm publish`

After an OIDC release succeeds, set Publishing access to **Require two-factor
authentication and disallow tokens**, then revoke the temporary bypass-2FA token.

## Public macOS assets

The canonical Kaidera OS repository is private. Never use its release URLs on the
website or another anonymous customer surface. Mirror these six files to this
repository's public `v<version>` release:

- `kaidera-os-console-v<version>.dmg`
- `kaidera-os-console-v<version>.dmg.sha256`
- `kaidera-os-console-v<version>.dmg.metadata.json`
- `kaidera-os-operator-v<version>.dmg`
- `kaidera-os-operator-v<version>.dmg.sha256`
- `kaidera-os-operator-v<version>.dmg.metadata.json`

Download both public DMGs without GitHub credentials and verify their SHA-256
values against the sidecars before updating website links.

## Release sequence

1. Update `npm/package.json` and all channel metadata to the new version.
2. Commit and push the complete channel update.
3. Create and publish `v<version>` from that exact commit.
4. Upload the signed macOS DMGs and their checksum/metadata sidecars.
5. Confirm anonymous downloads and SHA-256 verification for both DMGs.
6. Confirm the `Publish npm package` workflow succeeds through OIDC.
7. Run an unauthenticated clean install of the published npm version.

The workflow fails before publication when the release tag and package version do
not match. npm versions are immutable, so never reuse a published version.
