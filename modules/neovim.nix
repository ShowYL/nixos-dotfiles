{ lib, config, ... }:
{
  options = {
    neovim.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Neovim configuration from the modules/nvim submodule";
    };
  };

  config = lib.mkIf config.neovim.enable {
    home.file.".config/nvim" = {
      source = ./nvim;
      type = "symlink";
    };
  };
}
