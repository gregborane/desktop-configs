{ inputs, ... }: {
  flake.modules.nixos.neovim = { pkgs, ... }: {
    users.users.greg.packages = [
      (pkgs.wrapNeovimUnstable
        inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default
        {
          withPython3 = true;
          wrapRc = false;
        }
      )
      pkgs.python3Packages.pynvim
    ];
  };
}
