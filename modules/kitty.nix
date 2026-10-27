{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    kitty.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Kitty terminal emulator";
    };
  };

  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;

      font = {
        name = "JetBrains Mono Nerd Font";
        size = 11.0;
      };

      settings = {
        cursor_shape = "beam";
        cursor_trail = 1;
        window_margin_width = 0;
        confirm_os_window_close = 0;
        shell = "fish";

        # Kitty caches the last window geometry/state in ~/.cache/kitty/main.json.
        # Replaying a cached "maximized" state made every new kitty open
        # maximized (and thus take over the whole workspace), so let Hyprland
        # decide the initial size instead.
        remember_window_size = false;
      };

      keybindings = {
        "ctrl+c" = "copy_or_interrupt";

        "page_up" = "scroll_page_up";
        "page_down" = "scroll_page_down";

        "ctrl+plus" = "change_font_size all +1";
        "ctrl+equal" = "change_font_size all +1";
        "ctrl+kp_add" = "change_font_size all +1";
        "ctrl+minus" = "change_font_size all -1";
        "ctrl+underscore" = "change_font_size all -1";
        "ctrl+kp_subtract" = "change_font_size all -1";
        "ctrl+0" = "change_font_size all 0";
        "ctrl+kp_0" = "change_font_size all 0";
      };

      # Import the Noctalia-generated theme
      extraConfig = ''
        include themes/noctalia.conf
      '';
    };

    # Ensure ~/.config/kitty/themes exists so Noctalia can write to it,
    # and create an empty placeholder so Kitty doesn't complain on fresh installs
    home.activation.setupKittyThemes = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.config/kitty/themes"
      if [ ! -f "$HOME/.config/kitty/themes/noctalia.conf" ]; then
        touch "$HOME/.config/kitty/themes/noctalia.conf"
      fi
    '';
  };
}
