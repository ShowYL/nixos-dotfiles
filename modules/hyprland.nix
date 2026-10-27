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
        size = 24;
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
        ${lib.optionalString config.qt.enable ''
          -- Qt: qt5ct/qt6ct are provided by modules/qt.nix (Home Manager).
          hl.env("QT_QPA_PLATFORMTHEME", "${config.home.sessionVariables.QT_QPA_PLATFORMTHEME}")
          hl.env("QT_PLUGIN_PATH", "${lib.concatStringsSep ":" config.home.sessionSearchVariables.QT_PLUGIN_PATH}")
        ''}
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

        -- nwg-displays writes these files next to hyprland.lua when applying
        -- monitor/workspace changes. They must be loaded last so they can
        -- override the baked-in defaults above. pcall keeps the config valid
        -- when the files do not exist yet.
        pcall(require, "monitors")
        pcall(require, "workspaces")

        ${if config.noctalia.enable then "require(\"noctalia\").apply_theme()" else ""}
      '';
    };
  };
}
