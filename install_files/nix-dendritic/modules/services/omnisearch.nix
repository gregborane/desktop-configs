{ inputs, ... }: {
  flake.modules.nixos.omnisearch =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.omnisearch.nixosModules.default ];
      in {
      import = modules;
      services.omnisearch = {
        enable = true;
        };
      };
    };
}
