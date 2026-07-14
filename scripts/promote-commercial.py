#!/usr/bin/env python3
"""Promote published Kaidera OS commercial artifacts into the public tap.

The website manifests are the source of truth. This command refuses relative or
non-Kaidera URLs, malformed checksums, non-commercial metadata, and artifacts
that cannot be downloaded with the declared digest. It never publishes files;
it only writes reviewable Formula/Casks metadata after the website is live.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import tempfile
import urllib.request
from pathlib import Path
from typing import Any
from urllib.parse import urlparse

ROOT = Path(__file__).resolve().parents[1]
SHA256_RE = re.compile(r"^[0-9a-f]{64}$")
VERSION_RE = re.compile(r"^[0-9]+\.[0-9]+\.[0-9]+$")


def load_manifest(source: str) -> dict[str, Any]:
    if source.startswith(("https://", "http://")):
        with urllib.request.urlopen(source, timeout=30) as response:
            raw = response.read()
    else:
        raw = Path(source).read_bytes()
    value = json.loads(raw)
    if not isinstance(value, dict):
        raise ValueError(f"manifest is not an object: {source}")
    return value


def artifact_fields(manifest: dict[str, Any], *, channel: str) -> tuple[str, str, str]:
    edition = str(manifest.get("edition") or "")
    if edition != "commercial":
        raise ValueError(f"expected commercial edition, got {edition!r}")
    actual_channel = str(manifest.get("channel") or "")
    if actual_channel != channel:
        raise ValueError(f"expected {channel!r} channel, got {actual_channel!r}")

    version = str(manifest.get("version") or "").strip()
    url = str(manifest.get("artifact_url") or "").strip()
    digest = str(manifest.get("sha256") or "").strip().lower()
    parsed = urlparse(url)
    if not VERSION_RE.fullmatch(version):
        raise ValueError(f"manifest version is invalid: {version!r}")
    if parsed.scheme != "https" or parsed.netloc != "kaidera.ai":
        raise ValueError(f"artifact must use an absolute kaidera.ai HTTPS URL: {url!r}")
    expected_paths = {
        "server": f"/downloads/kaidera-os/server/kaidera-os-commercial-v{version}.tar.gz",
        "commercial-macos-operator": (
            f"/downloads/kaidera-os/macos/kaidera-os-commercial-operator-v{version}.dmg"
        ),
    }
    if parsed.path != expected_paths[channel] or parsed.query or parsed.fragment:
        raise ValueError(f"artifact URL does not match the {channel!r} release contract: {url!r}")
    if not SHA256_RE.fullmatch(digest):
        raise ValueError("manifest SHA-256 is invalid")
    return version, url, digest


def verify_download(url: str, expected: str) -> None:
    digest = hashlib.sha256()
    with tempfile.TemporaryFile() as sink:
        with urllib.request.urlopen(url, timeout=60) as response:
            while chunk := response.read(1024 * 1024):
                digest.update(chunk)
                sink.write(chunk)
    actual = digest.hexdigest()
    if actual != expected:
        raise ValueError(f"artifact checksum mismatch: expected {expected}, got {actual}")


def render(template: Path, output: Path, *, version: str, url: str, digest: str) -> None:
    text = template.read_text(encoding="utf-8")
    text = text.replace("@VERSION@", version)
    text = text.replace("@ARTIFACT_URL@", url)
    text = text.replace("@SHA256@", digest)
    if re.search(r"@[A-Z0-9_]+@", text):
        raise ValueError(f"unresolved template value in {template}")
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(text, encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--server-manifest")
    parser.add_argument("--operator-manifest")
    parser.add_argument("--skip-download-verification", action="store_true")
    args = parser.parse_args()
    if not args.server_manifest and not args.operator_manifest:
        parser.error("provide --server-manifest and/or --operator-manifest")

    targets = []
    if args.server_manifest:
        targets.append((
            args.server_manifest,
            "server",
            ROOT / "Templates/kaidera-os-commercial.rb.in",
            ROOT / "Formula/kaidera-os-commercial.rb",
        ))
    if args.operator_manifest:
        targets.append((
            args.operator_manifest,
            "commercial-macos-operator",
            ROOT / "Templates/kaidera-os-commercial-operator.rb.in",
            ROOT / "Casks/kaidera-os-commercial-operator.rb",
        ))

    for source, channel, template, output in targets:
        version, url, digest = artifact_fields(load_manifest(source), channel=channel)
        if not args.skip_download_verification:
            verify_download(url, digest)
        render(template, output, version=version, url=url, digest=digest)
        print(output.relative_to(ROOT))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
