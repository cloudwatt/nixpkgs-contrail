{ config, lib, pkgs, ... }:

with lib;

let
  # We should try a nixpkgs overlay to avoid this explicit import
  controllerPkgs = import ../controller.nix { inherit pkgs; };
  cfg = config.contrail.vrouterAgent;
  agent = pkgs.writeTextFile {
    name = "contrail-agent.conf";
    text = ''
      [DEFAULT]
      ble_flow_collection = 1
      log_file = /var/log/contrail/vrouter.log
      log_level = SYS_DEBUG
      log_local = 1
      collectors= ${cfg.collectorHost}:8086
      
      [CONTROL-NODE]
      server = ${cfg.controlHost}
      
      [DISCOVERY]
      port = 5998
      server = ${cfg.discoveryHost}
      
      [VIRTUAL-HOST-INTERFACE]
      name = vhost0
      ip = 192.168.1.1/24
      gateway = 192.168.1.1
      physical_interface = eth1
      
      [FLOWS]
      max_vm_flows = 20
      
      [METADATA]
      metadata_proxy_secret = t96a4skwwl63ddk6
      
      [TASK]
      tbb_keepawake_timeout = 25
    '';
  };

in {
  options = {
    contrail.vrouterAgent = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      provisionning = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If enable, the contrail-vrouter unit wait for the
          contrailApi and register itself as active vrouter.
          Note this currently only works if the Vrouter is collocated
          with the Contrail API.
        '';
      };
      collectorHost = mkOption {
        type = types.str;
        default = "127.0.0.1";
      };
      discoveryHost = mkOption {
        type = types.str;
        default = "127.0.0.1";
      };
      controlHost = mkOption {
        type = types.str;
        default = "127.0.0.1";
      };
    };
  };

  config = mkIf cfg.enable {
    boot.extraModulePackages = [ (controllerPkgs.contrailVrouter pkgs.linuxPackages.kernel.dev) ];
    boot.kernelModules = [ "vrouter" ];
    boot.kernelPackages = pkgs.linuxPackages;

    environment.systemPackages = [
      controllerPkgs.contrailVrouterPortControl controllerPkgs.contrailVrouterUtils
      controllerPkgs.contrailVrouterNetns
    ];
    
    systemd.services.contrailVrouterAgent = {
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        (mkIf cfg.provisionning "contrailApi.service") ];
      preStart = "mkdir -p /var/log/contrail/";
      script = "${controllerPkgs.contrailVrouterAgent}/bin/contrail-vrouter-agent --config_file ${agent}";
      postStart = mkIf cfg.provisionning "${controllerPkgs.contrailConfigUtils}/bin/provision_vrouter.py  --api_server_ip 127.0.0.1 --api_server_port 8082 --oper add --host_name machine --host_ip 192.168.1.1";
    };

    systemd.services.configureVhostInterface = {
      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ pkgs.iproute controllerPkgs.contrailVrouterUtils ];
      script = ''
        vif --create vhost0 --mac $(cat /sys/class/net/eth1/address)
        vif --add vhost0 --mac $(cat /sys/class/net/eth1/address) --vrf 0 --xconnect eth1 --type vhost
        vif --add eth1 --mac $(cat /sys/class/net/eth0/address) --vrf 0 --vhost-phys --type physical
        ip link set vhost0 up
      '';
    };
  };
}