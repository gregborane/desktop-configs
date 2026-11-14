{ inputs, ... }: {
  flake.modules.homeManager.noctalia = {
    imports = [ inputs.noctalia.homeModules.default ];
    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      settings = ../../../../../config/noctalia/noctalia-full-config.toml;
    };
  };
}
