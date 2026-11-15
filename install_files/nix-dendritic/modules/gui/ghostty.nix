{
  flake.modules.nixos.ghostty = { pkgs, ... }: {
    xdg.terminal-exec = {
      enable = true;
      settings = {
        default = [
          "com.mitchellh.ghostty.desktop"
        ];
      };
    };
    users.users.greg.packages = with pkgs; [
      ghostty
    ];
  };
}
