{pkgs,...}: {
  boot = {
    loader.systemd-boot.configurationLimit = 5;
    loader.efi.canTouchEfiVariables = true;
  };

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";

  services.printing.enable = true;

  zramSwap.enable = true;
  services.fwupd.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 2d";
  };
  nixpkgs.config.allowUnfree = true;

  networking = {
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
    wireless.iwd.enable = true;
    wireless.iwd.settings = {
      Network = {
        EnableIPV6 = true;
      };
      Settings = {
        AutoConnect = true;
      };
    };
    firewall.enable = true;
  };

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  hardware.bluetooth.enable = true;

  security.sudo.enable = false;
  security.sudo-rs.enable = true;

  environment.systemPackages = with pkgs; [home-manager git];
}
