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

void() grunt_stand1 = [ 65, grunt_stand2 ] { self.maxs_z = 64; ai_stand();};
void() grunt_stand2 = [ self.frame, grunt_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 115) 
	{	
		if (random() < 0.2)
			zsec_idle ();
		grunt_stand1 ();
		return;
	}
	ai_stand ();
};

void() grunt_walk1 = [ 204, grunt_walk2 ] { self.maxs_z = 64; ai_walk(2); };
void() grunt_walk2 = [ self.frame, grunt_walk2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 247) 
	{	
		if (random() < 0.2)
			zsec_idle ();
		grunt_walk1 ();
		return;
	}
	ai_walk (2);
};

void() grunt_run1 = [ 248, grunt_run2 ] { self.maxs_z = 64; ai_run(4); };
void() grunt_run2 = [ self.frame, grunt_run2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 285) 
	{	
		if (random() < 0.2)
			zsec_idle();
		grunt_run1 ();
		return;
	}
	ai_run (4);
};

void() grunt_atk1 = [ 116, grunt_atk2 ] {self.maxs_z = 64; ai_face(); self.nextthink = time + 0.03;};
void() grunt_atk2 = [ self.frame, grunt_atk2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;

	if (self.frame == 132)
		grunt_fire ();

	if (self.frame > 131 && self.frame < 135)
		self.skin = 1;
	else
		self.skin = 0;

	if (self.frame == 146 && random() <= 0.3 && skill > 1 && self.enemy.health > 0)
		self.frame = 129;

	if (self.frame >= 160) 
	{	
		grunt_run1 ();		
		return;
	}

	if (self.frame < 146)
		ai_face ();
};

void() grunt_atkc1 = [ 286, grunt_atkc2 ] { ai_run_slide(3); self.nextthink = time + 0.03;};
void() grunt_atkc2 = [ self.frame, grunt_atkc2 ] 
{ 
	self.frame ++;
	ai_face();

	if (self.frame == 308)
		grunt_fire ();

	if (self.frame > 307 && self.frame < 312)
		self.skin = 1;
	else
		self.skin = 0;

	if (self.frame >= 320) 
	{	
		grunt_run1 ();		
		return;
	}

	if (self.frame < 295)
		ai_run_slide (6, 0.03);
	else if (self.frame > 295 && self.frame < 298)
		ai_run_slide (2, 0.03);
	else
		self.nextthink = time + 0.03;
};

void() grunt_atkd1 = [ 335, grunt_atkd2 ] { ai_run_slide(3); self.nextthink = time + 0.03;};
void() grunt_atkd2 = [ self.frame, grunt_atkd2 ] 
{ 
	self.frame ++;
	ai_face();

	if (self.frame == 351)
		grunt_fire ();

	if (self.frame > 350 && self.frame < 354)
		self.skin = 1;
	else
		self.skin = 0;

	if (self.frame >= 363) 
	{	
		grunt_run1 ();		
		return;
	}

	if (self.frame < 346 && self.frame > 338)
		ai_run_slide (6, 0.03);
	else if (self.frame > 346 && self.frame < 350)
		ai_run_slide (2, 0.03);
	else
		self.nextthink = time + 0.03;

};

void() grunt_missile =
{	
	float rangee, vis;
	rangee = range (self.enemy);
	vis = visible(self.enemy);

	zsec_combat_0 ();

	if (vis && rangee <= RANGE_CLOSE && random() <= 0.25)
	{
		ChangeYaw ();

		if(self.lefty)
			grunt_atkd1 ();
		else
			grunt_atkc1 ();
	
		self.nextthink = time + frametime;
	}
	else
	{
		grunt_atk1 ();
		return;
	}
}

void() grunt_atkb1 = [ 161, grunt_atkb2 ] {ai_face(); self.maxs_z = 32; self.nextthink = time + 0.03;};
void() grunt_atkb2 = [ self.frame, grunt_atkb2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;

	if (self.frame == 172)
		grunt_fire ();

	if (self.frame > 171 && self.frame < 176)
		self.skin = 1;
	else
		self.skin = 0;
	
	if (self.frame >= 196) 
	{	
		self.flags &= ~FL_DODGED;
		grunt_run1 ();		
		return;
	}

	if (self.frame < 172)
		ai_face ();
};

void() grunt_strafel1 = [ 0, grunt_strafel2 ] { self.maxs_z = 32;  self.nextthink = time + 0.04;};
void() grunt_strafel2 = [ self.frame, grunt_strafel2 ] 
{ 
	self.frame ++;
	if (self.frame >= 32) 
	{	
		self.flags &= ~FL_DODGED;
		grunt_run1 ();
		return;
	}

	if (self.frame > 6 && self.frame < 19)
		ai_run_slide (9, 0.04);
	else if (self.frame < 6)
		ai_run_slide (3, 0.04);
	else
		self.nextthink = time + 0.04;
};

void() grunt_strafer1 = [ 33, grunt_strafer2 ] { self.maxs_z = 32;  self.nextthink = time + 0.04;};
void() grunt_strafer2 = [ self.frame, grunt_strafer2 ] 
{ 
	self.frame ++;
	if (self.frame >= 64) 
	{	
		self.flags &= ~FL_DODGED;
		grunt_run1 ();
		return;
	}

	if (self.frame > 40 && self.frame < 50)
		ai_run_slide (9, 0.04);
	else if (self.frame < 40)
		ai_run_slide (4, 0.04);
	else
		self.nextthink = time + 0.04;
};

void() grunt_roll =
{	
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);

	if(self.lefty)
		grunt_strafel1 ();
	else
		grunt_strafer1 ();
	
	self.nextthink = time + frametime;
}

void() grunt_dodge =
{	
	self.skin = 0;

	zsec_combat_0 ();

	if (skill == 0)
	{
		self.think = grunt_roll;
		self.nextthink = time + frametime;
		return;
	}

	if (skill == 1)
	{
		if (random() > 0.33)
			self.think = grunt_roll;
		else
			self.think = grunt_atkb1;

		self.nextthink = time + frametime;
		return;
	}

	if (skill >= 2)
	{
		if (random() > 0.66)
			self.think = grunt_roll;
		else
			self.think = grunt_atkb1;

		self.nextthink = time + frametime;
		return;
	}
};

void(entity attacker, float damage) grunt_pain =
{
	
	if (self.pain_finished > time)
		return;

	self.pain_finished = time + 1;

	zsec_pain ();
};


void() grunt_fire =
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
	org = ProjectAim(self.origin, off, v_forward, v_right);

	dir = en.origin - en.velocity*0.15;
	dir = normalize(dir - self.origin - '0 0 16');

	monster_FireBullets (1, org, dir, '0 0 0', 6, 2);
};


void() grunt_die =
{	
	if((self.deadflag & DEAD_DEAD))
		return;

	zsec_die ();

	self.skin = 2;

	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_NOT;
	self.think = grunt_die1;
	self.nextthink = time + 0.04;

	self.ammo_shells = 5;
	DropBackpack();

	MonsterGib (self.health);
};

void() grunt_die1 = [ self.frame, grunt_die2 ] {self.alpha = 1; self.nextthink = time + 0.02;};
void() grunt_die2 = [ self.frame, grunt_die2 ] 
{ 	
	self.nextthink = time + 0.02;
	self.alpha -= 0.02;
	if (self.alpha <= 0)
	{
		remove(self);
		return;
	}	
};


/*QUAKED monster_army (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_army =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/soldier.mdl");
	precache_model("progs/h_guard.mdl");
	precache_model("progs/gib1.mdl");
	precache_model("progs/gib2.mdl");
	precache_model("progs/gib3.mdl");

	 	zsec_precache_sfx ();



	spawn_grunt ();
};

/*
===========
SoldierCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() SoldierCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;

	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
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


void() spawn_grunt = 
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/soldier.mdl");

	setsize(self, '-16 -16 0', '16 16 64');
	self.health = 55;
	self.max_health = 55;
	self.mass = 100;
	// self.dcnt = 0;
	self.scale = 0.75;

	self.th_stand = grunt_stand1;
	self.th_walk = grunt_walk1;
	self.th_run = grunt_run1;
	self.th_missile = grunt_missile;
	self.th_melee = grunt_missile;
	self.th_pain = grunt_pain;
	self.th_die = grunt_die;
	self.th_dodge = grunt_dodge;
	self.th_checkatck = SoldierCheckAttack;
	self.th_spawn = spawn_grunt;
	self.th_sight = zsec_sight;

	walkmonster_start();
};
