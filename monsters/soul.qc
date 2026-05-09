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

BLOB

==============================================================================
*/

$cd /raid/quake/id1/models/tarbaby
$origin 0 0 24
$base base

$skin skin

$frame walk1 walk2 walk3 walk4  walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19
$frame walk20 walk21 walk22 walk23 walk24 walk25

$frame run1 run2 run3 run4 run5 run6  run7 run8 run9 run10 run11 run12 run13
$frame run14 run15 run16 run17 run18 run19 run20 run21 run22 run23
$frame run24 run25

$frame jump1 jump2 jump3 jump4 jump5 jump6

$frame fly1 fly2 fly3 fly4

$frame exp

void() soul_stand1 = [ 0, soul_stand2 ] { ai_stand();};
void() soul_stand2 = [ self.frame, soul_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 39) 
	{	
		if (random() < 0.2)
			soul_idle();
		
		soul_stand1 ();
		return;
	}
	ai_stand ();
};

void() soul_walk1 = [ 0, soul_walk2 ] { ai_walk(4);};
void() soul_walk2 = [ self.frame, soul_walk2 ] 
{ 
	self.frame ++;
	if (self.frame >= 39) 
	{	
		if (random() < 0.2)
			soul_idle();
		
		soul_walk1 ();
		return;
	}
	ai_walk (4);
};

void() soul_run1 = [ 0, soul_run2 ] { ai_run(4);};
void() soul_run2 = [ self.frame, soul_run2 ] 
{ 
	self.frame ++;
	if (self.frame >= 39) 
	{	
		if (random() < 0.2)
			soul_chatter();

		soul_run1 ();
		return;
	}
	ai_run (4);
};


void(entity attacker, float damage) soul_pain1 = [ 85, soul_pain2 ] {soul_pain(); self.movetype = MOVETYPE_STEP; ai_move(-15); self.nextthink = time + 0.02;};
void() soul_pain2 = [ self.frame, soul_pain2 ] 
{ 
	self.frame ++;
	if (self.frame >= 111) 
	{
		soul_run1 ();
		return;
	}
	
	if (self.frame < 97)
		ai_move(-4);	
	
	if (self.frame > 97 && self.frame < 105)
		ai_move(4);

	self.nextthink = time + 0.02;
};

void() soul_Melee =
{
	float ldmg;
	vector delta;

	ai_face();

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 90)
	{	
		soul_miss();
		return;
	}
		
	if (!CanDamage(self.enemy, self))
		return;

	ldmg = 2 + 5*random();
	T_Damage(self.enemy, self, self.origin + v_forward*16, self, ldmg, 15);

};

void() soul_atta1 = [ 152, soul_atta2 ] {ai_face(); self.nextthink = time + 0.035;};
void() soul_atta2 = [ self.frame, soul_atta2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.035;

	if (self.frame == 168)
		 soul_Melee();

	if (self.frame >= 200) 
	{
		soul_run1 ();
		return;
	}

	if (self.frame > 163 && self.frame < 194)
		ai_charge (6);
	else
		ai_charge (-2);
};

//============================================================================


void() soul_jump1;

void() Tar_JumpTouch =
{
	local float 	ldmg;

	if (other.solid == SOLID_BSP)
	{	
		sound(self, CHAN_BODY, "misc/null.wav", 1, ATTN_NORM);
		self.movetype = MOVETYPE_STEP;
		self.think = self.th_run;
		self.nextthink = time;
		return;
	}
	
	if (other.health <= 0)
		return;
		
	if (other.takedamage)
	{	
		sound(self, CHAN_BODY, "misc/null.wav", 1, ATTN_NORM);
		ldmg = 12 + 10*random();
		T_Damage (other, self, self.origin, self, ldmg, 2);	
		self.touch = SUB_Null;
		soul_hit();
		self.movetype = MOVETYPE_STEP;
		self.think = self.th_run;
		self.nextthink = time;
	}
};


void() soul_jump1 = [ 112, soul_jump2 ] 
{ 	
	soul_attack ();
	ai_face();
	self.nextthink = time + 0.035;
	self.movetype = MOVETYPE_FLY;	
	self.flags = self.flags - (self.flags & FL_ONGROUND);

	local vector dir = normalize((self.enemy.origin + self.enemy.view_ofs)- self.origin);

	self.velocity = dir * 800; 
	self.angles = vectoangles(dir);
	self.touch = Tar_JumpTouch;
	soul_charge();

};
void() soul_jump2 = [ self.frame, soul_jump2 ] 
{ 	
	self.frame ++;
	self.nextthink = time + 0.035;
	
	if (self.frame >= 151) 
	{	
		self.movetype = MOVETYPE_STEP;
		soul_run1 ();
		return;
	}
	//ai_face ();
};

void() soul_meleea = 
{
	if (vlen(self.origin - self.enemy.origin) > 90)
		soul_jump1();
	else
		soul_atta1();
}

//=============================================================================

void() soul_die1 = [ $exp, soul_die2 ] { soul_die(); self.takedamage = DAMAGE_NO; };
void() soul_die2 = [ $exp, soul_run1 ]
{
	//T_RadiusDamage(self, self, 60, 60, world);

	pointparticles (particleeffectnum("TE_EXPLOSION_BLAST"), self.origin, self.origin, 2);
	pointparticles (particleeffectnum("TE_EXPLOD"), self.origin, self.origin, 1);

	sound(self, CHAN_VOICE, "blob/death1.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);
	remove(self);
};

//=============================================================================

static void() soul_sight =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/lost_soul/sight/sight_01.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/lost_soul/sight/sight_02.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/lost_soul/sight/sight_03.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/lost_soul/sight/sight_04.wav", 1, ATTN_NORM);
};

static void() soul_die =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/lost_soul/death_01.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/lost_soul/death_02.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/lost_soul/death_03.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/lost_soul/death_04.wav", 1, ATTN_NORM);
};

static void() soul_idle =
{
	if (random() <= 0.5)
		    sound(self, CHAN_VOICE, "monsters/lost_soul/idle_01.wav", 1, ATTN_IDLE);
	else
		    sound(self, CHAN_VOICE, "monsters/lost_soul/idle_02.wav", 1, ATTN_IDLE);
};

static void() soul_pain =
{
	if (random() <= 0.5)
		    sound(self, CHAN_VOICE, "monsters/lost_soul/pain_01.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/lost_soul/pain_02.wav", 1, ATTN_NORM);
};

static void() soul_attack =
{
	if (random() <= 0.5)
		    sound(self, CHAN_VOICE, "monsters/lost_soul/attack_02.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/lost_soul/attack_01.wav", 1, ATTN_NORM);
};

static void() soul_chatter =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/lost_soul/chatter_01.wav", 1, ATTN_IDLE);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/lost_soul/chatter_02.wav", 1, ATTN_IDLE);
	else
		    sound(self, CHAN_VOICE, "monsters/lost_soul/chatter_03.wav", 1, ATTN_IDLE);
};

static void() soul_charge =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_BODY, "monsters/lost_soul/charge_01.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_BODY, "monsters/lost_soul/charge_02.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_BODY, "monsters/lost_soul/charge_03.wav", 1, ATTN_NORM);
};

static void() soul_miss =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/imp/melee/miss_01.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/imp/melee/miss_02.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/imp/melee/miss_03.wav", 1, ATTN_NORM);
};

static void() soul_hit =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/imp/melee/hit_03.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/imp/melee/hit_01.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/imp/melee/hit_04.wav", 1, ATTN_NORM);
};

/*QUAKED monster_tarbaby (1 0 0) (-16 -16 -24) (16 16 24) Ambush
*/
void() monster_tarbaby =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2 ("progs/tarbaby.md3");

	precache_sound2 ("monsters/lost_soul/charge_01.wav");
	precache_sound2 ("monsters/lost_soul/charge_02.wav");
	precache_sound2 ("monsters/lost_soul/charge_03.wav");
	precache_sound2 ("monsters/lost_soul/sight/sight_01.wav");
	precache_sound2 ("monsters/lost_soul/sight/sight_02.wav");
	precache_sound2 ("monsters/lost_soul/sight/sight_03.wav");
	precache_sound2 ("monsters/lost_soul/sight/sight_04.wav");
	precache_sound2 ("monsters/lost_soul/chatter_01.wav");
	precache_sound2 ("monsters/lost_soul/chatter_02.wav");
	precache_sound2 ("monsters/lost_soul/chatter_03.wav");
	precache_sound2 ("monsters/lost_soul/pain_01.wav");
	precache_sound2 ("monsters/lost_soul/pain_02.wav");
	precache_sound2 ("monsters/lost_soul/death_01.wav");
	precache_sound2 ("monsters/lost_soul/death_02.wav");
	precache_sound2 ("monsters/lost_soul/death_03.wav");
	precache_sound2 ("monsters/lost_soul/death_04.wav");
	precache_sound2 ("monsters/lost_soul/idle_01.wav");
	precache_sound2 ("monsters/lost_soul/idle_02.wav");
	precache_sound2 ("monsters/lost_soul/attack_01.wav");
	precache_sound2 ("monsters/lost_soul/attack_02.wav");

	precache_sound("monsters/imp/melee/hit_01.wav");
	precache_sound("monsters/imp/melee/hit_03.wav");
	precache_sound("monsters/imp/melee/hit_04.wav");

	particleeffectnum("TE_LOST_FLAME");
	particleeffectnum("TE_LOST_SMOKE");

	monster_myling_cache();
	
	if (world.model == "maps/e4m6.bsp")
		spawn_myling();
	 else
		spawn_soul();

	self.classname = "monster_grabbable";
};

void() spawn_soul =
{	
	self.classname = "monster_grabbable";
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/tarbaby.md3");

	setsize(self, '-16 -16 -24', '16 16 40');
	self.health = 120;

	self.th_stand = soul_stand1;
	self.th_walk = soul_walk1;
	self.th_run = soul_run1;
	self.th_missile = soul_jump1;
	self.th_melee = soul_jump1;
	self.th_die = soul_die1;
	self.th_pain = soul_pain1;
	self.th_spawn = spawn_soul;	
	self.th_melee = soul_meleea;
	self.emiteffectnum = (particleeffectnum("TE_LOST_FLAME"));
	self.traileffectnum = (particleeffectnum("TE_LOST_SMOKE"));
	self.th_sight = soul_sight;
	self.deathtype = "become one with the Lost Souls";
	
	flymonster_start();
};
