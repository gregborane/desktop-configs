{ inputs, ... }: {
  flake.modules.nixos.zapfast = { pkgs, ... }: {
    environment.systemPackages =
      with pkgs;
      [
        openssl
      ]

  };
}
