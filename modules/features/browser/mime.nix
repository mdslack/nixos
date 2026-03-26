_: {
  flake.modules.homeManager.browser-mime = {
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
        "application/msword" = [ "libreoffice-writer.desktop" ];
        "application/rtf" = [ "libreoffice-writer.desktop" ];
        "application/vnd.ms-excel" = [ "libreoffice-calc.desktop" ];
        "application/vnd.ms-powerpoint" = [ "libreoffice-impress.desktop" ];
        "application/vnd.oasis.opendocument.presentation" = [ "libreoffice-impress.desktop" ];
        "application/vnd.oasis.opendocument.spreadsheet" = [ "libreoffice-calc.desktop" ];
        "application/vnd.oasis.opendocument.text" = [ "libreoffice-writer.desktop" ];
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [ "libreoffice-impress.desktop" ];
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = [ "libreoffice-calc.desktop" ];
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "libreoffice-writer.desktop" ];
        "image/avif" = [ "org.gnome.Loupe.desktop" ];
        "image/bmp" = [ "org.gnome.Loupe.desktop" ];
        "image/gif" = [ "org.gnome.Loupe.desktop" ];
        "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
        "image/png" = [ "org.gnome.Loupe.desktop" ];
        "image/svg+xml" = [ "org.inkscape.Inkscape.desktop" ];
        "image/tiff" = [ "org.gnome.Loupe.desktop" ];
        "image/webp" = [ "org.gnome.Loupe.desktop" ];
        "text/html" = [ "brave-browser.desktop" ];
        "text/rtf" = [ "libreoffice-writer.desktop" ];
        "x-scheme-handler/http" = [ "brave-browser.desktop" ];
        "x-scheme-handler/https" = [ "brave-browser.desktop" ];
      };
    };
  };
}
