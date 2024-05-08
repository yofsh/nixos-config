{
  config,
  pkgs,
  ...
}: let
  link = config.lib.file.mkOutOfStoreSymlink;
  dotfiles = "${config.home.homeDirectory}/dotfiles";
in {

	imports = [
    ./xdg.nix
    ./nixos/firefox.nix
  ];

  home.username = "fobos";
  home.homeDirectory = "/home/fobos";

  # Packages that should be installed to the user profile.
  home.packages = [
    pkgs.libnotify
    pkgs.alejandra
  ];

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  xdg.enable = true;

  services.dunst.enable = true;

  xdg.configFile = {
    "hypr/hyprland.conf".source = link "${dotfiles}/hypr/hyprland.conf";
    "hypr/hyprlock.conf".source = link "${dotfiles}/hypr/hyprlock.conf";
    "foot/foot.ini".source = link "${dotfiles}/foot/foot.ini";
    "waybar/config".source = link "${dotfiles}/waybar/config";
    "waybar/style.css".source = link "${dotfiles}/waybar/style.css";
    "dunst/dunstrc".source = link "${dotfiles}/dunst/dunstrc";
    "tridactyl/tridactylrc".source = link "${dotfiles}/firefox/tridactylrc";
  };

  home.file = {
    ".config/testfile".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/testfile";
    ".zshrc".source = link "${dotfiles}/.zshrc";
  };

  home.sessionVariables = {
    TEST = "qwe";
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
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
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
}
