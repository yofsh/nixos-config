{ config, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./../../modules/base.nix
    ./../../modules/desktop.nix
    ./../../modules/lsp.nix
  ];
  networking.hostName = "athena";

  environment.systemPackages = with pkgs; [ ];

  services.udisks2.enable = true;
  programs.ssh.startAgent = false;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.polkit = { enable = true; };

  # environment.shellInit = ''
  #   gpg-connect-agent /bye
  #   export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  # '';

  services.pcscd.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];

  services.asusd.enable = true;
  programs.light.enable = true;

  services.power-profiles-daemon.enable = true;
  # powerManagement.powertop.enable = true;
}

