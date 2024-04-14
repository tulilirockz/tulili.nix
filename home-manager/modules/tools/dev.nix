{ config
, pkgs
, lib
, inputs
, ...
}:
let
  cfg = config.rose.programs.tools.dev;
in
{
  options.rose.programs.tools.dev = with lib; {
    enable = mkEnableOption "Development Tools";
    gui = mkOption {
      type = types.submodule (_: {
        options.enable = mkEnableOption "GUI Development Tools";
      });
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      GOPATH = "${config.home.homeDirectory}/.local/share/go";
    };

    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          name = config.programs.git.userName;
          email = config.programs.git.userEmail;
        };
        ui = {
          default-command = "log";
          diff-editor = "meld";
        };
        signing = {
          sign-all = true;
          backend = "ssh";
          key = config.programs.git.signing.key;
        };
      };
    };

    programs.git = {
      enable = true;
      userEmail = "tulilirockz@outlook.com";
      userName = "Tulili";
      signing.key = "/home/tulili/.ssh/id_ed25519.pub";
      signing.signByDefault = true;
      extraConfig = {
        gpg.format = "ssh";
        init.defaultBranch = "main";
        core.excludesfile = "${pkgs.writers.writeText "gitignore" ''
        .jj
        .jj/*
        /.jj
        /.git
        .git/*
        .direnv
        /.direnv
        .direnv/*
        ''}";
      };
    };

    xdg.configFile."libvirt/qemu.conf".text = ''
      nvram = [ "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd", "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ]
    '';

    programs.direnv = {
      enable = true;
      enableNushellIntegration = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    programs.yazi.enable = true;
    programs.zellij.enable = true;
    programs.helix = {
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
        (python3.withPackages
          (p: with p; [
            python-lsp-server
            pylsp-mypy
            pylsp-rope
            python-lsp-ruff
          ])
        )
        yaml-language-server
        tailwindcss-language-server
        clang-tools
        nil
        zls
        marksman
        rust-analyzer
        gopls
        ruff
        docker-ls
        vscode-langservers-extracted
        clojure-lsp
        dockerfile-language-server-nodejs
      ];
      settings = {
        theme = "boo_berry";
        editor = {
          line-number = "relative";
          mouse = false;
          middle-click-paste = false;
          auto-save = true;
          auto-pairs = false;
          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };
          whitespace.render = {
            tab = "all";
            nbsp = "none";
            nnbsp = "none";
            newline = "none";
          };
          file-picker = {
            hidden = false;
          };
        };
      };
    };

    home.packages = with pkgs; [
      unzip
      git
      ollama
      buildah
      gh
      glab
      fd
      ripgrep
      sbctl
      podman-compose
      tldr
      jq
      yq
      scc
      just
      iotop
      nix-prefetch-git
      pre-commit
      fh
      trashy
      android-tools
      wireshark
      wormhole-rs
      lldb
      gdb
      okteta
      bubblewrap
      just
      waypipe
      cage
      distrobox
      cosign
      jsonnet
      kubernetes-helm
      inputs.agenix.packages.${pkgs.system}.default
      kind
      devpod
      devenv
      lazydocker
      kubectl
      talosctl
      gitg
      gource
      meld
      jujutsu
      melange
      dive
      earthly
      poetry
      gdu
      asciinema
      maturin
      bun
      act
      wasmer
      go-task
      gnome.gnome-disk-utility
      (writeScriptBin "mount-qcow" ''
        	set -ex
          QCOW_PATH=$1
        	shift
        	set -euox pipefail
        	sudo modprobe nbd
        	sudo qemu-nbd $QCOW_PATH /dev/nbd0 &
        	sudo pkill qemu-nbd
      '')
      #(writeScriptBin "code-wayland" "${lib.getExe config.programs.vscode.package} --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland $@")
    ];
  };
}