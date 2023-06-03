#ifndef __CONFIG_H__
#define __CONFIG_H__
#define NUMPLANETS      8
#define MINUTE 			60
#define HOUR 			MINUTE*60
#define DAY 			HOUR*24
#define WEEK 			DAY*7
#define YEAR 			DAY*365
#define NUMASTEROIDS 1000
#define GRAV_CONSTANT 6.67e-11
#define MAX_DISTANCE 5000.0
#define MAX_VELOCITY 50000.0
#define MAX_MASS 938e18
#define DURATION (10*YEAR)
#define INTERVAL DAY

#define NUMENTITIES (NUMPLANETS+NUMASTEROIDS+1)
#endif
