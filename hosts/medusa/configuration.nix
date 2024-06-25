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
    ./../../modules/paperless-ngx.nix
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

  networking.firewall = {
	  enable = true;
	  allowedTCPPorts = [ 22 80 443 ];
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
  system.stateVersion = "23.11";

  programs.starship.settings.add_newline = lib.mkForce true;
  programs.starship.settings.format = lib.mkForce "$all$directory$character";
  programs.starship.settings.right_format = lib.mkForce "";


  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # Only allow PFS-enabled ciphers with AES256
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
  };


  services.nginx.virtualHosts."yof.sh" = {
	  addSSL = true;
	  enableACME = true;
	  root = "/var/www/yof.sh";
  };

  services.nginx.virtualHosts."yofsh.dev" = {
	  addSSL = true;
	  enableACME = true;
	  root = "/var/www/yofsh.dev";
	  globalRedirect = "yof.sh";
  };

  # services.nginx.virtualHosts."sd.yofsh.dev" = {
  #  addSSL = true;
  #  enableACME = true;
  #  root = "/var/www/sd.yofsh.dev";
  # };

  security.acme = {
	  acceptTerms = true;
	  defaults.email = "to@yof.sh";
  };


  networking.nat.enable = true;
  networking.nat.externalInterface = "eth0";
  networking.nat.internalInterfaces = [ "wg0" ];
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 51820;
# PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE; iptables -A FORWARD -i ens3 -m state --state RELATED,ESTABLISHED -j ACCEPT
# PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o ens3 -j MASQUERADE; iptables -D FORWARD -i ens3 -m state --state RELATED,ESTABLISHED -j ACCEPT
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT;
	${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE;
        ${pkgs.iptables}/bin/iptables -A FORWARD -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT;
      '';
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT;
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADES;
        ${pkgs.iptables}/bin/iptables -D FORWARD -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT;
      '';

      fwMark = "0xca6c";

      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/root/host";
      peers = [
        { 
          # athena 
          publicKey = "AV/a4BWC06udF2SiRyivR70CSikjduAeUry6Tr0k+Ao=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        { 
          # orpheus 
          publicKey = "ioYF114bpXWGnTSVKGcETd8zya8+bA2zeKyxZLB0lwM=";
          allowedIPs = [ "10.100.0.3/32" "192.168.1.0/24"];
        }
        { 
          # travelrouter
          publicKey = "CIVvtAprzkVUPxJZZ58EQ+xrrstYXWGx/GE7aaMvkns=";
          allowedIPs = [ "10.100.0.10/32" "10.2.2.0/24" "192.168.8.0/24" "192.168.9.0/24"];
        }
        { 
          # s24u
          publicKey = "byubHqF23fYUHkaD7aRik7uFVFEuiSPcAZ2u902nGww=";
          allowedIPs = [ "10.100.0.11/32" ];
        }
        { 
          # router_p
          publicKey = "SxEO9hqy4vz1wmIGtQKvIweKUID+/su9FcCWeZwUES8=";
          allowedIPs = [ "10.100.0.12/32" ];
        }
      ];
    };
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

