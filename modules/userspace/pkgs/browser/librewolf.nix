{ profile, pkgs, ... }:

{
  programs.librewolf = {
    enable = true;
    #package = pkgs.tor-browser;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;

      Preferences = {
        "browser.sessionstore.max_resumed_crashes" =
          0; # Disable Session Restore feature
        "browser.sessionhistory.max_entries" = 10;
        "browser.sessionstore.debug.no_auto_updates" = true;
        "browser.sessionstore.disable_platform_collection" = true;
        "cookiebanners.service.mode.privateBrowsing" =
          2; # Block cookie banners in private browsing
        "cookiebanners.service.mode" = 2; # Block cookie banners
        "privacy.donottrackheader.enabled" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.trackingprotection.emailtracking.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "browser.privatebrowsing.autostart" = true;
        "browser.privatebrowsing.vpnpromourl" = "";
        "network.http.sendRefererHeader" = 0;
        "network.cookie.cookieBehavior" = 2;
        "browser.cache.memory.enable" = false;
        "browser.cache.disk.enable" = false;
        "browser.chrome.site_icons" = false;
        "browser.shell.shortcutFavicons" = false;
        "geo.enabled" = false;
        "media.peerconnection.enabled" = false;
        "services.sync.prefs.sync.media.autoplay.default" = false;
        "messaging-system.rsexperimentloader.enabled" = false;
        "browser.translations.automaticallyPopup" = false;
        "browser.newtabpage.activity-stream.telemetry.structuredIngestion.endpoint" =
          "";
        "toolkit.telemetry.user_characteristics_ping.opt-out" = true;
      } // (if profile.display.themeType == "dark" then {
        "ui.systemUsesDarkTheme" = 1;
      } # In case of websites not adhering to system theme
      else
        { });

      ExtensionSettings = {
        "*" = {
          installation_mode =
            "blocked"; # Block all addons except the ones specified below
          private_browsing =
            true; # Allows extensions specified here to run in private browsing windows, by default
        };

        # DuckDuckGo
        "jid1-ZAdIEUB7XOzOJw@jetpack" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/duckduckgo-for-firefox/latest.xpi";
          installation_mode = "force_installed";
        };
        # U-Block Origin
        "uBlock0@raymondhill.net" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # Decentraleyes
        "jid1-BoFifL9Vbdl2zQ@jetpack" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/decentraleyes/latest.xpi";
          installation_mode = "force_installed";
        };
        # Canvas Blocker
        "CanvasBlocker@kkapsner.de" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/canvasblocker/latest.xpi";
          installation_mode = "force_installed";
        };
        # Ghostery
        "firefox@ghostery.com" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/ghostery/latest.xpi";
          installation_mode = "force_installed";
        };
        # ClearURLS
        "{74145f27-f039-47ce-a470-a662b129930a}" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
          installation_mode = "force_installed";
        };
        # Cookie AutoDelete
        "CookieAutoDelete@kennydo.com" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/cookie_autodelete/latest.xpi";
          installation_mode = "force_installed";
        };
        # Return Youtube Dislike
        "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/return_youtube_dislikes/latest.xpi";
          installation_mode = "force_installed";
        };
        # mtab
        "contact@maxhu.dev" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/mtab/latest.xpi";
          installation_mode = "force_installed";
        };
        "overbitewx@floodgap.com" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/overbitewx/latest.xpi";
          installation_mode = "force_installed";
        };
        # Tridactyl
        "tridactyl.vim@cmcaine.co.uk" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/file/4405615/tridactyl_vim-1.24.2.xpi";
          installation_mode = "force_installed";
        };
        "cookie.block.extension@gmail.com" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/cookieblock/latest.xpi";
          installation_mode = "force_installed";
        };
        "jid1-KKzOGWgsW3Ao4Q@jetpack" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/file/4202634/i_dont_care_about_cookies-3.5.0.xpi";
          installation_mode = "force_installed";
        };
        "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/file/4045009/auto_tab_discard-0.6.7.xpi";
          installation_mode = "force_installed";
        };
        "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/violentmonkey/latest.xpi";
          installation_mode = "force_installed";
        };
      } // (if profile.display.themeType == "dark" then {
        "addon@darkreader.org" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
      } else
        { });
    };

    profiles.default.search = {
      force = true;
      default = "DuckDuckGo Lite";
      privateDefault = "DuckDuckGo Lite";

      engines = {
        "DuckDuckGo Lite" = {
          urls = [{
            template = "https://start.duckduckgo.com/lite?q={searchTerms}";
          }];
        };
      };
    };
  };
}
