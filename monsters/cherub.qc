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


void() cherub_stand1 = [ 0, cherub_stand1 ] { ai_stand(); 
	if (random() < 0.02)
			cher_idle ();
};

void() cherub_walk1 = [ 64, cherub_walk2 ] { ai_walk(2);};
void() cherub_walk2 = [ self.frame, cherub_walk2 ] 
{ 
	self.frame ++;
	if (self.frame >= 117) 
	{	
		if (random() < 0.2)
			cher_idle ();
		cherub_walk1 ();
		return;
	}

	if (self.frame < 114)
		ai_walk (2);
	else
		ai_walk (0);
};

void() cherub_run1 = [ 0, cherub_run2 ] { ai_face(); self.nextthink = time + 0.035;};
void() cherub_run2 = [ self.frame, cherub_run2 ] 
{ 
	self.frame ++;
	if (self.frame >= 63) 
	{	
		if (random() < 0.2)
			cher_attack ();
		cherub_run1 ();
		return;
	}

	if (self.frame < 8)
		ai_run (6);
	else if (self.frame > 8 && self.frame < 17)
		ai_run (24);
	else if (self.frame > 17 && self.frame < 21)
		ai_run (6);
	else if (self.frame > 21 && self.frame < 26)
		ai_face ();
	else if (self.frame > 26 && self.frame < 51)
		ai_run (24);
	else if (self.frame > 51)
		ai_run (4);
	else 
		self.nextthink = time + 0.035;
};

void(entity attacker, float damage) cherub_pain =
{
	if (random() > 0.3)
		return;
	
	cher_pain ();
	cherub_pain1();
};


void() cherub_pain1 = [ 168, cherub_pain2 ] { self.nextthink = time + 0.02;};
void() cherub_pain2 = [ self.frame, cherub_pain2 ] 
{ 
	self.frame ++;
	if (self.frame >= 187) 
	{
		cherub_run1 ();
		return;
	}
	
	if (self.frame < 169)
		ai_move(2);	
	
	if (self.frame > 169 && self.frame < 176)
		ai_move(4);

	self.nextthink = time + 0.02;
};

void() cherub_Melee =
{
	float ldmg;
	vector delta;

	ai_face();

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 90)
		return;
	if (!CanDamage(self.enemy, self))
		return;

	ldmg = 8 + 5*random();
	T_Damage(self.enemy, self, self.origin + v_forward*16, self, ldmg, 15);

};

void() cherub_atta1 = [ 135, cherub_atta2 ]
 { sound(self, CHAN_VOICE, "monsters/cherub/attack_01.wav", 1, ATTN_NORM); ai_face(); self.nextthink = time + 0.035;};
void() cherub_atta2 = [ self.frame, cherub_atta2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.035;

	if (self.frame == 145 || self.frame == 150)
		 cherub_Melee();

	if (self.frame >= 167) 
	{
		cherub_run1 ();
		return;
	}

	if (self.frame > 137)
		ai_charge (16);
	else
		ai_face ();
};

void() cherub_die =
{	
	if (self.health < -80)
	{		
		self.deadflag = DEAD_DEAD;
		self.solid = SOLID_NOT;
		self.think = cherub_gib1;
		self.nextthink = time + 0.035;
		return;
	}
	
	if((self.deadflag & DEAD_DEAD))
		return;

	local vector tmpangle;
	local float tempskin;
	tmpangle = self.angles;
	tempskin = self.skin;
	
	if (random () <= 0.5)
	{
		self.think = cherub_die1;
		setmodel(self, "progs/mylingdie.md3");
	}
	else
	{
		self.think = cherub_dieb1;
		setmodel(self, "progs/mylingdie2.md3");
	}
	setsize(self, '-16 -16 0', '16 16 56');

	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_CORPSE;

	cher_die ();
	
	self.nextthink = time + 0.035;

	self.angles = tmpangle;
	//self.skin = tempskin;
};

void() cherub_die1 = [ 0, cherub_die2 ] { self.nextthink = time + 0.035;};
void() cherub_die2 = [ self.frame, cherub_die2 ] 
{ 	
	self.nextthink = time + 0.035;

	self.frame ++;
	if (self.frame < 8)
		ai_move (-4);
	
	if (self.frame == 16)
	{	
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() cherub_dieb1 = [ 0, cherub_dieb2 ] { self.nextthink = time + 0.035;};
void() cherub_dieb2 = [ self.frame, cherub_dieb2 ] 
{ 	
	self.nextthink = time + 0.035;

	self.frame ++;
	if (self.frame < 8)
		ai_move (-6);
	
	if (self.frame == 25)
	{	
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};


void() cherub_gib1 = [ self.frame, cherub_gib2 ] 
{MonsterGib (self.health); self.skin = 1; self.alpha = 1; self.nextthink = time + 0.02;};

void() cherub_gib2 = [ self.frame, cherub_gib2 ] 
{ 	
	self.nextthink = time + 0.02;
	self.alpha -= 0.02;
	if (self.alpha <= 0)
	{
		remove(self);
		return;
	}
};

//============================================================================

static void() cher_die =
{
	local float r = rint(random() * 1);	

	if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/cherub/death_01.wav", 1, ATTN_NORM);
	else 
		    sound(self, CHAN_VOICE, "monsters/cherub/death_02.wav", 1, ATTN_NORM);
};

static void() cher_sight =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/cherub/sight_01.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/cherub/sight_02.wav", 1, ATTN_NORM);
	else 
		    sound(self, CHAN_VOICE, "monsters/cherub/sight_03.wav", 1, ATTN_NORM);
};

static void() cher_pain =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/cherub/pain_01a.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/cherub/pain_02a.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/cherub/pain_03a.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/cherub/pain_04a.wav", 1, ATTN_NORM);
};

static void() cher_attack =
{
	if (random() <= 0.5)
		    sound(self, CHAN_VOICE, "monsters/cherub/chatter_combat_01.wav", 1, ATTN_NORM);
	else 
		    sound(self, CHAN_VOICE, "monsters/cherub/chatter_combat_02.wav", 1, ATTN_NORM);
};

static void() cher_idle =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/cherub/idle_01.wav", 1, ATTN_IDLE);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/cherub/idle_02.wav", 1, ATTN_IDLE);
	else 
		    sound(self, CHAN_VOICE, "monsters/cherub/idle_03.wav", 1, ATTN_IDLE);
};

static void() cher_flutter =
{

	if (random() < 0.5)
		    sound(self, CHAN_VOICE, "monsters/cherub/flutter_01.wav", 1, ATTN_IDLE);
	else 
		    sound(self, CHAN_VOICE, "monsters/cherub/flutter_02.wav", 1, ATTN_IDLE);
	
};


//=============================================================================


/*QUAKED monster_tarbaby (1 0 0) (-16 -16 -24) (16 16 24) Ambush
*/
void() monster_myling =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	monster_myling_cache ();	

	spawn_myling ();
	self.classname = "monster_grabbable";
};

void() monster_myling_cache =
{
	precache_model2 ("progs/myling.md3");
	precache_model2 ("progs/mylingdie.md3");
	precache_model2 ("progs/mylingdie2.md3");

	precache_sound ("monsters/cherub/flutter_01.wav");
	precache_sound ("monsters/cherub/flutter_02.wav");

	precache_sound ("monsters/cherub/idle_01.wav");
	precache_sound ("monsters/cherub/idle_02.wav");
	precache_sound ("monsters/cherub/idle_03.wav");

	precache_sound ("monsters/cherub/sight_01.wav");
	precache_sound ("monsters/cherub/sight_02.wav");
	precache_sound ("monsters/cherub/sight_03.wav");

	precache_sound ("monsters/cherub/pain_01a.wav");
	precache_sound ("monsters/cherub/pain_02a.wav");
	precache_sound ("monsters/cherub/pain_03a.wav");
	precache_sound ("monsters/cherub/pain_04a.wav");	
	
	precache_sound ("monsters/cherub/attack_01.wav");	
	precache_sound ("monsters/cherub/chatter_combat_01.wav");	
	precache_sound ("monsters/cherub/chatter_combat_02.wav");	

	precache_sound ("monsters/cherub/death_01.wav");
	precache_sound ("monsters/cherub/death_02.wav");
};

void() spawn_myling =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/myling.md3");

	setsize(self, '-16 -16 0', '16 16 56');
	self.health = 60;
	self.mass = 100;
	self.scale = 0.8;

	self.th_stand = cherub_stand1;
	self.th_walk = cherub_walk1;
	self.th_run = cherub_run1;
	self.th_die = cherub_die;
	self.th_pain = cherub_pain;
	self.th_spawn = spawn_myling;	
	self.th_melee = cherub_atta1;
	self.th_sight = cher_sight;

	self.deathtype = "is scared of babies";
	
	walkmonster_start();
};
