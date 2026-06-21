class Engenos < Formula
  desc "EnGen OS — EnGenAI local-deployment app (console + Cortex + autonomy runtime)"
  homepage "https://github.com/EnGen-AI/engenos"
  url "https://github.com/EnGen-AI/homebrew-engenos/releases/download/v0.1.157/engenos-0.1.157.tar.gz"
  sha256 "ddf82f91dd06779bc01f87bfe20511a3b3063022149a20b66c8eda87cb59d587"
  version "0.1.157"

  depends_on "python@3.12"

  def install
    # Homebrew strips the tarball's single top-level dir (engenos/) on stage, so the product
    # tree lands directly under libexec (libexec/local-cortex/..., NOT libexec/engenos/...).
    libexec.install Dir["*"]
    (bin/"engenos").write <<~SH
      #!/bin/bash
      exec "#{libexec}/local-cortex/console/scripts/engenos" "$@"
    SH
    chmod 0755, bin/"engenos"
  end

  def caveats
    <<~EOS
      EnGen OS is installed. Next:
        engenos install      # bootstrap Cortex + app-DB (Docker) + the native console
        engenos start

      Requires Docker (for the Cortex stack) + one provider API key (in Settings),
      and a valid ENGENOS_LICENSE_KEY at runtime.

      Upgrade later (non-disruptive — Cortex keeps running):
        brew update && brew upgrade engenos      # or:  engenos upgrade
    EOS
  end

  test do
    assert_match "0.1.157", shell_output("#{bin}/engenos version")
  end
end
