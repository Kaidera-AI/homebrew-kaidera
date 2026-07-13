class KaideraOs < Formula
  desc "Local AI-worker platform with Cortex memory"
  homepage "https://github.com/Kaidera-AI/homebrew-kaidera"
  url "https://github.com/Kaidera-AI/homebrew-kaidera/releases/download/v0.1.231/kaidera-os-v0.1.231.tar.gz"
  sha256 "e257680c5a3997d8192af0eab7eeb384b84be9fc5c62369bbbd6c5bfba1073eb"

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

      Docker is required for the Cortex stack. Configure providers and licensing
      from the console after installation. The license environment key is
      KAIDERA_OS_LICENSE_KEY.
    EOS
  end

  test do
    assert_match "0.1.231", shell_output("#{bin}/kaidera-os version")
  end
end
