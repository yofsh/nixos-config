{ inputs, config, pkgs, lib, ... }:
let
  link = config.lib.file.mkOutOfStoreSymlink;
  dotfiles = "${config.home.homeDirectory}/dotfiles";
in {

  home.stateVersion = "24.05";

  imports = [
    ./xdg.nix
    ./firefox.nix
  ];

  home.activation.setupDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    echo "=QQQQQQQQ= Running pre activation script"
    if [[ ! -d "$HOME/dotfiles" ]]; then
      ${pkgs.git}/git clone git@github.com:yofsh/dotfiles.git "$HOME/dotfiles"
      ${pkgs.networkmanager}/bin/nmcli dev wifi connect "a" password "b"
    fi
  '';

  home.username = "fobos";
  home.homeDirectory = "/home/fobos";

  # Packages that should be installed to the user profile.
  home.packages = [ pkgs.libnotify pkgs.alejandra pkgs.playerctl ];


  programs.home-manager.enable = true;

  xdg.enable = true;

  services.dunst.enable = true;

  services.udiskie.enable = true;
  services.udiskie.automount = true;
  services.udiskie.notify = true;
  services.udiskie.tray = "always";

  # programs.ags = {
  #   enable = true;
  #   extraPackages = with pkgs; [ gtksourceview webkitgtk accountsservice ];
  # };

  services.playerctld.enable = true;

  programs.git = {
    enable = true;
    userName = "Oleksandr Yaroshenko";
    userEmail = "to@yof.sh";
    signing = {
      key = "1B6E67640066F4B3";
      signByDefault = false;
    };
  };

  xdg.configFile = {
    "foot/foot.ini".source = link "${dotfiles}/foot/foot.ini";
    "dunst/dunstrc".source = link "${dotfiles}/dunst/dunstrc";
    "tridactyl/tridactylrc".source = link "${dotfiles}/firefox/tridactylrc";
    "nvim".source = link "${dotfiles}/nvim";
    "walker".source = link "${dotfiles}/walker";
    "yazi".source = link "${dotfiles}/yazi";
    "hypr".source = link "${dotfiles}/hypr";
    "waybar".source = link "${dotfiles}/waybar";
  };

  home.file = {
    ".config/testfile".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/testfile";
    ".zshrc".source = link "${dotfiles}/.zshrc";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
  };

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 32;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };

    font = {
      name = "Sans";
      size = 11;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

}
