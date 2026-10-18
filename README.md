# dotfiles

macOS setup with nix-darwin, home-manager and nix-homebrew.

## Install

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
git clone https://github.com/sankalpaacharya/dotfiles ~/dotfiles
cd ~/dotfiles
nix run nixpkgs#just -- bootstrap
```

## Usage

```bash
just switch
```
