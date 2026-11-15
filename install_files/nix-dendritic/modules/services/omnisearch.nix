{ inputs, ... }: {
  flake.modules.nixos.omnisearch =
    {config, lib, pkgs,... }:
    {
      imports = [ inputs.omnisearch.nixosModules.default ];
      services.omnisearch = {
        enable = true;
      };
    };
}
