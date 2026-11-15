{
  flake.modules.nixos.thunar = { pkgs, ... }: {
    users.users.greg.packages = with pkgs; [
      (thunar.override {
        thunarPlugins = [
          thunar-archive-plugin
          thunar-volman
        ];
      })
    ];
  };
}
