{
  flake.modules.nixos.audio = { pkgs, ... }: {
    services.pipewire = {
      enable = true;

      pulse.enable = true;
      wireplumber.enable = true;
      jack.enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };

      extraConfig.pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;

          # Low-latency audio.
          "default.clock.quantum" = 128;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 256;
        };
      };
    };
    environment.systemPackages = with pkgs; [
      pipewire
      pipewire.jack
      alsa-plugins
      pulseaudio
    ];
  };
}
