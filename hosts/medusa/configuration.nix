{
  config,
    lib,
    pkgs,
    ...
}: {
  imports = [
    # ./hardware-configuration.nix
    ./../../modules/base.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    ];


  networking.hostName = "medusa";
  networking.hosts = {
    "192.168.1.50" = [ "srv" ];
    "192.168.99.1" = [ "wghost" ];
    "116.203.205.147" = [ "vps" ];
  };

  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "23.05";

  virtualisation.docker.enable = true;
  programs.virt-manager = {
    enable = true;
  };

  # networking.wg-quick.interfaces = {
  #   wg0 = {
  #     autostart = false;
  #     address = [ "192.168.99.20/24" ];
  #     dns = [ "1.1.1.1" ];
  #     privateKeyFile = "/home/fobos/wg";
  #     peers = [
  #     {
  #       publicKey = "NcAhvpiJJQEttjJdP8aT4DJocX6jZObv4cBJiakZt3w=";
  #       allowedIPs = [ "0.0.0.0/0" "::/0" ];
  #       endpoint = "116.203.205.147:51820";
  #       persistentKeepalive = 25;
  #     }
  #     ];
  #   };
  # };
  # services.ollama = {
  #   enable = false;
  #   acceleration = "cuda";
  # };
}

