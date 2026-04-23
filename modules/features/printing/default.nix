_: {
  flake.modules.nixos.printing =
    { pkgs, ... }:
    let
      canonPdfPpd = pkgs.runCommand "canon-lbp632c-pdf-ppd" { } ''
        mkdir -p "$out/share/cups/model"
        ln -s \
          ${pkgs.cups-filters}/share/ppd/cupsfilters/Generic-PDF_Printer-PDF.ppd \
          "$out/share/cups/model/Generic-PDF_Printer-PDF.ppd"
      '';
    in
    {
      services.printing.enable = true;
      services.printing.drivers = [
        pkgs.gutenprint
        canonPdfPpd
      ];

      hardware.printers = {
        ensurePrinters = [
          {
            name = "Canon-LBP632C";
            location = "10.0.0.180";
            deviceUri = "ipp://10.0.0.180/ipp/print";
            model = "Generic-PDF_Printer-PDF.ppd";
          }
        ];
        ensureDefaultPrinter = "Canon-LBP632C";
      };
    };
}
