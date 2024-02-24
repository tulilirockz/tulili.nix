{
  config,
  pkgs,
  lib,
  preferences,
  ...
}: {
  wayland.windowManager.hyprland.extraConfig = "exec-once=${lib.getExe (pkgs.writeScriptBin "initial_script.sh" ''
    ${lib.getExe pkgs.networkmanagerapplet} --indicator &
    ${lib.getExe (pkgs.hyprpaper.overrideAttrs (oldAttrs: {patches = [../../../assets/bebea-hyprpaper.patch];}))} &
    ${pkgs.gnome.gnome-keyring}/bin/gnome-keyring-daemon -r --unlock &
    ${lib.getExe pkgs.swaynotificationcenter} &
    ${pkgs.openssh}/bin/ssh-agent &
    ${pkgs.udiskie}/bin/udiskie &
    ${lib.getExe pkgs.foot} --server &
    ${lib.getExe pkgs.waybar}
  '')}";

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${preferences.user_wallpaper}
    wallpaper = HDMI-A-1,${preferences.user_wallpaper}
    splash = true
    ipc = off
  '';

  services.hypridle = {
    enable = true;
    lockCmd = "${lib.getExe config.programs.hyprlock.package}";
    listeners = [
      {
        onTimeout = "${lib.getExe pkgs.playerctl} pause";
        onResume = "${lib.getExe pkgs.playerctl} play";
      }
      {
        onTimeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        onResume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
    ];
  };

  programs.hyprlock = {
    enable = true;
    backgrounds = [{path = preferences.user_wallpaper;}];
    input-fields = with preferences.colorScheme.palette ; [{
      outer_color = "rgb(${base02})";
      inner_color = "rgb(${base00})";
      font_color = "rgb(${base05})";
    }];
    labels = with preferences.colorScheme.palette ; [{
      color = "rgba(${base05}DD)";
    }];
  };

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$browser" = "${lib.getExe pkgs.firefox}";
    "$terminal" = "${pkgs.foot}/bin/footclient";
    "$file" = "${pkgs.foot}/bin/footclient -e ${lib.getExe pkgs.yazi}";
    "$selector" = "${lib.getExe pkgs.fuzzel}";
    "$screenshot" = "${lib.getExe pkgs.grimblast}";

    general = with preferences.colorScheme.palette; {
      "col.active_border" = "rgba(${base0E}ff) rgba(${base09}ff) 60deg";
      "col.inactive_border" = "rgba(${base00}ff)";
    };

    input = {
      kb_layout = "us,br";
      kb_options = ["grp:win_space_toggle"];
      accel_profile = "flat";
      sensitivity = 0.0;
      repeat_delay = 300;
      repeat_rate = 50;
    };

    decoration = {
      rounding = 5;
      blur = {
        enabled = true;
        size = 3;
        passes = 1;
        vibrancy = 0.1696;
      };
      drop_shadow = true;
      shadow_range = 4;
      shadow_render_power = 3;
    };

    animation = "workspaces,1,8,default,slidefade 20%";

    bind =
      [
        "$mod, F, exec, $browser"
        "$mod, Q, exec, $terminal"
        "$mod, E, exec, $file"
        "$mod, L, exec, ${lib.getExe config.programs.hyprlock.package}"
        "$mod, R, exec, $selector"
        ", Print, exec, $screenshot copy area"
        "$mod, V, togglefloating"
        "$mod, X, fullscreen"
        "$mod, C, killactive"
        "$mod, P, pseudo"
        "$mod, M, exec, ${lib.getExe pkgs.wlogout}"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ]
      ++ (
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
  };
}
