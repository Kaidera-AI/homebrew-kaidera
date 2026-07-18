from __future__ import annotations

import importlib.util
import json
import tempfile
import unittest
from pathlib import Path


MODULE_PATH = Path(__file__).resolve().parents[1] / "scripts/promote-commercial.py"
SPEC = importlib.util.spec_from_file_location("promote_commercial", MODULE_PATH)
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class PromoteCommercialTests(unittest.TestCase):
    def test_npm_provenance_names_the_publishing_repository(self) -> None:
        package = json.loads(
            (MODULE_PATH.parents[1] / "npm/package.json").read_text(encoding="utf-8")
        )
        self.assertEqual(
            package["repository"]["url"],
            "git+https://github.com/Kaidera-AI/homebrew-kaidera.git",
        )

    def test_accepts_website_commercial_manifest(self) -> None:
        version, url, digest = MODULE.artifact_fields(
            {
                "edition": "commercial",
                "channel": "server",
                "version": "1.2.3",
                "artifact_url": "https://kaidera.ai/downloads/kaidera-os/server/kaidera-os-commercial-v1.2.3.tar.gz",
                "sha256": "a" * 64,
            },
            channel="server",
        )
        self.assertEqual((version, url, digest), ("1.2.3", url, "a" * 64))

    def test_rejects_github_commercial_artifact(self) -> None:
        with self.assertRaisesRegex(ValueError, "kaidera.ai"):
            MODULE.artifact_fields(
                {
                    "edition": "commercial",
                    "channel": "server",
                    "version": "1.2.3",
                    "artifact_url": "https://github.com/Kaidera-AI/kaideraos/file.tar.gz",
                    "sha256": "a" * 64,
                },
                channel="server",
            )

    def test_rejects_invalid_version_and_artifact_path(self) -> None:
        for version, url in (
            ("1.2.3\nend", "https://kaidera.ai/downloads/kaidera-os/server/file.tar.gz"),
            ("1.2.3", "https://kaidera.ai/downloads/kaidera-os/macos/file.dmg"),
        ):
            with self.subTest(version=version, url=url), self.assertRaises(ValueError):
                MODULE.artifact_fields(
                    {
                        "edition": "commercial",
                        "channel": "server",
                        "version": version,
                        "artifact_url": url,
                        "sha256": "a" * 64,
                    },
                    channel="server",
                )

    def test_renders_without_unresolved_values(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            template = Path(tmp) / "template"
            output = Path(tmp) / "output"
            template.write_text("@VERSION@ @ARTIFACT_URL@ @SHA256@\n", encoding="utf-8")
            MODULE.render(
                template,
                output,
                version="1.2.3",
                url="https://kaidera.ai/file",
                digest="b" * 64,
            )
            self.assertNotIn("@", output.read_text(encoding="utf-8"))


if __name__ == "__main__":
    unittest.main()
