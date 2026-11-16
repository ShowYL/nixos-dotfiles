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
    # Symlink ~/.config/nvim directly into the writable modules/nvim submodule
    # checkout (outside the Nix store) so edits live in the submodule and can
    # be committed. Plain `source = ./nvim` would copy the submodule into the
    # read-only Nix store instead.
    home.file.".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink ./nvim;
    };
  };
}
