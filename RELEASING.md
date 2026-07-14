# Releasing distribution channels

`@kaidera/kaidera-os` publishes through npm trusted publishing. GitHub Actions
uses a short-lived OIDC credential; no npm write token belongs in GitHub secrets.

## npm trusted publisher

Configured on 2026-07-14 for `@kaidera/kaidera-os`:

- Provider: GitHub Actions
- Organization: `Kaidera-AI`
- Repository: `homebrew-kaidera`
- Workflow filename: `publish-npm.yml`
- Allowed action: `npm publish`
- Trusted publisher ID: `163e7b7c-d5cc-43e5-a5a9-6a814ea304f4`

After an OIDC release succeeds, set Publishing access to **Require two-factor
authentication and disallow tokens**, then revoke the temporary bypass-2FA token.

## Public macOS assets

Runtime source is published in `Kaidera-AI/kaidera-os`, while installable assets
belong in this distribution repository. Publish these six files to this
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

1. Confirm the matching source commit is public in `Kaidera-AI/kaidera-os`.
2. Update `npm/package.json` and all channel metadata to the new version.
3. Commit and push the complete channel update.
4. Create and publish `v<version>` from that exact distribution commit.
5. Upload the runtime archive, source archive, signed macOS DMGs, and sidecars.
6. Confirm anonymous downloads and SHA-256 verification for every artifact.
7. Confirm the `Publish npm package` workflow succeeds through OIDC.
8. Run an unauthenticated clean install of the published npm version.

The workflow fails before publication when the release tag and package version do
not match. npm versions are immutable, so never reuse a published version.
