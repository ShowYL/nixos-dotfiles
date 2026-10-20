{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  options = {
    fish.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable fish";
    };
  };

  config = lib.mkIf config.fish.enable {
    programs.fish = {
      enable = true;
      interactiveShellInit = /* fish */ ''
        # Commands to run in interactive sessions can go here
        if status is-interactive
            # No greeting
            set fish_greeting

            # Use starship
            function starship_transient_prompt_func
                starship module character
            end
            if test "$TERM" != linux
                starship init fish | source
                enable_transience
            end

            # Fuzzy Finder Integration
            if type -q fzf
                fzf --fish | source
            end

            # mise
            eval "$(mise activate fish)"

            # Aliases
            # kitty doesn't clear properly so we need to do this weird printing
            alias clear "printf '\033[2J\033[3J\033[1;1H'"
            alias celar "printf '\033[2J\033[3J\033[1;1H'"
            alias claer "printf '\033[2J\033[3J\033[1;1H'"
            alias ls 'eza --group-directories-first --icons=auto --color=auto --classify'
            alias ll 'eza -l --group-directories-first --icons=auto --color=auto --git'
            alias la 'eza -la --group-directories-first --icons=auto --color=always --git'
        end
      '';
    };
  };
}
