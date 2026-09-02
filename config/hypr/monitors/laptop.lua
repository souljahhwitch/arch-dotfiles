local dynamic_monitor = os.getenv("HOME") .. "/.config/hypr/scripts/dynamic-monitor.sh"

local function update_monitors()
    hl.exec_cmd(dynamic_monitor)
end

hl.on("hyprland.start", update_monitors)
hl.on("monitor.added", update_monitors)
hl.on("monitor.removed", update_monitors)
hl.on("monitor.layout_changed", update_monitors)
