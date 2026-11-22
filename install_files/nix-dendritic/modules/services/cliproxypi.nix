
{ inputs, ... }:
{
  flake.modules.nixos.cliproxyapi =
    { config, pkgs, ... }:
    let
      unstable = import inputs.nixpkgs-unstable {
        system = pkgs.stdenv.hostPlatform.system;
      };
    in
    {
      services.cliproxyapi = {
        enable = true;

        # Use the unstable package
        package = unstable.cliproxyapi;

        # Local access only
        openFirewall = false;

        settings = {
          server = {
            host = "127.0.0.1";
            port = 8317;
          };

          access.api-keys = [
            { _secret = "/var/lib/cliproxyapi-client-key"; }
          ];

          management = {
            allow-remote = false;
            secret-key = "";
          };
        };
      };

      # Make the CLI available system-wide
      environment.systemPackages = [
        config.services.cliproxyapi.package
      ];
    };
}

