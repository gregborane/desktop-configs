static const char *colorname[NUMCOLS] = {
	[BG]     = "black",     /* BACKGROUND */
	[INIT]   = "4f525c",    /* after initialization */
	[INPUT]  = "#ffffff",   /* during input */
	[FAILED] = "#CC3333",   /* wrong password */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;

/* size of square in px */
static const int squaresize = 30;
static const int squarespacing = 5;

/* Patch : Message */
#include <stdio.h>
#include <stdlib.h>

char msg[128];
static char *message;

static const char * text_color = "#ffffff"; /* color */
static const char * font_name = "-misc-spleen-medium-r-normal--64-640-72-72-c-320-iso10646-1";     /* font to choose */

/* Patch : DPMS auto turn off screen */
static const int monitortime = 60;

/* Patch : background */
static const char* background_image = "/home/greg/.config/lock.png";

/* Patch: auto-timeout */

/* should [command] be run only once? */
static const int runonce = 0;

/* length of time (seconds) until [command] is executed */
static const int timeoffset = 30;

/* command to be run after [timeoffset] seconds has passed */
static const char *command = "/usr/bin/xset dpms force off";
