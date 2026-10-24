hl.monitor({
  output = "DP-3",
  mode = "1920x1080@240",
  position = "0x0",
  scale = 1,
})

hl.workspace_rule({
  workspace = "1",
  monitor = "DP-3",
  default = true,
})

hl.workspace_rule({
  workspace = "4",
  monitor = "HDMI-A-1",
  default = true,
})
