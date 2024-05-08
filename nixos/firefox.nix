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
.urlbarView-row {
  min-height: 12px !important;
}

#webrtcIndicator {
  display: none;
}

.urlbarView-row-inner {
  padding-block: 0 !important;
  min-height: 12px !important;
}
.tabbrowser-tab:not([pinned]) { max-width: 150px !important; }

/* .tab-secondary-label{ */
/*   font-size: 15px !important; */
/*   opacity: 0.8 !important; */
/*   position: absolute !important; */
/*   top: 1px !important; */
/*   right: 20px !important; */
/*   display: block !important; */
/*   font-weight: bolder !important; */
/*   width: 11px !important; */
/*   overflow: hidden !important; */
/*   z-index: 9999 !important; */
/*   background: #7b0000 !important; */
/*   font-family: Noto Sans Mono !important; */
/*   padding: 0 1px !important; */
/*   opacity: 1 !important; */
/* } */

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
  font-size: 12px;
}

#titlebar {
  --tab-min-height: 20px !important;
  --proton-tab-block-margin: 0px !important;
}

.tab-background {
  margin-block: 0px !important;
}

.tab-context-line {
  margin: 0 !important;
  height: 22px !important;
  border-radius: 0 !important;
  opacity: 0.3 !important;
}

toolbarbutton {
  --toolbarbutton-inner-padding: 1px 1px !important;
}

/* Hide window controls on fullscreen */
#window-controls {
  display: none;
}

/* Change color of normal tabs */

tab:not([selected="true"]) {
  background-color: #000000 !important;
  color: #666666 !important;
  border: none;
}

/* tab font */
/* tab { font-family: 'Jetbrains Mono', monospace; border: none; } */

/* safari style tab width */
.tabbrowser-tab[fadein] {
  /* max-width: 100vw !important; */
  border: none;
}

.tabbrowser-tab:not([pinned]) { max-width: 150px !important; }

/* hide nav bar */
/* #nav-bar { visibility: collapse; } */

/* debloat navbar */

#back-button {
  /* display: none; */
}

#forward-button {
  display: none;
}

#reload-button {
  display: none;
}

#stop-button {
  /* display: none; */
}

#home-button {
  display: none;
}

#downloads-button {
  /* display: none; */
}

#library-button {
  display: none;
}

#sidebar-button {
  display: none;
}

/* Firefox account button */
#fxa-toolbar-menu-button {
  display: none;
}

#nav-bar-overflow-button {
  display: none !important;
}

/* General Firefox menu button */
/* #PanelUI-button { display: none; } */

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

/* end debloat navbar */

/* remove megabar */
/* https://github.com/WesleyBranton/Remove-Firefox-Megabar/blob/master/remove_megabar.css */

/* REMOVE MEGABAR START
   * VERSION 1.0.4
   * CODE AT: http://userchrome.wesleybranton.com/megabar
   * RELEASE NOTES: http://userchrome.wesleybranton.com/notes/megabar */
@-moz-document url(chrome://browser/content/browser.xhtml)
{
  /* DISABLE EXPANDING START */
  #urlbar[breakout][breakout-extend] {
    top: calc(
      (var(--urlbar-toolbar-height) - var(--urlbar-height)) / 2
    ) !important;
    left: 0 !important;
    width: 100% !important;
  }

  #urlbar[breakout][breakout-extend] > #urlbar-input-container {
    height: var(--urlbar-height) !important;
    padding-block: 0 !important;
    padding-inline: 0 !important;
  }
  /* DISABLE EXPANDING END */
}
/* REMOVE MEGABAR END */

/*  */

/* style urlbar */
#urlbar-container {
  --urlbar-container-height: 20px !important;
  margin-left: 0 !important;
  margin-right: 0 !important;
  padding-top: 0 !important;
  padding-bottom: 0 !important;
  font-size: 12px;
}

#urlbar {
  --urlbar-height: 20px !important;
  --urlbar-toolbar-height: 20px !important;
  min-height: 20px !important;
}

#urlbar[focused="true"] > #urlbar-background {
  /* outline: 1px solid gray !important; */
  outline: none !important;
}

#urlbar-background {
  border-width: 0 !important;
  border-radius: 0 !important;
}

#urlbar-input-container {
  border-width: 0 !important;
  margin-left: 1px !important;
}

#urlbar-input {
  margin-left: 0.4em !important;
  margin-right: 0.4em !important;
}

.urlbarView-row {
  padding-top: 0 !important;
  padding-bottom: 0 !important;
  line-height: var(--urlbar-height) !important;
}

.urlbarView-row-inner {
  padding-top: 0.3em !important;
  padding-bottom: 0.3em !important;
  height: var(--urlbar-height) !important;
}

.urlbarView-favicon {
  height: 1em !important;
  width: 1em !important;
  margin-bottom: 0.2em !important;
}

/* debloat urlbar */
#tracking-protection-icon-container {
  display: none;
}

.sharing-icon,
#identity-icon,
.urlbar-icon,
#permissions-granted-icon,
#tracking-protection-icon,
#blocked-permissions-container > .blocked-permission-icon {
  width: 16px !important;
  height: 16px !important;
}

#page-action-buttons {
  margin-right: 15px !important;
}

.urlbar-page-action {
  padding: 0 !important;
  width: 20px !important;
  display: flex;
  justify-content: center;
  height: 16px !important;
}
/* #identity-box { display: none; } */

/* #reader-mode-button { */
/*   display: none; */
/* } */

/* #pageActionButton { */
/*   display: none; */
/* } */

#pocket-button {
  display: none;
}

/* #star-button { */
/*   display: none; */
/* } */

#urlbar-zoom-button {
  font-size: 12px !important;
  padding: 0px 7px !important;
  margin-block: 1px !important;
}

/* Go to arrow button at the end of the urlbar when searching */
#urlbar-go-button {
  display: none;
}

/* Bottom left page loading status or url preview */
/* #statuspanel { display: none !important; } */
/* end debloat urlbar */

/* remove min-height from tabs toolbar (needed for fullscreen one tab) */
#TabsToolbar,
#tabbrowser-tabs,
#tabbrowser-tabs > .tabbrowser-arrowscrollbox,
#tabbrowser-arrowscrollbox {
  min-height: 0 !important;
}

/* remove white margin around active tabs */
#tabbrowser-tabs:not([movingtab])
  > #tabbrowser-arrowscrollbox
  > .tabbrowser-tab[beforeselected-visible]::after,
#tabbrowser-tabs[movingtab]
  > #tabbrowser-arrowscrollbox
  > .tabbrowser-tab[visuallyselected]::before,
.tabbrowser-tab[visuallyselected]::after {
  border: none !important;
}

/*AGENT_SHEET*/
#main-window #navigator-toolbox #TabsToolbar:not(:-moz-lwtheme) {
  /* background: #285577 !important; */
}

/* show favicon if tab is pinned */
.tabbrowser-tab[pinned] .tab-icon-image {
  display: inline !important;
}

.tab-icon-overlay {
  opacity: 1 !important;
  background: black ;
}

/* hide window controls */
.titlebar-buttonbox-container {
  display: none;
}

.toolbarbutton-badge-stack > .toolbarbutton-badge {
  position: absolute;
  top: 5px;
}
      '';
    };
  };
}
