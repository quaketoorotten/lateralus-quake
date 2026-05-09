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

SOLDIER / PLAYER

==============================================================================
*/

void() zsec2_fire =
{
	vector dir, org, off = '0 7 48';
	entity en;

//	AutofireMachineEnemyNoise ();

// fire somewhat behind the player, so a dodging player is harder to hit
	en = self.enemy;
	
	makevectors(self.angles);
	org = ProjectAim(self.origin, off, v_forward, v_right) + '0 0 -4.5';
	
		local float r = rint(random() * 2);

		if (r==2)
			sound(self, CHAN_WEAPON, "weapons/pistol/pistol_shot_02a.wav", 1, ATTN_NORM);
		else if (r==1)
			sound(self, CHAN_WEAPON, "weapons/pistol/pistol_shot_03a.wav", 1, ATTN_NORM);
		else
			sound(self, CHAN_WEAPON, "weapons/pistol/pistol_shot_04a.wav", 1, ATTN_NORM);

	dir = en.origin - en.velocity*0.2  + '0 0 -24';
	dir = normalize(dir - self.origin);

	monster_FireBullets (12, org, dir, '0.12 0.1 0', 3, 5, 7200);

	makevectors(self.angles);
	org = ProjectAim(self.origin, off, v_forward, v_right);

	local entity muzzle = spawn ();
	muzzle.origin = self.origin;
	setmodel(muzzle, "progs/infantrymf.mdl");
	setsize (muzzle, '-16 -16 0', '16 16 64');
	muzzle.think = SUB_Remove;
	muzzle.frame = self.frame;
	muzzle.nextthink = time + 0.14;
	muzzle.angles = self.angles;
	muzzle.scale = self.scale;
};

//============================================================================

void() zsec2_stand1 = [ 0, zsec2_stand2 ] {ai_stand();};
void() zsec2_stand2 = [ self.frame, zsec2_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 50) 
	{	
		if (random() < 0.2)
			zsec_idle ();
		zsec2_stand1 ();
		return;
	}
	ai_stand ();
};

void() zsec2_walk1 = [ 72, zsec2_walk2 ] {ai_walk(2);};
void() zsec2_walk2 = [ self.frame, zsec2_walk2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 99) 
	{	
		if (random() < 0.2)
			zsec_idle ();
		zsec2_walk1 ();
		return;
	}
	ai_walk (2);
};

void() zsec2_run1 = [ 51, zsec2_run2 ] {ai_run(4);};
void() zsec2_run2 = [ self.frame, zsec2_run2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 71) 
	{	
		if (random() < 0.2)
			zsec_idle ();
		zsec2_run1 ();
		return;
	}
	ai_run (4);
};

void() zsec2_raise1 = [ 100, zsec2_raise2 ] {zsec_combat_0 (); ai_face(); self.nextthink = time + 0.03;};
void() zsec2_raise2 = [ self.frame, zsec2_raise2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;
	ai_face ();

	if (self.frame >= 109) 
	{	
		zsec2_aim1 ();	
		return;
	}
};

void() zsec2_lower1 = [ 176, zsec2_lower2 ] {self.nextthink = time + 0.03;};
void() zsec2_lower2 = [ self.frame, zsec2_lower2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;

	if (self.frame >= 186) 
	{	
		zsec2_run1 ();	
		return;
	}
};

void() zsec2_fire1 = [ 153, zsec2_fire2 ] {zsec_combat_0 (); ai_face(); self.nextthink = time + 0.03;};
void() zsec2_fire2 = [ self.frame, zsec2_fire2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;

	if (self.frame == 154)
	{	
		ai_face ();
		zsec2_fire();
	}
	
	if (self.frame >= 173) 
	{	
		zsec2_lower1 ();	
		return;
	}
};

void() zsec2_aim1 = [ 110, zsec2_aim2 ] {self.speed = time + 0.04; ai_face(); self.nextthink = time + 0.035;};
void() zsec2_aim2 = [ self.frame, zsec2_aim2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.035;
	ai_face ();

	if (!visible( self.enemy))
	{	
		zsec2_lower1 ();	
		return;
	}

	if (random() > 0.7)
	{	
		zsec2_fire1 ();	
		return;
	}

	if (self.frame >= 152) 
	{	
		zsec2_lower1 ();	
		return;
	}
};


void() zsec2_paina1 = [ 187, zsec2_paina2 ] {self.nextthink = time + 0.035;};
void() zsec2_paina2 = [ self.frame, zsec2_paina2 ] 
{ 	
	self.frame ++;
	self.nextthink = time + 0.035;
	if (self.frame >= 205) 
	{	
		zsec2_run1 ();
		return;
	}
};

void(entity attacker, float damage) zsec2_pain =
{
	float r;

	r = random();
	self.skin = 0;
	
	if (damage < 40)
		return;

	if (self.pain_finished > time)
		return;

	zsec_pain ();

	if (r < 0.6)
	{
		self.pain_finished = time + 1;
		zsec2_paina1();
	}
};

//============================================================================

void() zsec2_die =
{	
	if (self.health < -40)
	{	
		self.deadflag = DEAD_DEAD;
		self.solid = SOLID_NOT;
		self.think = zsec1_gib1;
		self.nextthink = time + 0.035;
		return;
	}
	
	if((self.deadflag & DEAD_DEAD))
		return;

	zsec_die ();

	local vector tmpangle;
	local float tempskin;
	tmpangle = self.angles;
	tempskin = self.skin;
	
	setmodel(self, "progs/infantrydeath.md3");
	setsize(self, '-16 -16 0', '16 16 64');	

	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_CORPSE;
	self.think = zsec1_die1;
	self.nextthink = time + 0.035;	
	DropItem (weapon_supershotgun);

	self.angles = tmpangle;
	//self.skin = tempskin;
};


/*QUAKED monster_enforcer (1 0 0) (-16 -16 -24) (16 16 40) Ambush

*/

void() monster_infantry =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2 ("progs/infantry.md3");
	precache_model2 ("progs/infantrydeath.md3");

	precache_model2 ("progs/infantrymf.mdl");

	precache_model2 ("progs/h_mega.mdl");
	precache_model2 ("progs/laser.mdl");

 	zsec_precache_sfx ();

	spawn_infantry ();
};

void() spawn_infantry =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/infantry.md3");

	setsize(self, '-16 -16 0', '16 16 64');
	self.health = 90;
	self.max_health = 90;
	self.scale = 0.78;
	self.mass = 100;
	self.skin = 0;
	self.th_sight = zsec_sight;

	self.th_stand = zsec2_stand1;
	self.th_walk = zsec2_walk1;
	self.th_run = zsec2_run1;
	self.th_pain = zsec2_pain;
	self.th_die = zsec2_die;
	self.th_missile = zsec2_raise1;	
	self.th_melee = zsec2_raise1;
	self.th_spawn = spawn_infantry;
	self.th_checkatck = Shotgun_SoldierCheckAttack;
	self.deathtype = "got their head blown off by a Shotgunner";

	walkmonster_start();
};