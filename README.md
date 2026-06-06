# homebrew-tap

Homebrew tap for Endlex-net macOS applications.

This repository hosts Homebrew Casks that install prebuilt `.app` releases from Endlex-net projects.

## Add the tap

```bash
brew tap Endlex-net/tap
```

## Available casks

- `texere` — menu bar quick notes app for macOS

## Install

```bash
brew install --cask texere
```

## Upgrade

```bash
brew update
brew upgrade --cask texere
```

## Uninstall

```bash
brew uninstall --cask texere
```

## Repository layout

```text
Casks/
  texere.rb
```

## Notes for maintainers

- Casks in this repository should point to publicly accessible GitHub Release assets.
- When a new app version is released, update the corresponding cask `version`, `sha256`, and `url`.
- This tap is intended to host multiple Endlex-net GUI apps over time.

## Maintainer helpers

Update the Texere cask from the latest published GitHub release:

```bash
node scripts/update-cask.mjs --repo Endlex-net/Texere --cask texere --arch aarch64
```

Or target a specific release tag:

```bash
node scripts/update-cask.mjs --repo Endlex-net/Texere --cask texere --arch aarch64 --tag v0.1.6-alpha
```
