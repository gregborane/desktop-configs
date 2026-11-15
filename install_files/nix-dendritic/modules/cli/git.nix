{
  flake.modules.nixos.git = { pkgs, ... }: {
    programs.git = {
      enable = true;
      lfs.enable = true;
      config.include.path = "~/.gitconfig-xii";
    };
    systemd.tmpfiles.rules = [
      "L+ /home/greg/.gitconfig-xii - - - - ${pkgs.writeText "greg-git-identity" ''
        [user]
            name = gregborane
            email = madaradellac@gmail.com
      ''}"
    ];
  };
}
