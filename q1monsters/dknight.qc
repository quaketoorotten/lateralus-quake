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

KNIGHT

==============================================================================
*/

void() dknight_run1;
void() dknight_idle_sound;

void() hknight_MissileHome =
{
	local vector	dir, vtemp;
	local entity 	targ = self.enemy;
	local float		flytime = self.ltime;

	vtemp = targ.origin + targ.view_ofs;
	self.speed *= 0.98;
	
	if ((self.speed < 60) || (self.enemy.health <= 0))
	{	
		self.nextthink = 0.1 + time;
		self.think = SUB_Remove;
		return;
	}

	dir = normalize(vtemp - self.origin);
	
	self.velocity = dir * ceil(self.speed);

	self.angles = vectoangles(self.velocity);
	self.nextthink = time + flytime;
	self.think = hknight_MissileHome;	
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

    T_RadiusDamage(self, self.owner, 45, 80, self.owner);
	
    sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
    BecomeExplosion2();
};

void(vector org, vector dir) launch_hknightMissile =
{
	local float 	flytime;
	
	newmis = spawn ();
	newmis.owner = self;
	newmis.classname = "knightspike";
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;

	flytime = vlen(dir) * 0.002;
	if (flytime < 0.1)
		flytime = 0.1;

	newmis.angles = vectoangles(dir);
		
	newmis.ltime = flytime;
	newmis.nextthink = 0.4 + time;
	newmis.think = hknight_MissileHome;
	newmis.enemy = self.enemy;
	setmodel (newmis, "progs/revmiss.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	setorigin (newmis, org);
	newmis.traileffectnum = particleeffectnum ("EF_REVTRAIL");

	newmis.velocity = dir * 400;
	newmis.speed = 280;
	newmis.touch = knightspike_touch;
};

void(float off) dknight_shota =
{
	vector org, offset, dir;

	makevectors(self.angles);

	offset = setvector (0, off, self.view_ofs[2] + 2);
	org = ProjectAim (self.origin, offset, v_forward, v_right);

	dir = normalize(self.enemy.origin + '0 0 16' - org);
	
	if (random() <= 0.65)
	{
		launch_spike(org, dir, 600);
		newmis.classname = "knightspike";
		setmodel(newmis, "progs/revmiss.mdl");
		setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
		newmis.traileffectnum = particleeffectnum ("EF_REVTRAIL");
		newmis.touch = knightspike_touch;
	}
	else
	{
		launch_hknightMissile (org, dir);
	}

	sound(self, CHAN_WEAPON, "hknight/attack1.wav", 1, ATTN_NORM);
};


//===========================================================================

void() dknight_stand1 = [ 0, dknight_stand2 ] { ai_stand();};
void() dknight_stand2 = [ self.frame, dknight_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 115) 
	{	
		if (random() < 0.2)
			dknight_idle_sound ();
		dknight_stand1 ();
		return;
	}
	ai_stand ();
};

void() dknight_walk1 = [ 116, dknight_walk2 ] { ai_walk(2);};
void() dknight_walk2 = [ self.frame, dknight_walk2 ] 
{ 
	self.frame ++;
	if (self.frame >= 144) 
	{
		dknight_walk1 ();
		return;
	}
	ai_walk (2);
};


void() dknight_run1 = [ 116, dknight_run2 ] { ai_run(3);};
void() dknight_run2 = [ self.frame, dknight_run2 ] 
{ 
	self.frame ++;
	if (self.frame >= 144) 
	{
		if (random() < 0.2)
			dknight_idle_sound ();

		dknight_run1 ();
		return;
	}
	ai_run (3);
};


//============================================================================

void() dknight_pain1 = [ 277, dknight_pain2 ] { sound(self, CHAN_VOICE, "hknight/pain1.wav", 1, ATTN_NORM); self.nextthink = time + 0.04; };
void() dknight_pain2 = [ self.frame, dknight_pain2 ] 
{
	self.frame ++;
	self.nextthink = time + 0.04;
	if (self.frame >= 293) 
	{	
		dknight_run1 ();
		
		if (random() < 0.7)
			SUB_CheckRefire (dknight_missile);

		return;
	}
};


//============================================================================


void() dknight_die =
{	
	if((self.deadflag & DEAD_DEAD))
		return;

	local vector tmpangle;
	local float tmpframe;
	tmpframe = self.frame;
	tmpangle = self.angles;

	setmodel(self, "progs/hknight1.mdl");
	setsize(self, '-32 -32 0', '32 32 88');
	self.skin = 0;
	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_NOT;
	self.think = dknight_die1;
	self.nextthink = time + 0.04;

	self.frame = tmpframe;
	self.angles = tmpangle;

	MonsterGib (self.health);
};

void() dknight_die1 = [ self.frame, dknight_die2 ] {self.alpha = 1; self.nextthink = time + 0.02;};
void() dknight_die2 = [ self.frame, dknight_die2 ] 
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

void() dknight_attb1 = [ 175, dknight_attb2 ] {ai_face(); self.nextthink = time + 0.04;};
void() dknight_attb2 = [ self.frame, dknight_attb2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.04;

	if (self.frame == 187 || self.frame == 197)
		dknight_Melee (0);
	
	if (self.frame >= 216) 
	{
		dknight_run1 ();
		return;
	}

	if (self.frame > 179 && self.frame < 187)
		ai_charge (6);
	else if (self.frame > 203 && self.frame < 208)
		ai_charge (-4);
};

void() dknight_atta1 = [ 145, dknight_atta2 ] {ai_face(); self.nextthink = time + 0.03;};
void() dknight_atta2 = [ self.frame, dknight_atta2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;

	if (self.frame == 155)
		dknight_Melee (0);
	
	if (self.frame >= 175) 
	{
		dknight_run1 ();
		return;
	}

	if (self.frame > 153 && self.frame < 163)
		ai_charge (6);
	else if (self.frame > 163 && self.frame < 172)
		ai_charge (-4);
};

static void() HknightAttackFinished =
{
	if (enemy_range >= RANGE_MID || !enemy_vis)
	{
		self.attack_state = AS_STRAIGHT;
		self.think = self.th_run;
	}
	else
	{
		dknight_strafe ();
	}
};

void() dknight_strafel1 = [ 393, dknight_strafel2 ] { ai_run_slide (3, 0.04); };
void() dknight_strafel2 = [ self.frame, dknight_strafel2 ] 
{ 
	self.frame ++;
	if (self.frame >= 413) 
	{	
		dknight_run1 ();
		return;
	}

	if (self.frame < 411)
		ai_run_slide (4, 0.04);
};

void() dknight_strafer1 = [ 360, dknight_strafer2 ] { self.nextthink = time + 0.04; };
void() dknight_strafer2 = [ self.frame, dknight_strafer2 ] 
{ 
	self.frame ++;
	if (self.frame >= 381) 
	{	
		dknight_run1 ();
		return;
	}

	if (self.frame < 379)
		ai_run_slide (4, 0.04);
};

void() dknight_dodgel1 = [ 329, dknight_dodgel2 ] { ai_run_slide (6, 0.03); };
void() dknight_dodgel2 = [ self.frame, dknight_dodgel2 ] 
{ 
	self.frame ++;
	if (self.frame >= 353) 
	{	
		self.flags &= ~FL_DODGED;
		dknight_run1 ();
		return;
	}

	if (self.frame < 347)
		ai_run_slide (6, 0.03);
	else
		self.nextthink = time + 0.03;
};

void() dknight_dodger1 = [ 296, dknight_dodger2 ] { ai_run_slide (6, 0.03); };
void() dknight_dodger2 = [ self.frame, dknight_dodger2 ] 
{ 
	self.frame ++;

	if (visible(self.enemy))
	{
		if (self.frame == 312)
			dknight_shota (8);

		if (self.frame > 312 && self.frame < 318)
			self.skin = 1;
		else
			self.skin = 0;
	}
	
	if (self.frame >= 324) 
	{	
		self.flags &= ~FL_DODGED;
		dknight_run1 ();
		return;
	}

	if (self.frame < 315)
		ai_run_slide (6, 0.03);
	else 
		self.nextthink = time + 0.03;
};

void() dknight_strafe =
{		
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();

	if(self.lefty)
		dknight_strafel1 ();
	else 
		dknight_strafer1 ();
	
	self.nextthink = time + frametime;
};

void() dknight_dodge =
{		
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();

	if(self.lefty)
		dknight_dodgel1 ();
	else 
		dknight_dodger1 ();
	
	self.nextthink = time + frametime;
};

void() dknight_missilel1 = [ 216, dknight_missilel2 ] {ai_face(); self.nextthink = time + 0.04;};
void() dknight_missilel2 = [ self.frame, dknight_missilel2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.04;

	if (self.frame == 227)
		dknight_shota (-8);

	if (self.frame > 227 && self.frame < 230)
		self.skin = 2;
	else
		self.skin = 0;
	
	if (self.frame >= 246) 
	{	
		if (random() < 0.7)
			SUB_CheckRefire ( dknight_missiler1);
		else 
			HknightAttackFinished ();
		return;
	}

	if (self.frame < 229)
		ai_face ();
};


void() dknight_missiler1 = [ 247, dknight_missiler2 ] {ai_face(); self.nextthink = time + 0.04;};
void() dknight_missiler2 = [ self.frame, dknight_missiler2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.04;

	if (self.frame == 259)
		dknight_shota (8);

	if (self.frame > 260 && self.frame < 265)
		self.skin = 1;
	else
		self.skin = 0;
	
	
	if (self.frame >= 277) 
	{	
		if (random() < 0.7)
			SUB_CheckRefire ( dknight_missilel1);
		else 
			HknightAttackFinished ();		
		return;
	}

	if (self.frame < 259)
		ai_face ();
};

void() dknight_missilerl1 = [ 426, dknight_missilerl2 ] {ai_face(); self.nextthink = time + 0.03;};
void() dknight_missilerl2 = [ self.frame, dknight_missilerl2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;

	if (self.frame == 438)
	{
		dknight_shota (-8);
		dknight_shota (8);
	}

	if (self.frame > 437 && self.frame < 441)
		self.skin = 3;
	else
		self.skin = 0;
	
	if (self.frame >= 460) 
	{	
		dknight_run1 ();		
		return;
	}

	if (self.frame < 438)
		ai_face ();
};


void(float side) dknight_Melee =
{
	float ldmg;
	vector delta;

	ai_face();

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 90)
		return;
	if (!CanDamage(self.enemy, self))
		return;

	// sound(self, CHAN_WEAPON, "demon/dhit2.wav", 1, ATTN_NORM);
	ldmg = 12 + 5*random();
	T_Damage(self.enemy, self, self.origin + v_forward*16, self, ldmg, 15);

	makevectors(self.angles);
	SpawnMeatSpray(self.origin + v_forward*16, side * v_right);
};


//============================================================================

void() dknight_idle_sound =
{
	sound(self, CHAN_VOICE, "hknight/idle.wav", 1, ATTN_NORM);
};

void(entity attacker, float damage) dknight_pain =
{	
	self.skin = 0;

	if (damage < 25)	
		return;

	if (self.pain_finished > time)
		return;

	if (self.flags & FL_DODGED)
		return;

	sound(self, CHAN_VOICE, "hknight/pain1.wav", 1, ATTN_NORM);

	if (time - self.pain_finished > 10)
	{ // allways go into pain frame if it has been a while
		dknight_pain1();
		self.pain_finished = time + 3;
		return;
	}

	if ((random()*200 > damage))
		return; // didn't flinch

	self.pain_finished = time + 3;
	dknight_pain1();
};

float dknight_type;

void() dknight_melee =
{
	dknight_type = dknight_type + 1;

	sound(self, CHAN_WEAPON, "hknight/slash1.wav", 1, ATTN_NORM);
	if (dknight_type < 3)
		dknight_atta1 ();
	else 
	{
		dknight_attb1 ();
		dknight_type = 0;
	}
};


void() dknight_missile =
{
	dknight_type = dknight_type + 1;

	if (dknight_type == 3)
	{
		dknight_missilerl1 ();
		dknight_type = 0;
		return;
	}
	
	if (random() <= 0.5)
		dknight_missilel1();
	else 
		dknight_missiler1();
	
	SUB_AttackFinished (3*random());
};


/*QUAKED monster_death_knight (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_hell_knight =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2 ("progs/hknight.mdl");
	precache_model2 ("progs/hknight1.mdl");
	precache_model2 ("progs/revmiss.mdl");


	precache_model2 ("progs/k_spike.mdl");
	precache_model2 ("progs/h_hellkn.mdl");


	precache_sound2 ("hknight/attack1.wav");
	precache_sound2 ("hknight/death1.wav");
	precache_sound2 ("hknight/pain1.wav");
	precache_sound2 ("hknight/sight1.wav");
	precache_sound("hknight/hit.wav"); // used by C code, so don't sound2
	precache_sound2 ("hknight/slash1.wav");
	precache_sound2 ("hknight/idle.wav");
	precache_sound2 ("hknight/grunt.wav");

	precache_sound("knight/sword1.wav");
	precache_sound("knight/sword2.wav");

	spawn_death_knight ();
};

void() spawn_death_knight = 
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/hknight.mdl");

	setsize(self, '-16 -16 0', '16 16 64');
	self.health = 300;
	self.max_health = 300;
	self.mass = 300;
	self.scale = 0.8;

	self.th_stand = dknight_stand1;
	self.th_walk = dknight_walk1;
	self.th_run = dknight_run1;
	self.th_melee = dknight_melee;
	self.th_missile = dknight_missile;
	self.th_pain = dknight_pain;
	self.th_die = dknight_die;
	self.th_dodge = dknight_dodge;
	self.th_spawn = spawn_death_knight;
	
	walkmonster_start();
};
