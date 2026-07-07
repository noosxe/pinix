{
  description = "A reproducible Nix Flake wrapper for the Pi Coding Agent";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      # Define architectures you want this flake to support
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      # Helper function to generate outputs for all systems
      forEachSystem =
        f: nixpkgs.lib.genAttrs supportedSystems (system: f (import nixpkgs { inherit system; }));
    in
    {
      # 1. The Package: Allows you to run 'nix run' without installing anything permanently
      packages = forEachSystem (pkgs: rec {
        pinix = pkgs.writeShellScriptBin "pi" ''
          export PATH="${pkgs.nodejs_22}/bin:$PATH"
          # Fires up the agent seamlessly while respecting NixOS execution guardrails
          exec ${pkgs.nodejs_22}/bin/npx --yes --ignore-scripts @earendil-works/pi-coding-agent "$@"
        '';
        default = pinix;
      });

      # 2. The Overlay: Allows easy integration into other Nix configurations
      overlays.default = final: prev: {
        pinix = self.packages.${final.system}.default;
        pi = self.packages.${final.system}.default;
      };
    };
}
