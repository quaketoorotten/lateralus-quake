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

WIZARD

==============================================================================
*/

/*
==============================================================================

WIZARD

If the player moves behind cover before the missile is launched, launch it
at the last visible spot with no velocity leading, in hopes that the player
will duck back out and catch it.
==============================================================================
*/

/*
=================
FliesCheckAttack
=================
*/
float()	FliesCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;
	
	if ((enemy_range == RANGE_MELEE) && self.th_melee)
	{
		self.th_melee();
		return TRUE;
	}

	if (time < self.attack_finished)
		return FALSE;
	if (!enemy_vis)
		return FALSE;

	if (enemy_range == RANGE_FAR)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			self.th_run ();
		}
		return FALSE;
	}
		
	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_ent != targ)
	{	// don't have a clear shot, so move to a side
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			self.th_run ();
		}
		return FALSE;
	}
			
	if (enemy_range == RANGE_MELEE)
		chance = 0.9;
	else if (enemy_range == RANGE_CLOSE)
		chance = 0.6;
	else if (enemy_range == RANGE_NEAR)
		chance = 0.2;
	else if (enemy_range == RANGE_MID)
		chance = 0.1;
	else
		chance = 0;

	if (random () < chance)
	{
		self.attack_state = AS_MISSILE;
		self.attack_finished = time + 0.2 + random()*4;
		return TRUE;
	}

	if (enemy_range == RANGE_MID)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			self.th_run ();
		}
	}
	else
	{
		if (self.attack_state != AS_SLIDING)
		{
			self.attack_state = AS_SLIDING;
		}
	}
	
	return FALSE;
};

/*
=================
WizardAttackFinished
=================
*/
void()	FliesAttackFinished =
{
	if (enemy_range >= RANGE_MID || !enemy_vis)
	{
		self.attack_state = AS_STRAIGHT;
		self.think = self.th_run;
	}
	else
	{
		self.attack_state = AS_SLIDING;
	}
};



void() scrag_run1;

/*
==============================================================================

FAST ATTACKS

==============================================================================
*/

static void() thinker =
{	
	if (self.ltime < time)
		remove(self);

	if (self.frame > 3)
		self.frame = 0;

	self.frame ++;
	self.think = thinker;
	self.nextthink = time + 0.05;
};


static void() knightspike_touch =
{
    if (other == self.owner)
    {
        return; // don't explode on owner
    }

    if (pointcontents(self.origin) == CONTENT_SKY)
    {
        remove(self);
        return;
    }
	
    self.origin = self.origin - 16* normalize(self.velocity);

    T_RadiusDamage(self, self.owner, 40, 80, self.owner);
    self.traileffectnum = 0;
	
    sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
    BecomeExplosion2();
};

void(float speed) WizShoot =
{
	local	vector	org, dir;
	local entity	targ = self.enemy;
	local vector	targorg = targ.origin + targ.view_ofs;
	
	makevectors (self.angles);
	
	self.effects = self.effects | EF_MUZZLEFLASH;

	org = self.origin;
	dir = normalize (targorg - org);
	
	launch_spike (org, dir);
	newmis.classname = "wizspike";
	newmis.velocity = dir * speed;
	setmodel (newmis, "progs/w_spike.mdl");
	newmis.scale = 2.4;
	newmis.touch = knightspike_touch;
	newmis.think = thinker;
	newmis.nextthink = time + 0.05;
	newmis.avelocity_z = crandom()*200;
	newmis.ltime = time + 6;
	newmis.traileffectnum = (particleeffectnum("EF_CACOTRAIL"));

	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
};

void() Scrag_idlesound =
{
	float wr;
	wr = random() * 5;

	if (self.waitmin < time)
	{
		self.waitmin = time + 2;
		if (wr > 4.5)
			sound(self, CHAN_VOICE, "wizard/widle1.wav", 1, ATTN_IDLE);
		if (wr < 1.5)
			sound(self, CHAN_VOICE, "wizard/widle2.wav", 1, ATTN_IDLE);
	}
	return;
};

void() scrag_stand1 = [ 0, scrag_stand2 ] { ai_stand();};
void() scrag_stand2 = [ self.frame, scrag_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 99) 
	{	
		Scrag_idlesound ();
		scrag_stand1 ();
		return;
	}
	ai_stand ();
};

void() scrag_walk1 = [ 176, scrag_walk2 ] { ai_walk(2); };
void() scrag_walk2 = [ self.frame, scrag_walk2 ] 
{ 
	self.frame ++;
	if (self.frame >= 235) 
	{
		scrag_walk1 ();
		return;
	}
	ai_walk (2);
};


void() scrag_run1 = [ 236, scrag_run2 ] {	Scrag_idlesound (); ai_run(4); };
void() scrag_run2 = [ self.frame, scrag_run2 ] 
{ 
	self.frame ++;
	if (self.frame >= 275) 
	{
		scrag_run1 ();
		return;
	}
	ai_run (4);
};

void() scrag_fast1 = [ 100, scrag_fast2 ] {ai_face(); self.nextthink = time + 0.04;};
void() scrag_fast2 = [ self.frame, scrag_fast2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.04;

	if (self.frame == 119)
		WizShoot (800);

	if (self.frame >= 139) 
	{	
	//	SUB_CheckRefire (scrag_fast1 );
		scrag_run1 ();
		return;
	}
	
	if (self.frame < 112)
		ai_charge (-4);
	else if (self.frame > 118 && self.frame < 125)
		ai_charge (6);

	ai_face();
};

void() cacabite =
{
	vector delta;
	float ldmg;

	if (!self.enemy)
		return;
	if (!CanDamage(self.enemy, self))
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 90)
		return;

	ldmg = (random() + random() + random()) + 18;

	T_Damage(self.enemy, self, self.origin, self, ldmg, 2);
};

void() scrag_melee1 = [ 140, scrag_melee2 ] {ai_charge (7); ai_face(); self.nextthink = time + 0.04;};
void() scrag_melee2 = [ self.frame, scrag_melee2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.04;

	if (self.frame == 152)
		cacabite ();

	if (self.frame >= 176) 
	{	
		scrag_run1 ();
		return;
	}
	
	if (self.frame < 174)
		ai_charge (7);

	ai_face();
};


void() scrag_pain1 = [ 276, scrag_pain2 ] {self.nextthink = time + 0.04;};
void() scrag_pain2 = [ self.frame, scrag_pain2 ] 
{
	self.frame ++; self.nextthink = time + 0.04; 
	if (self.frame >= 294) 
		{scrag_run1(); return; } 
};

void() scrag_die1 = [ self.frame, scrag_die2 ] 
{
	self.touch = SUB_Null; 
	self.skin = 1; 
	self.alpha = 1; 
	self.nextthink = time + 0.02;
	MonsterGib (self.health);
};

void() scrag_die2 = [ self.frame, scrag_die2 ] 
{ 	
	self.nextthink = time + 0.02;
	self.alpha -= 0.02;
	if (self.alpha <= 0)
	{
		remove(self);
		return;
	}	
};

void() scrag_touch = 
{	
	self.think = scrag_die1;
	self.nextthink = time + 0.01;
};

void() scrag_die =
{	
	if((self.deadflag & DEAD_DEAD))
		return;

	self.movetype = MOVETYPE_BOUNCE;
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_CORPSE;
	
	setsize(self, '-16 -16 -16', '16 16 16');
	self.deadflag = DEAD_DEAD;
	self.avelocity = '300 300 300';
	self.touch = scrag_touch;

	self.think = SUB_Null;
	self.nextthink = time + 0.01;
};


void(entity attacker, float damage) Scrag_Pain =
{

	sound(self, CHAN_VOICE, "wizard/wpain.wav", 1, ATTN_NORM);
	if (random()*200 > damage)
		return; // didn't flinch

	scrag_pain1();
};


void() Scrag_Missile =
{
	
		scrag_fast1();
//	else
	//	scrag_slow1();
};

/*QUAKED monster_wizard (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_wizard =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/wizard.mdl");
	precache_model("progs/h_wizard.mdl");
	precache_model("progs/w_spike.mdl");

	precache_sound("wizard/hit.wav"); // used by c code
	precache_sound("wizard/wattack.wav");
	precache_sound("wizard/wdeath.wav");
	precache_sound("wizard/widle1.wav");
	precache_sound("wizard/widle2.wav");
	precache_sound("wizard/wpain.wav");
	precache_sound("wizard/wsight.wav");

	spawn_scrag();
};

static void() fireball_update_pos =
{	
	if (self.owner.health < 1)
	{	
		self.emiteffectnum = 0;
		remove(self);
		return;
	}
	
	makevectors(self.angles);
	self.origin = self.owner.origin + v_forward * 6;
	self.angles = self.owner.angles;
	//self.frame = self.owner.frame;
	
	self.think = fireball_update_pos;
	self.nextthink = time + 0.01;
};

static void() mouthsmoke =
{	
	makevectors(self.angles);
	local entity smoke;
	smoke = spawn();
	setmodel (smoke, "progs/muzzleflash.spr");
	setorigin (smoke, self.origin + v_forward * 6);
	smoke.angles = self.angles;
	smoke.think = fireball_update_pos;
	smoke.owner = self;
	smoke.nextthink = time + 0.01;
	smoke.traileffectnum = (particleeffectnum("TE_CACO_FLAME"));
};

void() spawn_scrag =
{

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/wizard.mdl");

	setsize(self, '-16 -16 -24', '16 16 40');
	self.health = 200;
	self.max_health = 200;
	self.mass = 200;
//	mouthsmoke ();

	self.th_stand = scrag_stand1;
	self.th_walk = scrag_walk1;
	self.th_run = scrag_run1;
	self.th_missile = Scrag_Missile;
	self.th_pain = Scrag_Pain;
	self.th_die = scrag_die;
	self.th_melee = scrag_melee1;
	self.th_checkatck = FliesCheckAttack;
	self.th_spawn = spawn_scrag;
	self.emiteffectnum = (particleeffectnum("TE_CACO_FLAME"));
	
	flymonster_start();
};
