{
  config,
    lib,
    pkgs,
    ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./../../modules/base.nix
  ];


  nixpkgs.config = {
    allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
      (google-chrome.override {
       commandLineArgs = [
       "--enable-features=UseOzonePlatform"
       "--ozone-platform=wayland"
       ];
       })
    foot
      walker
      anyrun
      mpv
      imv
      krita
      yubikey-personalization
      gnupg
      orca-slicer
# Coding stuff

#TUI utils
    bluetuith
    powertop

# CLI utils
    proxmark3
    rbw
    bluez
    bluez-tools
    udiskie


# GUI utils

# Wayland stuff

# WMs and stuff
    pyprland
    hyprpicker
    hyprcursor
    hyprlock
    hypridle
    hyprpaper
    brightnessctl
    xdg-desktop-portal-hyprland
    xdg-user-dirs
    wdisplays
    dunst
    waybar
    gammastep
    nvtop

    xwayland
    wl-clipboard
    wtype
    wev

# Sound
    pipewire
    pulseaudio
    ncpamixer
    usbutils

# GPU stuff

# Screenshotting
    grim
    slurp
    satty
    wf-recorder
    aichat
    plymouth

# Other
    home-manager
    materia-theme
    papirus-icon-theme
    ];

  fonts.packages = with pkgs; [
    jetbrains-mono
      noto-fonts
      noto-fonts-emoji
      twemoji-color-font
      font-awesome
      powerline-fonts
      powerline-symbols
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
  ];

  services.udisks2.enable = true;

  programs.ssh.startAgent = false;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

security.polkit = {
  enable = true;
};

 environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

services.pcscd.enable = true;
services.udev.packages = [ pkgs.yubikey-personalization ];


  networking.hostName = "laptop";
  networking.hosts = {
    "192.168.1.50" = [ "srv" ];
    "192.168.99.1" = [ "wghost" ];
    "116.203.205.147" = [ "vps" ];
  };

  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "23.05";

  virtualisation.docker.enable = true;
  programs.virt-manager = {
    enable = true;
  };
  services.asusd.enable = true;
  services.upower.enable = true;
  programs.light.enable = true;



  programs.noisetorch.enable = true;

  programs.firefox.enable = true;
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true; 


  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  programs.firefox.policies =   {
    NewTabPage = false;
    CaptivePortal = true;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableTelemetry = true;
    NoDefaultBookmarks = true;
    OfferToSaveLogins = false;
    OfferToSaveLoginsDefault = false;
    PasswordManagerEnabled = false;
    FirefoxHome = {
      Search = true;
      Pocket = false;
      Snippets = false;
      TopSites = false;
      Highlights = false;
    };
    UserMessaging = {
      ExtensionRecommendations = false;
      SkipOnboarding = true;
    };
    Preferences = {
      "ui.key.menuAccessKeyFocuses" = { Status = "locked"; Value = false; };
    };
  };

#Hyprland
  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
  environment.sessionVariables.BROWSER = "firefox";
  environment.sessionVariables.EDITOR = "nvim";

  services.getty.autologinUser = "fobos";

  # services.logind = {
  #   lidSwitch = "ignore";
  # };


#boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
# boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.timeout = 1;
# boot.initrd.verbose = false;
# boot.consoleLogLevel = 0;
# boot.kernelParams = ["quiet" "udev.log_level=0" "amdgpu"];
  boot.kernelParams = ["amdgpu" "amdgpu.dcdebugmask=0x10"];
# boot.plymouth = {
#   enable = true;
# };



#disable GPU
boot.extraModprobeConfig = ''
  blacklist nouveau
  options nouveau modeset=0
'';
  
services.udev.extraRules = ''
  # Remove NVIDIA USB xHCI Host Controller devices, if present
  ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
  # Remove NVIDIA USB Type-C UCSI devices, if present
  ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
  # Remove NVIDIA Audio devices, if present
  ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
  # Remove NVIDIA VGA/3D controller devices
  ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"

  KERNEL=="ttyACM0", TAG+="uaccess", SYMLINK+="ttyACM0_fobos", MODE="0660", OWNER="fobos"
'';


boot.blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];


  # hardware.nvidia.prime = {
  #   offload = {
  #     enable = true;
  #     enableOffloadCmd = true;
  #   };
  #   nvidiaBusId = "PCI:69:0:0";
  #   amdgpuBusId = "PCI:01:0:0"; 
  # };
  # services.xserver.videoDrivers = ["nvidia"];
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = false;
  #   powerManagement.finegrained = true;
  #   open = false;
  #   nvidiaSettings = true;
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  # };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  services.blueman.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
# If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  services.pipewire.wireplumber.configPackages = [
    (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
     bluez_monitor.properties = {
     ["bluez5.enable-sbc-xq"] = true,
     ["bluez5.enable-msbc"] = true,
     ["bluez5.enable-hw-volume"] = true,
     ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
     }
     '')
  ];

  services.fstrim.enable = true;
  networking.wg-quick.interfaces = {
    wg0 = {
      autostart = false;
      address = [ "192.168.99.20/24" ];
      dns = [ "1.1.1.1" ];
      privateKeyFile = "/home/fobos/wg";
      peers = [
      {
        publicKey = "NcAhvpiJJQEttjJdP8aT4DJocX6jZObv4cBJiakZt3w=";
        allowedIPs = [ "0.0.0.0/0" "::/0" ];
        endpoint = "116.203.205.147:51820";
        persistentKeepalive = 25;
      }
      ];
    };
    medusaWG = {
      autostart = false;
      address = [ "10.100.0.2" ];
      dns = [ "1.1.1.1" ];
      privateKeyFile = "/home/fobos/medusawg";
      peers = [
      {
        publicKey = "CTeiSpj47ioFxSFTe9nVk0dZXLmoLpGxRWbwZ3wWXgk=";
        allowedIPs = [ "0.0.0.0/0" "::/0" ];
        endpoint = "65.21.153.166:51820";
        persistentKeepalive = 25;
      }
      ];
    };
  };
  services.ollama = {
    enable = false;
    acceleration = "cuda";
  };
}

