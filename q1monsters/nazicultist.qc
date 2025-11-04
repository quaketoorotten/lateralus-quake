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

SHAMBLER

==============================================================================
*/

/*
============
ShamCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() ShamCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
//	local float		chance;

	if (enemy_range == RANGE_MELEE)
	{
		if (CanDamage (self.enemy, self))
		{
			self.attack_state = AS_MELEE;
			return TRUE;
		}
	}

	if (time < self.attack_finished)
		return FALSE;
	
	if (!enemy_vis)
		return FALSE;
		
	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	if (vlen(spot1 - spot2) > 1000)
		return FALSE;

	traceline (spot1, spot2, FALSE, self);

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_ent != targ)
	{
		return FALSE;	// don't have a clear shot
	}
			
// missile attack
	if (enemy_range == RANGE_FAR)
		return FALSE;
		
	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (1 + 2*random());
	return TRUE;
};


float(float rad)	inNaziRange =
{	
	local entity targ = self.enemy;
	local vector spot1 = self.origin + self.view_ofs;
	local vector spot2 = targ.origin + targ.view_ofs;

	if (vlen(spot1 - spot2) <= rad)
		return TRUE;
	
	return FALSE;
};

void() sham_stand1 = [ 0, sham_stand2 ] {ai_stand();};
void() sham_stand2 = [ self.frame, sham_stand2 ] 
{ 
	self.frame ++;
	if (self.frame >= 119) 
	{	
		if(random () < 0.2)
			hk_idle ();

		sham_stand1 ();
		return;
	}
	ai_stand ();
};

void() sham_walk1 = [ 120, sham_walk2 ] {ai_walk(3);};
void() sham_walk2 = [ self.frame, sham_walk2 ] 
{ 	
	self.frame ++;
	if (self.frame == 132 || self.frame == 150)
		hk_step ();

	if (self.frame >= 156) 
	{
		if(random () < 0.2)
			hk_idle ();

		sham_walk1 ();
		return;
	}
	ai_walk (3);
};

void() sham_run1 = [ 120, sham_run2 ] {ai_run(3);};
void() sham_run2 = [ self.frame, sham_run2 ] 
{ 
	self.frame ++;
	if (self.frame == 132 || self.frame == 150)
		hk_step ();
	
	if (self.frame >= 156) 
	{
		if(random () < 0.2)
			hk_idle ();

		sham_run1 ();
		return;
	}
	ai_run (3);
};


void() sham_smash1 = [ 157, sham_smash2 ] {ai_face(); self.nextthink = time + 0.03;};
void() sham_smash2 = [ self.frame, sham_smash2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;

	if (self.frame == 172)
		NaziSmash ();
	
	if (self.frame >= 196) 
	{
		sham_run1 ();
		return;
	}

	if (self.frame <= 175 && self.frame > 163)
		ai_charge (10);
	
	if (self.frame > 175)
		ai_charge (-2);
};

void() sham_swingr1 = [ 262, sham_swingr2 ] {ai_face(); self.nextthink = time + 0.03;};
void() sham_swingr2 = [ self.frame, sham_swingr2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;

	if (self.frame == 278)
		NaziClaw (0);
	
	if (self.frame >= 309) 
	{
		sham_run1 ();
		return;
	}

	if (self.frame < 292 && self.frame > 272)
		ai_charge (4);
};

void() sham_swingl1 = [ 310, sham_swingl2 ] {ai_face(); self.nextthink = time + 0.03;};
void() sham_swingl2 = [ self.frame, sham_swingl2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;

	if (self.frame == 326)
		NaziClaw (0);
	
	if (self.frame >= 348) 
	{
		sham_run1 ();
		return;
	}

	if (self.frame < 327)
		ai_face ();
};


void(float side) NaziClaw =
{
	vector delta;
	float ldmg;

	if (!self.enemy)
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 120)
	{
		hk_melee ();
		return;
	}
	
	ldmg = 10 + (random() + random() + random()) * 15;
	T_Damage(self.enemy, self, self.origin + v_forward*16, self, ldmg, 40);
	hk_chomp();

	if (side)
	{
		makevectors(self.angles);
		SpawnMeatSpray(self.origin + v_forward*16, side * v_right);
	}
};

void() NaziSmash =
{
	vector delta;
	float ldmg;

	if (!self.enemy)
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;

	ldmg = 20 + (random() + random() + random()) * 15;
	T_Damage(self.enemy, self, self.origin + v_forward*16, self, ldmg, 40);
	hk_chomp();
};

void() sham_melee =
{
	float chance;

	hk_combat ();

	if(self.count > 2)
	{
		sham_missile();
		self.count = 0;
		return;
	}
		
	
	if(self.count > 1)	
	{
		sham_smash1();
		return;
	}
	
	chance = random();
	if (chance >= 0.5)
		sham_swingr1();
	else
		sham_swingl1();
	
	self.count += 0.66;
};

void(float dmg) NaziFireBall =
{
	
	local	vector	dir, org, offset;
	local entity en = self.enemy;
		
//	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
	
	self.effects = self.effects | EF_MUZZLEFLASH;

	makevectors(self.angles);

	offset = setvector (16, -16, self.view_ofs[2] + 24);
	org = ProjectAim(self.origin, offset, v_forward, v_right);
	
	dir = en.origin - org;
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

	dir = v_forward;
	dir = dir + pitch * v_up;
//PGM	

	monster_FireGravityBall (org, dir, dmg);
};

void() sham_magic1 = [ 197, sham_magic2 ] { spawn_fireball (230); ai_face(); self.nextthink = time + 0.03;};
void() sham_magic2 = [ self.frame, sham_magic2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;
	
	if (self.frame < 230)
		ai_face();

	if (self.frame == 230)
		NaziFireBall (160);
	
	if (self.frame >= 261) 
	{	
	
		if (inNaziRange (125))
		{
			sham_melee ();
			return;
		}
		SUB_CheckRefire (sham_magic1);

		sham_run1 ();
		return;
	}

	if (self.frame < 245 && self.frame > 215)
		ai_charge (4);
};


void() sham_turret1 = [ 349, sham_turret2 ] { spawn_fireball (371); ai_face(); self.nextthink = time + 0.04;};
void() sham_turret2 = [ self.frame, sham_turret2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.04;
	
	if (self.frame < 371)
		ai_face();
	
	if (self.frame == 371)
		NaziFireBall (90);
	
	if (self.frame >= 388) 
	{	
		if (inNaziRange (125))
		{
			sham_melee ();
			return;
		}
			
		sham_run1 ();
		return;
	}
};

void() sham_missile =
{
	if (!inNaziRange (300))
		sham_magic1 ();
	else
		sham_turret1 ();

	hk_combat ();
};
	

//============================================================================


void() sham_pain1 = [ 389, sham_pain2 ] {ai_charge(-10); self.nextthink = time + 0.04;};
void() sham_pain2 = [ self.frame, sham_pain2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.04;
	
	if (self.frame >= 404) 
	{
		sham_run1 ();
		return;
	}

	if (self.frame < 397)
		ai_charge (1);
};

void(entity attacker, float damage) sham_pain =
{	
	if (self.pain_finished > time)
		return;

	self.pain_finished = time + 3;
	
	hk_pain ();

	if (self.health <= 0)
		return; // allready dying, don't go into pain frame

	if (random()*400 > damage)
		return; // didn't flinch

	sham_pain1 ();
};


//============================================================================

void() sham_death =
{	
	if((self.deadflag & DEAD_DEAD))
		return;
	
	hk_die ();

	local vector tmpangle;
	local float tmpframe;
	tmpframe = self.frame;
	tmpangle = self.angles;

	setmodel(self, "progs/shambler1.mdl");
	setsize(self, '-32 -32 0', '32 32 88');	
	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_NOT;
	self.think = sham_die1;
	self.nextthink = time + 0.04;

	self.frame = tmpframe;
	self.angles = tmpangle;

	MonsterGib (self.health);
};

void() sham_die1 = [ self.frame, sham_die2 ] {self.alpha = 1; self.nextthink = time + 0.02;};
void() sham_die2 = [ self.frame, sham_die2 ] 
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

static void() hk_chomp =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/hellknight/chomp1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/hellknight/chomp2.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/hellknight/chomp3.wav", 1, ATTN_NORM);	
};

static void() hk_melee =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/revenant/melee1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/revenant/melee2.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/revenant/melee3.wav", 1, ATTN_NORM);	
};

static void() hk_idle =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/hellknight/hk_chatter_01.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/hellknight/hk_chatter_02.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/hellknight/hk_chatter_03.wav", 1, ATTN_NORM);
};

static void() hk_combat =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/hellknight/ncc_01.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/hellknight/ncc_02.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/hellknight/ncc_03.wav", 1, ATTN_NORM);
};
static void() hk_die =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/hellknight/die1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/hellknight/die2.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/hellknight/die3.wav", 1, ATTN_NORM);
};

static void() hk_sight =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/hellknight/sight1_1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/hellknight/sight2_1.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/hellknight/sight3_1.wav", 1, ATTN_NORM);
};

static void() hk_pain =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/hellknight/hk_pain_01.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/hellknight/hk_pain_02.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/hellknight/hk_pain_03.wav", 1, ATTN_NORM);	
};

static void() hk_step =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_BODY, "monsters/hellknight/step4.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_BODY, "monsters/hellknight/step1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_BODY, "monsters/hellknight/step2.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_BODY, "monsters/hellknight/step3.wav", 1, ATTN_NORM);
};

/*QUAKED monster_nazicultist (1 0 0) (-32 -32 -24) (32 32 64) Ambush
*/
void() monster_shambler =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/shambler.mdl");
	precache_model("progs/hkball.mdl");
	precache_model("progs/shambler1.mdl");
	precache_model("progs/h_shams.mdl");
	precache_model("progs/bolt.mdl");

	precache_sound("monsters/revenant/melee1.wav");
	precache_sound("monsters/revenant/melee2.wav");
	precache_sound("monsters/revenant/melee3.wav");

	precache_sound("monsters/hellknight/ncc_01.wav");
	precache_sound("monsters/hellknight/ncc_02.wav");
	precache_sound("monsters/hellknight/ncc_03.wav");
	precache_sound("monsters/hellknight/hk_chatter_01.wav");
	precache_sound("monsters/hellknight/hk_chatter_02.wav");
	precache_sound("monsters/hellknight/hk_chatter_03.wav");

	precache_sound("monsters/hellknight/sight1_1.wav");
	precache_sound("monsters/hellknight/sight2_1.wav");
	precache_sound("monsters/hellknight/sight3_1.wav");

	precache_sound("monsters/hellknight/fb_create_02.wav");

	precache_sound("monsters/hellknight/chomp1.wav");
	precache_sound("monsters/hellknight/chomp2.wav");
	precache_sound("monsters/hellknight/chomp3.wav");

	precache_sound("monsters/hellknight/hk_pain_01.wav");
	precache_sound("monsters/hellknight/hk_pain_02.wav");
	precache_sound("monsters/hellknight/hk_pain_03.wav");

	precache_sound("monsters/hellknight/die1.wav");
	precache_sound("monsters/hellknight/die2.wav");
	precache_sound("monsters/hellknight/die3.wav");

	precache_sound("monsters/hellknight/step1.wav");
	precache_sound("monsters/hellknight/step2.wav");
	precache_sound("monsters/hellknight/step3.wav");
	precache_sound("monsters/hellknight/step4.wav");

	spawnnazi();
};

static void() fireball_update_pos =
{	
	if (self.frame == self.ltime
		|| self.owner.health < 1 
		|| (self.owner.think != sham_turret1 && self.owner.think != sham_turret2 &&
			self.owner.think != sham_magic1 && self.owner.think != sham_magic2))
	{
		remove(self);
		return;
	}

	self.origin = self.owner.origin;
	self.angles = self.owner.angles;
	self.frame = self.owner.frame;
	
	self.think = fireball_update_pos;
	self.nextthink = time + 0.01;
};

static void(float removeframe) spawn_fireball =
{
	local entity e;
	e = spawn ();
	setmodel (e, "progs/hkball.mdl");
	setsize (e, '-32 -32 0', '32 32 88');
	e.scale = 0.9;
	setorigin (e, self.origin);
	e.groundentity = self;
	e.angles = self.angles;
	e.owner = self;
	e.think = fireball_update_pos;
	e.nextthink = time + 0.01;
	e.ltime = removeframe;
	e.frame = self.frame;
	sound(self, CHAN_WEAPON, "monsters/hellknight/fb_create_02.wav", 1, ATTN_NORM);	
};

vector VEC_HULL2_MIN = '-32 -32 -24';
vector VEC_HULL2_MAX = '32 32 64';

void() spawnnazi =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/shambler.mdl");

	setsize(self, '-32 -32 0', '32 32 88');
	self.health = 1600;
	self.max_health = 1600;
	self.mass = 1000;
	self.scale = 0.9;

	if (world.worldtype == 2)
		self.skin = 1;

	self.th_stand = sham_stand1;
	self.th_walk = sham_walk1;
	self.th_run = sham_run1;
	self.th_die = sham_death;
	self.th_melee = sham_melee;
	self.th_missile = sham_missile;
	self.th_pain = sham_pain;
	self.th_checkatck = ShamCheckAttack;
	self.th_spawn = spawnnazi;
	self.th_sight = hk_sight;

	walkmonster_start();
}