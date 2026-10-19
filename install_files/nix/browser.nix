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

    extraOpts = {
      DefaultSearchProviderName = "Local Search";
      ShowHomeButton = true;
    };

    initialPrefs = {
      vertical_tabs = {
        enabled = true;
        expand_on_hover = true;
      };
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
