/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx       = 3;   /* border pixel of windows */
static const unsigned int gappx          = 6;   /* gaps between windows */
static const unsigned int snap           = 32;  /* snap pixel */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft  = 0;   /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on first monitor, False: display on last monitor*/
static const int showsystray             = 1;   /* 0 means no systray */
static const int showbar                 = 1;   /* 0 means no bar */
static const int topbar                  = 1;   /* 0 means bottom bar */
static const int vertpad                 = 10;  /* vertical padding of bar */
static const int sidepad                 = 10;  /* horizontal padding of bar */
static const char *fonts[]               = { "monospace:size=10" };
static const char dmenufont[]            = "monospace:size=10";

/* Colors */
static const char col_white[]            = "#ffffff";
static const char col_black[]            = "#000000";

static const char *colors[][3]           = {
	/*               fg          bg          border   */
	[SchemeNorm] = { col_white, col_black, col_black },
	[SchemeSel]  = { col_black, col_white, col_white },
};

/* tagging */
static const char *tags[] = { "1", "1", "2", "3", "5"};

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            0,          -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[T]",      tile },    /* first entry is default */
	{ "[W]",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

static void
view_adjacent(const Arg *arg) {
    int i;
    for (i = 0; !(selmon->tagset[selmon->seltags] & (1 << i)); i++);
    i += arg->i;
    if (i >= LENGTH(tags)) i = 0;
    if (i < 0) i = LENGTH(tags) - 1;

    const Arg a = {.ui = 1 << i};
    view(&a);
}

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { 
	"dmenu_run", 
	"-m", 
	dmenumon, 
	"-fn", 
	dmenufont, 
	"-nb", 
	col_black, 
	"-nf", 
	col_white, 
	"-sb", 
	col_white, 
	"-sf", 
	col_black, 
	NULL };

static const char *termcmd[] = { 
	"alacritty", 
	NULL };

static const char *rofi[] = {
	"rofi",
    	"-show", "drun",
    	"-modi", "drun,calc,top",
    	"-run-command", "/home/greg/.config/rofi/rofi-drun.sh {cmd}",
    	NULL
};

static const char *i3lock[] = {
	"/home/greg/.dwm/lock.sh",
	NULL };

static const char *flameshot[] = {
	"flameshot", 
	"gui", 
	NULL};

static const char *brightness[] = {
	"brightness", 
	NULL};

static const char *pavuctll[] = {
	"pavucontrol", 
	NULL};

static const Key keys[] = {
	/* modifier                     key                         function        argument */
	{ MODKEY|ShiftMask,		XK_s,			    spawn,          {.v = pavuctll } },
	{ MODKEY|ShiftMask,		XK_b,			    spawn, 	    {.v = brightness } },
	{ MODKEY,                       XK_c,                       spawn,          {.v = rofi } },
	{ MODKEY,                       XK_t,                       spawn,          {.v = termcmd } },
	{ MODKEY,			XK_l,                       spawn,          {.v = i3lock } },
	{ MODKEY,                       XK_i,                       incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,                       incnmaster,     {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_Left,                    setmfact,       {.f = -0.05} },
	{ MODKEY|ShiftMask,             XK_Right,                   setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Left,                    focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_Right,                   focusstack,     {.i = -1 } },
	{ 0,				XK_Print, 		    spawn,	    {.v = flameshot } },
	{ MODKEY,                       XK_f,       		    togglefullscr,  {0} },
	{ ControlMask|Mod1Mask,         XK_Right,                   view_adjacent,  {.i = +1 } },
	{ ControlMask|Mod1Mask,         XK_Left,                    view_adjacent,  {.i = -1 } },
	{ MODKEY,                       XK_Return,                  zoom,           {0} },
	{ MODKEY,                       XK_Tab,                     view,           {0} },
	{ MODKEY,                       XK_q,      	            killclient,     {0} },
	{ MODKEY|ShiftMask,             XK_Return, 		    setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      		    setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,                       setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  		    setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  		    togglefloating, {0} },
	{ MODKEY,                       XK_0,      		    view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      		    tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  		    focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period,                  focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  		    tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, 		    tagmon,         {.i = +1 } },
	{ MODKEY,                       XK_minus,  		    setgaps,        {.i = -1 } },
	{ MODKEY,                       XK_equal,  		    setgaps,        {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_equal,  		    setgaps,        {.i = 0  } },
	TAGKEYS(                        XK_ampersand,                       0)
	TAGKEYS(                        XK_eacute,                          1)
	TAGKEYS(                        XK_quotedbl,                        2)
	TAGKEYS(                        XK_apostrophe,                      3)
	TAGKEYS(                        XK_parenleft,                       4)
	{ MODKEY|ShiftMask,             XK_m,    		    quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

