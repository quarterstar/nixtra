{ profile, pkgs, ... }:

{
  programs.librewolf = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;

      preferences = [
        { name = "browser.sessionstore.max_resumed_crashes"; value = 0; } # Disable Session Restore feature
        { name = "cookiebanners.service.mode.privateBrowsing"; value = 2; } # Block cookie banners in private browsing
        { name = "cookiebanners.service.mode"; value = 2; } # Block cookie banners
        { name = "privacy.donottrackheader.enabled"; value = true; }
        { name = "privacy.fingerprintingProtection"; value = true; }
        { name = "privacy.resistFingerprinting"; value = true; }
        { name = "privacy.trackingprotection.emailtracking.enabled"; value = true; }
        { name = "privacy.trackingprotection.enabled"; value = true; }
        { name = "privacy.trackingprotection.fingerprinting.enabled"; value = true; }
        { name = "privacy.trackingprotection.socialtracking.enabled"; value = true; }
      ] ++ (if profile.display.themeType == "dark" then [
        { name = "ui.systemUsesDarkTheme"; value = 1; } # In case of websites not adhering to system theme
      ] else []);

        ExtensionSettings = {
          #"*".installation_mode = "blocked"; # Block all addons except the ones specified below

          # DuckDuckGo
          "jid1-ZAdIEUB7XOzOJw@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/duckduckgo-for-firefox/latest.xpi";
            installation_mode = "force_installed";
          };
          # U-Block Origin
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          # Decentraleyes
          "jid1-BoFifL9Vbdl2zQ@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4392113/decentraleyes-3.0.0.xpi";
            installation_mode = "force_installed";
          };
          # Canvas Blocker
          "CanvasBlocker@kkapsner.de" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4262820/canvasblocker-1.10.1.xpi";
            installation_mode = "force_installed";
          };
          # Ghostery
          "firefox@ghostery.com" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4392896/ghostery-10.4.16.xpi";
            installation_mode = "force_installed";
          };
          # ClearURLS
          "{74145f27-f039-47ce-a470-a662b129930a}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4064884/clearurls-1.26.1.xpi";
            installation_mode = "force_installed";
          };
          # Cookie AutoDelete
          "CookieAutoDelete@kennydo.com" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4040738/cookie_autodelete-3.8.2.xpi";
            installation_mode = "force_installed";
          };
          # Return Youtube Dislike
          "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4371820/return_youtube_dislikes-3.0.0.18.xpi";
            installation_mode = "force_installed";
          };
          # mtab
          "contact@maxhu.dev" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4445472/mtab-1.8.5.xpi";
            installation_mode = "force_installed";
          };
        } // (if profile.display.themeType == "dark" then {
          "addon@darkreader.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4439735/darkreader-4.9.103.xpi";
            installation_mode = "force_installed";
          };
      } else {});
    };
  };
}
