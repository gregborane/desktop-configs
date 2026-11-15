{
  flake.modules.nixos.hyprland = {
    programs.hyprland = {
      enable = false;
      xwayland.enable = true;
      withUWSM = false;
    };
  };
}
