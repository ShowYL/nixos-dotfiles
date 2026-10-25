{
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  options = {
    zen.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Zen Browser";
    };
  };

  config = lib.mkIf config.zen.enable {
    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;

      policies = {
        DisableAppUpdate = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
      };

      profiles.default = {
        settings = {
          "zen.workspaces.continue-where-left-off" = true;
        };

        sine = {
          enable = true;
          mods = [
          ];
        };
      };
    };
  };
}
