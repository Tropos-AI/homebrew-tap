# This file is written by scripts/update-formula.sh from the signed release manifest. Don't edit it by hand.
class Tcode < Formula
  desc "Coding agent for your terminal, browser and Telegram"
  homepage "https://troposlabs.com"
  version "0.5.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Tropos-AI/tropos-code/releases/download/v0.5.4/tropos-darwin-arm64"
      sha256 "f5cd4a9c10a8cfb71542a87fd1ca6f27ecd3d1d53493433d0906e49d29eb8212"
    end
    on_intel do
      url "https://github.com/Tropos-AI/tropos-code/releases/download/v0.5.4/tropos-darwin-x64"
      sha256 "61e075fa3e2952fb2ec5fbafeab7d0f8832ba23cfbfbca2408bc3789c031a317"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Tropos-AI/tropos-code/releases/download/v0.5.4/tropos-linux-arm64"
      sha256 "a5e9bd71064540fcddc2cbcedb30076b61e5eeecbdba310c319d64aecf595584"
    end
    on_intel do
      url "https://github.com/Tropos-AI/tropos-code/releases/download/v0.5.4/tropos-linux-x64"
      sha256 "906954cf2f0b1c7ca1d44d0e7c19f977f891261f5d3f1772b0128266aea4498b"
    end
  end

  def install
    bin.install Dir["tropos-*"].first => "tcode"
  end

  def caveats
    <<~EOS
      Set Tropos Code up with:
        tcode onboard

      Homebrew keeps this install up to date: run brew upgrade tcode.
      Tropos's own background updates stay off for it.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tcode --version")
  end
end
