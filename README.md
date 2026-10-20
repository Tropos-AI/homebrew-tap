# Tropos Labs Homebrew tap

[Tropos Code](https://github.com/Tropos-AI/tropos-code), the `tcode` coding agent, for macOS and Linux.

```sh
brew install tropos-ai/tap/tcode
tcode onboard
```

Update with `brew upgrade tcode`. Tropos's own background updates stay off for a Homebrew install, and the background
service follows each `brew upgrade` once nothing is running.

## How the formula is kept current

A scheduled workflow runs `scripts/update-formula.sh` every three hours. It reads the version the `latest` channel
points to, downloads that release's `manifest.json`, checks its signature against the release key in
`allowed_signers` (fingerprint `SHA256:QY3xHG6gCBN84NfeYw1Vy1r5G0NpGTf0jDR02/QVLr8`, the same key `install.sh` and
`tcode` pin), and writes the binaries' SHA-256 checksums from it into `Formula/tcode.rb`. Homebrew checks each
download against those checksums.

To install without Homebrew, or to verify a release yourself, see
[Install and verify](https://github.com/Tropos-AI/tropos-code/blob/main/docs/install.md).
