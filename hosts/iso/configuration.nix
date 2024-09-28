{ pkgs, modulesPath, lib, ... }: {

  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    ./../../modules/base.nix
    ./../../modules/desktop.nix
  ];

# iso uses grub by default
  boot.loader.systemd-boot.enable = lib.mkForce false;

  nixpkgs.hostPlatform = "x86_64-linux";




}
