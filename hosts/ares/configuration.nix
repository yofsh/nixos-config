{ config, inputs, lib, pkgs, ... }: {

  imports = [
    ./hardware-configuration.nix
    ./../../modules/base.nix
    ./../../modules/desktop.nix
    ./../../modules/lsp.nix
  ];
  networking.hostName = "ares";

  environment.systemPackages = with pkgs; [ ];

  services.udisks2.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  virtualisation.containers.cdi.dynamic.nvidia.enable = true;
  virtualisation.docker.enableNvidia =  true;
  hardware.nvidia-container-toolkit.enable = true;
  virtualisation.docker.daemon.settings = {
    features = {
      cdi = true;
    };
  };

  services.power-profiles-daemon.enable = true;
}

