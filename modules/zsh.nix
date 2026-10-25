{
  lib,
  config,
  ...
}:
{
  options = {
    zsh.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable zsh";
    };
  };

  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      initContent = /* zsh */ ''
        # Use starship
        starship_transient_prompt_func() {
          starship module character
        }

        if [[ "$TERM" != "linux" ]]; then
          eval "$(starship init zsh)"

          # Enable prompt transience in Zsh (replaces Fish's built-in `enable_transience`)
          zle-line-finish() {
            PROMPT=$(starship_transient_prompt_func)
            RPROMPT=""
            zle reset-prompt 2>/dev/null
          }
          zle -N zle-line-finish
        fi

        # Fuzzy Finder Integration
        if (( $+commands[fzf] )); then
          source <(fzf --zsh)
        fi

        # Go path
        export PATH="$HOME/go/bin:$PATH"

        # mise
        if (( $+commands[mise] )); then
          eval "$(mise activate zsh)"
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
        alias ls='eza --group-directories-first --icons=auto --color=auto --classify'
        alias ll='eza -l --group-directories-first --icons=auto --color=auto --git'
        alias la='eza -la --group-directories-first --icons=auto --color=always --git'
      '';
    };
  };
}
