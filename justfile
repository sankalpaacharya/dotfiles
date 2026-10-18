host := env_var_or_default("FLAKE_HOST", lowercase(`scutil --get LocalHostName`))

_default:
    @just --list --unsorted

# Build without activating, then show what would change.
build:
    nix build .#darwinConfigurations.{{ host }}.system

# Rebuild and activate this machine.
switch:
    sudo darwin-rebuild switch --flake .#{{ host }}

# First run only: darwin-rebuild isn't installed until nix-darwin has activated once.
bootstrap:
    sudo /nix/var/nix/profiles/default/bin/nix run nix-darwin/master#darwin-rebuild -- switch --flake .#{{ host }}

# Update every flake input (nixpkgs, nix-darwin, home-manager, nix-homebrew).
update:
    nix flake update

# Upgrade Homebrew casks and formulae.
brew-upgrade:
    brew update && brew upgrade && brew upgrade --cask

# Delete old generations and reclaim the Nix store.
gc:
    sudo nix-collect-garbage --delete-older-than 14d

# Format every .nix file.
fmt:
    nix fmt
