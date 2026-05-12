local session_display = "WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP"

hl.on("hyprland.start", function()
  hl.exec_cmd("waybar")
  hl.exec_cmd("swaybg -i ~/.config/hypr/wallpapers/img_1.jpg -m fill")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("/usr/lib/gvfsd-hal")
  hl.exec_cmd("dunst")
  hl.exec_cmd("xhost +si:localuser:root")
  hl.exec_cmd("systemctl --user import-environment " .. session_display) 
  hl.exec_cmd("dbus-update-activation-environment --systemd " .. session_display)
  hl.exec_cmd("~/.config/custom_scripts/portal-restart.sh")
end)
