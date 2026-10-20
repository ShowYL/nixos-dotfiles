{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    hyprland.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Hyprland";
    };
  };

  config = lib.mkIf config.hyprland.enable {
    home = {
      pointerCursor = {
        gtk.enable = true;
        # x11.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 16;
      };

      # Trick to expose lua stubs directly
      file.".local/share/hyprland-stubs".source = "${pkgs.hyprland}/share/hypr/stubs";
    };

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false;
      configType = "lua";
      settings = { };

      extraConfig = /* lua */ ''
        ${builtins.readFile ./hyprland/env.lua}
        ${builtins.readFile ./hyprland/variables.lua}
        ${builtins.readFile ./hyprland/animation.lua}
        ${builtins.readFile ./hyprland/bind.lua}
        ${builtins.readFile ./hyprland/config.lua}
        ${builtins.readFile ./hyprland/hyprland.lua}
        ${builtins.readFile ./hyprland/keybinds.lua}
        ${builtins.readFile ./hyprland/layer.lua}
        ${builtins.readFile ./hyprland/monitors.lua}
        ${builtins.readFile ./hyprland/tactile.lua}
        ${builtins.readFile ./hyprland/workspace.lua}
        ${if config.noctalia.enable then "require(\"noctalia\").apply_theme()" else ""}
      '';
    };
  };
}
