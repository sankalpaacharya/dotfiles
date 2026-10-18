# Dotfiles

Declarative macOS setup with [nix-darwin](https://github.com/nix-darwin/nix-darwin) + [home-manager](https://github.com/nix-community/home-manager) + [nix-homebrew](https://github.com/zhaofengli/nix-homebrew) on [Determinate Nix](https://determinate.systems).

Structure borrowed from [dillionverma/dotfiles](https://github.com/dillionverma/dotfiles).

## Setup (macOS, Apple Silicon)

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
git clone https://github.com/sankalpaacharya/dotfiles ~/dotfiles
cd ~/dotfiles
nix run nixpkgs#just -- bootstrap   # first run only
```

Sign into the App Store first, or the App Store apps are skipped. If this Mac's hostname isn't in `flake.nix`, add a `mkDarwinHost` line for it (`scutil --get LocalHostName`, lowercased).

## Usage

```bash
just            # list every recipe
just switch     # rebuild + activate
just update     # bump nixpkgs / nix-darwin / home-manager
just gc         # reclaim the Nix store
```

## Layout

|                     |                                                                 |
| ------------------- | --------------------------------------------------------------- |
| `me.nix`            | Name, email, username                                           |
| `flake.nix`         | Inputs, and one `mkDarwinHost` line per machine                 |
| `darwin.nix`        | Homebrew casks, App Store apps, macOS defaults, app preferences |
| `home.nix`          | CLI tools, zsh, git/gh, app config links                        |
| `config/karabiner/` | Caps Lock layer (linked live, so Karabiner's UI saves here)     |

## Keyboard

Hold **Caps Lock** and press:

| Key                       | Does                                                  |
| ------------------------- | ----------------------------------------------------- |
| W A S D                   | ↑ ← ↓ →                                               |
| H / L / K / J             | Left / right / top / bottom half (via Rectangle)      |
| Enter                     | Maximize                                              |
| Tab                       | Next window of the same app                           |
| B C T V G F M R X Z       | Arc, Claude, T3 Code, VS Code, Ghostty, Finder, WhatsApp, Discord, Xcode, Zed |
