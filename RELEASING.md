# Releasing the npm package

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

## Release sequence

1. Update `npm/package.json` and all channel metadata to the new version.
2. Commit and push the complete channel update.
3. Create and publish `v<version>` from that exact commit.
4. Confirm the `Publish npm package` workflow succeeds.
5. Run an unauthenticated clean install of the published version.

The workflow fails before publication when the release tag and package version do
not match. npm versions are immutable, so never reuse a published version.
