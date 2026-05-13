_: {
  flake.modules.nixos.files-archives =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        p7zip
        unzip
        zip
      ];
    };
}
