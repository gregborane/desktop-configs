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
local menu = "noctalia-shell ipc call launcher toggle"
local browser = "chromium"
local mainMod = "SUPER"

local activeBorderColor = "rgb(FFFFFF)"
local inactiveBorderColor = "rgb(000000)"

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
	position = "0x0",
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
	position = "1920x0",
	scale = 1,
})

--------------------------------------------------
-- AUTOSTART
--------------------------------------------------

hl.on("hyprland.start", function()
	-- Fixed UWSM spacing syntax
	hl.exec_cmd("uwsm app -- swaybg -i ~/.config/hypr/background.png")
	hl.exec_cmd("uwsm app -- noctalia-shell")
	hl.exec_cmd("uwsm app -- hypridle")
	hl.exec_cmd("uwsm app -- /run/current-system/sw/libexec/polkit-gnome-authentication-agent-1")
end)

--------------------------------------------------
-- ENVIRONMENT
--------------------------------------------------

hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland,x11")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("OZONE_PLATFORM", "wayland")
hl.env("XDG_SESSION_TYPE", "wayland")
-- hl.env("LIBVA_DRIVER_NAME", "nvidia")

-- if os.execute("nvidia-smi") ~= nil then
--    hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
-- end

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")

--------------------------------------------------
-- PERMISSIONS
--------------------------------------------------

-- Nothing to report yet

--------------------------------------------------
-- CONFIG
--------------------------------------------------

hl.config({

	general = {
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},

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
		border_size = 1,

		col = {
			active_border = activeBorderColor,
			inactive_border = inactiveBorderColor,
		},
	},

	decoration = {
		rounding = 5,
		rounding_power = 2,
		active_opacity = 1.00,
		inactive_opacity = 1.00,

		shadow = {
			enabled = false,
		},

		blur = {
			enabled = false,
			size = 5,
			passes = 1,
			vibrancy = 0.7,
		},
	},

	animations = { enabled = false },
})

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "altgr-intl",
		kb_model = "pc105",
		kb_options = "lv3:caps_switch",

		follow_mouse = 1,
		sensitivity = 0,

		touchpad = {
			natural_scroll = true,
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
-- Wrap desktop applications launched via keybinds
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("uwsm app -- " .. terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("uwsm app -- " .. filemanager))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("uwsm app -- " .. browser))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("uwsm app -- " .. menu))

hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("wofi-repos"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))

-- Hyprctl stuffs
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + ALT + M", hl.dsp.exit())
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
local function define_screen()
	for _, v in ipairs(hl.get_monitors()) do
		if v == "eDP-1" then
			return true
		end
	end
	return false
end

if define_screen() then
	hl.bind(mainMod .. " + CTRL + " .. keyboard_keys[1], hl.dsp.window.move({ monitor = "eDP-1" }))
else
	hl.bind(mainMod .. " + CTRL + " .. keyboard_keys[1], hl.dsp.window.move({ monitor = "DP-1" }))
end

hl.bind(mainMod .. " + CTRL + " .. keyboard_keys[2], hl.dsp.window.move({ monitor = "HDMI-A-1" }))

--------------------------------------------------
-- WORKSPACES
--------------------------------------------------

-- Change worskpace
for i = 1, 6 do
	local key = keyboard_keys[i]
	hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Quick switch workspace
hl.bind("CTRL + ALT + left", hl.dsp.focus({ workspace = "m-1" }))
hl.bind("CTRL + ALT + right", hl.dsp.focus({ workspace = "m+1" }))

--------------------------------------------------
-- MOUSE / RESIZE
--------------------------------------------------

-- resize with mouse
hl.bind("ALT + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("ALT + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- resize with keyboard
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })

--------------------------------------------------
-- MEDIA KEYS
--------------------------------------------------

hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s +5%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"), { locked = true, repeating = true })

--------------------------------------------------
-- NOTIFICATIONS / SCREENSHOT
--------------------------------------------------

hl.bind("SUPER + comma", hl.dsp.exec_cmd("noctalia-shell ipc call notifications dismissAll"))
hl.bind("SUPER + SHIFT + comma", hl.dsp.exec_cmd("noctalia-shell ipc call notifications toggleDND"))

hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind("SUPER + S", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))

--------------------------------------------------
-- WORKSPACE RULES
--------------------------------------------------

for i = 1, 6 do
	if 1 <= i and i <= 3 then
		hl.workspace_rule({
			workspace = tostring(i),
			monitor = "HDMI-A-1",
		})
	else
		hl.workspace_rule({
			workspace = tostring(i),
			monitor = "eDP-1",
		})
	end

	hl.workspace_rule({
		workspace = tostring(i),
		persistent = true,
	})
end

--------------------------------------------------
-- WINDOW RULES
--------------------------------------------------

function hl.window(match, rules)
	rules.match = rules.match or {}

	if type(match) == "string" then
		rules.match.class = match
	else
		for key, value in pairs(match) do
			rules.match[key] = value
		end
	end

	hl.window_rule(rules)
end

hl.window({ tag = "floating-window" }, {
	float = true,
	center = true,
	size = { 950, 800 },
})

hl.window("(com.Util)", { tag = "+floating-window" })

hl.window("steam", {
	float = true,
	idle_inhibit = "fullscreen",
})

hl.window({
	class = "steam",
	title = "Steam",
}, {
	center = true,
	size = { 1100, 700 },
})

hl.window("steam.*", {
	tag = "-default-opacity",
})
hl.window({
	class = "steam",
	title = "Friends List",
}, {
	size = { 460, 800 },
})
