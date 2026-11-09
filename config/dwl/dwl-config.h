/* Taken from https://github.com/djpohly/dwl/issues/466 */
#define COLOR(hex)    { ((hex >> 24) & 0xFF) / 255.0f, \
                        ((hex >> 16) & 0xFF) / 255.0f, \
                        ((hex >> 8) & 0xFF) / 255.0f, \
                        (hex & 0xFF) / 255.0f }
/* appearance */
static const int          sloppyfocus               = 1;  /* focus follows mouse */
static const int          bypass_surface_visibility = 0;  /* 1 means idle inhibitors will disable idle tracking even if it's surface isn't visible  */
static const unsigned int borderpx                  = 1;  /* border pixel of windows */
static const float        rootcolor[]               = COLOR(0x222222ff);
static const float        bordercolor[]             = COLOR(0x000000ff);
static const float        focuscolor[]              = COLOR(0xffffffff);
static const float        urgentcolor[]             = COLOR(0xff5555ff);
/* This conforms to the xdg-protocol. Set the alpha to zero to restore the old behavior */
static const float        fullscreen_bg[]           = {0.0f, 0.0f, 0.0f, 1.0f}; /* You can also use glsl colors */

/* tagging - TAGCOUNT must be no greater than 31 */
#define TAGCOUNT (6)

/* logging */
static int log_level = WLR_ERROR;

static const Rule rules[] = {
	{ "steam", NULL, 0, 1, -1 },
	{ "com.Util", NULL, 0, 1, -1 },
};

/* layout(s) */
static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },
	
	{ "[M]",      monocle },
};

/* monitors */
/* (x=-1, y=-1) is reserved as an "autoconfigure" monitor position indicator
 * WARNING: negative values other than (-1, -1) cause problems with Xwayland clients due to
 * https://gitlab.freedesktop.org/xorg/xserver/-/issues/899 */
static const MonitorRule monrules[] = {
   /* name        mfact  nmaster scale layout       rotate/reflect                x    y
    * example of a HiDPI laptop monitor:
    { "eDP-1",    0.5f,  1,      2,    &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL,   -1,  -1 }, */
	{ "eDP-1",    0.55f, 1,      1,    &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL,    0,   0 },
	{ NULL,       0.55f, 1,      1,    &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL,   -1,  -1 },
	/* default monitor rule: can be changed but cannot be eliminated; at least one monitor rule must exist */
};

/* keyboard */
static const struct xkb_rule_names xkb_rules = {
	.layout = "us", .variant = "altgr-intl", .model = "pc105", .options = "lv3:caps_switch",
};

static const int repeat_rate = 25;
static const int repeat_delay = 600;

/* Trackpad */
static const int tap_to_click = 1;
static const int tap_and_drag = 1;
static const int drag_lock = 1;
static const int natural_scrolling = 1;
static const int disable_while_typing = 1;
static const int left_handed = 0;
static const int middle_button_emulation = 0;
/* You can choose between:
LIBINPUT_CONFIG_SCROLL_NO_SCROLL
LIBINPUT_CONFIG_SCROLL_2FG
LIBINPUT_CONFIG_SCROLL_EDGE
LIBINPUT_CONFIG_SCROLL_ON_BUTTON_DOWN
*/
static const enum libinput_config_scroll_method scroll_method = LIBINPUT_CONFIG_SCROLL_2FG;

/* You can choose between:
LIBINPUT_CONFIG_CLICK_METHOD_NONE
LIBINPUT_CONFIG_CLICK_METHOD_BUTTON_AREAS
LIBINPUT_CONFIG_CLICK_METHOD_CLICKFINGER
*/
static const enum libinput_config_click_method click_method = LIBINPUT_CONFIG_CLICK_METHOD_BUTTON_AREAS;

/* You can choose between:
LIBINPUT_CONFIG_SEND_EVENTS_ENABLED
LIBINPUT_CONFIG_SEND_EVENTS_DISABLED
LIBINPUT_CONFIG_SEND_EVENTS_DISABLED_ON_EXTERNAL_MOUSE
*/
static const uint32_t send_events_mode = LIBINPUT_CONFIG_SEND_EVENTS_ENABLED;

/* You can choose between:
LIBINPUT_CONFIG_ACCEL_PROFILE_FLAT
LIBINPUT_CONFIG_ACCEL_PROFILE_ADAPTIVE
*/
static const enum libinput_config_accel_profile accel_profile = LIBINPUT_CONFIG_ACCEL_PROFILE_ADAPTIVE;
static const double accel_speed = 0.0;

/* You can choose between:
LIBINPUT_CONFIG_TAP_MAP_LRM -- 1/2/3 finger tap maps to left/right/middle
LIBINPUT_CONFIG_TAP_MAP_LMR -- 1/2/3 finger tap maps to left/middle/right
*/
static const enum libinput_config_tap_button_map button_map = LIBINPUT_CONFIG_TAP_MAP_LRM;

/* Six single-tag views, with a name-based preference independent of output discovery order. */
static Monitor *
namedmonitor(const char *name)
{
	Monitor *m;
	wl_list_for_each(m, &mons, link)
		if (m->wlr_output->enabled && !strcmp(m->wlr_output->name, name))
			return m;
	return NULL;
}

static Monitor *
tagoutput(unsigned int mask)
{
	Monitor *panel = namedmonitor("eDP-1"), *hdmi = namedmonitor("HDMI-A-1");
	return (mask & 7) && hdmi ? hdmi : panel ? panel : hdmi ? hdmi : selmon;
}

static void
viewpreferred(const Arg *arg)
{
	Monitor *m = tagoutput(arg->ui);
	if (!m)
		return;
	selmon = m;
	view(arg);
	focusclient(focustop(m), 1);
	printstatus();
}

static void
sendpreferred(const Arg *arg)
{
	Client *c = focustop(selmon);
	Monitor *m = tagoutput(arg->ui);
	if (!c || !m)
		return;
	if (c->mon == m)
		tag(arg);
	else
		setmon(c, m, arg->ui);
	printstatus();
}

static void
redistributetags(void)
{
	Monitor *panel = namedmonitor("eDP-1"), *hdmi = namedmonitor("HDMI-A-1");
	Client *c;
	if (!panel || !hdmi)
		return;
	if (panel->tagset[panel->seltags] & 7)
		panel->tagset[panel->seltags] = 1U << 3;
	wl_list_for_each(c, &clients, link) {
		Monitor *m = tagoutput(c->tags);
		if (c->mon && c->tags && !(c->tags & (c->tags - 1)) && c->mon != m)
			setmon(c, m, c->tags);
	}
	arrange(panel);
	arrange(hdmi);
	focusclient(focustop(selmon), 1);
	printstatus();
}

static void
cyclelocal(const Arg *arg)
{
	unsigned int i, current = 0;
	if (!selmon)
		return;
	while (current < TAGCOUNT && !(selmon->tagset[selmon->seltags] & (1U << current)))
		current++;
	for (i = 1; i <= TAGCOUNT; i++) {
		int next = ((int)current + TAGCOUNT + arg->i * (int)i) % TAGCOUNT;
		unsigned int mask = 1U << next;
		if (tagoutput(mask) == selmon) {
			view(&(Arg){.ui = mask});
			return;
		}
	}
}

enum Direction { Left, Right, Up, Down };
static Client *
neighbor(Client *c, int dir, int tiled)
{
	Client *other, *best = NULL;
	double bestdist = HUGE_VAL;
	wl_list_for_each(other, &clients, link) {
		if (other == c || !VISIBLEON(other, selmon) || (tiled && other->isfloating))
			continue;
		double dx = other->geom.x - c->geom.x + (other->geom.width - c->geom.width) / 2.0;
		double dy = other->geom.y - c->geom.y + (other->geom.height - c->geom.height) / 2.0;
		double forward = dir == Left ? -dx : dir == Right ? dx : dir == Up ? -dy : dy;
		double cross = dir == Left || dir == Right ? fabs(dy) : fabs(dx);
		if (forward <= 0 || cross > forward)
			continue;
		double distance = forward * forward + cross * cross;
		if (distance < bestdist) {
			bestdist = distance;
			best = other;
		}
	}
	return best;
}

static void
focusdir(const Arg *arg)
{
	Client *c = focustop(selmon);
	if (c && !c->isfullscreen) {
		Client *other = neighbor(c, arg->i, 0);
		if (other)
			focusclient(other, 1);
	}
}

static void
movedir(const Arg *arg)
{
	Client *c = focustop(selmon), *other;
	struct wl_list anchor;
	if (!c || c->isfullscreen)
		return;
	if (c->isfloating) {
		struct wlr_box box = c->geom;
		box.x += 30 * ((arg->i == Right) - (arg->i == Left));
		box.y += 30 * ((arg->i == Down) - (arg->i == Up));
		resize(c, box, 0);
		return;
	}
	other = neighbor(c, arg->i, 1);
	if (!other)
		return;
	/* The temporary anchor also handles adjacent clients in either order. */
	wl_list_insert(&c->link, &anchor);
	wl_list_remove(&c->link);
	wl_list_insert(&other->link, &c->link);
	wl_list_remove(&other->link);
	wl_list_insert(&anchor, &other->link);
	wl_list_remove(&anchor);
	arrange(selmon);
	focusclient(c, 1);
	printstatus();
}

/* Resize a stack row against its next sibling, or its previous sibling at the bottom. */
static void
resizestack(Client *selected, int delta)
{
	Client *c, *previous = NULL, *next = NULL;
	int seen = 0, count = 0;
	wl_list_for_each(c, &clients, link) {
		if (!VISIBLEON(c, selmon) || c->isfloating || c->isfullscreen)
			continue;
		if (++count <= selmon->nmaster)
			continue;
		if (c == selected)
			seen = 1;
		else if (seen && !next)
			next = c;
		else if (!seen)
			previous = c;
	}
	if (!seen || (!next && !previous))
		return;
	Client *sibling = next ? next : previous;
	int minheight = (int)(2 * selected->bw + 1);
	int siblingmin = (int)(2 * sibling->bw + 1);
	delta = MAX(minheight - selected->geom.height, MIN(delta, sibling->geom.height - siblingmin));
	if (!delta)
	return;
	/* Current pixel heights sum to the column's usable height. Updating the pair
	 * keeps other rows the same size and retains the ratio when outputs resize. */
	count = 0;
	wl_list_for_each(c, &clients, link)
		if (VISIBLEON(c, selmon) && !c->isfloating && !c->isfullscreen && ++count > selmon->nmaster)
			c->stackweight = MAX(1, c->geom.height);
	selected->stackweight += delta;
	sibling->stackweight -= delta;
	arrange(selmon);
}

static void
resizekey(const Arg *arg)
{
	Client *c = focustop(selmon);
	int width = (arg->i == Right) - (arg->i == Left);
	int height = (arg->i == Up) - (arg->i == Down);
	if (!c || c->isfullscreen)
		return;
	if (c->isfloating) {
		struct wlr_box box = c->geom;
		box.width = MAX(1, box.width + 30 * width);
		box.height = MAX(1, box.height + 30 * height);
		resize(c, box, 0);
	} else if (height && selmon->lt[selmon->sellt]->arrange == tile) {
		resizestack(c, 30 * height);
	} else if (width && selmon->w.width > 0 && selmon->lt[selmon->sellt]->arrange == tile) {
		Client *first;
		wl_list_for_each(first, &clients, link) {
			if (VISIBLEON(first, selmon) && !first->isfloating && !first->isfullscreen) {
				setmfact(&(Arg){.f = (first == c ? width : -width) * 30.0f / selmon->w.width});
				break;
			}
		}
	}
}

#define SUPER WLR_MODIFIER_LOGO
#define SHIFT WLR_MODIFIER_SHIFT
#define ALT   WLR_MODIFIER_ALT
#define CTRL  WLR_MODIFIER_CTRL
#define SHELL(cmd) {.v = (const char *[]) {"/bin/sh", "-c", cmd, NULL}}
#define PREFKEY(n, shifted, index) \
	{SUPER,       XKB_KEY_##n,       viewpreferred, {.ui = 1U << index}}, \
	{SUPER|SHIFT, XKB_KEY_##shifted, sendpreferred, {.ui = 1U << index}}

static const Key keys[] = {
	{SUPER,            XKB_KEY_Return,                spawn,            SHELL("xdg-terminal-exec")},
	{SUPER,            XKB_KEY_b,                     spawn,            SHELL("xdg-filemanager-exec")},
	{SUPER,            XKB_KEY_y,                     spawn,            SHELL("xdg-browser-exec")},
	{SUPER,            XKB_KEY_space,                 spawn,            SHELL("noctalia msg panel-toggle launcher")},
	{SUPER,            XKB_KEY_r,                     spawn,            SHELL("wofi-repos")},
	{SUPER|SHIFT,      XKB_KEY_l,                     spawn,            SHELL("noctalia msg session lock")},
	{SUPER,            XKB_KEY_c,                     spawn,            SHELL("wl-copy < \"$HOME/Documents/PhD/papers/prompt.md\"")},
	{SUPER|ALT,        XKB_KEY_m,                     spawn,            SHELL("noctalia msg session logout")},
	{SUPER,            XKB_KEY_comma,                 spawn,            SHELL("noctalia msg notification-clear-active")},
	{SUPER|SHIFT,      XKB_KEY_less,                  spawn,            SHELL("noctalia msg notification-dnd-toggle")},
	{0,                XKB_KEY_Print,                 spawn,            SHELL("noctalia msg screenshot-region")},
	{SUPER,            XKB_KEY_s,                     spawn,            SHELL("noctalia msg screenshot-region")},
	{0,                XKB_KEY_XF86AudioRaiseVolume,  spawn,            SHELL("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")},
	{0,                XKB_KEY_XF86AudioLowerVolume,  spawn,            SHELL("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")},
	{0,                XKB_KEY_XF86AudioMute,         spawn,            SHELL("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")},
	{0,                XKB_KEY_XF86AudioMicMute,      spawn,            SHELL("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")},
	{0,                XKB_KEY_XF86MonBrightnessUp,   spawn,            SHELL("brightnessctl s +5%")},
	{0,                XKB_KEY_XF86MonBrightnessDown, spawn,            SHELL("brightnessctl s 5%-")},
	{SUPER,            XKB_KEY_q,                     killclient,       {0}},
	{SUPER,            XKB_KEY_t,                     togglefloating,   {0}},
	{SUPER,            XKB_KEY_f,                     togglefullscreen, {0}},
	{SUPER|SHIFT,      XKB_KEY_j,                     setlayout,        {0}},
	{ALT,              XKB_KEY_Tab,                   focusstack,       {.i = 1}},
	{SUPER|CTRL,       XKB_KEY_Return,                zoom,             {0}},
	{SUPER|CTRL|SHIFT, XKB_KEY_q,                     quit,             {0}},
	{CTRL|ALT,         XKB_KEY_Left,                  cyclelocal,       {.i = -1}},
	{CTRL|ALT,         XKB_KEY_Right,                 cyclelocal,       {.i = 1}},
	{SUPER,            XKB_KEY_Left,                  focusdir,         {.i = Left}},
	{SUPER,            XKB_KEY_h,                     movedir,          {.i = Left}},
	{SUPER|SHIFT,      XKB_KEY_Left,                  resizekey,        {.i = Left}},
	{SUPER,            XKB_KEY_Right,                 focusdir,         {.i = Right}},
	{SUPER,            XKB_KEY_j,                     movedir,          {.i = Right}},
	{SUPER|SHIFT,      XKB_KEY_Right,                 resizekey,        {.i = Right}},
	{SUPER,            XKB_KEY_Up,                    focusdir,         {.i = Up}},
	{SUPER,            XKB_KEY_k,                     movedir,          {.i = Up}},
	{SUPER|SHIFT,      XKB_KEY_Up,                    resizekey,        {.i = Up}},
	{SUPER,            XKB_KEY_Down,                  focusdir,         {.i = Down}},
	{SUPER,            XKB_KEY_l,                     movedir,          {.i = Down}},
	{SUPER|SHIFT,      XKB_KEY_Down,                 resizekey,         {.i = Down}},

	PREFKEY(1, exclam, 0),
	PREFKEY(2, at, 1),
	PREFKEY(3, numbersign, 2),
	PREFKEY(4, dollar, 3),
	PREFKEY(5, percent, 4),
	PREFKEY(6, asciicircum, 5),

#define CHVT(n) {CTRL|ALT, XKB_KEY_XF86Switch_VT_##n, chvt, {.ui = n}}
	CHVT(1), CHVT(2), CHVT(3), CHVT(4), CHVT(5), CHVT(6),
	CHVT(7), CHVT(8), CHVT(9), CHVT(10), CHVT(11), CHVT(12),
};
static const Button buttons[] = {
	{ALT, BTN_LEFT,  moveresize, {.ui = CurMove}},
	{ALT, BTN_RIGHT, moveresize, {.ui = CurResize}},
};
