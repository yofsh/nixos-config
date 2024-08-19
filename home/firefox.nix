{ inputs, pkgs, system, username, config, ... }:
let
  username = "fobos";
in
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      cfg = {
        enableTridactylNative = true;
      };
    };
    profiles.${username} = {
      name = "${username}";
       settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.aboutConfig.showWarning" = false;
      };
      isDefault = true;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        sponsorblock
        return-youtube-dislikes
        sidebery
        tridactyl
      ];
      search = {
        engines = {
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
            "NixOS Wiki" = {
              urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@nw" ];
            };
            "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
          };
        default = "Google";
      };
      bookmarks = [
        {
          toolbar = true;
          bookmarks = [
            {
              name = "Nix sites";
              bookmarks = [
                {
                  name = "homepage";
                  url = "https://nixos.org/";
                }
                {
                  name = "wiki";
                  tags = [ "wiki" "nix" ];
                  url = "https://nixos.wiki/";
                }
            ];
            }
            {
              name = "Homelab";
              bookmarks = [
              {
                name = "Plex";
                url = "http://srv-prod-nas.home.USER_NAMEkiss.net:32400/web/index.html#!";
              }
              {
                name = "Proxmox";
                url = "https://srv-prod-proxmox.home.USER_NAMEkiss.net:8006/#v1:0:18:4:::::::";
              }
              {
                name = "Home Assistant";
                url = "http://srv-prod-hac.home.USER_NAMEkiss.net:8123/lovelace/HPCA";
              }
              {
                name = "Router";
                url = "https://router.home.USER_NAMEkiss.net/network/default/dashboard";
              }
               {
                name = "Docker";
                url = "http://srv-prod-docker.home.USER_NAMEkiss.net:9000";
              }
             {
                name = "NAS";
                url = "https://srv-prod-nas.home.USER_NAMEkiss.net/ui/dashboard";
              }
             {
                name = "";
                url = "";
              }


              ];
            }
            {
              name = "Learn Rust";
              bookmarks = [
              {
                name = "Comprehensive Rust";
                url = "https://google.github.io/comprehensive-rust";
              }
              {
                name = "The Book";
                url = "https://doc.rust-lang.org/book/";
              }
              ];
            }
            {
              name = "Github Links";
              bookmarks = [
              {
                name = "Home";
                url = "https://github.USER_NAMEkiss.net/";
              }
              {
                name = "Advent of Code";
                url = "https://github.com/HirschBerge/AdventOfCode";
              }
              {
                name = "Anilyzer";
                url = "https://github.com/HirschBerge/anilyzer";
              }
              {
                name = "Dots";
                url = "https://github.com/HirschBerge/.dotfiles";
              }
              {
                name = "Scripts";
                url = "https://github.com/HirschBerge/Scripts";
              }
              ];
            }
            {
              name = "Pathfinder";
              bookmarks = [
                {
                  name = "Dominion";
                  url = "https://docs.google.com/spreadsheets/d/1nNXydoOHAUUW18FTjk4O5QZnyipzyVkQ5rm2V-5bUaE/edit?pli=1";
                }
                {
                  name = "Pathbuilder2E";
                  # toolbar = true;
                  url = "https://pathbuilder2e.com/app.html?v=71a";
                }
                {
                  name = "Roll20";
                  url = "https://app.roll20.net/campaigns/search/";
                }
                {
                  name = "Mark's Books";
                  url = "https://drive.google.com/drive/folders/1uce9hs9MrRcIZebNvdQbvYLi-6vbkV9m";
                }
              ];
            }
            {
              name = "All Anime";
              # toolbar = true;
              url = "https://allmanga.to/search-anime?tr=sub&cty=ALL";
            }
            {
              name = "YouTube";
              url = "https://youtube.com";
            }
            {
              name = "AniWave";
              # toolbar = true;
              url = "https://aniwave.to/home";
            }
            {
              name = "ProtonDB";
              url = "https://www.protondb.com/";
            }
            {
              name = "CMU Workday";
              url = "https://wd5.myworkday.com/cmu/d/home.htmld";
            }
          ];
        }
      ];
      userChrome = ''
@namespace "http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul";

/* Hide close button on tabs */
#tabbrowser-tabs .tabbrowser-tab .tab-close-button {
  display: none !important; 
}
.notification-anchor-icon {
  padding: 2px !important;
}
#TabsToolbar,
.tabbrowser-tab {
  max-height: 20px !important;
  font-size: 14px;
  font-weight: 600;
  letter-spacing: -0.7px;
}
#titlebar {
  --tab-min-height: 20px !important;
  --proton-tab-block-margin: 0px !important;
}
.tab-background {
  margin-block: 0px !important;
}
toolbarbutton {
  --toolbarbutton-inner-padding: 1px 1px !important;
}

/* Change color of normal tabs */
tab:not([selected="true"]) {
  background-color: #000000 !important;
  color: #666666 !important;
  border: none;
}
.tabbrowser-tab:not([pinned]) { 
/*   max-width: 150px !important;  */
}

/* Firefox account button */
#fxa-toolbar-menu-button {
/*   display: none; */
}

/* Empty space before and after the url bar */
#customizableui-special-spring1,
#customizableui-special-spring2 {
  display: none;
}
/* style navbar */
#nav-bar,
#navigator-toolbox {
  border-width: 0 !important;
}

/* style urlbar */
#urlbar-container {
  --urlbar-container-height: 20px !important;
  margin-left: 0 !important;
  margin-right: 0 !important;
  padding-top: 0 !important;
  padding-bottom: 0 !important;
  font-size: 14px;
}
#urlbar {
  --urlbar-height: 20px !important;
  --urlbar-toolbar-height: 20px !important;
  min-height: 20px !important;
}
.urlbar-page-action {
  padding: 0 !important;
  width: 20px !important;
  height: 16px !important;
}
#urlbar-zoom-button {
  font-size: 12px !important;
  padding: 0px 7px !important;
  margin-block: 1px !important;
}
.tab-secondary-label {
  position: absolute;
  padding: 2px 7px;
  background: rgb(27, 110, 4);
  top: 5px;
  left: 5px;
  width: 20px;
  overflow: hidden;
  font-size: 9px;
  letter-spacing: 10px;
  border-radius: 5px;
  color: white;
}

      '';
    };
  };
}
