#!/bin/sh

sleep 1

killall -e xdg-desktop-portal-hyprland 2>/dev/null
killall -e xdg-desktop-portal-gtk 2>/dev/null
killall -e xdg-desktop-portal 2>/dev/null

systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP

sleep 1
/usr/lib/xdg-desktop-portal-hyprland &
sleep 2
/usr/lib/xdg-desktop-portal &
