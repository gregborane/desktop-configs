{ inputs, ... }: {
  flake.modules.homeManager.zotero = { pkgs, ... }: {
    home.packages = [
      (
        let
          package = inputs.zotero-nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.zotero;
        in
        assert package.version == "10.0.2";
        package
      )
    ];
  };
}
