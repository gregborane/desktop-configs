
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

      documentation.nixos.enable = false;

      # Import the service module from unstable Nixpkgs
      imports = [
        (inputs.nixpkgs-unstable
          + "/nixos/modules/services/misc/cliproxyapi.nix")
      ];

      services.cliproxyapi = {
        enable = true;

        # Use the CLIProxyAPI package from unstable
        package = unstable.cliproxyapi;

        openFirewall = false;

        settings = {
          config-version = 8;

          server = {
            host = "127.0.0.1";
            port = 8317;
          };

          access.api-keys = [
            {
              _secret = "/var/lib/cliproxyapi-client-key";
            }
          ];

          management = {
            allow-remote = false;
            secret-key = "";
          };
        };
      };

      environment.systemPackages = [
        config.services.cliproxyapi.package
      ];
    };
}

