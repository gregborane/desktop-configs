{ config, pkgs, ... }:

{
  home.username = "greg";
  home.homeDirectory = "/home/greg";
  home.stateVersion = "25.05";
  programs.git.enable = true;
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
    };
  };
}
