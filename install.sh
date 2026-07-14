#!/usr/bin/env bash
# Kaidera OS curl installer. Downloads the public channel artifact, verifies its
# SHA-256 sidecar, strips the versioned archive root, and runs the product installer.
set -euo pipefail

VERSION="${KAIDERA_OS_VERSION:-0.1.231}"
DEST="${KAIDERA_OS_HOME:-$HOME/kaidera-os}"
[[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] \
  || { echo "invalid Kaidera OS version: $VERSION" >&2; exit 1; }
if [ "$VERSION" = "0.1.231" ]; then
  RELEASE_REPO="Kaidera-AI/homebrew-kaidera"
else
  RELEASE_REPO="Kaidera-AI/kaidera-os"
fi
BASE="https://github.com/$RELEASE_REPO/releases/download/v${VERSION}"
TARBALL="kaidera-os-v${VERSION}.tar.gz"

echo "Kaidera OS ${VERSION} -> ${DEST}"
need() { command -v "$1" >/dev/null 2>&1 || { echo "missing dependency: $1" >&2; exit 1; }; }
need curl
need tar
SHACHECK="$(command -v sha256sum || command -v shasum || true)"
[ -n "$SHACHECK" ] || { echo "missing dependency: need sha256sum or shasum" >&2; exit 1; }

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
curl -fsSL "${BASE}/${TARBALL}" -o "$tmp/${TARBALL}"
curl -fsSL "${BASE}/${TARBALL}.sha256" -o "$tmp/${TARBALL}.sha256"

if [ "$(basename "$SHACHECK")" = "sha256sum" ]; then
  (cd "$tmp" && "$SHACHECK" -c "${TARBALL}.sha256")
else
  (cd "$tmp" && "$SHACHECK" -a 256 -c "${TARBALL}.sha256")
fi

mkdir -p "$DEST"
tar -xzf "$tmp/${TARBALL}" -C "$DEST" --strip-components=1
echo "running the Kaidera OS installer"
exec bash "$DEST/install.sh" "$@"
