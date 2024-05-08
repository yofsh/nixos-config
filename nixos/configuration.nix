{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    # Desktop apps
    firefox
(google-chrome.override {
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
      ];
    })
    foot
    #TODO: walker
    anyrun
    mpv
    swayimg

    orca-slicer

    # Coding stuff
    gnumake
    gcc
    nodejs
    yarn

    #TUI utils
    htop
    glances
    kmon
    sysz
    bluetuith
    lazygit
    lazydocker
    ncdu
    diskonaut
    mtr
    powertop
    nvtop
    zellij
    s-tui
    pulsemixer
    lnav
    yazi
    gping

    # CLI utils
    neofetch
    file
    tree
    wget
    git
    grc
    nix-index
    nix-inspect
    nh

    hyperfine
    ripgrep
    fd
    bc
    jq
    qrencode
    zoxide
    fzf
    exiftool
    lshw
    pngquant
    proxmark3
    rbw
    smartmontools
    wev
    zbar

    bluez
    bluez-tools
    udiskie

    ffmpeg
    light
    ntfs3g
    yt-dlp

    # GUI utils
    zsh
    starship

    # Wayland stuff
    xwayland
    wl-clipboard
    # cliphist ?

    # WMs and stuff
    pyprland
    hyprpicker
    hyprcursor
    hyprlock
    hypridle
    hyprpaper
    brightnessctl

    # seatd
    xdg-desktop-portal-hyprland
    dunst
    waybar
    gammastep

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

    neovim

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
    # noto-fonts-emoji-blob-bin
    twemoji-color-font
    font-awesome
    powerline-fonts
    powerline-symbols
    (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
  ];

  networking.hostName = "laptop";
  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = ["nix-command" "flakes"]; # Enabling flakes

  system.stateVersion = "23.05"; # Don't change it bro

  virtualisation.docker.enable = true;
  programs.virt-manager = {
    enable = true;
  };
  services.asusd.enable = true;
  services.upower.enable = true;

  programs.noisetorch.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting = {
        enable = true;
        patterns = {"rm -rf *" = "fg=black,bg=red";};
        styles = {"alias" = "fg=magenta";};
        highlighters = ["main" "brackets" "pattern"];
      };

    autosuggestions.enable = true;
    };

  programs.firefox.enable = true;

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

  programs.starship.enable = true;
  programs.starship.settings = {
    add_newline = false;
    format = "$directory$character";
    right_format = "$all";
    character = {
      success_symbol = "[>](bold green)";
    };
    cmd_duration = {
      min_time = 100;
      show_milliseconds = true;
    };
    directory = {
      truncation_length = 5;
    };
  };

  users = {
    defaultUserShell = pkgs.zsh;

    users.fobos = {
      isNormalUser = true;
      description = "fobos";
      extraGroups = ["networkmanager" "wheel" "input" "libvirtd" "docker"];
      packages = with pkgs; [];
    };
  };

  services.getty.autologinUser = "fobos";

  #boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1;
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 0;
  boot.kernelParams = ["quiet" "udev.log_level=0" "amdgpu"];
  boot.plymouth = {
    enable = true;
  };

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
  networking.networkmanager.enable = true;

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
  services.fprintd = {
    enable = true;
  };
}
