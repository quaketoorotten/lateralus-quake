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
.float savedammo_shellsDB;
.float savedammo_nails;
.float savedammo_nails2;
.float savedammo_rockets;
.float savedammo_cells;
.float savedammo_cells2;

.float ammo_shellsDB;

.float megahealth_finished;
.float megahealth_time;
.float artifact_healfinished;
.float artifact_healtime;

.float mass;
.float hitmarker_time;

float SHOTGUN_PELLETS = 13;
float SHOTGUN_HSPREAD = 1500;
float SHOTGUN_VSPREAD = 800;

float CHAINGUN_HSPREAD = 400;
float CHAINGUN_VSPREAD = 300;

float MACHINEGUN_HSPREAD = 250;
float MACHINEGUN_VSPREAD = 200;

float GRENADE_MINSPEED = 200;
float GRENADE_MAXSPEED = 900;
float GRENADE_TIMER = 4.0;
.float grenade_time;

float PSTL_AMMO_CAP = 16;
float SG_AMMO_CAP = 7;
float SG_AMMO_LOAD = 2;
float MG_AMMO_CAP = 50;
float CG_AMMO_CAP = 120;
float BFG_AMMO_CAP = 120;
float RL_AMMO_CAP = 5;
float PLSG_AMMO_CAP = 50;
float NO_AMMO = 0;

float MAX_SHELLS = 125;
float MAX_SHELLS2 = 15;

float MAX_NAILS = 300;
float MAX_ROCKETS = 50;
float MAX_CELLS = 300;

.float trail_time;

.float aiflags;
.vector last_sighting;
.vector saved_goal;
.float shake_interval;
.float shake_time;

float AI_LOST_SIGHT		= 1; 
float AI_PURSUE_NEXT		= 2;
float AI_PURSUE_TEMP		= 4;	
float AI_PURSUIT_LAST_SEEN	= 8;
float AI_COMBAT_POINT		= 16;
float AI_STAND_GROUND		= 32;
float AI_THIRD_EYE		= 64;
float IS_PROJECTILE		= 128;
float AI_SCRIPTED_ACTION		= 256;

float CHAN_FIVE = 5;
float CHAN_SIX = 6;
float CHAN_RELOAD = 7;

float IT_FIST 					= 1;
float IT_PISTOL 				= 2;
float IT_SHOTGUN 				= 4;
float IT_MACHINEGUN 			= 8;
float IT_CHAINGUN 				= 16;
float IT_GRENADE	 			= 32;
float IT_PLASMA_GUN 			= 64;
float IT_ROCKET_LAUNCHER 		= 128;
float IT_BFG					= 256;
float IT_CHAINSAW				= 512;

float IT_DOUBLEBARREL			= 1024;
float IT_GRABBER				= 2048;
float IT_ARTIFACT				= 4096;

float FL_MEDIC				= 8192;
float FL_DODGED				= 16384;
float FL_RESURRECTED			= 32768;
float FL_LEAP				= 65536;

float MAX_WEAPONS				= 14;

.entity goonmaster;

const float M_PI = 3.14159265358979323846;	/* Mathematica Pi constant. */ // yo why tf ts so short lemme make it longer

/*void(float start_fire, float idle_start, float idle_end, float change_end, 
	optional float change_start, optional float reload_start, optional float reload_loop_start, reload_insert
	 optional float reload_end_start, optional float reload_end_end, optional float ammo_load, optional float max_ammo_load, optional float ammo_type) */

typedef struct { // burp
	float last_activation;
	vector idle_frames;
	vector swap_frames;
	vector reload_frames;
	vector reloadloop_frames;
	float mag_size;
	float capacity;
	void() weaponfire;
	void() weaponsound;
	
} weapon_info_frames;

typedef struct { // burp
	string vmodel;
	string pmodel;
	float() condition;
	
} weapon_info_generic;

typedef struct { // burp
	void() assign_currentammo;
	float() get_ammo;
	void(float ammo_type) save_ammo;
	
} weapon_info_ammo;

.float weaponstate;
.float weaponitems;

int WEAPON_IDLE = 0;
int WEAPON_USED = 1;
int WEAPON_ACTIVATE = 2;
int WEAPON_DEACTIVATE = 3;
int WEAPON_RELOAD = 5;

.float weapontype;
.float oldweapon;
.float newweapon;

.float oldweaponid;
.float newweaponid;
.float weaponid;

.float powerups; // replace .items
