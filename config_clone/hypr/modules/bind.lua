require("modules.global")

hl.bind("SUPER + RETURN", hl.dsp.exec_cmd(TERMINAL), {
  description = "Open Terminal"
})

hl.bind("SUPER + W", hl.dsp.window.close(), {
  description = "Kill Focus window"
})

hl.bind("SUPER + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()"), {
  description = "Exit Hyprland"
})

hl.bind("SUPER + B", hl.dsp.exec_cmd(BROWSER), {
  description = "Open Browser"
})

hl.bind("SUPER + F", hl.dsp.exec_cmd(FILE_MANAGER), {
  description = "Open File Manager"
})

hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(LAUNCHER), {
  description = "Open App Launcher"
})

hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd(POWER_MENU), {
  description = "Open Power Menu"
})

hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd(EMOJI_PICKER), {
  description = "Open Emoji Picker"
})

hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"), {
  description = "Reload Hyprland"
})

-- hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("killall waybar && waybar &"), {
--   description = "Kill And Reopen Waybar (Reload waybar)"
-- })

hl.bind("Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | satty --filename -"), {
  description = "Take Area Screenshot"
})

hl.bind("SUPER +  Print", hl.dsp.exec_cmd("grim - | satty --filename -"), {
  description = "Take Fullscreen Screenshot"
})

hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + J", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen())
hl.bind("SUPER + SHIFT + T", hl.dsp.window.float({ action = "toggle" }))

hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

for i = 1, 10 do
    local key = i % 10
    hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i}))
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
