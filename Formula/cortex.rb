class Cortex < Formula
  desc "Persistent memory and coordination for AI agent teams (launcher)"
  homepage "https://github.com/Kaidera-AI/cortex"
  url "https://github.com/Kaidera-AI/cortex/releases/download/v0.1.002/cortex-launcher-0.1.2.tar.gz"
  sha256 "1829fb6d1af19471ee1fc005b881d6a0c3bf34113757aa86726b1a36ae4e41ca"
  license "MIT"

  depends_on "node"

  def install
    # The launcher is one dependency-free Node file plus its templates; brew installs
    # exactly the bytes the npm package @kaidera/cortex 0.1.2 ships.
    libexec.install Dir["*"]
    (bin/"cortex").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/bin/cortex.js" "$@"
    SH
    chmod 0755, bin/"cortex"
  end

  def caveats
    <<~EOS
      cortex preflight   checks the container engine (rootless Podman >= 5.0).
      cortex install     refuses (exit 2) until a digest-pinned release payload is
                         published; no payload or container images ship with v0.1.002.
      Nothing here needs sudo. See https://github.com/Kaidera-AI/cortex#installing-the-launcher
    EOS
  end

  test do
    assert_match "0.1.2", shell_output("#{bin}/cortex version")
  end
end
