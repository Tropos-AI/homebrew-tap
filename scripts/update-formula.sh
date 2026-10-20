#!/bin/sh
# Writes Formula/tcode.rb for the version the `latest` channel points to. The checksums come from that release's
# manifest, and the manifest is only used after its signature checks out against the pinned Tropos release key.
set -eu

repo="Tropos-AI/tropos-code"
channels="https://github.com/Tropos-AI/tropos-code-channels/releases/download/channels"
root="$(cd "$(dirname "$0")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

version="$(curl -fsSL "$channels/latest" | tr -d '[:space:]')"
case "$version" in
  [0-9]*.[0-9]*.[0-9]*) ;;
  *) echo "update-formula: unexpected version from the latest channel: $version" >&2; exit 1 ;;
esac

base="https://github.com/$repo/releases/download/v$version"
curl -fsSL -o "$tmp/manifest.json" "$base/manifest.json"
curl -fsSL -o "$tmp/manifest.json.sig" "$base/manifest.json.sig"
ssh-keygen -Y verify -f "$root/allowed_signers" -I tropos-release -n tropos-manifest \
  -s "$tmp/manifest.json.sig" <"$tmp/manifest.json" >/dev/null

if [ "$(jq -r .version "$tmp/manifest.json")" != "$version" ]; then
  echo "update-formula: the manifest of v$version names another version" >&2
  exit 1
fi

sha() { jq -er --arg p "$1" '.platforms[$p].sha256' "$tmp/manifest.json"; }

cat >"$root/Formula/tcode.rb" <<RUBY
# This file is written by scripts/update-formula.sh from the signed release manifest. Don't edit it by hand.
class Tcode < Formula
  desc "Coding agent for your terminal, browser and Telegram"
  homepage "https://troposlabs.com"
  version "$version"
  license "MIT"

  on_macos do
    on_arm do
      url "$base/tropos-darwin-arm64"
      sha256 "$(sha darwin-arm64)"
    end
    on_intel do
      url "$base/tropos-darwin-x64"
      sha256 "$(sha darwin-x64)"
    end
  end

  on_linux do
    on_arm do
      url "$base/tropos-linux-arm64"
      sha256 "$(sha linux-arm64)"
    end
    on_intel do
      url "$base/tropos-linux-x64"
      sha256 "$(sha linux-x64)"
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
RUBY

echo "Formula/tcode.rb: $version"
