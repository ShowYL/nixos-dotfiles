{
  pkgs,
  lib,
  config,
  ...
}:
let
  # Base Starship config template for Noctalia (without the dynamic [palettes.noctalia] block)
  baseStarshipConfig = pkgs.writeText "starship.toml" ''
    palette = "noctalia"
    add_newline = true

    format = """
      $cmd_duration $directory$git_branch
       $character"""

    [fill]
    symbol = '-'
    style = 'fg:overlay0'

    [character]
    success_symbol = "[ ](bold fg:blue)"
    error_symbol = "[ ](bold fg:red)"

    [package]
    disabled = true

    [git_branch]
    style = "bg:cyan"
    symbol = "󰘬"
    truncation_length = 12
    truncation_symbol = ""
    format = " 󰜥 [](bold fg:cyan)[$symbol $branch(:$remote_branch)](fg:base bg:cyan)[ ](bold fg:cyan)"

    [git_commit]
    commit_hash_length = 4
    tag_symbol = " "

    [git_state]
    format = '[\($state( $progress_current of $progress_total)\)]($style) '
    cherry_pick = "[🍒 PICKING](bold red)"

    [git_status]
    conflicted = " 🏳 "
    ahead = " 🏎💨 "
    behind = " 😰 "
    diverged = " 😵 "
    untracked = " 🤷 ‍"
    stashed = " 📦 "
    modified = " 📝 "
    staged = '[++\($count\)](green)'
    renamed = " ✍️ "
    deleted = " 🗑 "

    [hostname]
    ssh_only = false
    format = "[•$hostname](bg:cyan bold fg:base)[](bold fg:cyan)"
    trim_at = ".companyname.com"
    disabled = false

    [line_break]
    disabled = false

    [memory_usage]
    disabled = true
    threshold = -1
    symbol = " "
    style = "bold dimmed green"

    [time]
    disabled = true
    format = '🕙[\[ $time \]]($style) '
    time_format = "%T"

    [username]
    style_user = "bold bg:cyan fg:base"
    style_root = "red bold"
    format = "[](bold fg:cyan)[$user]($style)"
    disabled = false
    show_always = true

    [directory]
    home_symbol = " "
    read_only = "  "
    style = "bg:green fg:base"
    truncation_length = 2
    truncation_symbol = ".../"
    format = '[](bold fg:green)[󰉋 → $path]($style)[](bold fg:green)'

    [directory.substitutions]
    "Desktop" = "  "
    "Documents" = "  "
    "Downloads" = "  "
    "Music" = " 󰎈 "
    "Pictures" = "  "
    "Videos" = "  "
    "GitHub" = " 󰊤 "

    [cmd_duration]
    min_time = 0
    format = '[](bold fg:yellow)[󰪢 $duration](bold bg:yellow fg:base)[](bold fg:yellow)'
  '';
in
{
  options = {
    starship.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Starship with dynamic Noctalia palette support";
    };
  };

  config = lib.mkIf config.starship.enable {
    programs.starship = {
      enable = true;
      # Do not set `settings = { ... };` so Home Manager does not create a read-only symlink
    };

    # Seeds a writable starship.toml file that Noctalia can safely modify in-place
    home.activation.setupStarship = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.config"
      if [ ! -f "$HOME/.config/starship.toml" ]; then
        cp ${baseStarshipConfig} "$HOME/.config/starship.toml"
        chmod u+w "$HOME/.config/starship.toml"
      fi
    '';
  };
}
