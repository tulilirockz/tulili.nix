{ inputs
, pkgs
, preferences
, config
, ...
}: rec {
  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];

  system.stateVersion = "24.05";

  boot = {
    loader.systemd-boot.enable = true;
    loader.systemd-boot.configurationLimit = 5;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_zen;
    kernel.sysctl."kernel.sysrq" = 1;
  };

  networking.hostName = "studio";

  zramSwap.enable = true;
  zramSwap.memoryPercent = 75;

  time.timeZone = preferences.timeZone;
  i18n.defaultLocale = preferences.locale;


  users = {
    defaultUserShell = pkgs.nushell;
    mutableUsers = false;
    users.${preferences.username} = {
      isNormalUser = true;
      hashedPassword = "$6$iea8d6J3Sppre8Sy$.Oyx.gAZfZjIe3t7f98boN8lyQMoTdqyVT/WheOdLrMuJFH7ptgoUQvdUJxYLFZBoUYlyH6cEhssuBt2BUX1E1";
      extraGroups = [ "wheel" "libvirtd" "incus-admin" "qemu" ];
      shell = config.users.defaultUserShell;
    };
  };

  services.flatpak.enable = true;

  environment.localBinInPath = true;
  security.pam.services.${preferences.username}.showMotd = true;


  rose = {
    system.impermanence.enable = true;
    programs.gaming = {
      enable = true;
      steam.enable = true;
      others.enable = true;
    };
    programs.desktops = {
      niri.enable = true;
      shared.enable = true;
    };
    programs.collections = with pkgs.lib; {
      enable = true;
      qt.enable = mkDefault false;
      gnome.enable = mkDefault false;
      shared.enable = mkDefault false;
      wm.enable = mkDefault false;
    };
    networking = {
      enable = true;
      firewall.enable = false;
      tailscale.enable = true;
      wireless.enable = true;
      ipfs.enable = false;
    };
    virtualization = {
      enable = true;
      gui.enable = true;
    };
    services = {
      sunshine.enable = false;
      sunshine.openFirewall = false;
    };
  };

  hardware = {
    bluetooth.enable = true;
    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  };

  services = {
    printing.enable = true;
    system76-scheduler.enable = true;
    fwupd.enable = true;
  };

  system.autoUpgrade = {
    enable = true;
    dates = "12:00";
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L"
    ];
    randomizedDelaySec = "45min";
  };

  nix = {
    package = pkgs.nixVersions.unstable;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 2d";
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      use-xdg-base-directories = true;
    };
  };

  security.sudo.enable = false;
  security.sudo-rs.enable = !(security.sudo.enable);

  home-manager = {
    extraSpecialArgs = {
      inherit preferences;
      inherit inputs;
    };
    useGlobalPkgs = true;
    users = {
      ${preferences.username} = _: {
        imports = with inputs; [
          plasma-manager.homeManagerModules.plasma-manager
          persist-retro.nixosModules.home-manager.persist-retro
          nix-colors.homeManagerModules.default
          impermanence.nixosModules.home-manager.impermanence
        ] ++ [../../../home-manager/configurations/tulip-nixos.nix];
      };
    };
  };
}
