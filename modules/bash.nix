{
  lib,
  config,
  ...
}:
{
  options = {
    bash.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable bash";
    };
  };

  config = lib.mkIf config.bash.enable {
    programs.bash = {
      enable = true;
      initExtra = /* bash */ ''
        # Use starship
        if [[ "$TERM" != "linux" ]] && command -v starship >/dev/null 2>&1; then
          eval "$(starship init bash)"
        fi

        # Fuzzy Finder Integration
        if command -v fzf >/dev/null 2>&1; then
          eval "$(fzf --bash)"
        fi

        # Go path
        export PATH="$HOME/go/bin:$PATH"

        # mise
        if command -v mise >/dev/null 2>&1; then
          eval "$(mise activate bash)"
        fi

        # pnpm
        export PNPM_HOME='/home/yann/.local/share/pnpm'
        case ":$PATH:" in
          ":$PNPM_HOME/bin:"*) ;;
          *) export PATH="$PNPM_HOME/bin:$PATH" ;;
        esac
        # pnpm end

        # Aliases
        # kitty doesn't clear properly so we need to do this weird printing
        alias clear="printf '\033[2J\033[3J\033[1;1H'"
        alias celar="printf '\033[2J\033[3J\033[1;1H'"
        alias claer="printf '\033[2J\033[3J\033[1;1H'"
        alias ls='eza --group-directories-first --icons=auto --color=auto --classify=auto'
        alias ll='eza -l --group-directories-first --icons=auto --color=auto --git'
        alias la='eza -la --group-directories-first --icons=auto --color=always --git'
      '';
    };
  };
}
