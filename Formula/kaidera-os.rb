class KaideraOs < Formula
  desc "Local AI-worker platform with Cortex memory"
  homepage "https://kaidera.ai/downloads/kaidera-os"
  url "https://github.com/Kaidera-AI/kaidera-os/releases/download/v0.1.237/kaidera-os-v0.1.237.tar.gz"
  sha256 "ecfc46ab6a4a55f4b2bb76f2a66db7869990fd8637410f86b6dc7d325a80d679"

  depends_on "python@3.12"

  def install
    # Dir["*"] drops dotfiles, and .agents/ is exactly the tree the
    # installer needs (docker-compose.cortex.yml, the Cortex API, scripts).
    # Install it explicitly or the bottle cannot deploy anywhere (rehearsal finding 07).
    libexec.install Dir["*"], Dir[".agents"]
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
    assert_match "0.1.237", shell_output("#{bin}/kaidera-os version")
  end
end
