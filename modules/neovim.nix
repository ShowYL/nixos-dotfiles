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
    # Symlink ~/.config/nvim into the modules/nvim submodule checkout so edits
    # live in the submodule and can be committed. mkOutOfStoreSymlink keeps the
    # target outside the read-only Nix store.
    #
    # The path is relative to $HOME (assumes the repo is cloned to
    # ~/.config/nixos) so the configuration works on other machines after
    # `git submodule update --init`. With flakes, ./modules/nvim resolves to
    # Nix's store source snapshot, which excludes submodule content, so a real
    # filesystem path is required.
    home.file.".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos/modules/nvim";
    };
  };
}
