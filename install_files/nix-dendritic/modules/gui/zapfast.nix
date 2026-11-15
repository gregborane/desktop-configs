{ inputs, ... }: {
  flake.modules.nixos.zapfast = { pkgs, ... }: {
    users.users.greg.packages = [ inputs.zapfast.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}
