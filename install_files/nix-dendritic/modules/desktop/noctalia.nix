{ inputs, ... }: {
  flake.modules.nixos.noctalia =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      assets = ../../../../config/noctalia;
      settings = assets + "/noctalia-full-config.toml";
    in
    {
      imports = [ inputs.noctalia.nixosModules.default ];
      programs.noctalia = {
        enable = true;
        systemd.enable = true;
      };
      environment.etc = {
        "xdg/noctalia/config.toml".source = pkgs.runCommand "noctalia-config.toml" { } ''
          ${lib.getExe config.programs.noctalia.package} config validate ${settings}
          cp ${settings} "$out"
        '';
        "xdg/noctalia/plugins".source = assets + "/plugins";
        "xdg/noctalia/palettes".source = assets + "/palettes";
      };
      environment.sessionVariables.NOCTALIA_CONFIG_HOME = "/etc/xdg";
      systemd.user.services.noctalia = {
        environment.NOCTALIA_CONFIG_HOME = "/etc/xdg";
        restartTriggers = [ config.environment.etc."xdg/noctalia/config.toml".source ];
        unitConfig.ConditionUser = "greg";
      };
    };
}
