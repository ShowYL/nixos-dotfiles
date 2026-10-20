{
  pkgs,
  lib,
  config,
  hostname,
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

  imports = lib.filter (n: lib.strings.hasSuffix ".nix" n) (
    lib.filesystem.listFilesRecursive ../modules
  );

  home = {
    packages = with pkgs; [
      vim
      nil
      nixfmt
      nixd
      neovim
      curl
      wget
      git
      xar
      clang
      gnumake
      cmake
      go
      cargo
      go-task
      mise
      rustc
      zsh
      btop
      fastfetch
      cheese
      fzf
      bibata-cursors
      tree
      nautilus
      nerd-fonts.jetbrains-mono
      google-fonts
      jq
      adw-gtk3
      libreoffice
      vlc
      eza
      bat
      nwg-displays
      nwg-look
      inkscape
      openssl
      virt-manager
      qemu
      yt-dlp
      nodejs_26
      gradle
      maven
      vscodium
      jdk25
      beekeeper-studio
      localsend
      zip
      unzip
      zed-editor
    ];

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      NIXOS_FORCE_FONTCONFIG_DIRS = "1";
    };
  };

  hyprland.enable = true;
  noctalia.enable = true;
  helium.enable = true;
  starship.enable = true;
  fish.enable = true;
  gh.enable = true;
  kitty.enable = true;
  gtk.enable = true;
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
