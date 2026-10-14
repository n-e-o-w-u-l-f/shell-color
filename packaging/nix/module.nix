{ self }:
{ config, lib, pkgs, ... }:
let
  cfg = config.programs.shell-color;
  package = self.packages.${pkgs.system}.default;
in {
  options.programs.shell-color = {
    enable = lib.mkEnableOption "shell-color Bash prompt coloring";
    package = lib.mkOption {
      type = lib.types.package;
      default = package;
      description = "shell-color package to install.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    programs.bash.interactiveShellInit = ''
      source ${cfg.package}/share/shell-color/shell-color.sh
    '';
  };
}
