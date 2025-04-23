# engine-nix

- [`journal.md`](./journal.md)
- [`flake.nix`](./flake.nix)
- [`wine.nix`](./wine.nix)

# Setup

1. Install Nix: `sh <(curl -L https://nixos.org/nix/install)`
2. Run `nix develop .` (you might need to enable some experimental features in the Nix config)
3. Inside the development shell, run `genericBuild` (or if you already have the sources, `cd source` and do `buildPhase`)
