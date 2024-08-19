{ config, lib, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ./../../modules/base.nix ];

  networking.hostName = "hermes";

  environment.systemPackages = with pkgs; [ ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.firewall = {
    enable = false;
    allowedTCPPorts = [ 22 80 443 8123 6052 ];
  };

  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_US.UTF-8";

  virtualisation.docker.enable = true;
  virtualisation.containers.enable = true;

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  services.openssh.enable = true;
  system.stateVersion = "24.05";

  programs.starship.settings.add_newline = lib.mkForce true;
  programs.starship.settings.format = lib.mkForce "$all$directory$character";
  programs.starship.settings.right_format = lib.mkForce "";

  # networking.firewall.interfaces."wg0".allowedTCPPorts = [ 8000 ];

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true;

  networking.nat.enable = true;
  # networking.nat.externalInterface = "eth0";
  # networking.nat.internalInterfaces = [ "wg0" ];
}

