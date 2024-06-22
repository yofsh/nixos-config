{
  config,
    lib,
    pkgs,
    ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
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

  virtualisation.docker.enable = true;
  programs.virt-manager = {
    enable = true;
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1ZWtcOzD0v67ORNy6YxBQxwHtPu8q0IWNzhpvcMGXsxUD5veeRZtuQLSXXf3+0EA+r+iC0K+1gEXAhjjyyKKUVhjzgtSPd+eI85d+BRY/X+8y9EjxAx5I0BFpxI0uSvukhrqLnbzs0/EMjr2yxMPRf66KJ6gpevzW7q9AvAJsxCEOTI8Xv/6WJh+jnqU+BrB86qczcPWbUYuZCEEoQ9HTpPrIWeC0KSgSn94nAQYV3UZjbJSkELyIc2dDDxb9pP+60kr2/J6c4NeSRPWTPjAGdOFjcdqH7oRTLOLMQyk+JimPw8zkp7BDL2TCDpvcTj2RCF4zQ9QeVdyXFwbipKspiCCBl1mXM+mePNtak4jGgc7V9WQjKFz+7CTRoTEteAyIkM/FElxtlKUkxA55UQGh3SA4wxqF0ZbYVKtHgjMNO9uTPsbZy1c0Ixfq9eKIcoKQxNBRx0pavGmKrh9BAMoHPXOqztOrkAJ6ClQzr5eA7a1N23EayFJo/hHvz4ncYrcm+glW11wlTfNbvdHCDsfNcpczK9C+NDPOAI8BER4Q0NOZQ/7HtVnXu2MfXkzeoBX20Xpv8+Br3HJ/T1qQlSn2lkRy+gMFTVZaC/CkrWVpR/xTMU0Ac3T8kIAk34cpLZlH5DqX0Phzqxn+s7c4e/IpQt5RgLbBmwQ3dsp2BnFLlw== user@host'' ];
  system.stateVersion = "23.11";

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

