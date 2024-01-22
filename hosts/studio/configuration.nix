{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/sys/desktops/hyprland.nix
    ../../modules/usr/user.nix
    ../../modules/sys/std.nix
  ];

  system.stateVersion = "24.05";

  boot = {
    loader.systemd-boot.enable = true;
    extraModulePackages = [config.boot.kernelPackages.rtl8192eu];
  };

  networking.hostName = "studio";

  zramSwap.memoryPercent = 75;

  services.system76-scheduler.enable = true;

  environment.systemPackages = with pkgs; [
    alacritty
    gamescope
    mangohud
    gamemode
  ];

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    waydroid.enable = true;
    libvirtd.enable = true;
    incus.enable = true;
  };

  programs.virt-manager.enable = true;

  programs.steam.enable = true;
}
