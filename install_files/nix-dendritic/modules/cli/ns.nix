{
  flake.modules.homeManager.ns = { pkgs, ... }: {
    home.packages = with pkgs; [
      (pkgs.writeShellApplication {
        name = "ns";
        runtimeInputs = with pkgs; [
          fzf
          nix-search-tv
        ];
        text = ''exec ${pkgs.bash}/bin/bash ${pkgs.nix-search-tv.src}/nixpkgs.sh "$@"'';
      })
    ];
  };
}
