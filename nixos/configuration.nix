# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    overlays = [
      inputs.self.overlays.unstable-packages

      (final: prev: {
        ipu6ep-camera-hal = prev.ipu6ep-camera-hal.overrideAttrs (oldAttrs: {
          postInstall = (oldAttrs.postInstall or "") + ''
            # 1. Fix the hyphen in CSI entity name for all XML files
            sed -i 's/Intel IPU6 CSI-2/Intel IPU6 CSI2/g' $out/etc/camera/ipu6ep/sensors/*.xml
            sed -i 's/Intel IPU6 CSI-2/Intel IPU6 CSI2/g' $out/etc/camera/ipu6ep/gcss/*.xml

            # 2. Add ov2740-uf-0 to availableSensors so it matches CSI port 0
            sed -i 's/ov2740-uf-1/ov2740-uf-0,ov2740-uf-1/g' $out/etc/camera/ipu6ep/libcamhal_profile.xml
          '';
        });
      })
    ];

    config.allowUnfree = true;
  };

  # Enable systemd in initrd (Required for TPM2 LUKS auto-unlock)
  boot.initrd.systemd.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;

    limine = {
      enable = true;
      secureBoot.enable = true; # Enables sbctl signing during rebuilds
      maxGenerations = 10;
      enableEditor = false; # Disables editing kernel cmdline at boot (prevents bypassing security)
    };
  };

  hardware = {
    bluetooth.enable = true;

    ipu6 = {
      enable = true;
      platform = "ipu6ep";
    };

    enableRedistributableFirmware = true;
    firmware = with pkgs; [
      ivsc-firmware
      linux-firmware
    ];

    graphics = {
      enable = true;

      extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
      ];
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;

    nftables.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [
        config.services.tailscale.interfaceName
        "virbr0"
      ];

      # Allow the Tailscale UDP port through the firewall
      allowedUDPPorts = [
        config.services.tailscale.port
        53317 # Localsend
      ];
      allowedTCPPorts = [ 53317 ];
      # See https://github.com/tailscale/tailscale/issues/4432#issuecomment-1112819111
      checkReversePath = "loose";
    };
  };

  security = {
    rtkit.enable = true;
  };

  # Configure network connections interactively with nmcli or nmtui.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "fr";
  console.keyMap = "fr-latin9";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yann = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager"
      "libvirtd"
      "docker"
      "video"
    ];
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    sbctl # Secure Boot key manager
    limine # Limine bootloader CLI
    tpm2-tools # To inspect TPM status
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neovim
    curl
    git
    gcc
    kitty
    fish
    nerd-fonts.jetbrains-mono
    bibata-cursors
    bat
    eza
    zsh
    virt-manager
    gnumake
    tree
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs = {
    hyprland = {
      enable = true;
      package = pkgs.unstablePkgs.hyprland;
      portalPackage = pkgs.unstablePkgs.xdg-desktop-portal-hyprland;
    };

    steam.enable = true;
    fish.enable = true;
    git.enable = true;
  };

  # List services that you want to enable:

  services = {
    # Enable the OpenSSH daemon.
    openssh.enable = true;

    tailscale.enable = true;

    power-profiles-daemon.enable = true;
    upower.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Enable sound with pipewire.
    pulseaudio.enable = false;

    # Enable CUPS to print documents.
    printing.enable = true;

    qemuGuest.enable = true;
    spice-vdagentd.enable = true;

    displayManager.noctalia-greeter = {
      enable = true;

      settings = {
        keyboard.layout = "fr";

        cursor = {
          theme = "Bibata-Modern-Ice";
          size = 24;
        };

        # Default session to Hyprland
        session.default = "Hyprland";
      };

      # Allow user session to sync wallpapers & themes to the greeter seamlessly
      passwordless-sync-users = [ "yann" ];
    };

    accounts-daemon.enable = true;
  };

  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
      firewallBackend = "nftables";
    };
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      hostName = config.networking.hostName;
    };

    users."yann" = import ./home.nix;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
