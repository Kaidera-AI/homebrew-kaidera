# Releasing Distribution Channels

## Channel Invariants

- `kaidera-os` is the AGPL open-source formula. Its runtime artifact comes from
  `Kaidera-AI/kaidera-os`.
- `kaidera-os-commercial` is the licensed server/runtime formula. Its immutable
  archive comes from `https://kaidera.ai/downloads/kaidera-os/server/`.
- `kaidera-os-commercial-operator` is the optional macOS controller cask. Its
  signed/notarized DMG comes from `https://kaidera.ai/downloads/kaidera-os/macos/`.
- Commercial source, license signing keys, Apple signing credentials, and
  customer data never enter this repository.
- Do not add a commercial formula or cask before its URL is anonymously
  downloadable and its declared SHA-256 matches.

## Open-Source Release

1. Confirm the exact reviewed source commit in `Kaidera-AI/kaidera-os`.
2. Run that repository's source-boundary, clean-install, and release checks.
3. Publish an immutable `v<version>` open-source artifact from that commit.
4. Update `Formula/kaidera-os.rb`, `install.sh`, and `npm/package.json` together.
5. Run a source install on a clean host:

   ```sh
   brew install --build-from-source kaidera-ai/kaidera/kaidera-os
   ```

6. Commit and push the channel update, then publish the matching npm version.

`@kaidera/kaidera-os` uses npm trusted publishing with GitHub Actions OIDC:

- Organization: `Kaidera-AI`
- Repository: `homebrew-kaidera`
- Workflow: `publish-npm.yml`
- Allowed action: `npm publish`

npm versions are immutable. Never reuse a published version.

## Commercial Release

Commercial builds happen only in the private `Kaidera-AI/kaideraos` repository.
After its tests pass:

1. Build the signed commercial server archive and website manifest.
2. Build, Developer ID sign, notarize, and staple the commercial macOS artifacts.
3. Publish the files and manifests under `kaidera.ai`.
4. Confirm every artifact is anonymously downloadable over HTTPS.
5. Generate tap metadata from the live manifests:

```sh
base=https://kaidera.ai/downloads/kaidera-os
python3 scripts/promote-commercial.py \
  --server-manifest "$base/server/latest-server.json" \
  --operator-manifest "$base/macos/latest-operator-macos.json"
```

1. Review the generated Ruby files and run `brew audit --strict` on both.
2. Install each channel on a clean supported host; verify trial, activation,
   expiry, restore, upgrade, and uninstall.
3. Commit and push the tap metadata only after those checks pass.

The generator verifies edition/channel fields, requires absolute
`https://kaidera.ai` URLs, downloads each artifact, and confirms the declared
SHA-256 before writing a formula or cask.

## Current Hold

Version `0.1.231` remains the current public release. Do not publish a new
commercial formula/cask or cut a new release until the commercial licensing flow
has passed end-to-end acceptance. This version predates the repository split and
remains at its existing `homebrew-kaidera` release URL. The first later
open-source release moves its archive, checksum, and signature to
`Kaidera-AI/kaidera-os`; the compatibility branch in the curl/npm launchers can
be removed after supported installations have upgraded.
