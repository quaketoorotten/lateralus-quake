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

/*
==============================================================================
SOLDIER CODE
==============================================================================
*/

void() zsec1_stand1 = [ 65, zsec1_stand2 ] { self.maxs_z = 64; ai_stand();};
void() zsec1_stand2 = [ self.frame, zsec1_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 115) 
	{	
		if (random() < 0.2)
			zsec_idle ();
		zsec1_stand1 ();
		return;
	}
	ai_stand ();
};

void() zsec1_walk1 = [ 204, zsec1_walk2 ] { self.maxs_z = 64; ai_walk(2); };
void() zsec1_walk2 = [ self.frame, zsec1_walk2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 247) 
	{	
		if (random() < 0.2)
			zsec_idle ();
		zsec1_walk1 ();
		return;
	}
	ai_walk (2);
};

void() zsec1_run1 = [ 248, zsec1_run2 ] { self.maxs_z = 64; ai_run(4); };
void() zsec1_run2 = [ self.frame, zsec1_run2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 285) 
	{	
		if (random() < 0.2)
			zsec_idle();
		zsec1_run1 ();
		return;
	}
	ai_run (4);
};

void() zsec1_atk1 = [ 130, zsec1_atk2 ] {self.maxs_z = 64; ai_face(); self.nextthink = time + 0.03;};
void() zsec1_atk2 = [ self.frame, zsec1_atk2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;

	if (self.frame == 132)
		zsec1_fire ();

	if (self.frame == 146 && random() <= 0.3 && skill > 1 && self.enemy.health > 0 && visible(self.enemy))
		self.frame = 130;

	if (self.frame >= 146) 
	{		
		if (random() <= 0.3 && skill > 1 && self.enemy.health > 0 && visible(self.enemy))
			self.frame = 131;
		else
		{
			zsec1_lower1 ();		
			return;
		}
	}

	if (self.frame < 136)
		ai_face ();
};

void() zsec1_raise1 = [ 116, zsec1_raise2 ] {zsec_combat_0 (); ai_face(); self.nextthink = time + 0.03;};
void() zsec1_raise2 = [ self.frame, zsec1_raise2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;
	ai_face ();

	if (self.frame >= 129) 
	{	
		zsec1_aim1 ();	
		return;
	}
};

void() zsec1_lower1 = [ 146, zsec1_lower2 ] {self.nextthink = time + 0.03;};
void() zsec1_lower2 = [ self.frame, zsec1_lower2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;

	if (self.frame >= 156) 
	{	
		zsec1_run1 ();	
		return;
	}
};

void() zsec1_aim1 = [ 301, zsec1_aim2 ] {self.speed = time + 0.04; ai_face(); self.nextthink = time + 0.035;};
void() zsec1_aim2 = [ self.frame, zsec1_aim2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.035;
	ai_face ();

	if (!visible( self.enemy))
	{	
		zsec1_lower1 ();	
		return;
	}

	if (random() <= 0.9)
	{	
		zsec1_atk1 ();	
		return;
	}

	if (self.frame >= 316) 
	{		
		zsec1_lower1 ();	
		return;
	}
};

void() zsec1_missile =
{	
	float rangee, vis;
	rangee = range (self.enemy);
	vis = visible(self.enemy);

	zsec_combat_0 ();

	zsec1_atk1 ();
}

void() zsec1_atkb1 = [ 161, zsec1_atkb2 ] {ai_face(); self.maxs_z = 32; self.nextthink = time + 0.03;};
void() zsec1_atkb2 = [ self.frame, zsec1_atkb2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;

	if (self.frame == 172)
		zsec1_fire ();
	
	if (self.frame >= 196) 
	{	
		self.flags &= ~FL_DODGED;
		zsec1_run1 ();		
		return;
	}

	if (self.frame < 172)
		ai_face ();
};

void() zsec1_strafel1 = [ 0, zsec1_strafel2 ] { self.maxs_z = 16;  self.nextthink = time + 0.03;};
void() zsec1_strafel2 = [ self.frame, zsec1_strafel2 ] 
{ 
	self.frame ++;
	if (self.frame >= 32) 
	{	
		self.flags &= ~FL_DODGED;
		zsec1_run1 ();
		return;
	}

	if (self.frame > 6 && self.frame < 19)
		ai_slide (4.5, 0.03);
	else if (self.frame < 6)
		ai_slide (2, 0.03);
	else
		self.nextthink = time + 0.03;
};

void() zsec1_strafer1 = [ 33, zsec1_strafer2 ] { self.maxs_z = 16;  self.nextthink = time + 0.03;};
void() zsec1_strafer2 = [ self.frame, zsec1_strafer2 ] 
{ 
	self.frame ++;
	if (self.frame >= 64) 
	{	
		self.flags &= ~FL_DODGED;
		zsec1_run1 ();
		return;
	}

	if (self.frame > 40 && self.frame < 50)
		ai_slide (5, 0.03);
	else if (self.frame < 40)
		ai_slide (2.5, 0.03);
	else
		self.nextthink = time + 0.03;
};

void() zsec1_roll =
{	
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);

	ChangeYaw ();

	if(self.lefty)
		zsec1_strafel1 ();
	else
		zsec1_strafer1 ();
	
	self.nextthink = time + frametime;
}

void() zsec1_dodge =
{	
	self.skin = 0;

	zsec_combat_0 ();

	if (skill == 0)
	{
		self.think = zsec1_roll;
		self.nextthink = time + frametime;
		return;
	}

	if (skill == 1)
	{
		if (random() > 0.33)
			self.think = zsec1_roll;
		else if (visible(self.enemy))
			self.think = zsec1_atkb1;

		self.nextthink = time + frametime;
		return;
	}

	if (skill >= 2)
	{
		if (random() > 0.66)
			self.think = zsec1_roll;
		else if (visible(self.enemy))
			self.think = zsec1_atkb1;

		self.nextthink = time + frametime;
		return;
	}
};

void(entity attacker, float damage) zsec1_pain =
{
	
	if (self.pain_finished > time)
		return;

	self.pain_finished = time + 1;

	zsec_pain ();
};


void() zsec1_fire =
{
	vector dir, org, off = '0 6 48';
	entity en;

	local float r = rint(random() * 2);


		if (r==2)
			sound(self, CHAN_WEAPON, "weapons/pistol/pistol_shot_02a.wav", 1, ATTN_NORM);
		else if (r==1)
			sound(self, CHAN_WEAPON, "weapons/pistol/pistol_shot_03a.wav", 1, ATTN_NORM);
		else
			sound(self, CHAN_WEAPON, "weapons/pistol/pistol_shot_04a.wav", 1, ATTN_NORM);

// fire somewhat behind the player, so a dodging player is harder to hit
	en = self.enemy;
	
	if (self.maxs_z < 64)
		off = '0 6 18';
	
	makevectors(self.angles);
	org = ProjectAim(self.origin, off, v_forward, v_right) + '0 0 -4.5';

	dir = en.origin - en.velocity*0.13  + '0 0 -24';
	dir = normalize(dir - self.origin);

	local entity muzzle = spawn ();
	muzzle.origin = self.origin;
	setmodel(muzzle, "progs/soldiermf.mdl");
	setsize (muzzle, '-16 -16 0', '16 16 64');
	muzzle.think = SUB_Remove;
	muzzle.frame = self.frame;
	muzzle.nextthink = time + 0.14;
	muzzle.angles = self.angles;
	muzzle.scale = self.scale;

	monster_FireBullets (1, org, dir, '0.02 0.04 0', 7, 2, 7200);
};

void() zsec1_die =
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
	
	setmodel(self, "progs/soldierdeath.md3");
	setsize(self, '-16 -16 0', '16 16 64');

	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_CORPSE;
	self.think = zsec1_die1;
	self.nextthink = time + 0.035;

	DropItem (weapon_shotgun);

	self.angles = tmpangle;
	//self.skin = tempskin;
};

void() zsec1_die1 = [ 0, zsec1_die2 ] { self.nextthink = time + 0.035;};
void() zsec1_die2 = [ self.frame, zsec1_die2 ] 
{ 	
	self.nextthink = time + 0.035;

	if (self.frame < 10)
		ai_move (-4);
	self.frame ++;
	if (self.frame == 30)
	{	
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() zsec1_gib1 = [ self.frame, zsec1_gib2 ] 
{MonsterGib (self.health); self.skin = 1; self.alpha = 1; self.nextthink = time + 0.02;};

void() zsec1_gib2 = [ self.frame, zsec1_gib2 ] 
{ 	
	self.nextthink = time + 0.02;
	self.alpha -= 0.02;
	if (self.alpha <= 0)
	{
		remove(self);
		return;
	}
}


/*QUAKED monster_army (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_army =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/soldier.md3");
	precache_model("progs/soldiermf.mdl");
	precache_model("progs/soldierdeath.md3");
	precache_model("progs/gib1.mdl");
	precache_model("progs/gib2.mdl");
	precache_model("progs/gib3.mdl");

	zsec_precache_sfx ();
	precache_model2 ("progs/infantry.md3");
	precache_model2 ("progs/infantrydeath.md3");

	precache_model("progs/infantrymf.mdl");
	precache_model2 ("progs/h_mega.mdl");
	precache_model2 ("progs/laser.mdl");

	
	if (random() > 0.6)
		spawn_zsec1 ();
	else
		spawn_infantry();
};

void() monster_army2 =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/soldier.md3");
	precache_model("progs/soldiermf.mdl");
	precache_model("progs/soldierdeath.md3");

	precache_model("progs/h_guard.mdl");
	precache_model("progs/gib1.mdl");
	precache_model("progs/gib2.mdl");
	precache_model("progs/gib3.mdl");

	zsec_precache_sfx ();
	
	spawn_zsec1 ();

};

/*
===========
SoldierCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() Pistol_SoldierCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;

	targ = self.enemy;
	
// see if any entities are in the way of the shot
	vector org, off = '0 7 48';

	makevectors(self.angles);
	org = ProjectAim(self.origin, off, v_forward, v_right);

	spot1 = org ;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_ent != targ)
		return FALSE;	// don't have a clear shot	

	if (enemy_range == RANGE_MELEE)
	{	
		// don't always melee in easy mode
		if (skill == 0 && (rand()&3) )
			return FALSE;

		self.attack_state = AS_MELEE;
		return TRUE;
	}		
	
// missile attack
	if (time < self.attack_finished)
		return FALSE;	
	
	if (enemy_range == RANGE_FAR)
		return FALSE;
		
	if (enemy_range == RANGE_CLOSE)
		chance = 0.4;
	else if (enemy_range == RANGE_NEAR)
		chance = 0.7;
	else if (enemy_range == RANGE_MID)
		chance = 0.9;
	else
		chance = 0;

	if (random () < chance)
	{
		self.attack_state = AS_MISSILE;
		SUB_AttackFinished (1.2 + random()*2);

		return TRUE;
	}

	return FALSE;
};

float() Shotgun_SoldierCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;

	targ = self.enemy;
	
// see if any entities are in the way of the shot
	vector org, off = '0 7 48';

	makevectors(self.angles);
	org = ProjectAim(self.origin, off, v_forward, v_right);

	spot1 = org ;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_ent != targ)
		return FALSE;	// don't have a clear shot	

	if (enemy_range == RANGE_MELEE)
	{	
		// don't always melee in easy mode
		if (skill == 0 && (rand()&3) )
			return FALSE;

		self.attack_state = AS_MELEE;
		return TRUE;
	}		
	
// missile attack
	if (time < self.attack_finished)
		return FALSE;	
	
	if (enemy_range == RANGE_FAR)
		return FALSE;
		
	if (enemy_range == RANGE_CLOSE)
		chance = 0.2;
	else if (enemy_range == RANGE_NEAR)
		chance = 0.3;
	else if (enemy_range == RANGE_MID)
		chance = 0.4;
	else
		chance = 0;

	if (random () < chance)
	{
		self.attack_state = AS_MISSILE;
		SUB_AttackFinished (1.2 + random()*2);

		return TRUE;
	}

	return FALSE;
};

float() Machineg_SoldierCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;

	targ = self.enemy;
	
// see if any entities are in the way of the shot
	vector org, off = '0 7 48';

	makevectors(self.angles);
	org = ProjectAim(self.origin, off, v_forward, v_right);

	spot1 = org;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_ent != targ)
		return FALSE;	// don't have a clear shot	

	if (enemy_range == RANGE_MELEE)
	{	
		self.attack_state = AS_MELEE;
		return TRUE;
	}		
	
// missile attack
	if (time < self.attack_finished)
		return FALSE;	
	
	if (enemy_range == RANGE_FAR)
		return FALSE;
		
	if (enemy_range == RANGE_CLOSE)
		chance = 4.2;
	else if (enemy_range == RANGE_NEAR)
		chance = 1.9;
	else if (enemy_range == RANGE_MID)
		chance = 0.9;
	else
		chance = 0;

	if (random () < chance)
	{
		self.attack_state = AS_MISSILE;
		SUB_AttackFinished (1.2 + random()*2);

		return TRUE;
	}

	return FALSE;
};



void() spawn_zsec1 = 
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/soldier.md3");

	setsize(self, '-16 -16 0', '16 16 64');
	self.health = 55;
	self.max_health = 55;
	self.mass = 100;
	// self.dcnt = 0;
	self.scale = 0.74;

	self.th_stand = zsec1_stand1;
	self.th_walk = zsec1_walk1;
	self.th_run = zsec1_run1;
	self.th_missile = zsec1_missile;
	self.th_melee = zsec1_missile;
	self.th_pain = zsec1_pain;
	self.th_die = zsec1_die;
	self.th_dodge = zsec1_dodge;
	self.th_checkatck = Pistol_SoldierCheckAttack;
	self.th_spawn = spawn_zsec1;
	self.th_sight = zsec_sight;
	self.deathtype = "was sniped by a Pistolero";

	walkmonster_start();
};
