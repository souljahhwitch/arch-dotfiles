local dynamic_monitor = os.getenv("HOME") .. "/.config/hypr/scripts/dynamic-monitor.sh"

hl.monitor({
    output = "DP-5",
    mode = "1920x1080@280",
    position = "0x0",
    scale = 1,
})

hl.monitor({
    output = "DP-4",
    mode = "1920x1080@143.85",
    position = "1920x0",
    scale = 1,
})

local function update_monitors()
    hl.exec_cmd(dynamic_monitor .. " DP-5 DP-4")
end

hl.on("hyprland.start", update_monitors)
hl.on("monitor.added", update_monitors)
hl.on("monitor.removed", update_monitors)
hl.on("monitor.layout_changed", update_monitors)
