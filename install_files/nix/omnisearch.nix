{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.services.omnisearch;

  beaker = pkgs.stdenv.mkDerivation {
    pname = "beaker";
    version = "git";
    src = inputs.beaker-src;

    makeFlags = [
      "INSTALL_PREFIX=$(out)/"
      "LDCONFIG=true"
    ];
  };

  omnisearchPackage = pkgs.stdenv.mkDerivation {
    pname = "omnisearch";
    version = "git";
    src = inputs.omnisearch;

    buildInputs = [
      pkgs.libxml2.dev
      pkgs.curl.dev
      pkgs.openssl
      beaker
    ];

    # OmniSearch's Makefile uses /usr/include/libxml2, which is absent on NixOS.
    NIX_CFLAGS_COMPILE = "-I${pkgs.libxml2.dev}/include/libxml2";

    installPhase = ''
      runHook preInstall
      install -Dm755 bin/omnisearch "$out/bin/omnisearch"
      mkdir -p "$out/share/omnisearch/locales"
      cp -r templates static "$out/share/omnisearch/"
      if [ -d locales ]; then
        cp -r locales/. "$out/share/omnisearch/locales/"
      fi
      runHook postInstall
    '';
  };

  configFile = pkgs.writeText "omnisearch.ini" ''
    [server]
    host = ${cfg.settings.server.host}
    port = ${toString cfg.settings.server.port}
    domain = http://${cfg.settings.server.host}:${toString cfg.settings.server.port}

    [cache]
    dir = /var/cache/omnisearch
    ttl_search = 3600
    ttl_infobox = 86400

    [engines]
    engines = "*"
  '';

in
{
  options.services.omnisearch = {
    enable = lib.mkEnableOption "OmniSearch metasearch engine";

    package = lib.mkOption {
      type = lib.types.package;
      default = omnisearchPackage;
      description = "OmniSearch package to run.";
    };

    settings.server = {
      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8087;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.omnisearch = {
      description = "OmniSearch metasearch engine";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/omnisearch";
        WorkingDirectory = "/var/lib/omnisearch";
        StateDirectory = "omnisearch";
        CacheDirectory = "omnisearch";

        BindReadOnlyPaths = [
          "${cfg.package}/share/omnisearch/templates:/var/lib/omnisearch/templates"
          "${cfg.package}/share/omnisearch/static:/var/lib/omnisearch/static"
          "${cfg.package}/share/omnisearch/locales:/var/lib/omnisearch/locales"
          "${configFile}:/var/lib/omnisearch/config.ini"
        ];

        DynamicUser = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
