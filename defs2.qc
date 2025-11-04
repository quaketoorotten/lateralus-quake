.float dcnt;
.void() th_dodge;
.void() th_spawn;
// .void() th_duckhold;
.float dspeed;
.float nextthink2;
.float brainspeed;

.string deathtarget;
.string combattarget;

.float dodge_finished;
.void() th_char;
.float() th_checkatck;
.void() itemname;
.float color;
.float pissed;

.float savedammo_shells;
.float savedammo_shells2;
.float savedammo_nails;
.float savedammo_nails2;
.float savedammo_rockets;
.float savedammo_cells;
.float savedammo_cells2;

.float megahealth_finished;
.float megahealth_time;

.float mass;

float SHOTGUN_PELLETS = 13;
float SHOTGUN_HSPREAD = 2860;
float SHOTGUN_VSPREAD = 2200;

float CHAINGUN_HSPREAD = 500;
float CHAINGUN_VSPREAD = 500;

float MACHINEGUN_HSPREAD = 250;
float MACHINEGUN_VSPREAD = 300;

float GRENADE_MINSPEED = 200;
float GRENADE_MAXSPEED = 900;
float GRENADE_TIMER = 4.0;
.float grenade_time;

.float trail_time;

.float aiflags;
.vector last_sighting;
.vector saved_goal;

float AI_LOST_SIGHT		= 1; 
float AI_PURSUE_NEXT		= 2;
float AI_PURSUE_TEMP		= 4;	
float AI_PURSUIT_LAST_SEEN	= 8;
float AI_COMBAT_POINT		= 16;
float AI_STAND_GROUND		= 32;
float AI_THIRD_EYE		= 64;

float CHAN_FIVE = 5;
float CHAN_SIX = 6;
float CHAN_RELOAD = 7;

float	IT_HANDGR				= 65536;
float	IT_RAILGUN				= 8388608;
float	IT_BFG				= 128;

float FL_MEDIC				= 8192;
float FL_DODGED				= 16384;
float FL_RESURRECTED			= 32768;
float FL_LEAP				= 65536;


