{ inputs, ... }: {
  flake.modules.nixos.omnisearch =
    {config, lib, pkgs,... }:
    {
      imports = [ inputs.omnisearch.nixosModules.default ];
      services.omnisearch = {
        enable = true;

        package =
          inputs.omnisearch.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
          (old: {
            installPhase = old.installPhase + ''
              cp -v ${../../../../config/omnisearch/templates}/*.html \
                $out/share/omnisearch/templates/
            '';
          });      
      };
    };
}
