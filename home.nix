{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "fobos";
  home.homeDirectory = "/home/fobos";

  # Packages that should be installed to the user profile.
  #home.packages = [
  #];

  #home.stateVersion = "unstable";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
