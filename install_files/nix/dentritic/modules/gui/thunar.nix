{
  flake.modules.homeManager.thunar = { pkgs, ... }: {
    home.packages = with pkgs; [
      (thunar.override {
        thunarPlugins = [
          thunar-archive-plugin
          thunar-volman
        ];
      })
    ];
  };
}
