/*
 *    Copyright (C) 1987, 1988 Chuck Simmons
 * 
 * See the file COPYING, distributed with empire, for restriction
 * and warranty information.
 */

/*
main.c -- parse command line for empire

options:

    -w water: percentage of map that is water.  Must be in the range
              10..90.  Default is 70.
	      
    -s smooth: amount of smoothing performed to generate map.  Must
	       be a nonnegative integer.  Default is 5.
	       
    -d delay:  number of milliseconds to delay between output.
               default is 500 (0.5 seconds).

    -S saveinterval: sets turn interval between saves.
	       default is 10
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "empire.h"
#include "extern.h"

#define OPTFLAGS "w:s:d:S:f:"

int main(argc, argv)
int argc;
char *argv[];
{
    int c;
    extern char *optarg;
    extern int optind;
    int errflg = 0;
    int wflg, sflg, dflg, Sflg;
    int land;
	
    wflg = 70; /* set defaults */
    sflg = 5;
    dflg = 500;
    Sflg = 10;
    game.savefile = "empsave.dat";

    /*
     * extract command line options
     */

    while ((c = getopt (argc, argv, OPTFLAGS)) != EOF) {
	switch (c) {
	case 'w':
	    wflg = atoi (optarg);
	    break;
	case 's':
	    sflg = atoi (optarg);
	    break;
	case 'd':
	    dflg = atoi (optarg);
	    break;
	case 'S':
	    Sflg = atoi (optarg);
	    break;
	case 'f':
	    game.savefile = optarg;
	    break;
	case '?': /* illegal option? */
	    errflg++;
	    break;
	}
    }
    if (errflg || (argc-optind) != 0) {
	(void) printf ("empire: usage: empire [-w water] [-s smooth] [-d delay]\n");
	exit (1);
    }

    if (wflg < 10 || wflg > 90) {
	(void) printf ("empire: -w argument must be in the range 10..90.\n");
	exit (1);
    }
    if (sflg < 0) {
	(void) printf ("empire: -s argument must be greater or equal to zero.\n");
	exit (1);
    }
	
    if (dflg < 0 || dflg > 30000) {
	(void) printf ("empire: -d argument must be in the range 0..30000.\n");
	exit (1);
    }

    game.SMOOTH = sflg;
    game.WATER_RATIO = wflg;
    game.delay_time = dflg;
    game.save_interval = Sflg;

    /* compute min distance between cities */
    land = MAP_SIZE * (100 - game.WATER_RATIO) / 100; /* available land */
    land /= NUM_CITY; /* land per city */
    game.MIN_CITY_DIST = isqrt (land); /* distance between cities */

    empire (); /* call main routine */
    return (0);
}
