[{
    "label" = "lock";
    "action" = "swaylock";
    "keybind" = "l";
}
{
    "label" = "hibernate";
    "action" = "systemctl hibernate";
    "keybind" = "h";
}
{
    "label" = "logout";
    "action" = "loginctl terminate-user $USER";
    "keybind" = "e";
}
{
    "label" = "shutdown";
    "action" = "systemctl poweroff";
    "keybind" = "s";
}
{
    "label" = "suspend";
    "action" = "systemctl suspend";
    "keybind" = "u";
}
{
    "label" = "reboot";
    "action" = "systemctl reboot";
    "keybind" = "r";
}]
