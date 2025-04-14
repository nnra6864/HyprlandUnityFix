{
  description = "A module to make Unity usable with Hyprland";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      home-manager,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        # Try home man's libs first, nixpkgs to be env agnostic
        lib = home-manager.lib or nixpkgs.lib;
        pkgs = import nixpkgs { inherit system; };
      in
      {
        # Optional package
        packages.hyprlandUnityFix = pkgs.stdenv.mkDerivation {
          name = "HyprlandUnityFix";
          src = ./.;
          buildPhase = "true"; # No build needed.
        };
      }
    )
    // {

      # Inline module in style of home-manager
      # You can use this as system-wide if you like.
      # Usage:
      # import = [ inputs.hyprlandUnityFix.nixosModules.hyprlandUnityFixModule ]
      #
      # or more reasonably:
      # inputs.hyprlandUnityFix.enable = true;
      #
      nixosModules.hyprlandUnityFixModule =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        let
          cfg = config.hyprlandUnityFix;
        in
        {
          options.hyprlandUnityFix = {
            enable = lib.mkEnableOption "Enable Hyprland Unity Fixes.";
            configRules = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "Additional configuration rules (each as strings) to be concatenated.";
            };
          };

          # Merge existing extraConfigs a user might have.
          config = lib.mkIf cfg.enable {
            wayland.windowManager.hyprland.extraConfig = lib.concatStringsSep "\n" (
              cfg.configRules ++ [ (builtins.readFile ./UnityFix.conf) ]
            );
          };
        };
    };
}
