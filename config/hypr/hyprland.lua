-- ~/.config/hypr/hyprland.l })
--
require("binds")


local function is_laptop()
    local f = io.open("/sys/class/dmi/id/chassis_type", "r")
    if not f then
        return false
    end

    local chassis = tonumber(f:read("*l"))
    f:close()

    return chassis == 9
        or chassis == 10
        or chassis == 14
        or chassis == 31
        or chassis == 32
end

if is_laptop() then

    hl.workspace_rule({
        workspace = "1",
        monitor = "eDP-1",
        default = true,
    })

    hl.monitor({
        output = "desc:Samsung Electric Company SAMSUNG 0x01000E00",
        mode = "1920x1080@60",
        position = "0x0",
        scale = 1,
    })

else

    hl.workspace_rule({
        workspace = "1",
        monitor = "desc:Shenzhen KTC Technology Group H27E22P",
        default = true,
    })

    hl.workspace_rule({
        workspace = "2",
        monitor = "desc:Acer Technologies KG241Q P 0x0261C41A",
        default = true,
    })

    hl.workspace_rule({
        workspace = "3",
        monitor = "desc:Samsung Electric Company SAMSUNG 0x01000E00",
        default = true,
    })

    hl.monitor({
        output = "desc:Samsung Electric Company SAMSUNG 0x01000E00",
        mode = "3840x2160@30",
        position = "0x0",
        scale = 1,
    })

    hl.monitor({
        output = "desc:Shenzhen KTC Technology Group H27E22P",
        mode = "1920x1080@280",
        position = "0x2160",
        scale = 1,
    })

    hl.monitor({
        output = "desc:Acer Technologies KG241Q P 0x0261C41A",
        mode = "1920x1080@143.85",
        position = "1920x2160",
        scale = 1,
    })

    end

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprlock")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("dunst -conf ~/.config/dunst/dunstrc")
    hl.exec_cmd("hypridle")
end)

hl.env("XCURSOR_SIZE", "3")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("BROWSER", "firefox")

-- ============================================================
-- GENERAL
-- ============================================================

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 3,

        col = {
            active_border = "rgb(D399A1)",
            inactive_border = "rgb(1a1a1a)",
        },

        layout = "dwindle",
    },

    -- ========================================================
    -- DECORATION
    -- ========================================================

    decoration = {
        rounding = 4,

        active_opacity = 1.0,
        inactive_opacity = 0.9,

        blur = {
            enabled = true,
            size = 10,
            passes = 1,
            new_optimizations = true,
        },

        shadow = {
            enabled = true,
            range = 2,
            offset = { 2, 2 },
            render_power = 2,
            color = "0x66000000",
        },
    },

    -- ========================================================
    -- ANIMATIONS
    -- ========================================================

    animations = {
        enabled = true,

    },

    -- ========================================================
    -- DWINDLE
    -- ========================================================

    dwindle = {
        preserve_split = true,
    },

    -- ========================================================
    -- MASTER
    -- ========================================================

    master = {
        new_status = "master",
        new_on_top = true,
    },
  })
-- ============================================================
-- ANIMATION CURVES
-- ============================================================

hl.curve("wind", {
    type = "bezier",
    points = {
        { 0.05, 0.9 },
        { 0.1, 1.05 },
    },
})

hl.curve("winIn", {
    type = "bezier",
    points = {
        { 0.1, 1.1 },
        { 0.1, 1.1 },
    },
})

hl.curve("winOut", {
    type = "bezier",
    points = {
        { 0.3, -0.3 },
        { 0, 1 },
    },
})

hl.curve("linear", {
    type = "bezier",
    points = {
        { 1, 1 },
        { 1, 1 },
    },
})

hl.curve("Cubic", {
    type = "bezier",
    points = {
        { 0.1, 0.1 },
        { 0.1, 1 },
    },
})

hl.curve("overshot", {
    type = "bezier",
    points = {
        { 0.05, 0.9 },
        { 0.1, 1.1 },
    },
})

hl.curve("ease-in-out", {
    type = "bezier",
    points = {
        { 0.17, 0.67 },
        { 0.83, 0.67 },
    },
})

hl.curve("ease-in", {
    type = "bezier",
    points = {
        { 0.17, 0.67 },
        { 0.83, 0.67 },
    },
})

hl.curve("ease-out", {
    type = "bezier",
    points = {
        { 0.42, 0 },
        { 1, 1 },
    },
})

hl.curve("easeInOutSine", {
    type = "bezier",
    points = {
        { 0.37, 0 },
        { 0.63, 1 },
    },
})

hl.curve("easeInSine", {
    type = "bezier",
    points = {
        { 0.12, 0 },
        { 0.39, 0 },
    },
})

hl.curve("easeOutSine", {
    type = "bezier",
    points = {
        { 0.61, 1 },
        { 0.88, 1 },
    },
})

-- ============================================================
-- ANIMATIONS
-- ============================================================

hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 3,
    bezier = "easeInOutSine",
    style = "popin",
})

hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 3,
    bezier = "easeInOutSine",
    style = "popin",
})

hl.animation({
    leaf = "border",
    enabled = true,
    speed = 3,
    bezier = "easeInOutSine",
})

hl.animation({
    leaf = "borderangle",
    enabled = true,
    speed = 30,
    bezier = "easeInOutSine",
    loop = true,
})

hl.animation({
    leaf = "workspacesIn",
    enabled = true,
    speed = 3,
    bezier = "easeInOutSine",
    style = "slidefade",
})

hl.animation({
    leaf = "workspacesOut",
    enabled = true,
    speed = 3,
    bezier = "easeInOutSine",
    style = "slidefade",
})

hl.animation({
    leaf = "specialWorkspaceIn",
    enabled = true,
    speed = 3,
    bezier = "easeInOutSine",
    style = "slidevert",
})

hl.animation({
    leaf = "specialWorkspaceOut",
    enabled = true,
    speed = 3,
    bezier = "easeInOutSine",
    style = "slidevert",
})

hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = 3,
    bezier = "easeInOutSine",
    style = "fade",
})

hl.animation({
    leaf = "layersOut",
    enabled = true,
    speed = 3,
    bezier = "easeInOutSine",
    style = "fade",
})



