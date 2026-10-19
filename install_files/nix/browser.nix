
{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.ungoogled-chromium
  ];

  programs.chromium = {
    enable = true;

    homepageLocation = "http://127.0.0.1:8087/";

    defaultSearchProviderEnabled = true;
    defaultSearchProviderSearchURL =
      "http://127.0.0.1:8087/search?q={searchTerms}";

    initialPrefs = {
      vertical_tabs = {
        enabled = true;
        expand_on_hover = true;
      };
    };

    extraOpts = {
      DefaultSearchProviderName = "Local Search";
      ShowHomeButton = true;
      BookmarkBarEnabled = true;

      ManagedBookmarks = [
        {
          toplevel_name = "Bookmarks";
        }

        {
          name = "YouTube";
          url = "https://www.youtube.com";
        }

        {
          name = "llm";
          children = [
            {
              name = "ChatGPT";
              url = "https://chatgpt.com";
            }
            {
              name = "NotebookLM";
              url = "https://notebooklm.google.com";
            }
            {
              name = "ResearchRabbit";
              url = "https://app.researchrabbit.ai";
            }
          ];
        }

        {
          name = "local";
          children = [
            {
              name = "Downloads";
              url = "file:///home/greg/Downloads/";
            }
            {
              name = "Documents";
              url = "file:///home/greg/Documents/";
            }
            {
              name = "PhD";
              url = "file:///home/greg/Documents/PhD/";
            }
          ];
        }

        {
          name = "school";
          children = [
            {
              name = "Moodle PolyMTL";
              url = "https://moodle.polymtl.ca";
            }
            {
              name = "CADET-Core";
              url = "https://cadet.github.io";
            }
            {
              name = "Dossier étudiant PolyMTL";
              url = "https://dossieretudiant.polymtl.ca";
            }
          ];
        }
      ];
    };

    extensions = [
      # Dark Reader
      "eimadpbcbfnmbkopoojfekhnkhdbieeh;https://clients2.google.com/service/update2/crx"

      # Google Translate
      "aapbdbdomjkkjkaonfhkkikfgjllcleb;https://clients2.google.com/service/update2/crx"

      # uBlock Origin
      "cjpalhdlnbpafiamejdnhcphjbkeiagm;https://clients2.google.com/service/update2/crx"

      # SponsorBlock
      "mnjggcdmjocbbbhaepdhchncahnbgone;https://clients2.google.com/service/update2/crx"

      # YouTube Shorts Block
      "jiaopdjbehhjgokpphdfgmapkobbnmjp;https://clients2.google.com/service/update2/crx"
    ];
  };
}

