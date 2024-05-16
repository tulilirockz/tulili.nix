{ config, lib, ... }:
with lib;
let
  cfg = config.rose.system.impermanence;
in
{
  options.rose.system.impermanence = {
    enable = lib.mkEnableOption "impermanence";
    extraDirectories = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "/var/log" ];
      description = "Extra Paths to be added to impermanence";
    };
    persistenceRoot = mkOption {
      type = types.str;
      default = "/persist";
      example = "/nix/persist";
      description = "Place where persistent files are mounted to";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.initrd = {
      services.lvm.enable = true;
      systemd = {
        enable = true;
        emergencyAccess = true;
      };
    };

    environment.etc."machine-id".text = "6a819e8d9a3e406abf68c03da0ba4d49";
    fileSystems."${cfg.persistenceRoot}".neededForBoot = true;
    environment.persistence."${cfg.persistenceRoot}/system" = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/lib/containers"
        "/var/lib/machines"
        "/var/lib/waydroid"
        "/var/lib/libvirt"
        "/var/lib/tailscale"
        "/var/lib/iwd"
      ] ++ cfg.extraDirectories;
    };

    programs.fuse.userAllowOther = true;

    systemd.sysusers.enable = false;
    system.etc.overlay.enable = true;
    system.etc.overlay.mutable = true;
  };
}