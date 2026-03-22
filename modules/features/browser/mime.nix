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
        "image/avif" = [ "gimp.desktop" ];
        "image/bmp" = [ "gimp.desktop" ];
        "image/gif" = [ "gimp.desktop" ];
        "image/jpeg" = [ "gimp.desktop" ];
        "image/png" = [ "gimp.desktop" ];
        "image/svg+xml" = [ "org.inkscape.Inkscape.desktop" ];
        "image/tiff" = [ "gimp.desktop" ];
        "image/webp" = [ "gimp.desktop" ];
        "text/html" = [ "brave-browser.desktop" ];
        "text/rtf" = [ "libreoffice-writer.desktop" ];
        "x-scheme-handler/http" = [ "brave-browser.desktop" ];
        "x-scheme-handler/https" = [ "brave-browser.desktop" ];
      };
    };
  };
}
