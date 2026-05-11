--  #######################################################################################
--
--  ██   ██╗██╗██╗
--  ╚██ ██╔╝██║██║
--   ╚███═╝ ██║██║
--   ██╔██╗ ██║██║
--  ██╔╝ ██╗██║██║
--  ╚═╝  ╚═╝╚═╝╚═╝
--
--  One config to rule all my computers.
--
--  #######################################################################################

--------------------------------------------------
-- VARIABLES
--------------------------------------------------

local terminal = "ghostty"
local filemanager = "nemo"
local menu = "wofi"
local browser = "chromium"
local mainMod = "SUPER"

local activeBorderColor = "rgb(FFFFFF)"
local inactiveBorderColor = "rgb(000000)"

local osdclient = [[swayosd-client --monitor "$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')"]]

local keyboard_keys = {
	"ampersand",
	"eacute",
	"quotedbl",
	"apostrophe",
	"parenleft",
	"minus",
	"egrave",
	"underscore",
	"ccedilla",
	"agrave",
}

--------------------------------------------------
-- MONITORS
--------------------------------------------------

hl.monitor({
	output = "DP-1",
	mode = "2560x1440@144",
	position = "auto",
	scale = 1,
})
hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@60",
	position = "0x0",
	scale = 1,
})
hl.monitor({
	output = "HDMI-A-1",
	mode = "1920x1080@60",
	position = "0x-1080",
	scale = 1,
})

--------------------------------------------------
-- AUTOSTART
--------------------------------------------------

hl.on("hyprland.start", function()
	hl.exec_cmd("uwsm-app -- swaybg -i ~/.config/hypr/himeno1.png")
	hl.exec_cmd("uwsm-app -- mako")
	hl.exec_cmd("uwsm-app -- waybar")
	hl.exec_cmd("uwsm-app -- swayosd-server")
	hl.exec_cmd("uwsm-app -- hypridle")
	hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
end)

--------------------------------------------------
-- ENVIRONMENT
--------------------------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland,x11")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("OZONE_PLATFORM", "wayland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XCOMPOSEFILE", "~/.XCompose")

--------------------------------------------------
-- PERMISSIONS
--------------------------------------------------

-- Nothing to report yet

--------------------------------------------------
-- CONFIG
--------------------------------------------------

hl.config({

	xwayland = {
		enabled = true,
		force_zero_scaling = true,
	},
	render = {
		direct_scanout = 0,
	},
})

hl.config({
	general = {
		gaps_in = 1,
		gaps_out = 2,
		border_size = 2,

		col = {
			active_border = activeBorderColor,
			inactive_border = inactiveBorderColor,
		},

		resize_on_border = false,

		allow_tearing = false,

		layout = "dwindle",
	},

	decoration = {
		rounding = 5,
		rounding_power = 2,
		active_opacity = 1.0,
		inactive_opacity = 0.95,

		shadow = {
			enabled = false,
		},

		blur = {
			enabled = true,
			size = 5,
			passes = 1,
			vibrancy = 0.7,
		},
	},

	animations = { enabled = false },
})

hl.config({
	input = {
		kb_layout = "fr",
		kb_variant = "",
		kb_model = "pc105",
		kb_options = "compose:caps",

		follow_mouse = 1,
		sensitivity = 0,

		touchpad = {
			natural_scroll = false,
		},
	},

	cursor = { hide_on_key_press = true },
})

--------------------------------------------------
-- GESTURES
--------------------------------------------------

-- Nothing to report yet

--------------------------------------------------
-- BINDS
--------------------------------------------------

-- Quick launch app
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(filemanager))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("wofi-scripts"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("wofi-repos"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

-- Hyprctl stuffs
hl.bind(mainMod .. " + Q", hl.dsp.window.kill())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

--------------------------------------------------
-- Windows
--------------------------------------------------

-- Switch focus between windows
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch places between windows
hl.bind(mainMod .. " + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.window.move({ direction = "down" }))

-- Quick switch between windows
hl.bind("ALT + Tab", hl.dsp.window.cycle_next())

-- Move windows to screen
hl.bind(mainMod .. " + CTRL + " .. keyboard_keys[1], hl.dsp.window.move({ monitor = "DP-1" }))
hl.bind(mainMod .. " + CTRL + " .. keyboard_keys[1], hl.dsp.window.move({ monitor = "eDP-1" }))
hl.bind(mainMod .. " + CTRL + " .. keyboard_keys[2], hl.dsp.window.move({ monitor = "HDMI-A-1" }))

--------------------------------------------------
-- WORKSPACES
--------------------------------------------------

-- Change worskpace

for i = 1, 9 do
	local key = keyboard_keys[i]
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + " .. keyboard_keys[10], hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. " + SHIFT + " .. keyboard_keys[10], hl.dsp.window.move({ workspace = 10 }))

-- Quick switch workspace
hl.bind("CTRL + ALT + left", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("CTRL + ALT + right", hl.dsp.focus({ workspace = "e+1" }))

--------------------------------------------------
-- MOUSE / RESIZE
--------------------------------------------------

-- resize with mouse
hl.bind("ALT + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("ALT + mouse:272", hl.dsp.window.resize(), { mouse = true })

-- resize with keyboard
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 30, y = 0 }))
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.resize({ x = -30, y = 0 }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.resize({ x = 0, y = 30 }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.resize({ x = 0, y = -30 }))

--------------------------------------------------
-- MEDIA KEYS
--------------------------------------------------

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(osdclient .. " --output-volume raise"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(osdclient .. " --output-volume lower"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(osdclient .. " --output-volume mute-toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(osdclient .. " --input-volume mute-toggle"))

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(osdclient .. " --brightness raise"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(osdclient .. " --brightness lower"))

hl.bind("XF86AudioNext", hl.dsp.exec_cmd(osdclient .. " --playerctl next"))

hl.bind("XF86AudioPause", hl.dsp.exec_cmd(osdclient .. " --playerctl play-pause"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(osdclient .. " --playerctl play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(osdclient .. " --playerctl previous"))

--------------------------------------------------
-- NOTIFICATIONS / SCREENSHOT
--------------------------------------------------

hl.bind(mainMod .. " + COMMA", hl.dsp.exec_cmd("makoctl dismiss"))
hl.bind(mainMod .. " + SHIFT + COMMA", hl.dsp.exec_cmd("makoctl dismiss --all"))
hl.bind(
	mainMod .. " + COMMA",
	hl.dsp.exec_cmd(
		[[makoctl mode -t do-not-disturb && makoctl mode | grep -q 'do-not-disturb' && notify-send "Silenced notifications" || notify-send "Enabled notifications"]]
	)
)
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))

--------------------------------------------------
-- WINDOW RULES
--------------------------------------------------

--[[
hl.windowrule("float on", "match:tag floating-window")
hl.windowrule("center on", "match:tag floating-window")
hl.windowrule("size 950 800", "match:tag floating-window")

hl.windowrule("tag +floating-window", "match:class (com.Bluetui|com.Nmtui|com.Wiremix|com.Btop|com.Batty)")

hl.windowrule("float on", "match:class steam")
hl.windowrule("center on", "match:class steam, match:title Steam")
hl.windowrule("opacity 1 1", "match:class steam")
hl.windowrule("size 1100 700", "match:class steam, match:title Steam")
hl.windowrule("size 460 800", "match:class steam, match:title Friends List")
hl.windowrule("idle_inhibit fullscreen", "match:class steam")
]]
