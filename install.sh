#!/usr/bin/env bash
# EnGen OS — curl installer. Downloads the public release artifact + runs the product
# installer. Usage:  curl -fsSL https://raw.githubusercontent.com/EnGen-AI/homebrew-engenos/main/install.sh | bash
set -euo pipefail

VERSION="${ENGENOS_VERSION:-0.1.149}"
DEST="${ENGENOS_HOME:-$HOME/.engenos}"
BASE="https://github.com/EnGen-AI/homebrew-engenos/releases/download/v${VERSION}"
TARBALL="engenos-${VERSION}.tar.gz"

echo "EnGen OS ${VERSION} → ${DEST}"
need() { command -v "$1" >/dev/null 2>&1 || { echo "missing dependency: $1" >&2; exit 1; }; }
need curl; need tar; need shasum

tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
echo "downloading ${TARBALL}…"
curl -fsSL "${BASE}/${TARBALL}" -o "$tmp/${TARBALL}"

# Integrity: verify the published sha256 before extracting (a release becomes the live app).
echo "verifying checksum…"
curl -fsSL "${BASE}/${TARBALL}.sha256" -o "$tmp/${TARBALL}.sha256"
( cd "$tmp" && echo "$(cat "${TARBALL}.sha256")  ${TARBALL}" | shasum -a 256 -c - ) \
  || { echo "checksum FAILED — refusing to install" >&2; exit 1; }

mkdir -p "$DEST"
tar xzf "$tmp/${TARBALL}" -C "$DEST"
echo "running the product installer…"
exec bash "$DEST/engenos/install.sh" "$@"
