{ config
, pkgs
, lib
, preferences
, ...
}: {
  xdg.configFile = {
    "niri/autostart".executable = true;
    "niri/autostart".text = ''
      ${lib.getExe pkgs.networkmanagerapplet} --indicator &
      ${lib.getExe pkgs.swaybg} -m fill -i ${preferences.theme.wallpaperPath} &
      ${lib.getExe pkgs.mako} &
      ${pkgs.openssh}/bin/ssh-agent &
      ${pkgs.udiskie}/bin/udiskie &
      ${pkgs.kdeconnect}/bin/kdeconnect-applet &
      ${lib.getExe pkgs.swayidle} -w timeout 150 '${lib.getExe pkgs.swaylock-effects} -w timeout 300 '${config.programs.niri.package} msg' -w timeout 1000 'systemctl suspend' -f' &
      ${lib.getExe pkgs.foot} --server &
      ${lib.getExe pkgs.waybar}
    '';
  };

  programs.niri.config = with config.colorScheme.palette ; ''
    // This config is in the KDL format: https://kdl.dev
    // "/-" comments out the following node.

    input {
        keyboard {
            xkb {
                // You can set rules, model, layout, variant and options.
                // For more information, see xkeyboard-config(7).

                // For example:
                layout "us,br"
                options "grp:win_space_toggle,compose:ralt,ctrl:nocaps"
            }

            // You can set the keyboard repeat parameters. The defaults match wlroots and sway.
            // Delay is in milliseconds before the repeat starts. Rate is in characters per second.
            repeat-delay 250
            repeat-rate 75

            // Niri can remember the keyboard layout globally (the default) or per-window.
            // - "global" - layout change is global for all windows.
            // - "window" - layout is tracked for each window individually.
            track-layout "global"
        }

        // Next sections include libinput settings.
        // Omitting settings disables them, or leaves them at their default values.
        touchpad {
            tap
            // dwt
            // dwtp
            natural-scroll
            // accel-speed 0.2
            // accel-profile "flat"
            // tap-button-map "left-middle-right"
        }

        mouse {
            // natural-scroll
            accel-speed 0.2
            accel-profile "flat"
        }

        trackpoint {
            // natural-scroll
            accel-speed 0.2
            accel-profile "flat"
        }

        tablet {
            // Set the name of the output (see below) which the tablet will map to.
            // If this is unset or the output doesn't exist, the tablet maps to one of the
            // existing outputs.
            map-to-output "HDMI-A-1"
        }

        // By default, niri will take over the power button to make it sleep
        // instead of power off.
        // Uncomment this if you would like to configure the power button elsewhere
        // (i.e. logind.conf).
        // disable-power-key-handling
    }

    // You can configure outputs by their name, which you can find
    // by running `niri msg outputs` while inside a niri instance.
    // The built-in laptop monitor is usually called "eDP-1".
    // Remember to uncomment the node by removing "/-"!
    output "HDMI-A-1" {
        // Uncomment this line to disable this output.
        // off

        // Scale is a floating-point number, but at the moment only integer values work.
        //scale 2.0

        // Transform allows to rotate the output counter-clockwise, valid values are:
        // normal, 90, 180, 270, flipped, flipped-90, flipped-180 and flipped-270.
        transform "normal"

        // Resolution and, optionally, refresh rate of the output.
        // The format is "<width>x<height>" or "<width>x<height>@<refresh rate>".
        // If the refresh rate is omitted, niri will pick the highest refresh rate
        // for the resolution.
        // If the mode is omitted altogether or is invalid, niri will pick one automatically.
        // Run `niri msg outputs` while inside a niri instance to list all outputs and their modes.
        mode "1920x1080@120.030"

        // Position of the output in the global coordinate space.
        // This affects directional monitor actions like "focus-monitor-left", and cursor movement.
        // The cursor can only move between directly adjacent outputs.
        // Output scale has to be taken into account for positioning:
        // outputs are sized in logical, or scaled, pixels.
        // For example, a 3840×2160 output with scale 2.0 will have a logical size of 1920×1080,
        // so to put another output directly adjacent to it on the right, set its x to 1920.
        // It the position is unset or results in an overlap, the output is instead placed
        // automatically.
        // position x=1280 y=0
    }

    layout {
        // By default focus ring and border are rendered as a solid background rectangle
        // behind windows. That is, they will show up through semitransparent windows.
        // This is because windows using client-side decorations can have an arbitrary shape.
        //
        // If you don't like that, you should uncomment `prefer-no-csd` below.
        // Niri will draw focus ring and border *around* windows that agree to omit their
        // client-side decorations.

        focus-ring {
            // Uncomment this line to disable the focus ring.
            // off

            // How many logical pixels the ring extends out from the windows.
            width 2

            // Color of the ring on the active monitor: red, green, blue, alpha.
            active-color 33 33 33 125

            // Color of the ring on inactive monitors: red, green, blue, alpha.
            inactive-color 80 80 80 255

            // You can also use gradients. They take precedence over solid colors.
            // Gradients are rendered the same as CSS linear-gradient(angle, from, to).
            // Colors can be set in a variety of ways here:
            // - CSS named colors: from="red"
            // - RGB hex: from="#rgb", from="#rgba", from="#rrggbb", from="#rrggbbaa"
            // - CSS-like notation: from="rgb(255, 127, 0)", rgba(), hsl() and a few others.
            // The angle is the same as in linear-gradient, and is optional,
            // defaulting to 180 (top-to-bottom gradient).
            // You can use any CSS linear-gradient tool on the web to set these up.
            //
            active-gradient from="#${base00}" to="#${base01}" angle=45 relative-to="workspace-view"

            // You can also color the gradient relative to the entire view
            // of the workspace, rather than relative to just the window itself.
            // To do that, set relative-to="workspace-view".
            //
            inactive-gradient from="#505050" to="#808080" angle=45 relative-to="workspace-view"
        }


        // You can customize the widths that "switch-preset-column-width" (Mod+R) toggles between.
        preset-column-widths {
            // Proportion sets the width as a fraction of the output width, taking gaps into account.
            // For example, you can perfectly fit four windows sized "proportion 0.25" on an output.
            // The default preset widths are 1/3, 1/2 and 2/3 of the output.
            proportion 0.33333
            proportion 0.5
            proportion 0.66667

            // Fixed sets the width in logical pixels exactly.
            // fixed 1920
        }

        // You can change the default width of the new windows.
        default-column-width { proportion 0.5; }
        // If you leave the brackets empty, the windows themselves will decide their initial width.
        // default-column-width {}

        // Set gaps around windows in logical pixels.
        gaps 16

        // Struts shrink the area occupied by windows, similarly to layer-shell panels.
        // You can think of them as a kind of outer gaps. They are set in logical pixels.
        // Left and right struts will cause the next window to the side to always be visible.
        // Top and bottom struts will simply add outer gaps in addition to the area occupied by
        // layer-shell panels and regular gaps.
        struts {
            // left 64
            // right 64
            // top 64
            // bottom 64
        }

        // When to center a column when changing focus, options are:
        // - "never", default behavior, focusing an off-screen column will keep at the left
        //   or right edge of the screen.
        // - "on-overflow", focusing a column will center it if it doesn't fit
        //   together with the previously focused column.
        // - "always", the focused column will always be centered.
        center-focused-column "never"
    }

    // Add lines like this to spawn processes at startup.
    // Note that running niri as a session supports xdg-desktop-autostart,
    // which may be more convenient to use.
    spawn-at-startup "${config.xdg.configFile."niri/autostart".target}"

    // Uncomment this line to ask the clients to omit their client-side decorations if possible.
    // If the client will specifically ask for CSD, the request will be honored.
    // Additionally, clients will be informed that they are tiled, removing some rounded corners.
    prefer-no-csd

    // You can change the path where screenshots are saved.
    // A ~ at the front will be expanded to the home directory.
    // The path is formatted with strftime(3) to give you the screenshot date and time.
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"


    // Settings for the "Important Hotkeys" overlay.
    hotkey-overlay {
        // Uncomment this line if you don't want to see the hotkey help at niri startup.
        // skip-at-startup
    }

    // Animation settings.
    animations {
        // Uncomment to turn off all animations.
        // off

        // Slow down all animations by this factor. Values below 1 speed them up instead.
        // slowdown 3.0

        // You can configure all individual animations.
        // Available settings are the same for all of them:
        // - off disables the animation.
        // - duration-ms sets the duration of the animation in milliseconds.
        // - curve sets the easing curve. Currently, available curves
        //   are "ease-out-cubic" and "ease-out-expo".

        // Animation when switching workspaces up and down,
        // including after the touchpad gesture.
        workspace-switch {
            // off
            // duration-ms 250
            // curve "ease-out-cubic"
        }

        // All horizontal camera view movement:
        // - When a window off-screen is focused and the camera scrolls to it.
        // - When a new window appears off-screen and the camera scrolls to it.
        // - When a window resizes bigger and the camera scrolls to show it in full.
        // - And so on.
        horizontal-view-movement {
            // off
            // duration-ms 250
            // curve "ease-out-cubic"
        }

        // Window opening animation. Note that this one has different defaults.
        window-open {
            // off
            // duration-ms 150
            // curve "ease-out-expo"
        }

        // Config parse error and new default config creation notification
        // open/close animation.
        config-notification-open-close {
            // off
            // duration-ms 250
            // curve "ease-out-cubic"
        }
    }

    binds {
        // Keys consist of modifiers separated by + signs, followed by an XKB key name
        // in the end. To find an XKB name for a particular key, you may use a program
        // like wev.
        //
        // "Mod" is a special modifier equal to Super when running on a TTY, and to Alt
        // when running as a winit window.
        //
        // Most actions that you can bind here can also be invoked programmatically with
        // `niri msg action do-something`.

        // Mod-Shift-/, which is usually the same as Mod-?,
        // shows a list of important hotkeys.
        Mod+Shift+H { show-hotkey-overlay; }
        Mod+C { close-window; }

        Mod+Q { spawn "${pkgs.foot}/bin/footclient"; }
        Mod+F { spawn "${lib.getExe config.programs.chromium.package}"; }
        Mod+R { spawn "${lib.getExe pkgs.fuzzel}"; }
        Mod+E { spawn "${lib.getExe pkgs.gnome.nautilus}"; }
        Mod+M { spawn "${lib.getExe pkgs.wlogout}"; }
        Mod+Shift+L { spawn "${lib.getExe pkgs.swaylock-effects}"; }

        // Example volume keys mappings for PipeWire & WirePlumber.
        XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"; }
        XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"; }

        Mod+Left  { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Up    { focus-workspace-up; }
        Mod+Down  { focus-workspace-down; }
        Mod+H  { focus-column-left; }
        Mod+J  { focus-workspace-down; }
        Mod+K    { focus-workspace-up; }
        Mod+L { focus-column-right; }

        Mod+Ctrl+Left  { move-column-left; }
        Mod+Ctrl+Down  { move-window-down; }
        Mod+Ctrl+Up    { move-window-up; }
        Mod+Ctrl+Right { move-column-right; }
        Mod+Ctrl+H     { move-column-left; }
        Mod+Ctrl+J     { move-window-down; }
        Mod+Ctrl+K     { move-window-up; }
        Mod+Ctrl+L     { move-column-right; }

        // Alternative commands that move across workspaces when reaching
        // the first or last window in a column.
        // Mod+J     { focus-window-or-workspace-down; }
        // Mod+K     { focus-window-or-workspace-up; }
        // Mod+Ctrl+J     { move-window-down-or-to-workspace-down; }
        // Mod+Ctrl+K     { move-window-up-or-to-workspace-up; }

        Mod+Home { focus-column-first; }
        Mod+End  { focus-column-last; }
        Mod+Ctrl+Home { move-column-to-first; }
        Mod+Ctrl+End  { move-column-to-last; }

        //Mod+Shift+Left  { focus-monitor-left; }
        //Mod+Shift+Down  { focus-monitor-down; }
        //Mod+Shift+Up    { focus-monitor-up; }
        //Mod+Shift+Right { focus-monitor-right; }
        //Mod+Shift+H     { focus-monitor-left; }
        //Mod+Shift+J     { focus-monitor-down; }
        //Mod+Shift+K     { focus-monitor-up; }
        //Mod+Shift+L     { focus-monitor-right; }
        //Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
        //Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
        //Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
        //Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
        //Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
        //Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
        //Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
        //Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

        // Alternatively, there are commands to move just a single window:
        // Mod+Shift+Ctrl+Left  { move-window-to-monitor-left; }
        // ...

        // And you can also move a whole workspace to another monitor:
        // Mod+Shift+Ctrl+Left  { move-workspace-to-monitor-left; }
        // ...

        Mod+Page_Down      { focus-workspace-down; }
        Mod+Page_Up        { focus-workspace-up; }
        Mod+U              { focus-workspace-down; }
        Mod+I              { focus-workspace-up; }
        Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
        Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
        Mod+Ctrl+U         { move-column-to-workspace-down; }
        Mod+Ctrl+I         { move-column-to-workspace-up; }

        // Alternatively, there are commands to move just a single window:
        // Mod+Ctrl+Page_Down { move-window-to-workspace-down; }
        // ...

        Mod+Shift+Page_Down { move-workspace-down; }
        Mod+Shift+Page_Up   { move-workspace-up; }
        Mod+Shift+U         { move-workspace-down; }
        Mod+Shift+I         { move-workspace-up; }

        // You can refer to workspaces by index. However, keep in mind that
        // niri is a dynamic workspace system, so these commands are kind of
        // "best effort". Trying to refer to a workspace index bigger than
        // the current workspace count will instead refer to the bottommost
        // (empty) workspace.
        //
        // For example, with 2 workspaces + 1 empty, indices 3, 4, 5 and so on
        // will all refer to the 3rd workspace.
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+Ctrl+1 { move-column-to-workspace 1; }
        Mod+Ctrl+2 { move-column-to-workspace 2; }
        Mod+Ctrl+3 { move-column-to-workspace 3; }
        Mod+Ctrl+4 { move-column-to-workspace 4; }
        Mod+Ctrl+5 { move-column-to-workspace 5; }
        Mod+Ctrl+6 { move-column-to-workspace 6; }
        Mod+Ctrl+7 { move-column-to-workspace 7; }
        Mod+Ctrl+8 { move-column-to-workspace 8; }
        Mod+Ctrl+9 { move-column-to-workspace 9; }

        Mod+Comma  { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }

        // There are also commands that consume or expel a single window to the side.
        // Mod+BracketLeft  { consume-or-expel-window-left; }
        // Mod+BracketRight { consume-or-expel-window-right; }

        Mod+T { switch-preset-column-width; }
        Mod+V { maximize-column; }
        Mod+X { fullscreen-window; }
        //Mod+C { center-column; }

        // Finer width adjustments.
        // This command can also:
        // * set width in pixels: "1000"
        // * adjust width in pixels: "-5" or "+5"
        // * set width as a percentage of screen width: "25%"
        // * adjust width as a percentage of screen width: "-10%" or "+10%"
        // Pixel sizes use logical, or scaled, pixels. I.e. on an output with scale 2.0,
        // set-column-width "100" will make the column occupy 200 physical screen pixels.
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }

        // Finer height adjustments when in column with other windows.
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }

        // Actions to switch layouts.
        // Note: if you uncomment these, make sure you do NOT have
        // a matching layout switch hotkey configured in xkb options above.
        // Having both at once on the same hotkey will break the switching,
        // since it will switch twice upon pressing the hotkey (once by xkb, once by niri).
        // Mod+Space       { switch-layout "next"; }
        // Mod+Shift+Space { switch-layout "prev"; }

        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }

        // The quit action will show a confirmation dialog to avoid accidental exits.
        // If you want to skip the confirmation dialog, set the flag like so:
        // Mod+Shift+E { quit skip-confirmation=true; }
        Mod+Shift+E { quit; }

        Mod+Shift+P { power-off-monitors; }
    }
  '';
}
