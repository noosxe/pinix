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
      packages = forEachSystem (pkgs: {
        default = pkgs.writeShellScriptBin "pi" ''
          export PATH="${pkgs.nodejs_22}/bin:$PATH"
          # Fires up the agent seamlessly while respecting NixOS execution guardrails
          exec ${pkgs.nodejs_22}/bin/npx --ignore-scripts @earendil-works/pi-coding-agent "$@"
        '';
      });

      # 2. The Dev Shell: For drop-in terminal environments via 'nix develop'
      devShells = forEachSystem (pkgs: {
        default = pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs_22
          ];

          shellHook = ''
            echo "🤖 Pi Coding Agent development shell loaded!"
            echo "-> You can now execute 'nix run' to spin up the agent."
          '';
        };
      });
    };
}
