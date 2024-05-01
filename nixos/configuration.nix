{ config, lib, pkgs, ... }:
{


  imports =
    [
      ./hardware-configuration.nix
    ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    # Desktop apps
    firefox
    foot
    # walker TODO
    anyrun
    mpv
    swayimg

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

    # CLI utils
    neofetch
    file
    tree
    wget
    git
    grc
    nix-index
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
    hyprland
    hyprpaper
    hyprpicker
    # seatd
    xdg-desktop-portal-hyprland
    dunst
    waybar
    gammastep

    # Sound
    pipewire
    pulseaudio
    ncpamixer

    # GPU stuff 

    # Screenshotting
    grim
    slurp
    satty
    wf-recorder

    neovim

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
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];


  networking.hostName = "laptop";
  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # Enabling flakes

  system.stateVersion = "23.05"; # Don't change it bro

  virtualisation.docker.enable = true;
  programs.virt-manager = {
    enable = true;
  };
  services.asusd.enable = true;

  programs.noisetorch.enable = true;
  programs.zsh.enable = true;
  programs.firefox.enable = true;
  programs.hyprland.enable = true;
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
      extraGroups = [ "networkmanager" "wheel" "input" "libvirtd" "docker" ];
      packages = with pkgs; [];
    };
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "fobos";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];

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

  environment.variables = {
    EDITOR = "nvim";
  };

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

}
