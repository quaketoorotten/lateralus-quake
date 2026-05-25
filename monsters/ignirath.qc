/*  Copyright (C) 1996-1997  Id Software, Inc.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    See file, 'COPYING', for details.
*/
/*
==============================================================================

SHAL-RATH

==============================================================================
*/

void() salamander_stand1 = [ 0, salamander_stand2 ] { ai_stand();};
void() salamander_stand2 = [ self.frame, salamander_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 170) 
	{	
		if (random() < 0.2)
			sal_idle ();
		salamander_stand1 ();
		return;
	}
	ai_stand ();
};

void() salamander_walk1 = [ 171, salamander_walk2 ] { ai_walk(3);};
void() salamander_walk2 = [ self.frame, salamander_walk2 ] 
{ 	
	self.frame ++;

	if (self.frame == 188 || self.frame == 203)
		sal_step ();
	if (self.frame >= 203) 
	{	
		if (random() < 0.2)
			sal_idle ();
		salamander_walk1 ();
		return;
	}
	ai_walk (3);
};

void() salamander_run1 = [ 171, salamander_run2 ] { ai_run(3.5);};
void() salamander_run2 = [ self.frame, salamander_run2 ] 
{ 	
	self.frame ++;
	
	if (self.frame == 188 || self.frame == 203)
		sal_step ();
	if (self.frame >= 203) 
	{	
		if (random() < 0.2)
			sal_idle ();
		salamander_run1 ();
		return;
	}
	ai_run (3.5);
};

void() salamander_atka1 = [ 348, salamander_atka2 ] {RIGHT_spawn_fireball4 (348, 131, 146); ai_face(); self.nextthink = time + 0.03; };
void() salamander_atka2 = [ self.frame, salamander_atka2 ] 
{ 	
	self.frame ++;	

	//bprint("attack a", "\n");
	if (self.frame == 364)
		salamander_fire (30, 32);
	
	if (self.frame >= 380) 	
	{	
			salamander_run1 ();	

		return;
	}
	if (self.frame < 364)
		ai_face();
	
	self.nextthink = time + 0.03;
};

void() salamander_atkb1 = [ 381, salamander_atkb2 ] {LEFT_spawn_fireball4 (381, 164, 179); ai_face(); self.nextthink = time + 0.03; };
void() salamander_atkb2 = [ self.frame, salamander_atkb2 ] 
{ 	
	self.frame ++;		
	
	//	bprint("attack b", "\n");
	if (self.frame == 397)
		salamander_fire (-30, 32);
	
	if (self.frame >= 413) 	
	{
		salamander_run1 ();
		return;
	}
	if (self.frame < 397)
		ai_face();

	self.nextthink = time + 0.03;
};

void() salamander_atkc1 = [ 414, salamander_atkc2 ] {ai_face(); self.nextthink = time + 0.03; };
void() salamander_atkc2 = [ self.frame, salamander_atkc2 ] 
{ 	
	self.frame ++;	

	if (self.frame == 433)
		MOUTH_spawn_fireball4 (433, 216, 222);

	if (self.frame >= 436 && self.frame < 438)
	{
		salamander_fire (0, 32);
	//	salamander_fire (0, 32);
	}
		
	if (self.frame >= 454) 	
	{	
			salamander_run1 ();	

		return;
	}
	if (self.frame < 444)
		ai_face();
	
	self.nextthink = time + 0.03;
};

void() salamander_atka_a1 = [ 217, salamander_atka_a2 ] {LEFT_spawn_fireball4 (217, 0, 19); ai_charge(3.5); self.nextthink = time + 0.03; };
void() salamander_atka_a2 = [ self.frame, salamander_atka_a2 ] 
{ 	
	self.frame ++;	

	//bprint("attack a", "\n");
	if (self.frame == 236)
		salamander_fire (-30, 32);
	
	if (self.frame >= 250) 	
	{	
			salamander_run1 ();	

		return;
	}
	if (self.frame < 236)
		ai_charge(3.5);
	else	
		ai_move(3.5);
	
	self.nextthink = time + 0.03;
};

void() salamander_atkb_b1 = [ 251, salamander_atkb_b2 ] {RIGHT_spawn_fireball4 (251, 35, 50); ai_charge(3.5); self.nextthink = time + 0.03; };
void() salamander_atkb_b2 = [ self.frame, salamander_atkb_b2 ] 
{ 	
	self.frame ++;	
	
	//	bprint("attack b", "\n");
	if (self.frame == 267)
		salamander_fire (30, 32);
	
	if (self.frame >= 280) 	
	{
		salamander_run1 ();
		return;
	}

	if (self.frame < 267)
		ai_charge(3.5);
	else	
		ai_move(3.5);

	self.nextthink = time + 0.03;
};

void() salamander_left_atk = 
{
	if(random() <= 0.5)
		salamander_atka_a1 ();
	else
		salamander_atka1 ();
}


void() salamander_right_atk = 
{
	if(random() <= 0.5)
		salamander_atkb_b1 ();
	else
		salamander_atkb1 ();
}

void() salamander_range =
{	
	sal_attack ();

	float r = rint(rand() % 2);
	if (r == 0)
		salamander_left_atk ();
	else if (r == 1)
		salamander_right_atk ();
	else
		salamander_atkc1 ();
}

void() salamander_melee =
{	
	sal_attack ();

	if (random() <= 0.5)
		salamander_meleea1 ();
	else
		salamander_meleeb1 ();
}

void() salamanderMelee =
{
	vector delta;
	float ldmg;

	if (!self.enemy)
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 120)
		return;

	ldmg = 38 + (random() + random() + random()) * 15;
	T_Damage(self.enemy, self, self.origin + v_forward*16, self, ldmg, 40);
};

void() salamander_meleea1 = [ 283, salamander_meleea2 ] {ai_face(); self.nextthink = time + 0.035; };
void() salamander_meleea2 = [ self.frame, salamander_meleea2 ] 
{ 	
	self.frame ++;	

	if (self.frame == 298)
		salamanderMelee ();
	
	if (self.frame >= 315) 
	{	
		salamander_run1 ();
		return;
	}

	if (self.frame < 298)
		ai_face();

	self.nextthink = time + 0.035;
};

void() salamander_meleeb1 = [ 316, salamander_meleeb2 ] {ai_face(); self.nextthink = time + 0.035; };
void() salamander_meleeb2 = [ self.frame, salamander_meleeb2 ] 
{ 	
	self.frame ++;	

	if (self.frame == 328)
		salamanderMelee ();
	
	if (self.frame >= 347) 
	{	
		salamander_run1 ();
		return;
	}

	if (self.frame < 115)
		ai_face();

	self.nextthink = time + 0.035;
};

void() salamander_pain1 = [ 206, salamander_pain2 ] {self.nextthink = time + 0.035; };
void() salamander_pain2 = [ self.frame, salamander_pain2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 216) 
	{	
		salamander_run1 ();
		return;
	}
	
	self.nextthink = time + 0.035;
};


void(entity attacker, float damage) salamander_pain =
{	
	if (self.flags & FL_DODGED)
		return;

	if (self.pain_finished > time)
		return;

	if (random()*300 > damage)
		return; // didn't flinch

	sal_pain();
	salamander_pain1();
	self.pain_finished = time + 3;
};

void() salamander_die =
{	
	if (self.health < -400)
	{	
		self.deadflag = DEAD_DEAD;
		self.solid = SOLID_NOT;
		self.think = salamander_gib1;
		self.nextthink = time + 0.035;
		return;
	}
	
	if((self.deadflag & DEAD_DEAD))
		return;

	local vector tmpangle;
	local float tempskin;
	tmpangle = self.angles;
	tempskin = self.skin;

	sal_die ();
	
		self.think = salamander_die1;
	setmodel(self, "progs/salamanderdeath.md3");
	setsize(self, '-32 -32 0', '32 32 88');

	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_CORPSE;
	self.nextthink = time + 0.035;

	self.angles = tmpangle;
	//self.skin = tempskin;
};

void() salamander_die1 = [ 0, salamander_die2 ] { self.nextthink = time + 0.03;};
void() salamander_die2 = [ self.frame, salamander_die2 ] 
{ 	
	self.nextthink = time + 0.03;

	if (self.frame > 3)
		ai_move (-2);
	self.frame ++;
	if (self.frame == 27)
	{	
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() salamander_gib1 = [ self.frame, salamander_gib2 ] 
{MonsterGib (self.health); self.skin = 1; self.alpha = 1; self.nextthink = time + 0.02;};

void() salamander_gib2 = [ self.frame, salamander_gib2 ] 
{ 	
	self.nextthink = time + 0.02;
	self.alpha -= 0.02;
	if (self.alpha <= 0)
	{
		remove(self);
		return;
	}
};

/*
================
salamander_Missile
================
*/
static void(float off, float off2 = 0) salamander_fire = 
{	
	for (float i = 0; i<2;i++)
		salamander_spew (off, off2);	
}

static void(float off, float off2 = 0) salamander_spew =
{	
	vector dir, org, f, r, u;
	vector target;

	AngleVectors(self.angles, f, r, u);
	org = self.origin + '0 0 30' + r * off + u * off2 + f * 24;
	
	target = self.enemy.origin;
	dir = target - org;
	local float dist = vlen(dir), pitch;

//PGM
	if((dist > 512) && (dir[2] < 64) && (dir[2] > -64))
	{
		dir[2] += (dist - 512);
	}

	dir = normalize (dir);
	pitch = dir[2];
	if(pitch > 0.4)
	{
		pitch = 0.4;
	}
	else if(pitch < -0.5)
		pitch = -0.5;

	dir = f;
	dir = dir + pitch * u;
//PGM	
	
	salamander_Missile (org, dir, (crandom() * 100), 200 + (crandom() * 80));
};


static void(vector org, vector dir, float right_adjust, float up_adjust) salamander_Missile =
{
	local	entity missile;
	float grav = cvar("sv_gravity");
	
	//self.effects = self.effects | EF_MUZZLEFLASH;

	missile = spawn ();
	missile.owner = self;
	missile.enemy = self.enemy;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
// set missile speed	

	makevectors (dir);
	missile.velocity = dir * 600;
	
	if (up_adjust)
	{
		float gravityAdjustment = grav / 800;
		missile.velocity += v_up * up_adjust * gravityAdjustment ;
	}

	if (right_adjust)
		missile.velocity += v_right * right_adjust;

	//missile.dmg = damage;

//	vector org = ;

	missile.touch = salamander_MissileTouch;

	setmodel(missile, "progs/muzzleflash.spr");
	setsize(missile, '0 0 0', '0 0 0');
	missile.emiteffectnum = particleeffectnum("TE_ARCHVILEFLAME");

	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, org);
};

static void() salamander_MissileTouch =
{
	if (other == self.owner)
		return; // don't explode on owner

	if (other.classname == "monster_zombie")
		T_Damage(other, self, self.origin, self, 110, 0);

	T_RadiusDamage(self, self.owner, 60, 60, world);
		SpawnFlameWall (self.origin, 4, '-16 -16 0', '16 16 24', 2.7);
	//sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);

	rocketimpact  ();

  self.origin = self.origin - 32* normalize(self.velocity);

	BecomeExplosion ();

	//remove(self);
};

//=================================================================

/*QUAKED monster_shalrath (1 0 0) (-32 -32 -24) (32 32 48) Ambush
*/

static void() sal_step =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_BODY, "monsters/bruiser/fs_01.wav", 0.8, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_BODY, "monsters/bruiser/fs_02.wav", 0.8, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_BODY, "monsters/bruiser/fs_03.wav", 0.8, ATTN_NORM);
	else
		    sound(self, CHAN_BODY, "monsters/bruiser/fs_04.wav", .8, ATTN_NORM);
	
	GroundShake (self, 0.3, 0.2);
};

static void() sal_die =
{
	sound(self, CHAN_VOICE, "monsters/baronofhell/death_01.wav", 1, ATTN_NORM);
};

static void() sal_sight =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/baronofhell/sight1_1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/baronofhell/sight2_1.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/baronofhell/sight3_1.wav", 1, ATTN_NORM);
};

static void() sal_pain =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/baronofhell/ba_pain_01.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/baronofhell/ba_pain_02.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/baronofhell/ba_pain_03.wav", 1, ATTN_NORM);
};

static void() sal_attack =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/baronofhell/ncc_01.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/baronofhell/ncc_02.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/baronofhell/ncc_01.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/baronofhell/ncc_02.wav", 1, ATTN_NORM);
};

static void() sal_idle =
{
	local float r = (random());	

	if (r < 0.5)
		    sound(self, CHAN_VOICE, "monsters/baronofhell/ba_chatter_01.wav", 1, ATTN_IDLE);
	else 
		    sound(self, CHAN_VOICE, "monsters/baronofhell/ba_chatter_02.wav", 1, ATTN_IDLE);
};

void() monster_salamander_cache =
{
	precache_model2 ("progs/salamander.md3");
	precache_model2 ("progs/salamanderdeath.md3");

	precache_sound2 ("monsters/baronofhell/ba_chatter_01.wav");
	precache_sound2 ("monsters/baronofhell/ba_chatter_02.wav");
	
	precache_sound2 ("monsters/baronofhell/sight1_1.wav");
	precache_sound2 ("monsters/baronofhell/sight2_1.wav");
	precache_sound2 ("monsters/baronofhell/sight3_1.wav");

	precache_sound2 ("monsters/baronofhell/ba_pain_01.wav");
	precache_sound2 ("monsters/baronofhell/ba_pain_02.wav");
	precache_sound2 ("monsters/baronofhell/ba_pain_03.wav");

	precache_sound2 ("monsters/baronofhell/death_01.wav");

	precache_sound2 ("monsters/baronofhell/ncc_01.wav");
	precache_sound2 ("monsters/baronofhell/ncc_02.wav");
	precache_sound2 ("monsters/baronofhell/ncc_03.wav");

	precache_sound2 ("monsters/bruiser/fs_01.wav");
	precache_sound2 ("monsters/bruiser/fs_02.wav");
	precache_sound2 ("monsters/bruiser/fs_03.wav");
	precache_sound2 ("monsters/bruiser/fs_04.wav");

	precache_sound ("monsters/archvile/fire_01.wav");
	precache_sound ("monsters/archvile/fire_02.wav");
	precache_sound ("monsters/archvile/fire_03.wav");
	precache_sound ("monsters/archvile/fire_04.wav");
	precache_sound ("monsters/archvile/fire_05.wav");

		precache_sound("monsters/hellknight/fb_create_02.wav");
};

void() monster_salamander =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	monster_salamander_cache ();

	spawn_salamander();
};

void() spawn_salamander =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/salamander.md3");
	setsize(self, '-32 -32 0', '32 32 88');
	self.health = 825;
	self.max_health = 825;
	self.scale = 0.756;
	self.mass = 600;

	self.th_stand = salamander_stand1;
	self.th_walk = salamander_walk1;
	self.th_run = salamander_run1;
	self.th_die = salamander_die;
	self.th_pain = salamander_pain;
	self.th_melee = salamander_melee;
//	self.th_dodge = salamander_dodge;

	self.th_missile = salamander_range;
	self.th_sight = sal_sight;
	self.th_spawn = spawn_salamander;
	self.deathtype = "was barbecued by an Ignirath";

	self.think = walkmonster_start;
	self.nextthink = time + 0.1 + random()*0.1;
};

vector sal_leftspot[] =
{
'22.92 33.43 44.81', // frame 0
'19.81 32.82 45.33', // frame 1
'22.92 32.22 49.50', // frame 2
'22.40 33.43 51.58', // frame 3
'20.33 37.05 52.62', // frame 4
'16.70 40.68 52.10', // frame 5
'12.56 44.90 51.58', // frame 6
'8.41 47.92 51.06', // frame 7
'5.31 50.94 51.58', // frame 8
'3.24 53.36 52.10', // frame 9
'4.27 56.38 51.58', // frame 10
'8.41 58.80 53.14', // frame 11
'15.15 61.21 56.27', // frame 12
'23.44 63.02 60.96', // frame 13
'33.28 64.23 67.21', // frame 14
'46.23 64.23 75.03', // frame 15
'61.76 61.82 82.84', // frame 16
'78.86 56.98 89.61', // frame 17
'94.91 30.41 90.66', // frame 18
'102.16 -14.90 89.09', // frame 19
'98.02 -40.87 89.61', // frame 20
'87.14 -41.47 89.09', // frame 21
'73.68 -37.85 84.40', // frame 22
'61.25 -31.21 76.07', // frame 23
'62.28 -28.19 64.61', // frame 24
'59.17 -19.73 64.61', // frame 25
'60.21 -8.86 70.34', // frame 26
'62.28 5.04 76.07', // frame 27
'58.14 17.72 77.63', // frame 28
'33.79 24.97 73.46', // frame 29
'26.54 27.39 65.65', // frame 30
'21.88 30.41 56.27', // frame 31
'19.29 32.82 49.50', // frame 32
'22.92 33.43 44.81', // frame 33
'19.81 32.82 45.33', // frame 34
'24.99 32.82 51.06', // frame 35
'30.17 34.03 56.79', // frame 36
'35.87 34.64 64.09', // frame 37
'40.53 34.03 70.34', // frame 38
'43.64 30.41 75.03', // frame 39
'45.19 26.18 77.63', // frame 40
'46.74 22.55 79.19', // frame 41
'49.33 20.74 80.76', // frame 42
'53.99 19.53 82.84', // frame 43
'58.14 18.93 85.45', // frame 44
'61.76 18.33 87.53', // frame 45
'64.35 18.33 88.05', // frame 46
'66.94 20.14 87.53', // frame 47
'66.43 27.39 82.84', // frame 48
'59.17 41.88 73.98', // frame 49
'43.64 56.38 65.65', // frame 50
'22.92 61.82 60.44', // frame 51
'9.97 59.40 57.31', // frame 52
'7.38 55.78 55.23', // frame 53
'9.97 50.94 54.19', // frame 54
'13.08 45.51 53.66', // frame 55
'16.18 38.86 53.14', // frame 56
'17.22 33.43 52.10', // frame 57
'17.22 31.01 51.58', // frame 58
'17.74 29.80 50.54', // frame 59
'17.74 29.80 49.50', // frame 60
'18.26 30.41 48.45', // frame 61
'18.26 31.01 47.41', // frame 62
'18.26 31.61 46.37', // frame 63
'18.26 32.82 45.33', // frame 64
'18.26 33.43 44.81', // frame 65
'18.26 34.03 50.02', // frame 66
'18.26 33.43 50.02', // frame 67
'18.77 32.82 50.54', // frame 68
'18.77 31.61 51.06', // frame 69
'18.77 31.01 51.06', // frame 70
'18.77 30.41 51.58', // frame 71
'18.77 29.20 52.10', // frame 72
'18.26 28.59 52.10', // frame 73
'18.26 27.39 52.62', // frame 74
'18.26 30.41 50.02', // frame 75
'13.59 35.84 45.33', // frame 76
'5.31 38.86 43.24', // frame 77
'0.65 38.26 43.77', // frame 78
'-0.91 38.26 44.29', // frame 79
'-2.46 38.86 44.81', // frame 80
'-3.50 39.47 45.85', // frame 81
'-4.02 40.07 46.37', // frame 82
'-4.02 40.07 46.37', // frame 83
'-2.98 40.07 45.85', // frame 84
'-1.94 40.07 45.33', // frame 85
'-0.39 40.68 44.81', // frame 86
'1.68 40.68 44.29', // frame 87
'4.27 40.68 43.77', // frame 88
'6.86 40.07 44.29', // frame 89
'9.45 39.47 44.29', // frame 90
'12.04 38.26 45.33', // frame 91
'14.11 37.66 45.85', // frame 92
'15.67 36.45 46.89', // frame 93
'16.70 35.84 47.93', // frame 94
'17.22 35.24 48.98', // frame 95
'17.74 34.64 49.50', // frame 96
'18.26 34.64 49.50', // frame 97
'18.26 34.03 50.02', // frame 98
'18.26 34.03 50.02', // frame 99
'17.74 31.01 50.02', // frame 100
'20.33 26.18 50.02', // frame 101
'29.13 17.72 51.58', // frame 102
'39.49 5.64 53.14', // frame 103
'43.64 -4.63 55.75', // frame 104
'43.64 -10.67 57.83', // frame 105
'42.60 -17.92 57.31', // frame 106
'39.49 -28.19 55.23', // frame 107
'30.69 -33.62 56.27', // frame 108
'47.78 -40.87 57.83', // frame 109
'79.89 -34.83 60.96', // frame 110
'102.16 -1.61 71.90', // frame 111
'94.91 35.84 85.97', // frame 112
'74.19 46.11 90.14', // frame 113
'48.30 59.40 95.35', // frame 114
'29.13 64.23 90.14', // frame 115
'13.08 60.00 79.19', // frame 116
'7.38 61.82 75.03', // frame 117
'5.31 60.00 66.69', // frame 118
'4.27 58.80 59.92', // frame 119
'2.72 57.59 55.75', // frame 120
'1.68 56.38 53.66', // frame 121
'2.72 54.57 52.10', // frame 122
'4.27 52.15 51.06', // frame 123
'6.86 49.13 50.54', // frame 124
'9.97 46.72 50.54', // frame 125
'12.56 43.70 50.54', // frame 126
'14.63 40.68 50.02', // frame 127
'16.18 37.66 50.02', // frame 128
'17.22 35.84 50.02', // frame 129
'17.74 34.64 50.02', // frame 130
'30.17 18.33 64.61', // frame 131
'30.17 18.33 64.61', // frame 132
'32.24 17.72 66.69', // frame 133
'36.90 17.12 70.86', // frame 134
'42.08 16.51 75.03', // frame 135
'47.78 16.51 76.07', // frame 136
'50.89 16.51 74.51', // frame 137
'51.92 15.31 73.98', // frame 138
'52.96 15.91 75.55', // frame 139
'54.51 18.33 79.19', // frame 140
'52.44 21.95 82.32', // frame 141
'43.12 26.78 81.80', // frame 142
'32.24 29.80 78.67', // frame 143
'24.99 32.22 73.46', // frame 144
'15.67 35.84 64.61', // frame 145
'3.75 38.86 57.31', // frame 146
'-5.05 41.28 53.66', // frame 147
'-9.20 42.49 53.66', // frame 148
'-9.71 42.49 55.23', // frame 149
'-9.20 41.88 56.27', // frame 150
'-8.16 41.28 57.31', // frame 151
'-5.57 41.88 56.27', // frame 152
'-1.94 41.88 56.27', // frame 153
'1.68 41.28 56.27', // frame 154
'5.31 39.47 57.31', // frame 155
'9.45 37.66 58.35', // frame 156
'13.59 35.24 59.40', // frame 157
'17.22 32.22 60.44', // frame 158
'20.85 28.59 62.00', // frame 159
'23.95 25.57 63.04', // frame 160
'26.03 22.55 63.56', // frame 161
'28.10 20.14 64.61', // frame 162
'29.65 18.33 64.61', // frame 163
'22.92 33.43 54.71', // frame 164
'23.95 32.82 55.23', // frame 165
'24.47 31.61 59.40', // frame 166
'18.26 32.82 61.48', // frame 167
'8.93 35.84 62.00', // frame 168
'-1.43 39.47 61.48', // frame 169
'-10.23 44.90 60.96', // frame 170
'-14.89 50.94 60.44', // frame 171
'-16.97 58.19 61.48', // frame 172
'-16.97 66.05 63.04', // frame 173
'-13.86 73.90 64.61', // frame 174
'-6.09 79.94 67.73', // frame 175
'13.08 82.35 72.94', // frame 176
'43.12 80.54 81.28', // frame 177
'67.98 61.21 92.22', // frame 178
'76.78 30.41 97.43', // frame 179
'75.75 -8.86 96.39', // frame 180
'66.43 -41.47 80.76', // frame 181
'61.25 -40.87 76.59', // frame 182
'57.62 -39.06 73.98', // frame 183
'53.99 -35.43 72.42', // frame 184
'51.40 -31.21 70.86', // frame 185
'48.30 -25.16 68.77', // frame 186
'46.23 -19.12 65.13', // frame 187
'54.51 -16.71 57.31', // frame 188
'54.51 -11.88 58.87', // frame 189
'53.48 -7.04 63.04', // frame 190
'51.92 -1.00 67.21', // frame 191
'47.78 6.25 66.69', // frame 192
'42.08 12.89 62.00', // frame 193
'35.35 21.35 57.31', // frame 194
'28.61 29.20 54.71', // frame 195
'23.95 32.82 54.71', // frame 196
'18.26 34.03 50.02', // frame 197
'18.77 34.03 50.54', // frame 198
'19.29 34.03 51.06', // frame 199
'19.81 33.43 52.10', // frame 200
'20.85 33.43 52.62', // frame 201
'22.40 32.82 53.14', // frame 202
'24.47 32.22 54.19', // frame 203
'27.06 31.01 54.71', // frame 204
'30.17 29.80 55.75', // frame 205
'33.79 27.39 57.31', // frame 206
'34.83 23.76 59.92', // frame 207
'32.24 21.35 62.52', // frame 208
'31.20 21.35 63.56', // frame 209
'31.20 21.95 64.09', // frame 210
'31.20 20.14 64.09', // frame 211
'29.65 19.53 63.04', // frame 212
'27.58 20.14 59.92', // frame 213
'27.06 21.35 54.71', // frame 214
'28.10 21.35 50.02', // frame 215
'29.65 26.78 37.51', // frame 216
'17.22 34.64 30.74', // frame 217
'4.27 38.86 26.05', // frame 218
'-5.05 41.88 23.45', // frame 219
'-7.64 42.49 22.92', // frame 220
'-7.64 41.88 23.97', // frame 221
'-6.09 41.28 25.01', // frame 222
'-4.02 40.68 26.57', // frame 223
'-1.43 39.47 28.66', // frame 224
'1.16 38.26 30.74', // frame 225
'4.27 37.66 32.30', // frame 226
'6.86 37.05 34.39', // frame 227
'8.93 36.45 35.95', // frame 228
'11.00 35.84 37.51', // frame 229
'13.08 35.24 39.08', // frame 230
'14.63 35.24 40.12', // frame 231
'15.67 34.64 41.68', // frame 232
'17.22 34.64 42.72', // frame 233
'18.26 34.64 44.29', // frame 234
'18.77 34.64 45.85', // frame 235
'19.29 34.64 47.41', // frame 236
'18.77 34.03 49.50', // frame 237
'18.26 34.03 50.02', // frame 238
};

vector sal_rightspot [] =
{
'51.40 -14.90 62.00', // frame 0
'47.26 -15.50 62.52', // frame 1
'49.85 -16.10 63.56', // frame 2
'53.99 -16.10 65.65', // frame 3
'59.69 -14.90 67.73', // frame 4
'63.84 -11.27 70.34', // frame 5
'67.98 -7.65 72.42', // frame 6
'72.12 -5.84 72.94', // frame 7
'75.75 -4.02 73.46', // frame 8
'77.30 -4.02 74.51', // frame 9
'77.30 -5.23 74.51', // frame 10
'76.27 -8.25 73.98', // frame 11
'74.71 -11.88 71.38', // frame 12
'72.12 -16.10 67.21', // frame 13
'67.46 -20.94 62.52', // frame 14
'58.66 -28.79 56.79', // frame 15
'47.78 -34.83 54.19', // frame 16
'37.42 -36.04 53.14', // frame 17
'26.54 -36.04 51.58', // frame 18
'14.63 -34.83 50.02', // frame 19
'3.75 -33.62 48.45', // frame 20
'-1.94 -33.02 46.89', // frame 21
'-2.46 -31.81 46.37', // frame 22
'-0.91 -31.21 45.85', // frame 23
'1.68 -30.60 45.85', // frame 24
'5.82 -30.00 46.37', // frame 25
'10.49 -28.79 46.89', // frame 26
'17.22 -26.98 48.45', // frame 27
'24.99 -24.56 50.54', // frame 28
'32.24 -21.54 53.14', // frame 29
'38.46 -18.52 56.79', // frame 30
'43.12 -16.71 59.92', // frame 31
'45.71 -15.50 60.96', // frame 32
'51.40 -14.90 62.00', // frame 33
'47.78 -17.92 59.92', // frame 34
'45.19 -20.94 57.83', // frame 35
'38.97 -20.94 57.31', // frame 36
'30.69 -20.33 57.83', // frame 37
'21.36 -20.33 60.44', // frame 38
'9.97 -20.94 62.52', // frame 39
'-0.39 -20.94 63.04', // frame 40
'-7.64 -20.33 64.09', // frame 41
'-10.75 -20.33 64.09', // frame 42
'-9.20 -23.96 64.09', // frame 43
'-3.50 -31.81 64.09', // frame 44
'8.41 -42.08 66.69', // frame 45
'27.58 -50.53 75.55', // frame 46
'46.74 -51.14 84.93', // frame 47
'66.43 -48.72 91.18', // frame 48
'85.59 -23.35 93.78', // frame 49
'92.84 3.83 92.74', // frame 50
'85.07 8.06 85.45', // frame 51
'73.68 8.06 74.51', // frame 52
'63.84 6.25 66.17', // frame 53
'57.10 5.04 63.56', // frame 54
'53.48 3.23 63.56', // frame 55
'52.44 0.81 64.09', // frame 56
'52.96 -1.61 64.09', // frame 57
'53.99 -4.02 64.61', // frame 58
'53.99 -6.44 64.61', // frame 59
'53.99 -8.86 64.61', // frame 60
'52.96 -10.67 64.09', // frame 61
'51.92 -12.48 63.56', // frame 62
'50.37 -13.69 63.04', // frame 63
'48.82 -14.29 62.52', // frame 64
'47.26 -14.90 62.00', // frame 65
'17.22 -30.60 50.54', // frame 66
'18.77 -32.41 52.62', // frame 67
'16.70 -35.43 55.75', // frame 68
'10.49 -40.27 60.96', // frame 69
'2.20 -45.10 65.65', // frame 70
'-5.05 -49.93 69.30', // frame 71
'-11.27 -53.55 71.90', // frame 72
'-16.97 -55.97 73.46', // frame 73
'-21.11 -57.18 73.98', // frame 74
'-20.07 -58.39 71.38', // frame 75
'-16.97 -58.39 70.34', // frame 76
'-15.93 -59.60 71.90', // frame 77
'-8.68 -51.14 79.72', // frame 78
'51.92 -55.97 85.45', // frame 79
'75.23 -22.14 80.24', // frame 80
'88.70 13.49 79.72', // frame 81
'71.09 27.99 86.49', // frame 82
'51.92 50.94 72.94', // frame 83
'49.33 50.34 68.77', // frame 84
'46.23 47.32 63.56', // frame 85
'43.12 42.49 58.87', // frame 86
'41.56 37.05 56.79', // frame 87
'41.56 27.99 57.31', // frame 88
'43.64 12.29 58.87', // frame 89
'45.71 -2.21 59.40', // frame 90
'45.71 -11.27 58.35', // frame 91
'44.15 -17.92 54.71', // frame 92
'40.01 -23.96 51.58', // frame 93
'33.79 -27.58 50.02', // frame 94
'28.10 -29.39 50.02', // frame 95
'22.92 -30.60 50.02', // frame 96
'19.81 -30.60 50.02', // frame 97
'17.74 -30.60 50.54', // frame 98
'17.22 -30.60 50.54', // frame 99
'17.22 -31.21 50.54', // frame 100
'17.22 -32.41 50.02', // frame 101
'15.67 -33.62 49.50', // frame 102
'13.08 -34.83 48.98', // frame 103
'7.90 -37.25 47.41', // frame 104
'2.20 -39.06 46.89', // frame 105
'-2.98 -40.27 46.89', // frame 106
'-7.64 -40.87 46.37', // frame 107
'-12.30 -40.27 44.81', // frame 108
'-13.86 -38.45 46.89', // frame 109
'-11.27 -37.25 50.02', // frame 110
'1.68 -39.06 52.62', // frame 111
'16.18 -34.23 64.61', // frame 112
'16.70 -30.00 70.34', // frame 113
'17.22 -29.39 67.21', // frame 114
'17.22 -28.79 63.56', // frame 115
'17.74 -28.79 61.48', // frame 116
'18.26 -29.39 59.40', // frame 117
'18.26 -29.39 57.31', // frame 118
'18.26 -29.39 55.75', // frame 119
'17.74 -30.00 54.19', // frame 120
'17.74 -30.00 53.66', // frame 121
'17.74 -30.00 52.62', // frame 122
'17.74 -30.00 52.10', // frame 123
'17.74 -30.00 51.58', // frame 124
'17.22 -30.00 51.06', // frame 125
'17.22 -30.60 51.06', // frame 126
'17.22 -30.60 51.06', // frame 127
'17.22 -30.60 50.54', // frame 128
'17.22 -30.60 50.54', // frame 129
'17.22 -30.60 50.54', // frame 130
'29.65 -32.41 66.17', // frame 131
'29.65 -33.62 66.17', // frame 132
'24.47 -37.25 64.61', // frame 133
'11.52 -41.47 60.96', // frame 134
'-0.91 -44.49 57.31', // frame 135
'-6.61 -46.31 55.75', // frame 136
'-6.61 -47.51 57.31', // frame 137
'-9.20 -46.91 60.44', // frame 138
'-11.27 -48.12 63.56', // frame 139
'-10.75 -51.74 67.21', // frame 140
'-9.71 -57.18 71.38', // frame 141
'-11.27 -60.20 75.55', // frame 142
'-0.39 -62.01 79.72', // frame 143
'25.51 -62.01 83.36', // frame 144
'51.40 -53.55 89.61', // frame 145
'77.82 -31.81 94.30', // frame 146
'78.86 14.70 93.78', // frame 147
'68.50 38.86 81.80', // frame 148
'59.69 35.84 72.94', // frame 149
'57.10 30.41 69.82', // frame 150
'55.55 24.37 68.77', // frame 151
'52.44 20.74 68.25', // frame 152
'49.85 17.12 66.69', // frame 153
'50.37 11.08 64.09', // frame 154
'52.44 2.02 62.52', // frame 155
'53.99 -8.25 61.48', // frame 156
'53.99 -16.71 61.48', // frame 157
'52.96 -22.75 61.48', // frame 158
'50.37 -26.98 62.00', // frame 159
'46.23 -30.00 62.52', // frame 160
'40.53 -31.21 63.56', // frame 161
'35.35 -31.81 64.61', // frame 162
'31.20 -32.41 65.65', // frame 163
'27.06 -14.90 63.04', // frame 164
'27.58 -15.50 63.04', // frame 165
'29.13 -16.71 64.09', // frame 166
'30.69 -17.92 65.13', // frame 167
'31.72 -17.92 66.17', // frame 168
'31.72 -15.50 66.17', // frame 169
'31.72 -14.29 65.13', // frame 170
'32.24 -14.29 63.04', // frame 171
'33.79 -14.29 62.00', // frame 172
'35.35 -14.90 62.00', // frame 173
'36.90 -16.10 62.00', // frame 174
'38.46 -17.92 62.52', // frame 175
'39.49 -20.94 62.00', // frame 176
'35.35 -25.16 59.92', // frame 177
'23.44 -30.60 57.31', // frame 178
'9.97 -34.23 55.23', // frame 179
'-0.91 -36.64 54.19', // frame 180
'-5.57 -37.25 53.14', // frame 181
'-5.05 -36.64 52.62', // frame 182
'-2.98 -34.83 53.14', // frame 183
'0.13 -33.62 53.66', // frame 184
'3.75 -33.02 54.19', // frame 185
'8.41 -33.02 53.66', // frame 186
'13.08 -33.02 52.62', // frame 187
'18.26 -32.41 52.62', // frame 188
'21.88 -31.21 53.66', // frame 189
'24.99 -28.79 55.75', // frame 190
'26.54 -26.37 57.83', // frame 191
'27.58 -23.35 59.40', // frame 192
'28.10 -20.33 60.44', // frame 193
'27.58 -17.92 60.96', // frame 194
'27.58 -16.10 62.00', // frame 195
'27.06 -15.50 62.52', // frame 196
'17.22 -30.60 50.54', // frame 197
'17.74 -30.00 51.06', // frame 198
'18.26 -30.00 52.10', // frame 199
'19.29 -30.00 52.62', // frame 200
'20.33 -29.39 53.66', // frame 201
'21.88 -28.79 54.19', // frame 202
'23.95 -28.19 54.71', // frame 203
'26.54 -27.58 55.75', // frame 204
'29.65 -25.77 56.27', // frame 205
'32.76 -23.96 56.79', // frame 206
'34.31 -20.33 57.31', // frame 207
'31.20 -17.92 59.40', // frame 208
'30.69 -17.92 60.44', // frame 209
'31.20 -17.92 60.96', // frame 210
'31.20 -17.92 62.52', // frame 211
'30.69 -19.12 63.04', // frame 212
'29.13 -21.54 63.56', // frame 213
'29.13 -21.54 59.40', // frame 214
'30.17 -21.54 54.19', // frame 215
'30.69 -28.79 43.77', // frame 216
'18.77 -37.25 38.03', // frame 217
'6.34 -40.87 31.78', // frame 218
'-2.98 -43.29 27.61', // frame 219
'-6.09 -43.29 27.09', // frame 220
'-6.09 -42.68 27.61', // frame 221
'-4.53 -41.47 28.66', // frame 222
'-2.46 -40.87 30.22', // frame 223
'-0.39 -39.66 31.78', // frame 224
'2.72 -38.45 33.35', // frame 225
'5.31 -37.25 34.91', // frame 226
'7.90 -36.04 36.47', // frame 227
'9.97 -35.43 38.03', // frame 228
'12.04 -34.23 39.08', // frame 229
'13.59 -33.62 40.64', // frame 230
'14.63 -33.02 41.68', // frame 231
'16.18 -33.02 42.72', // frame 232
'17.22 -32.41 44.29', // frame 233
'17.74 -31.81 45.33', // frame 234
'18.26 -31.21 46.89', // frame 235
'18.26 -30.60 48.45', // frame 236
'17.74 -30.60 50.02', // frame 237
'17.22 -30.60 50.54', // frame 238
};

static void()  RIGHT_fireball4_update_pos =
{	
	if ((self.arraynumfire + (self.owner.frame - self.startfire) >= self.endfire) 
		|| self.owner.think == salamander_pain1 || self.owner.think == salamander_pain2 
		|| self.owner.health <= 0)
	{
		remove(self);
		return;
	}

	vector f, r, u;
	AngleVectors(self.owner.angles, f, r, u);
	vector org = ProjectAim(self.owner.origin, sal_rightspot[self.arraynumfire + (self.owner.frame - self.startfire)]*0.756, f, -1*r);	
	
	//bprint (ftos(self.arraynumfire + (self.owner.frame - self.startfire)),"\n");
	self.origin = org;
	
	self.think = RIGHT_fireball4_update_pos;
	self.nextthink = time;
};

static void(float start, float arrnum, float end)  RIGHT_spawn_fireball4 =
{
	local entity e;

	makevectors(self.angles);
	vector org = ProjectAim(self.origin, sal_rightspot[arrnum + (self.frame - start)]*0.756, v_forward, -1*v_right);	
	
	e = spawn ();
	setmodel (e, "progs/muzzleflash.spr");
	
	setsize (e, '0 0 0', '0 0 0');
	//
	setorigin (e, self.origin);
	e.origin = org;

	e.emiteffectnum = (particleeffectnum("TE_ARCHVILEFLAME_HAND"));
	e.traileffectnum = (particleeffectnum("EF_ARCHVILEFLAME_HAND_LIGHT"));

	e.startfire = start;
	e.endfire = end - 3;
	e.arraynumfire = arrnum;

	e.owner = self;
	e.think = RIGHT_fireball4_update_pos;
	e.nextthink = time;
	//e.ltime = removeframe;
	
	sound(self, CHAN_WEAPON, "monsters/hellknight/fb_create_02.wav", 1, ATTN_NORM);	
};

static void()  LEFT_fireball4_update_pos =
{	
	if ((self.arraynumfire + (self.owner.frame - self.startfire) >= self.endfire) 
		|| self.owner.think == salamander_pain1 || self.owner.think == salamander_pain2 
		|| self.owner.health <= 0)
	{
		remove(self);
		return;
	}

	vector f, r, u;
	AngleVectors(self.owner.angles, f, r, u);
	vector org = ProjectAim(self.owner.origin, sal_leftspot[self.arraynumfire + (self.owner.frame - self.startfire)]*0.756, f, -1*r);	
	
	//bprint (ftos(self.arraynumfire + (self.owner.frame - self.startfire)),"\n");
	self.origin = org;
	
	self.think = LEFT_fireball4_update_pos;
	self.nextthink = time;
};
static void(float start, float arrnum, float end)  LEFT_spawn_fireball4 =
{
	local entity e;

	makevectors(self.angles);
	vector org = ProjectAim(self.origin, sal_leftspot[arrnum + (self.frame - start)]*0.756, v_forward, -1*v_right);	
	
	e = spawn ();
	setmodel (e, "progs/muzzleflash.spr");
	
	setsize (e, '0 0 0', '0 0 0');
	//
	setorigin (e, self.origin);
	e.origin = org;

	e.emiteffectnum = (particleeffectnum("TE_ARCHVILEFLAME_HAND"));
	e.traileffectnum = (particleeffectnum("EF_ARCHVILEFLAME_HAND_LIGHT"));

	e.startfire = start;
	e.endfire = end - 3;
	e.arraynumfire = arrnum;

	e.owner = self;
	e.think = LEFT_fireball4_update_pos;
	e.nextthink = time;
	//e.ltime = removeframe;
	
	sound(self, CHAN_WEAPON, "monsters/hellknight/fb_create_02.wav", 1, ATTN_NORM);	
};

vector sal_MOUTH_spot [] =
{
	'56.07 13.49 119.83', // frame 0
'59.17 14.70 118.79', // frame 1
'65.91 18.33 113.06', // frame 2
'69.53 18.93 109.41', // frame 3
'72.12 20.74 106.29', // frame 4
'73.16 22.55 104.20', // frame 5
'72.64 24.37 104.20', // frame 6
'70.57 24.97 106.81', // frame 7
'68.50 24.97 110.46', // frame 8
'67.46 24.37 113.06', // frame 9
'66.43 21.95 115.14', // frame 10
'66.43 18.93 116.19', // frame 11
'65.91 15.31 117.75', // frame 12
'65.39 10.47 118.79', // frame 13
'66.43 5.04 119.83', // frame 14
'65.39 0.20 121.40', // frame 15
'62.80 -5.84 121.92', // frame 16
'60.73 -11.27 119.83', // frame 17
'60.73 -16.71 116.19', // frame 18
'60.21 -19.73 113.06', // frame 19
'59.17 -20.33 111.50', // frame 20
'59.17 -19.73 111.50', // frame 21
'60.73 -16.71 112.02', // frame 22
'62.28 -13.08 112.54', // frame 23
'64.35 -8.25 113.06', // frame 24
'66.43 -4.02 113.58', // frame 25
'67.46 0.20 115.14', // frame 26
'66.94 3.23 116.19', // frame 27
'64.87 5.64 118.79', // frame 28
'61.76 8.06 121.40', // frame 29
'58.66 10.47 122.44', // frame 30
'57.10 12.29 121.40', // frame 31
'56.58 12.89 120.88', // frame 32
'56.07 13.49 119.83', // frame 33
'56.07 10.47 119.83', // frame 34
'55.55 7.45 116.19', // frame 35
'55.03 5.04 114.62', // frame 36
'54.51 5.64 114.62', // frame 37
'52.44 8.66 117.23', // frame 38
'47.78 9.87 121.92', // frame 39
'43.12 11.08 126.61', // frame 40
'41.05 11.08 130.25', // frame 41
'42.60 11.68 131.82', // frame 42
'47.78 12.29 131.82', // frame 43
'53.99 11.08 129.73', // frame 44
'59.69 9.27 126.09', // frame 45
'62.28 6.85 121.40', // frame 46
'65.91 5.04 112.02', // frame 47
'66.94 5.64 104.20', // frame 48
'67.46 6.85 100.56', // frame 49
'68.50 6.85 98.47', // frame 50
'70.05 4.43 95.87', // frame 51
'70.57 3.23 94.83', // frame 52
'70.05 4.43 94.83', // frame 53
'70.05 3.83 96.39', // frame 54
'70.05 3.23 99.51', // frame 55
'69.53 2.62 102.64', // frame 56
'69.02 2.02 105.77', // frame 57
'68.50 1.41 109.41', // frame 58
'67.46 1.41 112.54', // frame 59
'66.94 3.23 116.19', // frame 60
'64.87 5.04 119.83', // frame 61
'61.25 8.06 122.96', // frame 62
'58.66 10.47 122.96', // frame 63
'57.10 12.89 120.88', // frame 64
'56.07 13.49 119.83', // frame 65
'43.12 2.02 112.54', // frame 66
'41.05 1.41 112.02', // frame 67
'38.46 0.81 110.98', // frame 68
'35.87 0.20 110.46', // frame 69
'32.76 -0.40 109.41', // frame 70
'29.65 -1.00 108.37', // frame 71
'25.51 -1.61 106.81', // frame 72
'19.29 -2.21 103.16', // frame 73
'16.18 -2.21 101.08', // frame 74
'14.63 -0.40 100.04', // frame 75
'15.67 2.62 98.99', // frame 76
'32.76 13.49 103.68', // frame 77
'50.89 23.76 107.33', // frame 78
'55.03 26.78 103.68', // frame 79
'55.55 28.59 99.51', // frame 80
'54.51 28.59 96.39', // frame 81
'53.48 28.59 95.35', // frame 82
'52.96 27.39 96.91', // frame 83
'52.96 25.57 98.47', // frame 84
'53.48 22.55 100.56', // frame 85
'53.48 18.33 102.12', // frame 86
'53.99 14.10 103.68', // frame 87
'54.51 11.08 104.72', // frame 88
'54.51 8.66 105.25', // frame 89
'54.51 6.85 105.77', // frame 90
'53.99 5.04 106.29', // frame 91
'52.96 4.43 107.33', // frame 92
'51.92 3.23 107.85', // frame 93
'50.37 2.62 108.89', // frame 94
'48.82 2.62 109.93', // frame 95
'46.74 2.02 110.46', // frame 96
'45.19 2.02 111.50', // frame 97
'43.12 2.02 112.54', // frame 98
'42.08 2.02 114.62', // frame 99
'44.67 0.81 113.58', // frame 100
'47.26 -0.40 112.54', // frame 101
'49.85 -2.21 110.98', // frame 102
'51.40 -7.65 108.89', // frame 103
'49.85 -13.08 106.29', // frame 104
'47.78 -19.73 103.16', // frame 105
'46.23 -25.77 101.08', // frame 106
'45.19 -28.19 99.51', // frame 107
'48.82 -21.54 102.12', // frame 108
'56.58 -8.86 106.81', // frame 109
'62.80 -1.00 111.50', // frame 110
'63.84 1.41 115.14', // frame 111
'56.58 5.04 116.71', // frame 112
'42.08 6.85 112.02', // frame 113
'24.47 5.04 101.60', // frame 114
'15.15 3.83 96.39', // frame 115
'15.15 3.23 97.43', // frame 116
'16.18 2.62 98.99', // frame 117
'18.26 2.62 102.12', // frame 118
'20.33 2.62 105.25', // frame 119
'22.92 2.02 107.85', // frame 120
'24.47 2.02 109.93', // frame 121
'26.03 2.02 111.50', // frame 122
'27.58 2.02 112.54', // frame 123
'29.65 2.02 112.54', // frame 124
'31.20 2.02 113.06', // frame 125
'32.76 2.02 113.06', // frame 126
'34.31 2.02 113.58', // frame 127
'35.35 2.02 114.10', // frame 128
'36.90 2.02 114.62', // frame 129
'37.94 2.02 115.14', // frame 130
'46.23 -13.69 119.83', // frame 131
'44.67 -14.90 119.83', // frame 132
'41.56 -17.92 116.71', // frame 133
'38.97 -20.33 112.02', // frame 134
'35.35 -22.75 109.93', // frame 135
'31.72 -23.35 109.41', // frame 136
'30.17 -24.56 106.81', // frame 137
'30.69 -22.75 105.77', // frame 138
'32.76 -19.12 105.77', // frame 139
'34.31 -12.48 105.77', // frame 140
'34.31 -4.02 106.29', // frame 141
'32.76 5.04 106.29', // frame 142
'29.65 14.10 107.33', // frame 143
'28.10 20.74 108.37', // frame 144
'31.72 24.97 111.50', // frame 145
'41.05 20.74 115.67', // frame 146
'44.67 17.72 116.19', // frame 147
'45.71 17.12 113.58', // frame 148
'47.78 16.51 109.41', // frame 149
'49.85 15.91 104.72', // frame 150
'50.37 14.70 102.12', // frame 151
'49.85 12.89 101.60', // frame 152
'48.30 11.68 101.60', // frame 153
'46.23 10.47 102.12', // frame 154
'45.71 8.06 102.64', // frame 155
'45.71 5.04 105.77', // frame 156
'45.71 1.41 108.37', // frame 157
'45.71 -2.21 110.98', // frame 158
'46.23 -5.23 113.58', // frame 159
'46.23 -8.25 115.67', // frame 160
'46.23 -11.27 117.75', // frame 161
'46.23 -12.48 119.31', // frame 162
'46.23 -13.69 119.83', // frame 163
'46.23 13.49 119.83', // frame 164
'44.15 15.31 120.88', // frame 165
'38.97 19.53 119.31', // frame 166
'35.35 24.37 115.67', // frame 167
'35.35 26.78 111.50', // frame 168
'37.94 26.18 108.89', // frame 169
'38.46 24.97 104.72', // frame 170
'37.94 22.55 104.20', // frame 171
'36.90 20.74 106.29', // frame 172
'36.90 19.53 107.33', // frame 173
'37.42 19.53 107.85', // frame 174
'38.46 18.93 108.37', // frame 175
'40.53 18.33 109.41', // frame 176
'42.60 14.70 112.02', // frame 177
'45.19 7.45 116.71', // frame 178
'49.33 -2.82 121.92', // frame 179
'46.74 -12.48 123.48', // frame 180
'44.67 -16.71 121.92', // frame 181
'47.26 -18.52 118.27', // frame 182
'50.37 -18.52 113.06', // frame 183
'52.96 -17.31 108.89', // frame 184
'54.51 -13.08 106.29', // frame 185
'55.03 -5.23 104.20', // frame 186
'55.03 2.02 102.12', // frame 187
'56.58 6.85 101.08', // frame 188
'58.14 9.27 101.08', // frame 189
'59.69 10.47 102.12', // frame 190
'60.21 11.68 103.16', // frame 191
'58.66 12.29 106.29', // frame 192
'55.03 12.89 109.93', // frame 193
'50.89 12.89 114.62', // frame 194
'47.78 13.49 118.27', // frame 195
'46.23 13.49 119.83', // frame 196
'43.12 2.02 112.54', // frame 197
'42.60 2.02 112.02', // frame 198
'41.56 2.02 111.50', // frame 199
'41.05 2.02 110.46', // frame 200
'40.53 2.02 109.93', // frame 201
'40.01 2.02 108.89', // frame 202
'40.01 2.02 107.85', // frame 203
'40.01 2.02 106.81', // frame 204
'40.01 2.02 104.72', // frame 205
'41.05 2.02 102.64', // frame 206
'43.12 2.02 98.47', // frame 207
'46.74 2.02 91.18', // frame 208
'48.30 2.02 85.97', // frame 209
'48.82 2.02 82.84', // frame 210
'49.85 2.02 81.80', // frame 211
'50.37 2.02 82.32', // frame 212
'49.85 2.02 84.40', // frame 213
'48.82 2.02 87.01', // frame 214
'43.64 2.02 84.93', // frame 215
'40.53 2.02 78.15', // frame 216
'37.42 2.02 73.98', // frame 217
'37.94 2.02 73.98', // frame 218
'38.97 2.02 74.51', // frame 219
'40.53 2.02 74.51', // frame 220
'42.08 2.02 74.51', // frame 221
'43.64 2.02 73.46', // frame 222
'45.71 2.02 72.94', // frame 223
'48.30 2.02 73.46', // frame 224
'50.89 2.02 73.46', // frame 225
'53.99 2.02 74.51', // frame 226
'56.07 2.02 75.55', // frame 227
'57.62 2.02 78.15', // frame 228
'53.48 2.02 88.05', // frame 229
'48.82 2.02 98.99', // frame 230
'47.26 2.02 104.72', // frame 231
'45.71 2.02 107.85', // frame 232
'44.67 2.02 109.93', // frame 233
'43.64 2.02 110.98', // frame 234
'43.64 2.02 112.02', // frame 235
'43.12 2.02 112.02', // frame 236
'43.12 2.02 112.54', // frame 237
'43.12 2.02 112.54', // frame 238
};

static void()  MOUTH_fireball4_update_pos =
{	
	if ((self.arraynumfire + (self.owner.frame - self.startfire) >= self.endfire) 
		|| self.owner.think == salamander_pain1 || self.owner.think == salamander_pain2 
		|| self.owner.health <= 0)
	{
		remove(self);
		return;
	}

	vector f, r, u;
	AngleVectors(self.owner.angles, f, r, u);
	vector org = ProjectAim(self.owner.origin, sal_MOUTH_spot[self.arraynumfire + (self.owner.frame - self.startfire)]*0.756, f, -1*r);	
	
	//bprint (ftos(self.arraynumfire + (self.owner.frame - self.startfire)),"\n");
	self.origin = org;
	
	self.think = MOUTH_fireball4_update_pos;
	self.nextthink = time;
};
static void(float start, float arrnum, float end)  MOUTH_spawn_fireball4 =
{
	local entity e;

	makevectors(self.angles);
	vector org = ProjectAim(self.origin, sal_leftspot[arrnum + (self.frame - start)]*0.756, v_forward, -1*v_right);	
	
	e = spawn ();
	setmodel (e, "progs/muzzleflash.spr");
	
	setsize (e, '0 0 0', '0 0 0');
	//
	setorigin (e, self.origin);
	e.origin = org;

	e.emiteffectnum = (particleeffectnum("TE_ARCHVILEFLAME_HAND"));
	e.traileffectnum = (particleeffectnum("EF_ARCHVILEFLAME_HAND_LIGHT"));

	e.startfire = start;
	e.endfire = end - 3;
	e.arraynumfire = arrnum;

	e.owner = self;
	e.think = MOUTH_fireball4_update_pos;
	e.nextthink = time;
	//e.ltime = removeframe;
	
	sound(self, CHAN_WEAPON, "monsters/hellknight/fb_create_02.wav", 1, ATTN_NORM);	
};