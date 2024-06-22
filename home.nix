{
  inputs,
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
    inputs.ags.homeManagerModules.default
  ];

  # home.activation.preActivation.setupDotfiles = pkgs.writeShellScriptBin "setup-dotfiles" ''
  #       if [[ ! -d "$HOME/dotfiles" ]]; then
  #         git clone git@github.com:yofsh/dotfiles.git "$HOME/dotfiles"
  #       fi
  #     '';
  #   };
  # };

  home.username = "fobos";
  home.homeDirectory = "/home/fobos";

  # Packages that should be installed to the user profile.
  home.packages = [
    pkgs.libnotify
    pkgs.alejandra
    pkgs.playerctl
  ];

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  xdg.enable = true;

  services.dunst.enable = true;

  services.udiskie.enable = true;
  services.udiskie.automount = true;
  services.udiskie.notify = true;         
  services.udiskie.tray = "always";         

  programs.ags = {
    enable = true;
    extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
    ];
  };

  services.playerctld.enable = true;

  programs.git = {
  enable = true;
  userName = "Oleksandr Yaroshenko";
  userEmail = "to@yof.sh";
  signing = {
    key = "1B6E67640066F4B3";
    signByDefault = true;
  };
};


  xdg.configFile = {
    "hypr/hyprland.conf".source = link "${dotfiles}/hypr/hyprland.conf";
    "hypr/hyprlock.conf".source = link "${dotfiles}/hypr/hyprlock.conf";
    "hypr/hypridle.conf".source = link "${dotfiles}/hypr/hypridle.conf";
    "hypr/hyprpaper.conf".source = link "${dotfiles}/hypr/hyprpaper.conf";
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
      package = pkgs.paper-icon-theme;
      name = "Paper";
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
