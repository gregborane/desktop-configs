{
  flake.modules.nixos.nix = {
    nixpkgs.config.allowUnfree = true;

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    programs.nix-ld.enable = true;
    system.stateVersion = "26.05";
  };
}
