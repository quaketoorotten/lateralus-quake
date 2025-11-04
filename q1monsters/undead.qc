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

ZOMBIE

==============================================================================
*/
$cd /raid/quake/id1/models/zombie

$origin 0 0 24

$base base
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8
$frame stand9 stand10 stand11 stand12 stand13 stand14 stand15

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11
$frame walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19

$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11 run12
$frame run13 run14 run15 run16 run17 run18

$frame atta1 atta2 atta3 atta4 atta5 atta6 atta7 atta8 atta9 atta10 atta11
$frame atta12 atta13

$frame attb1 attb2 attb3 attb4 attb5 attb6 attb7 attb8 attb9 attb10 attb11
$frame attb12 attb13 attb14

$frame attc1 attc2 attc3 attc4 attc5 attc6 attc7 attc8 attc9 attc10 attc11
$frame attc12

$frame paina1 paina2 paina3 paina4 paina5 paina6 paina7 paina8 paina9 paina10
$frame paina11 paina12

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14 painb15 painb16 painb17 painb18 painb19
$frame painb20 painb21 painb22 painb23 painb24 painb25 painb26 painb27 painb28

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8 painc9 painc10
$frame painc11 painc12 painc13 painc14 painc15 painc16 painc17 painc18

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8 paind9 paind10
$frame paind11 paind12 paind13

$frame paine1 paine2 paine3 paine4 paine5 paine6 paine7 paine8 paine9 paine10
$frame paine11 paine12 paine13 paine14 paine15 paine16 paine17 paine18 paine19
$frame paine20 paine21 paine22 paine23 paine24 paine25 paine26 paine27 paine28
$frame paine29 paine30

$frame cruc_1 cruc_2 cruc_3 cruc_4 cruc_5 cruc_6

//=============================================================================

.float inpain;

void() undead_stand1 = [ 68, undead_stand2 ] { ai_stand();};
void() undead_stand2 = [ self.frame, undead_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 210) 
	{	
		//if (random() < 0.2)
		//	sound(self, CHAN_VOICE, "demon/idle1.wav", 1, ATTN_NORM);
		undead_stand1 ();
		return;
	}
	ai_stand ();
};

void() undead_cruc1 = [ $cruc_1, undead_cruc2 ]
{
	if (random() < 0.1)
		sound(self, CHAN_VOICE, "zombie/idle_w2.wav", 1, ATTN_STATIC);
};
void() undead_cruc2 = [ $cruc_2, undead_cruc3 ] { self.nextthink = time + 0.1 + random()*0.1; };
void() undead_cruc3 = [ $cruc_3, undead_cruc4 ] { self.nextthink = time + 0.1 + random()*0.1; };
void() undead_cruc4 = [ $cruc_4, undead_cruc5 ] { self.nextthink = time + 0.1 + random()*0.1; };
void() undead_cruc5 = [ $cruc_5, undead_cruc6 ] { self.nextthink = time + 0.1 + random()*0.1; };
void() undead_cruc6 = [ $cruc_6, undead_cruc1 ] { self.nextthink = time + 0.1 + random()*0.1; };


void() undead_walk1 = [ 0, undead_walk2 ] { ai_walk(2);};
void() undead_walk2 = [ self.frame, undead_walk2 ] 
{ 
	self.frame ++;
	if (self.frame >= 67) 
	{	
		if (random() < 0.2)
			sound(self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_IDLE);

		undead_walk1 ();
		return;
	}
	ai_walk (2);
};

void() undead_run1 = [ 0, undead_run2 ] { ai_run(2);};
void() undead_run2 = [ self.frame, undead_run2 ] 
{ 
	self.frame ++;
	if (self.frame >= 67) 
	{
		if (random() < 0.2)
			sound(self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_IDLE);
		if (random() > 0.8)
			sound(self, CHAN_VOICE, "zombie/z_idle1.wav", 1, ATTN_IDLE);

		undead_run1 ();
		return;
	}
	ai_run (2);
};
/*
=============================================================================

ATTACKS

=============================================================================
*/

void() undead_GrenadeTouch =
{
	if (other == self.owner)
		return; // don't explode on owner
	if (other.takedamage)
	{
		T_Damage(other, self, self.origin, self.owner, 1, 0 );
		sound(self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
		remove(self);
		return;
	}
	sound(self, CHAN_WEAPON, "zombie/z_miss.wav", 1, ATTN_NORM); // bounce sound
	self.velocity = '0 0 0';
	self.avelocity = '0 0 0';
	self.touch = SUB_Remove;
};

/*
================
undead_FireGrenade
================
*/
void() undead_FireGrenade =
{
	entity missile;
	vector org, dir;

	sound(self, CHAN_WEAPON, "zombie/z_shot1.wav", 1, ATTN_NORM);

	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;

// calc org
	org = self.origin + '0 0 43' + v_forward * 8;

	dir = self.enemy.origin - org;
	local float dist = vlen(dir), pitch;

// set missile speed

	makevectors(self.angles);

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

	dir = v_forward;
	dir = dir + pitch * v_up;
//PGM		
	
	makevectors(dir);

	missile.velocity = dir * 600;
	missile.velocity += (200 + crandom() * 40)* v_up;
	missile.velocity += (crandom() * 80) * v_right;

	missile.avelocity = '3000 1000 2000';

	missile.touch = undead_GrenadeTouch;

// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = SUB_Remove;

	setmodel(missile, "progs/zom_gib.mdl");
	setsize(missile, '0 0 0', '0 0 0');
	missile.traileffectnum = particleeffectnum("EF_ZOMBIEFLESHSPRAY");

	setorigin(missile, org);
};

void() zom_missile =
{
	for (float i = 0; i < 3; i++ )
		undead_FireGrenade ();
}

void() zom_Melee =
{
	float ldmg;
	vector delta;

	ai_face();

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;
	if (!CanDamage(self.enemy, self))
		return;

//	sound(self, CHAN_WEAPON, "demon/dhit2.wav", 1, ATTN_NORM);
	ldmg = 8 + 5*random();
	T_Damage(self.enemy, self, self.origin + v_forward*16, self, ldmg, 15);

	makevectors(self.angles);
};



void() undead_atk1 = [ 324, undead_atk2 ] { ai_charge (2); self.nextthink = time + 0.04;};
void() undead_atk2 = [ self.frame, undead_atk2 ] 
{	
	self.frame ++;

	if (self.frame == 339)
		zom_Melee ();
	
	if (self.frame == 345)
		zom_missile ();
	
	if (self.frame >= 353)
	{	
		undead_run2 ();
		self.frame = 58;
		return;
	}
	
	if(self.frame < 347)
		ai_charge (2);
	
	self.nextthink = time + 0.04; 
};


/*
=============================================================================

PAIN

=============================================================================
*/


void() undead_paina1 = [ 311, undead_paina2 ] {self.health = 60; ai_move (-4); self.nextthink = time + 0.04; };
void() undead_paina2 = [ self.frame, undead_paina2 ] 
{	
	self.frame ++;
	
	if (self.frame >= 323)
	{	
		undead_run1 ();
		return;
	}

	ai_move (2);
	
	self.nextthink = time + 0.04; 
};

void() undead_paine1 = [ 354, undead_paine2 ] {self.health = 60; ai_move (-10); self.nextthink = time + 0.04; };
void() undead_paine2 = [ self.frame, undead_paine2 ] 
{	
	self.frame ++;
	self.maxs_z = 8;
	self.solid = SOLID_CORPSE;
	self.takedamage = DAMAGE_YES;
	
	if (self.frame >= 384)
	{	
		self.ltime = time + 14;
		undead_stun1 ();
		return;
	}

	if (self.frame > 358 && self.frame < 364)
		ai_move (-4);
	
	self.nextthink = time + 0.04; 
};

void() undead_stun1 = [ 211, undead_stun2 ] {self.nextthink = time + 0.08; };
void() undead_stun2 = [ self.frame, undead_stun2 ] 
{	
	self.frame ++;
	
	if (self.frame >= 225)
	{	
		if (!walkmove (0, 0))
			self.ltime = time + 6;
	
		if (time > self.ltime && walkmove (0, 0))
		{
			self.maxs_z = 64;
			undead_getup1 ();
			return;
		}
		undead_stun1 ();
		return;
	}
	
	self.nextthink = time + 0.08; 
};

void() undead_getup1 = [ 226, undead_getup2 ] { self.nextthink = time + 0.04; };
void() undead_getup2 = [ self.frame, undead_getup2 ] 
{	
	self.frame ++;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_AIM;
	self.health = 60;
	
	if (self.frame >= 310)
	{	
		self.inpain = 0;
		undead_run1 ();
		return;
	}

	if (self.frame > 253 && self.frame < 280)
		ai_move (1);

	if (self.frame > 290 && self.frame < 296)
		ai_move (2);

//	if (self.frame > 298 && self.frame < 310)
//		ai_move (1);
	
	self.nextthink = time + 0.04; 
};

void() undead_die =
{
	sound(self, CHAN_VOICE, "zombie/z_gib.wav", 1, ATTN_NORM);
	MonsterGib (self.health);
	remove(self);
};

/*
=================
undead_pain

undead_s can only be killed(gibbed) by doing 60 hit points of damage
in a single frame(rockets, grenades, quad shotgun, quad nailgun).

A hit of 25 points or more(super shotgun, quad nailgun) will allways put it
down to the ground.

A hit of from 10 to 40 points in one frame will cause it to go down if it
has been twice in two seconds, otherwise it goes into one of the four
fast pain frames.

A hit of less than 10 points of damage(winged by a shotgun) will be ignored.

FIXME: don't use pain_finished because of nightmare hack
=================
*/
void(entity attacker, float take) undead_pain =
{
	float r;
	
	if (attacker.weapon == IT_RAILGUN) 
		self.max_health = self.health - take; // allways reset health

	self.health = self.max_health;

	// go down immediately if hit by a shotgun
	if (attacker.weapon == IT_SUPER_SHOTGUN)
	{
		self.inpain = 2;
		undead_paine1();
		return;
	}

	if (take < 9)
		return; // totally ignore

	if (self.inpain == 2)
		return; // down on ground, so don't reset any counters

// go down immediately if a big enough hit
	if (take >= 25)
	{
		self.inpain = 2;
		undead_paine1();
		return;
	}

	if (self.inpain)
	{
// if hit again in next gre seconds while not in pain frames, definately drop
		self.pain_finished = time + 3;
		return; // currently going through an animation, don't change
	}

	if (self.pain_finished > time)
	{
// hit again, so drop down
		self.inpain = 2;
		undead_paine1();
		return;
	}

// gp into one of the fast pain animations
	self.inpain = 1;

	r = random();
	if (r < 0.75)
		undead_paina1();
};

//============================================================================

/*QUAKED monster_zombie (1 0 0) (-16 -16 -24) (16 16 32) Crucified ambush

If crucified, stick the bounding box 12 pixels back into a wall to look right.
*/
void() monster_zombie =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model("progs/zombie.mdl");
	precache_model("progs/h_zombie.mdl");
	precache_model("progs/zom_gib.mdl");

	precache_sound("zombie/z_idle.wav");
	precache_sound("zombie/z_idle1.wav");
	precache_sound("zombie/z_shot1.wav");
	precache_sound("zombie/z_gib.wav");
	precache_sound("zombie/z_pain.wav");
	precache_sound("zombie/z_pain1.wav");
	precache_sound("zombie/z_fall.wav");
	precache_sound("zombie/z_miss.wav");
	precache_sound("zombie/z_hit.wav");
	precache_sound("zombie/idle_w2.wav");

	particleeffectnum("EF_ZOMBIEFLESHSPRAY");

	spawn_undead ();
};

float	SPAWN_CRUCIFIED	= 1;

void() spawn_undead =
{
		self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/zombie.mdl");

	setsize(self, '-16 -16 0', '16 16 64');
	self.health = 60;
	self.max_health = 60;
	self.mass = 300;
	self.scale = 0.8;

	self.th_stand = undead_stand1;
	self.th_walk = undead_walk1;
	self.th_run = undead_run1;
	self.th_pain = undead_pain;
	self.th_die = undead_die;
	self.th_missile = undead_atk1;
	//self.th_melee = undead_atk1;
	self.th_spawn = spawn_undead;

	if (self.spawnflags & SPAWN_CRUCIFIED)
	{
		self.movetype = MOVETYPE_NONE;
		undead_cruc1();
	}
	else
		walkmonster_start();
};
