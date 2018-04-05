{ config, lib, pkgs, contrailPkgs, ... }:

with lib;

let
  cfg = config.contrail.api;
in {
  options = {
    contrail.api = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      configFile = mkOption {
        type = types.path;
        description = "The contrail api file path";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.contrailApi = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "cassandra.service" "rabbitmq.servive" "zookeeper.service" ];
      preStart = "mkdir -p /var/log/contrail/";
      script = "${contrailPkgs.api}/bin/contrail-api --conf_file  ${cfg.configFile}";
      path = [ pkgs.netcat ];
      postStart = ''
        sleep 2
        while ! nc -vz localhost 8082; do
          sleep 2
        done
        sleep 2
      '';
    };
  };
}

