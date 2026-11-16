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
    # be committed. We use an absolute path because, with flakes, `./nvim`
    # resolves to Nix's store source copy which does not include submodule
    # content. mkOutOfStoreSymlink keeps the target outside the read-only store.
    home.file.".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/yann/.config/nixos/modules/nvim";
    };
  };
}
