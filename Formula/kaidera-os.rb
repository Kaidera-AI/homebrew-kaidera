class KaideraOs < Formula
  desc "Local AI-worker platform with Cortex memory"
  homepage "https://kaidera.ai/downloads/kaidera-os"
  url "https://github.com/Kaidera-AI/kaidera-os/releases/download/v0.1.233/kaidera-os-v0.1.233.tar.gz"
  sha256 "3c831d6abae7d4848b1332495c434d561581a632bddaf9a749e5a22a1ad8e062"

  depends_on "python@3.12"

  def install
    libexec.install Dir["*"]
    (bin/"kaidera-os").write <<~SH
      #!/bin/bash
      exec "#{libexec}/local-cortex/console/scripts/kaidera-os" "$@"
    SH
    chmod 0755, bin/"kaidera-os"
  end

  def caveats
    <<~EOS
      Kaidera OS is installed. Next:
        kaidera-os install
        kaidera-os start

      Docker is required for the Cortex stack. This is the AGPL open-source,
      provider-free edition; it has no commercial trial or license activation.
      Contact sales@kaidera.ai for the supported commercial edition.
    EOS
  end

  test do
    assert_match "0.1.233", shell_output("#{bin}/kaidera-os version")
  end
end
