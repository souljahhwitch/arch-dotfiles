-- ~/.config/hypr/hyprland.l })


local mainMod = "SUPER"

hl.bind("CTRL + SHIFT + M", hl.dsp.pass({window = "class:^vesktop"}))

-- Core Applications
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("alacritty"))
hl.bind("CTRL + ALT + T", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + TAB", hl.dsp.window.swap({ next = true }))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + D", hl.dsp.window.fullscreen())
hl.bind("ALT + F4", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("kitty -e yazi"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. "+ C", hl.dsp.exec_cmd("vesktop"))
hl.bind(mainMod .. "+ L", hl.dsp.exec_cmd("hyprlock"))



-- Rofi Launchers
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/rofi/launchers/launcher.sh"))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/rofi/run/run.sh"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("$HOME/.config/rofi/clipboard/clipboard.sh"))
hl.bind(mainMod .. " + PERIOD", hl.dsp.exec_cmd("$HOME/.config/rofi/emoji/emoji.sh"))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("$HOME/.config/rofi/powermenu/type-2/powermenu.sh"))


hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))

-- Poweroff, Logout, Reboot
hl.bind(mainMod .. " + SHIFT + ALT + P", hl.dsp.exec_cmd("shutdown -h now"))
hl.bind(mainMod .. " + SHIFT + ALT + R", hl.dsp.exec_cmd("reboot"))
hl.bind(mainMod .. " + SHIFT + ALT + L", function()
  hl.dispatch(hl.dsp.exit())
end)

-- Turn off screen
hl.bind(mainMod .. " + SHIFT + ALT + S", hl.dsp.exec_cmd("sleep 1 && hyprctl dispatch dpms off"))

-- Turn on screen
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("sleep 1 && hyprctl dispatch dpms on"))


-- Window settings
hl.bind(mainMod .. "+ S", function()
	hl.dispatch(hl.dsp.window.float({action = "toggle" }))
end)

hl.bind("ALT + Tab", function()
  hl.dispatch(hl.dsp.window.cycle_next())
end)



-- Focus Movement
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

-- Workspaces (1-9)
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = tostring(i) }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = tostring(i) }))
end

-- Window movement / resizing
hl.bind("SUPER + mouse:272", hl.dsp.window.drag())
hl.bind("SUPER + mouse:273", hl.dsp.window.resize())

-- Keyboard window resizing
hl.bind("SUPER + SHIFT + RIGHT",
    hl.dsp.window.resize({ x = 10, y = 0, relative = true }))

hl.bind("SUPER + SHIFT + LEFT",
    hl.dsp.window.resize({ x = -10, y = 0, relative = true }))

hl.bind("SUPER + SHIFT + UP",
    hl.dsp.window.resize({ x = 0, y = -10, relative = true }))

hl.bind("SUPER + SHIFT + DOWN",
    hl.dsp.window.resize({ x = 0, y = 10, relative = true }))


local volume_script = os.getenv("HOME") .. "/.local/bin/volumeslider.sh"

hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd(volume_script .. " 5%+"),
    { locked = true, repeating = true }
)

hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd(volume_script .. " 5%-"),
    { locked = true, repeating = true }
)



-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

