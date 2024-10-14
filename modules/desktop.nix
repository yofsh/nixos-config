{ config, lib, pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    (google-chrome.override {
      commandLineArgs =
        [ "--enable-features=UseOzonePlatform" "--ozone-platform=wayland" ];
    })

    #GUI tools
    obsidian
    foot
    mpv
    imv
    krita
    orca-slicer
    yubikey-personalization
    godot_4

    #TUI utils
    bluetuith
    powertop
    nvtop

    # CLI utils
    gnupg
    proxmark3
    rbw
    bluez
    bluez-tools
    udiskie
    socat
    libqalculate
    tesseract
    bat

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
    xdg-utils
    wdisplays
    dunst
    waybar
    gammastep
    geoclue2
    walker

    xwayland
    wl-clipboard
    wtype
    wev

    # Sound
    pipewire
    pulseaudio
    ncpamixer
    usbutils

    # Screen capture
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
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];

  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "24.05";

  security.polkit = { enable = true; };
  services.fstrim.enable = true;
  security.rtkit.enable = true;

  # Virtualisation
  # virtualisation.docker.enable = true;
  # programs.virt-manager = { enable = true; };

  # Software
  programs.noisetorch.enable = true;
  services.upower.enable = true;

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  programs.firefox.enable = true;
  programs.firefox.policies = {
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
      "ui.key.menuAccessKeyFocuses" = {
        Status = "locked";
        Value = false;
      };
    };
  };

  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
  environment.sessionVariables.BROWSER = "firefox";
  environment.sessionVariables.EDITOR = "nvim";

  services.getty.autologinUser = lib.mkForce "fobos";

  networking.wireless.enable = lib.mkForce false;
  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.timeout = lib.mkForce 1;

  # Graphics
hardware.graphics = {
  enable = true;
  enable32Bit = true;
};


  # Wireless
  services.blueman.enable = true;
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

  # Sound
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  services.pipewire.wireplumber.configPackages = [
    (pkgs.writeTextDir
      "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
        bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
        }
      '')
  ];

  # Network
  networking.wg-quick.interfaces = {
    medusaWG = {
      autostart = false;
      address = [ "10.100.0.2" ];
      dns = [ "1.1.1.1" ];
      privateKeyFile = "/home/fobos/medusawg";
      peers = [{
        publicKey = "CTeiSpj47ioFxSFTe9nVk0dZXLmoLpGxRWbwZ3wWXgk=";
        allowedIPs = [ "0.0.0.0/0" "::/0" ];
        endpoint = "65.21.153.166:51820";
        persistentKeepalive = 25;
      }];
    };
  };

}

