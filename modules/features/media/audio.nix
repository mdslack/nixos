{ lib, ... }:
let
  audioMimeTypes = [
    "audio/aac"
    "audio/flac"
    "audio/m4a"
    "audio/mp4"
    "audio/mpeg"
    "audio/ogg"
    "audio/vnd.wave"
    "audio/wav"
    "audio/webm"
    "audio/x-aac"
    "audio/x-flac"
    "audio/x-m4a"
    "audio/x-matroska"
    "audio/x-mpegurl"
    "audio/x-ms-wma"
    "audio/x-scpls"
    "audio/x-vorbis+ogg"
    "audio/x-wav"
  ];
in {
  flake.modules.nixos.media-audio = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      strawberry
    ];
  };

  flake.modules.homeManager.media-audio = {
    xdg.mimeApps.defaultApplications =
      lib.genAttrs audioMimeTypes (_: [ "org.strawberrymusicplayer.strawberry.desktop" ]);
  };
}
