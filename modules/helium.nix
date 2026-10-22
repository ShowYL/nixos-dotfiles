{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  options = {
    helium.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Helium";
    };
  };

  config = lib.mkIf config.helium.enable {
    home.packages = [
      inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
