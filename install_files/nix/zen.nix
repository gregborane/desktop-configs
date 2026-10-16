# Home Manager module for github:0xc000022070/zen-browser-flake.
# Import this file from install_files/nix/home.nix.
{ config, inputs, ... }:

let
  # Firefox enterprise policy: automatically install an AMO extension.
  extension = id: {
    name = id;
    value = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
      # Install automatically and prevent disabling/removal.
      installation_mode = "force_installed";
    };
  };

  bookmark = name: url: { inherit name url; };
  folder = name: bookmarks: { inherit name bookmarks; };
  localFolder = name: relativePath:
    bookmark name "file://${config.home.homeDirectory}/${relativePath}/";
in
{
  # Use twilight instead of beta here if you prefer the reproducible channel.
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

    # Firefox enterprise policies also work with Zen.
    policies = {
      DisableAppUpdate = true; # Nix owns application updates.
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisableFeedbackCommands = true;
      DisablePocket = true;
      DontCheckDefaultBrowser = true;

      ExtensionSettings = builtins.listToAttrs [
        (extension "sponsorBlocker@ajay.app")
        (extension "uBlock0@raymondhill.net")
        (extension "{34daeb50-c2d2-4f14-886a-7160b24d66a4}")
      ];

      # Lock toolbar visibility and telemetry preferences.
      Preferences = {
        "browser.toolbars.bookmarks.visibility" = { Value = "always"; Status = "locked"; };
        "toolkit.telemetry.enabled" = { Value = false; Status = "locked"; };
        "toolkit.telemetry.unified" = { Value = false; Status = "locked"; };
        "toolkit.telemetry.archive.enabled" = { Value = false; Status = "locked"; };
        "datareporting.healthreport.uploadEnabled" = { Value = false; Status = "locked"; };
        "datareporting.policy.dataSubmissionEnabled" = { Value = false; Status = "locked"; };
        "app.shield.optoutstudies.enabled" = { Value = false; Status = "locked"; };
        "browser.ping-centre.telemetry" = { Value = false; Status = "locked"; };
        "browser.newtabpage.activity-stream.telemetry" = { Value = false; Status = "locked"; };
        "browser.newtabpage.activity-stream.feeds.telemetry" = { Value = false; Status = "locked"; };
      };
    };

    profiles.default = {
      isDefault = true;

      settings = {
        # Keep the top toolbar accessible in Zen's single-toolbar layout.
        "zen.view.hide-window-controls" = false;
        "zen.view.experimental-no-window-controls" = false;
        "extensions.autoDisableScopes" = 0;
        "extensions.pocket.enabled" = false;
        "browser.discovery.enabled" = false;
      };

      search = {
        # Force makes the declared engine the default on each activation.
        force = true;
        default = "local-search";
        privateDefault = "local-search";
        engines.local-search = {
          name = "Local Search";
          urls = [{
            template = "http://127.0.0.1:8087/search?q={searchTerms}";
          }];
          definedAliases = [ "@local" ];
        };
      };

      bookmarks = {
        # Declarative bookmark set; browser changes won't be preserved
        # if Home Manager reapplies this forced configuration.
        force = true;
        settings = [{
          name = "Bookmarks Toolbar";
          toolbar = true;
          bookmarks = [
            (bookmark "YouTube" "https://www.youtube.com/")

            (folder "science-search" [
              (bookmark "ChatGPT" "https://chatgpt.com/")
              (bookmark "NotebookLM" "https://notebooklm.google.com/")
              (bookmark "Gemini" "https://gemini.google.com/")
              (bookmark "ResearchRabbit" "https://app.researchrabbit.ai/")
            ])

            (folder "ecole" [
              (bookmark "Cadet Core" "https://cadet.github.io/v5.1.X/index.html")
              (bookmark "Dossier etudiant - Polytechnique Montreal" "https://dossieretudiant.polymtl.ca/")
              (bookmark "Accueil Moodle - Polytechnique Montreal" "https://moodle.polymtl.ca/")
            ])

            (folder "file" [
              (localFolder "Downloads" "Downloads")
              (localFolder "Documents" "Documents")
              (localFolder "PhD" "Documents/PhD")
            ])
          ];
        }];
      };
    };
  };
}
