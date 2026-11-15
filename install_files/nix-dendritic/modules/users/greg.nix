{
  flake.modules.nixos.greg = { pkgs, ... }: {
    users.users.greg = {
      isNormalUser = true;

      extraGroups = [
        "networkmanager"
        "wheel"
        "rfkill"
        "audio"
        "pipewire"
        "video"
        "render"
      ];

      packages = with pkgs; [
        tree
      ];
    };
  };
}
