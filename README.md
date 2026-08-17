# Pinix

A reproducible Nix Flake wrapper for the **Pi Coding Agent**, a terminal-first coding assistant by Earendil.

This wrapper ensures that the agent executes smoothly, respecting NixOS execution guardrails by packaging the command and its node environment appropriately.

## Quick Usage (Ad-hoc)

You can run the Pi Coding Agent directly without installing it globally:

```bash
nix run github:noosxe/pinix -- --help
```

---

## Installation & Integration

To integrate this package into your Nix setup, first add this repository as an input to your system's `flake.nix`:

```nix
inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  # Add pinix to your inputs
  pinix.url = "github:noosxe/pinix";
};
```

### 1. Installing via Home Manager

You can install the package directly or use the provided overlay.

#### Option A: Direct Package Reference (Recommended)
Add the package output directly to your home-manager configuration:

```nix
{ inputs, pkgs, ... }: {
  home.packages = [
    inputs.pinix.packages.${pkgs.system}.default
  ];
}
```

#### Option B: Using the Overlay
If you prefer packages to be merged into your standard `pkgs` set:

```nix
{ inputs, pkgs, ... }: {
  nixpkgs.overlays = [
    inputs.pinix.overlays.default
  ];

  home.packages = [
    pkgs.pinix  # or pkgs.pi
  ];
}
```

---

### 2. Installing via NixOS (System Packages)

To make `pi` available to all system users under your NixOS configuration:

```nix
{ inputs, pkgs, ... }: {
  environment.systemPackages = [
    inputs.pinix.packages.${pkgs.system}.default
  ];
}
```

Or by utilizing the overlay:

```nix
{ inputs, pkgs, ... }: {
  nixpkgs.overlays = [
    inputs.pinix.overlays.default
  ];

  environment.systemPackages = [
    pkgs.pinix
  ];
}
```
