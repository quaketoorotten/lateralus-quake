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

void() spawn_stand1 = [ 0, spawn_stand2 ] { ai_stand();};
void() spawn_stand2 = [ self.frame, spawn_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 39) 
	{	
		spawn_stand1 ();
		return;
	}
	ai_stand ();
};

void() spawn_walk1 = [ 0, spawn_walk2 ] { ai_walk(4);};
void() spawn_walk2 = [ self.frame, spawn_walk2 ] 
{ 
	self.frame ++;
	if (self.frame >= 39) 
	{
		spawn_walk1 ();
		return;
	}
	ai_walk (4);
};

void() spawn_run1 = [ 0, spawn_run2 ] { ai_run(4);};
void() spawn_run2 = [ self.frame, spawn_run2 ] 
{ 
	self.frame ++;
	if (self.frame >= 39) 
	{
		spawn_run1 ();
		return;
	}
	ai_run (4);
};


void(entity attacker, float damage) spawn_pain1 = [ 85, spawn_pain2 ] {self.movetype = MOVETYPE_STEP; ai_move(-15); self.nextthink = time + 0.02;};
void() spawn_pain2 = [ self.frame, spawn_pain2 ] 
{ 
	self.frame ++;
	if (self.frame >= 111) 
	{
		spawn_run1 ();
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
		return;
	if (!CanDamage(self.enemy, self))
		return;

	ldmg = 2 + 5*random();
	T_Damage(self.enemy, self, self.origin + v_forward*16, self, ldmg, 15);

};

void() spawn_atta1 = [ 152, spawn_atta2 ] {ai_face(); self.nextthink = time + 0.04;};
void() spawn_atta2 = [ self.frame, spawn_atta2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.04;

	if (self.frame == 168)
		 soul_Melee();

	if (self.frame >= 200) 
	{
		spawn_run1 ();
		return;
	}

	if (self.frame > 163 && self.frame < 194)
		ai_charge (4);
	else
		ai_charge (-2);
};

//============================================================================


void() spawn_jump1;

void() Tar_JumpTouch =
{
	local float 	ldmg;
	
	if (other.health <= 0)
		return;

	if (time < self.dmgtime)
		return;

	self.dmgtime = time + 0.33;
		
	if (other.takedamage)
	{
		ldmg = 5 + 10*random();
		T_Damage (other, self, self.origin, self, ldmg, 2);	
		//sound (self, CHAN_VOICE, "player/punch.wav", 1, ATTN_NORM);
	}
};


void() spawn_jump1 = [ 112, spawn_jump2 ] 
{ 
	ai_face();
	self.nextthink = time + 0.04;
	self.movetype = MOVETYPE_FLY;	
	self.flags = self.flags - (self.flags & FL_ONGROUND);

	local vector dir = normalize((self.enemy.origin + self.enemy.view_ofs)- self.origin);

	self.velocity = dir * 500; 
	self.angles = vectoangles(dir);
	self.touch = Tar_JumpTouch ;
};
void() spawn_jump2 = [ self.frame, spawn_jump2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.04;

	local vector dir = normalize((self.enemy.origin + self.enemy.view_ofs)- self.origin);

	self.velocity = dir * 350; 
	self.angles = vectoangles(dir);
	self.touch = Tar_JumpTouch ;
	
	if (self.frame >= 151) 
	{	
		self.movetype = MOVETYPE_STEP;
		spawn_run1 ();
		return;
	}
	ai_face ();
};


//=============================================================================

void() spawn_die1 = [ $exp, spawn_die2 ] { self.takedamage = DAMAGE_NO; };
void() spawn_die2 = [ $exp, spawn_run1 ]
{
	T_RadiusDamage(self, self, 20, 60, world);

	sound(self, CHAN_VOICE, "blob/death1.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_TAREXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);

	BecomeExplosion2();
};

//=============================================================================


/*QUAKED monster_tarbaby (1 0 0) (-16 -16 -24) (16 16 24) Ambush
*/
void() monster_tarbaby =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2 ("progs/tarbaby.mdl");

	precache_sound2 ("blob/death1.wav");
	precache_sound2 ("blob/hit1.wav");
	precache_sound2 ("blob/land1.wav");
	precache_sound2 ("blob/sight1.wav");
	particleeffectnum("TE_LOST_FLAME");
	particleeffectnum("TE_LOST_SMOKE");


	spawn_spawn();
};

void() spawn_spawn =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/tarbaby.mdl");

	setsize(self, '-16 -16 -24', '16 16 40');
	self.health = 80;

	self.th_stand = spawn_stand1;
	self.th_walk = spawn_walk1;
	self.th_run = spawn_run1;
	self.th_missile = spawn_jump1;
	self.th_melee = spawn_jump1;
	self.th_die = spawn_die1;
	self.th_pain = spawn_pain1;
	self.th_spawn = spawn_spawn;	
	self.th_melee = spawn_atta1;
	self.emiteffectnum = (particleeffectnum("TE_LOST_FLAME"));
	self.traileffectnum = (particleeffectnum("TE_LOST_SMOKE"));

	
	flymonster_start();
};
