{
  description = "Customizable xterm-256 Bash prompt colors";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      packages = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.stdenvNoCC.mkDerivation {
            pname = "shell-color";
            version = nixpkgs.lib.removeSuffix "\n" (builtins.readFile ./VERSION);
            src = self;
            installPhase = ''
              install -Dm755 bin/shell-color $out/bin/shell-color
              install -Dm644 src/shell-color.sh $out/share/shell-color/shell-color.sh
              install -Dm644 profile.d/shell-color.sh $out/etc/profile.d/shell-color.sh
              install -Dm644 LICENCE.md $out/share/licenses/shell-color/LICENCE.md
            '';
          };
        });

      nixosModules.default = import ./packaging/nix/module.nix { inherit self; };
    };
}
