# Archived

The nix configuration in this repo has been merged into the generalized nix-config in https://github.com/dartagan/dotfiles.


## Update the system

One should first make sure all changes are committed to the repo.
```
nix flake update
sudo nixos-rebuild switch --flake .
```
