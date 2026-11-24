_: {
  flake.modules.nixos.controls-packages =
    { pkgs, ... }:
    {
      users.users.mslack.extraGroups = [ "video" ];

      environment.systemPackages = with pkgs; [
        bluetui
        dfu-util
        impala
        usbutils
        v4l-utils
        wiremix
      ];

      # Keychron Launcher: Q1 Max (0810) and Keychron Link receiver (d030).
      # https://wiki.nixos.org/wiki/Keychron_M6
      services.udev.extraRules = ''
        SUBSYSTEM=="hidraw", KERNEL=="hidraw*", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0810", MODE="0660", GROUP="users", TAG+="uaccess"
        SUBSYSTEM=="hidraw", KERNEL=="hidraw*", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d030", MODE="0660", GROUP="users", TAG+="uaccess"
        SUBSYSTEM=="usb", ATTR{idVendor}=="3434", ATTR{idProduct}=="0810", MODE="0660", GROUP="users", TAG+="uaccess"
        SUBSYSTEM=="usb", ATTR{idVendor}=="3434", ATTR{idProduct}=="d030", MODE="0660", GROUP="users", TAG+="uaccess"

        # STM32 DFU bootloader used when flashing the Q1 Max firmware.
        SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="df11", MODE="0660", GROUP="users", TAG+="uaccess"
      '';
    };
}
