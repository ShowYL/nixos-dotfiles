{ ... }:
let
  # Noctalia's "qt" template writes the color scheme these tools load.
  qtctSettings = qtct: {
    Appearance = {
      style = "Fusion";
      custom_palette = true;
      color_scheme_path = "$HOME/.config/${qtct}/colors/noctalia.conf";
      standard_dialogs = "default";
    };
  };
in
{
  qt = {
    enable = true;

    # Installs qt5ct and qt6ct. qt6ct also registers the "qt5ct" platform theme
    # key, so both Qt5 and Qt6 applications are themed.
    platformTheme.name = "qtct";

    qt5ctSettings = qtctSettings "qt5ct";
    qt6ctSettings = qtctSettings "qt6ct";
  };
}
