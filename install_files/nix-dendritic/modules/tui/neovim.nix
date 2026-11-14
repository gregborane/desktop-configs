{ inputs, ... }: {
  flake.modules.homeManager.neovim = { pkgs, ... }: {
    programs.neovim = {
      enable = true;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
      sideloadInitLua = true;
      withPython3 = true;
    };
    home.packages = with pkgs; [
      python3Packages.pynvim
    ];
  };
}
