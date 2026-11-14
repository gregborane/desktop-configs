{
  flake.modules.nixos.git = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      git
    ];
  };

  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;
      lfs.enable = true;

    };
  };
}
