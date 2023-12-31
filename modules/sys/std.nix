{ ... }:

{
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  services.printing.enable = true;
  zramSwap.enable = true;
  services.fwupd.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
    wireless.enable = false;
  };

  boot.plymouth.enable = true;
  boot.plymouth.theme = "breeze";
}
