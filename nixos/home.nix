{
  pkgs,
  lib,
  inputs,
  ...
}:

{
  home.username = "yann";
  home.homeDirectory = "/home/yann";
  home.stateVersion = "26.05";

  nixpkgs = {
    overlays = [
      inputs.self.overlays.unstable-packages
    ];

    config.allowUnfree = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "gtk" ];
      };
      hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
      };
    };
  };

  imports = lib.filter (n: lib.strings.hasSuffix ".nix" n) (
    lib.filesystem.listFilesRecursive ../modules
  );

  home = {
    packages = with pkgs; [
      # Shell
      zsh

      # Editors
      neovim
      vim
      vscodium
      zed-editor

      # Nix tooling
      nil
      nixd
      nixfmt

      # Languages & build tools
      cargo
      clang
      cmake
      go
      go-task
      gradle
      gnumake
      jdk25
      lua
      maven
      mise
      pkg-config
      nodejs_26
      python3
      rustc
      meson
      uv

      # Version control & containers
      git
      lazydocker
      lazygit

      # CLI utilities
      bat
      btop
      curl
      eza
      typst
      fastfetch
      fzf
      jq
      openssl
      ripgrep
      tree
      unzip
      wget
      xar
      zip

      # Fonts, cursors & theming
      adw-gtk3
      bibata-cursors
      google-fonts
      nerd-fonts.jetbrains-mono

      # Desktop & Hyprland utilities
      ddcutil
      hyprpicker
      nwg-displays
      nwg-look

      # Applications
      seahorse
      beekeeper-studio
      cheese
      inkscape
      libreoffice
      localsend
      nautilus
      papers
      gnome-boxes
      cine
      bottles
      keypunch
      eog
      pavucontrol
      bookup
      foliate
      nucleus
      crosswords
      gnome-weather
      epiphany
      gnome-calculator
      gnome-calendar
      gnome-maps
      vlc
      yt-dlp

      # Virtualization
      qemu
      virt-manager
    ];

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };

  hyprland.enable = true;
  noctalia.enable = true;
  helium.enable = true;
  starship.enable = true;
  bash.enable = true;
  fish.enable = true;
  zsh.enable = true;
  gh.enable = true;
  kitty.enable = true;
  neovim.enable = true;
  gtk.enable = true;
  qt.enable = true;
  zen.enable = true;

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  fonts.fontconfig.enable = true;

  targets.genericLinux.nixGL.vulkan.enable = true;

  programs.git = {
    enable = true;
    settings.user = {
      name = "Yann Lacaze";
      email = "yannlacaze31@gmail.com";
    };
    settings = {
      init.defaultBranch = "main";
    };
  };
}
