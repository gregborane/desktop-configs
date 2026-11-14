{
  flake.modules.homeManager.ghostty = { pkgs, ... }: {
    xdg.terminal-exec = {
      enable = true;
      settings = {
        default = [
          "com.michelly.ghostty"
        ];
      };
    };
    home.packages = with pkgs; [
      ghostty
    ];
  };
}
