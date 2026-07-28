local suppressMaximizeRule = hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

suppressMaximizeRule:set_enabled(true)

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
  name = "satty-minimized",
  match = { class = "^(com\\.gabm\\.satty)$" },
  float = true,
  center = true,
  size = { 800, 600 },
})

hl.window_rule({
  name = "rezy-minimized",
  match = { class = "Rezy" },
  float = true,
  center = true,
})

hl.window_rule({
    name = "emoji-picker",
    match = { class = "emote" },
    float = true,
    center = true,
    pin = true,
    size = { 400, 200 },
})
