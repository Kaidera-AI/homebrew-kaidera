#!/usr/bin/env bash
# EnGen OS — curl installer. Downloads the public release artifact + runs the product
# installer. Usage:  curl -fsSL https://raw.githubusercontent.com/EnGen-AI/homebrew-engenos/main/install.sh | bash
set -euo pipefail

VERSION="${ENGENOS_VERSION:-0.1.150}"
DEST="${ENGENOS_HOME:-$HOME/.engenos}"
BASE="https://github.com/EnGen-AI/homebrew-engenos/releases/download/v${VERSION}"
TARBALL="engenos-${VERSION}.tar.gz"

echo "EnGen OS ${VERSION} → ${DEST}"
need() { command -v "$1" >/dev/null 2>&1 || { echo "missing dependency: $1" >&2; exit 1; }; }
need curl; need tar
# sha256: prefer Linux-native sha256sum, fall back to macOS/perl shasum. (Plain Debian/Ubuntu
# ships sha256sum but NOT shasum — requiring shasum broke the install on a fresh box.)
SHACHECK="$(command -v sha256sum || command -v shasum || true)"
[ -n "$SHACHECK" ] || { echo "missing dependency: need 'sha256sum' or 'shasum'" >&2; exit 1; }

tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
echo "downloading ${TARBALL}…"
curl -fsSL "${BASE}/${TARBALL}" -o "$tmp/${TARBALL}"

# Integrity: verify the published sha256 BEFORE extracting (a release becomes the live app).
# The .sha256 sidecar is the conventional "<hash>  <filename>" line, checked DIRECTLY (no
# re-appending the name — doing so doubled it and made the check always fail).
echo "verifying checksum…"
curl -fsSL "${BASE}/${TARBALL}.sha256" -o "$tmp/${TARBALL}.sha256"
if [ "$(basename "$SHACHECK")" = "sha256sum" ]; then
  ( cd "$tmp" && "$SHACHECK" -c "${TARBALL}.sha256" )
else
  ( cd "$tmp" && "$SHACHECK" -a 256 -c "${TARBALL}.sha256" )
fi || { echo "checksum FAILED — refusing to install" >&2; exit 1; }

mkdir -p "$DEST"
tar xzf "$tmp/${TARBALL}" -C "$DEST"
echo "running the product installer…"
exec bash "$DEST/engenos/install.sh" "$@"
