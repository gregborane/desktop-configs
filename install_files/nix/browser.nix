
{ pkgs, lib, ... }:

let
  bookmarks = [
    {
      name = "YouTube";
      type = "url";
      url = "https://www.youtube.com";
    }
    {
      name = "llm";
      type = "folder";
      children = [
        {
          name = "ChatGPT";
          type = "url";
          url = "https://chatgpt.com";
        }
        {
          name = "NotebookLM";
          type = "url";
          url = "https://notebooklm.google.com";
        }
        {
          name = "ResearchRabbit";
          type = "url";
          url = "https://app.researchrabbit.ai";
        }
      ];
    }
    {
      name = "local";
      type = "folder";
      children = [
        {
          name = "Downloads";
          type = "url";
          url = "file:///home/greg/Downloads/";
        }
        {
          name = "Documents";
          type = "url";
          url = "file:///home/greg/Documents/";
        }
        {
          name = "PhD";
          type = "url";
          url = "file:///home/greg/Documents/PhD/";
        }
      ];
    }
    {
      name = "school";
      type = "folder";
      children = [
        {
          name = "Moodle PolyMTL";
          type = "url";
          url = "https://moodle.polymtl.ca";
        }
        {
          name = "CADET-Core";
          type = "url";
          url = "https://cadet.github.io";
        }
        {
          name = "Dossier étudiant PolyMTL";
          type = "url";
          url = "https://dossieretudiant.polymtl.ca";
        }
      ];
    }
    {
      name = "Journals";
      type = "folder";
      children = [
        {
            name = "Web of Science";
            type = "url";
            url = "https://www.webofscience.com/wos/woscc/smart-search";
        }
        {
            name = "Sci Finder";
            type = "url";
            url = "archlinux.org";
        }
        {
            name = "Sci Hub";
            type = "url";
            url = "archlinux.org";
        }
      ];
    }
  ];

  renderBookmark = item:
    if item.type == "folder" then ''
      <DT><H3>${item.name}</H3>
      <DL><p>
      ${lib.concatMapStringsSep "\n" renderBookmark item.children}
      </DL><p>
    ''
    else ''
      <DT><A HREF="${item.url}">${item.name}</A>
    '';

in
{
  environment.systemPackages = [
    pkgs.ungoogled-chromium
  ];

  # Importable bookmarks for existing profiles
  environment.etc."chromium/bookmarks-import.html".text = ''
    <!DOCTYPE NETSCAPE-Bookmark-file-1>
    <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
    <TITLE>Bookmarks</TITLE>
    <H1>Bookmarks</H1>
    <DL><p>
      <DT><H3 PERSONAL_TOOLBAR_FOLDER="true">Bookmarks bar</H3>
      <DL><p>
      ${lib.concatMapStringsSep "\n" renderBookmark bookmarks}
      </DL><p>
    </DL><p>
  '';

  programs.chromium = {
    enable = true;

    homepageLocation = "http://127.0.0.1:8087/";

    defaultSearchProviderEnabled = true;
    defaultSearchProviderSearchURL =
      "http://127.0.0.1:8087/search?q={searchTerms}";

    extraOpts = {
      DefaultSearchProviderName = "Local Search";
      ShowHomeButton = true;
      BookmarkBarEnabled = true;
    };

    initialPrefs = {
      vertical_tabs = {
        enabled = true;
        expand_on_hover = true;
      };

      # Place items directly on the bookmarks bar
      # when creating a new Chromium profile.
      bookmarks.first_run_bookmarks.children = bookmarks;
    };
  };
}

