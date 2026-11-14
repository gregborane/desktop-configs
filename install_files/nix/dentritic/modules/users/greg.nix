{ config, ... }: {
  flake.modules.nixos.greg = { pkgs, ... }: {
    users.users.greg = {
      isNormalUser = true;

      extraGroups = [
        "networkmanager"
        "wheel"
        "rfkill"
        "audio"
        "pipewire"
        "video"
        "render"
      ];

      packages = with pkgs; [
        tree
      ];
    };
  };

  flake.modules.homeManager.greg = {
    imports = with config.flake.modules.homeManager; [
      sway
      noctalia
      zapfast
      serein
      zotero
      neovim
      bash
      git
      ghostty
      thunar
      wine
      ns
      cli-packages
      tui-packages
      desktop-packages
      gui-packages
      development-packages
    ];
    home.username = "greg";
    home.homeDirectory = "/home/greg";
    home.stateVersion = "26.05";
    programs.git.settings.user = {
      name = "gregborane";
      email = "madaradellac@gmail.com";
    };
  };
}
