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
.vector rndAng;

void() revenant_run1;
void() revenant_idle_sound;

static float (float diff) get_diff =
{
	if ( diff > 180 ) 
		diff = 180;
	else if ( diff < -180 ) 
		diff = -180;
	return diff;
}

void() hknight_MissileHome =
{
	vector	dir, seekPos;
	vector  dirAng, nose;
	float frac;
	vector diff;
	float i = 0;

	self.speed -= 0.2;
	if ((self.speed < 60) || (self.enemy.health <= 0))
	{	
		self.nextthink = time + 0.1;
		self.think = SUB_Remove;
		return;
	}

	nose = self.origin;
	seekPos = self.enemy.origin + self.enemy.view_ofs;

	dir = seekPos - nose;
	dirAng = vectoangles(normalize(dir));
	dirAng [0] = -dirAng[0]; // im not sure why 

	if ( self.ltime < time ) 
	{
		self.rndAng[ 0 ] = 15 * crandom();
		self.rndAng[ 1 ] = 15 * crandom();
		self.rndAng[ 2 ] = 15 * crandom();
		self.ltime = time + 1.25;
	}

	// make it more accurate as it gets closer
	frac = vlen(dir) / 256;
	if ( frac > 1) 
		frac = 1;

	diff = dirAng - self.angles + self.rndAng * frac;
	diff = Normalize180(diff);

	diff[0] = get_diff(diff[0]);
	diff[1] = get_diff(diff[1]);
	diff[2] = get_diff(diff[2]);

	self.angles += diff;

	vector fwd;
	AngleVectors(self.angles, fwd);

	self.velocity = fwd * self.speed;

	self.nextthink = time;
	self.think = hknight_MissileHome;	
};

void() knightspike_touch =
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

	if (self.nextbumper)
		remove(self.nextbumper);
	
    self.origin = self.origin - 32* normalize(self.velocity);

    T_RadiusDamage(self, self.owner, 45, 80, self.owner);
	
//    sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
    BecomeExplosion2();
};


static void() followmissile =
{	
	if (!self.owner)
	{
		remove(self);
		return;
	}
	self.origin = self.owner.origin;
	self.think = followmissile;
	self.nextthink = time;
}

static void(entity attacker, float damage) rev_missilePAIN = 
{	
	if (attacker.weaponid == 4)
		self.health -= 20; 
}

static void(entity own) rev_MissileHitbox = 
{
	local entity e;
	e = spawn();
	setsize(e, '-10 -10 -10', '10 10 10');
	setorigin(e, own.origin);
	e.health = 65;
	e.takedamage = DAMAGE_AIM;
	e.solid = SOLID_CORPSE;
	e.classname = "homing_missilebbox";
	e.movetype = MOVETYPE_FLY;
	e.th_die = rev_MissileDie;
	e.owner = own;
	e.origin = own.origin;
	e.think = followmissile;
	e.nextthink = time;
	e.groundentity = own;
	own.nextbumper = e;
}

static void() rev_MissileDie =
{	
	self.th_die = SUB_Null;

	if (!(self.owner.flags & FL_MONSTER))
		remove(self.owner);

	self.origin = self.origin - 32* normalize(self.velocity);
	
	BecomeExplosion2 ();
};

void(vector org, vector dir) launch_hknightMissile =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.classname = "knightspike";
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_SLIDEBOX;
	newmis.rndAng = 0;
	newmis.angles = vectoangles(dir);
	newmis.ltime = time;
	newmis.nextthink = time;
	newmis.think = hknight_MissileHome;
	newmis.enemy = self.enemy;
	setmodel (newmis, "progs/missile.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	setorigin (newmis, org);
	newmis.traileffectnum = particleeffectnum ("EF_REVTRAIL");
	newmis.aiflags |= IS_PROJECTILE;

	newmis.velocity = dir * 400;
	newmis.speed = 280;
	newmis.touch = knightspike_touch;
	rev_MissileHitbox(newmis);
};

void(float off, float skin1) revenant_shota =
{
	vector org, offset, dir;

	makevectors(self.angles);

	offset = setvector (0, off, self.view_ofs[2] + 2);
	org = ProjectAim (self.origin, offset, v_forward, v_right);

	dir = normalize(self.enemy.origin + '0 0 16' - org);
	
	if (random() <= 0.65)
	{
		launch_spike(org, dir, 600, TRUE);
		newmis.classname = "knightspike";
		setmodel(newmis, "progs/missile.mdl");
		setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
		newmis.traileffectnum = particleeffectnum ("EF_REVTRAIL");
		newmis.touch = knightspike_touch;
		newmis.aiflags |= IS_PROJECTILE;
		//rev_MissileHitbox(newmis);
	}
	else
	{
		launch_hknightMissile (org, dir);
	}

	if (skin1 == 0)
		return;

	local entity muzzle = spawn ();
	muzzle.origin = self.origin;
	setmodel(muzzle, "progs/hknightmf.mdl");
	setsize (muzzle, '-16 -16 0', '16 16 32');
	muzzle.think = SUB_Remove;
	muzzle.frame = self.frame + 1;
	muzzle.nextthink = time + 0.14;
	muzzle.angles = self.angles;
	muzzle.scale = self.scale;
	muzzle.skin = skin1;
};


//===========================================================================

void() revenant_stand1 = [ 0, revenant_stand2 ] { ai_stand();};
void() revenant_stand2 = [ self.frame, revenant_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 115) 
	{	
		if (random() < 0.2)
			revenant_idle_sound ();
		revenant_stand1 ();
		return;
	}
	ai_stand ();
};

void() revenant_walk1 = [ 116, revenant_walk2 ] { ai_walk(2);};
void() revenant_walk2 = [ self.frame, revenant_walk2 ] 
{ 
	self.frame ++;
	if (self.frame >= 144) 
	{
		revenant_walk1 ();
		return;
	}
	ai_walk (2);
};


void() revenant_run1 = [ 116, revenant_run2 ] { ai_run(3);};
void() revenant_run2 = [ self.frame, revenant_run2 ] 
{ 
	self.frame ++;
	if (self.frame >= 144) 
	{
		if (random() < 0.2)
			revenant_idle_sound ();

		revenant_run1 ();
		return;
	}
	ai_run (3);
};


//============================================================================

void() revenant_pain1 = [ 277, revenant_pain2 ] { self.nextthink = time + 0.035; };
void() revenant_pain2 = [ self.frame, revenant_pain2 ] 
{
	self.frame ++;
	self.nextthink = time + 0.035;
	if (self.frame >= 293) 
	{	
		revenant_run1 ();
		
		if (random() < 0.7)
			SUB_CheckRefire (revenant_missile);

		return;
	}
};


//============================================================================


void() revenant_die =
{	
	if (self.health < -100)
	{	
		self.deadflag = DEAD_DEAD;
		self.solid = SOLID_NOT;
		self.think = revenant_gib1;
		self.nextthink = time + 0.035;
		return;
	}
	
	if((self.deadflag & DEAD_DEAD))
		return;

	local vector tmpangle;
	local float tempskin;
	tmpangle = self.angles;
	tempskin = self.skin;

	knight_die ();
	
	setmodel(self, "progs/hknightdeath.md3");
	setsize(self, '-16 -16 0', '16 16 64');

	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_CORPSE;
	self.think = revenant_die1;
	self.nextthink = time + 0.035;

	self.angles = tmpangle;
	//self.skin = tempskin;
};

void() revenant_die1 = [ 0, revenant_die2 ] { self.nextthink = time + 0.035;};
void() revenant_die2 = [ self.frame, revenant_die2 ] 
{ 	
	self.nextthink = time + 0.035;

	if (self.frame < 10)
		ai_move (-4);
	self.frame ++;
	if (self.frame == 22)
	{
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() revenant_gib1 = [ self.frame, revenant_gib2 ] 
{MonsterGib (self.health); self.skin = 1; self.alpha = 1; self.nextthink = time + 0.02;};

void() revenant_gib2 = [ self.frame, revenant_gib2 ] 
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

void() revenant_attb1 = [ 175, revenant_attb2 ] {ai_face(); self.nextthink = time + 0.035;};
void() revenant_attb2 = [ self.frame, revenant_attb2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.035;

	if (self.frame == 187 || self.frame == 197)
		revenant_Melee (0);
	
	if (self.frame >= 216) 
	{
		revenant_run1 ();
		return;
	}

	if (self.frame > 179 && self.frame < 187)
		ai_charge (6);
	else if (self.frame > 203 && self.frame < 208)
		ai_charge (-4);
};

void() revenant_atta1 = [ 145, revenant_atta2 ] {ai_face(); self.nextthink = time + 0.03;};
void() revenant_atta2 = [ self.frame, revenant_atta2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;

	if (self.frame == 155)
		revenant_Melee (0);
	
	if (self.frame >= 175) 
	{
		revenant_run1 ();
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
		revenant_strafe ();
	}
};

void() revenant_strafel1 = [ 393, revenant_strafel2 ] { ai_slide (3, 0.04); };
void() revenant_strafel2 = [ self.frame, revenant_strafel2 ] 
{ 
	self.frame ++;
	if (self.frame >= 413) 
	{	
		revenant_run1 ();
		return;
	}

	if (self.frame < 411)
		ai_slide (4, 0.04);
};

void() revenant_strafer1 = [ 360, revenant_strafer2 ] { self.nextthink = time + 0.035; };
void() revenant_strafer2 = [ self.frame, revenant_strafer2 ] 
{ 
	self.frame ++;
	if (self.frame >= 381) 
	{	
		revenant_run1 ();
		return;
	}

	if (self.frame < 379)
		ai_slide (4, 0.04);
};

void() revenant_dodgel1 = [ 329, revenant_dodgel2 ] { ai_slide (6, 0.03); };
void() revenant_dodgel2 = [ self.frame, revenant_dodgel2 ] 
{ 
	self.frame ++;
	if (self.frame >= 353) 
	{	
		self.flags &= ~FL_DODGED;
		revenant_run1 ();
		return;
	}

	if (self.frame < 347)
		ai_slide (6, 0.03);
	else
		self.nextthink = time + 0.03;
};

void() revenant_dodger1 = [ 296, revenant_dodger2 ] { ai_slide (6, 0.03); };
void() revenant_dodger2 = [ self.frame, revenant_dodger2 ] 
{ 
	self.frame ++;

	if (visible(self.enemy))
	{
		if (self.frame == 312)
			revenant_shota (8,2);
	}
	
	if (self.frame >= 324) 
	{	
		self.flags &= ~FL_DODGED;
		revenant_run1 ();
		return;
	}

	if (self.frame < 315)
		ai_slide (6, 0.03);
	else 
		self.nextthink = time + 0.03;
};

void() revenant_strafe =
{		
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();

	if(self.lefty)
		revenant_strafel1 ();
	else 
		revenant_strafer1 ();
	
	self.nextthink = time + frametime;
};

void() revenant_dodge =
{		
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();

	if(self.lefty)
		revenant_dodgel1 ();
	else 
		revenant_dodger1 ();
	
	self.nextthink = time + frametime;
};

void() revenant_missilel1 = [ 216, revenant_missilel2 ] {ai_face(); self.nextthink = time + 0.035;};
void() revenant_missilel2 = [ self.frame, revenant_missilel2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.035;

	if (self.frame == 227)
		revenant_shota (-8,2);

	if (self.frame >= 246) 
	{	
		if (random() < 0.7)
			SUB_CheckRefire ( revenant_missiler1);
		else 
			HknightAttackFinished ();
		return;
	}

	if (self.frame < 229)
		ai_face ();
};


void() revenant_missiler1 = [ 247, revenant_missiler2 ] {ai_face(); self.nextthink = time + 0.035;};
void() revenant_missiler2 = [ self.frame, revenant_missiler2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.035;

	if (self.frame == 259)
		revenant_shota (8,1);
	
	if (self.frame >= 277) 
	{	
		if (random() < 0.7)
			SUB_CheckRefire ( revenant_missilel1);
		else 
			HknightAttackFinished ();		
		return;
	}

	if (self.frame < 259)
		ai_face ();
};

void() revenant_missilerl1 = [ 426, revenant_missilerl2 ] {ai_face(); self.nextthink = time + 0.03;};
void() revenant_missilerl2 = [ self.frame, revenant_missilerl2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;

	if (self.frame == 438)
	{
		revenant_shota (-8,3);
		revenant_shota (8, 0);
	}
	
	if (self.frame >= 460) 
	{	
		revenant_run1 ();		
		return;
	}

	if (self.frame < 438)
		ai_face ();
};


void(float side) revenant_Melee =
{
	float ldmg;
	vector delta;

	ai_face();

	knight_melee ();

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 90)
	{
		knight_miss ();
		return;
	}
	if (!CanDamage(self.enemy, self))
		return;

	// sound(self, CHAN_WEAPON, "demon/dhit2.wav", 1, ATTN_NORM);
	ldmg = 12 + 5*random();
	T_Damage(self.enemy, self, self.origin + v_forward*16, self, ldmg, 15);
	knight_hit ();
	makevectors(self.angles);
	SpawnMeatSpray(self.origin + v_forward*16, side * v_right);
};


//============================================================================


void(entity attacker, float damage) revenant_pain =
{	
	self.skin = 0;

	if (damage < 25)	
		return;

	if (self.pain_finished > time)
		return;

	if (self.flags & FL_DODGED)
		return;

	knight_pain();

	if (time - self.pain_finished > 10)
	{ // allways go into pain frame if it has been a while
		revenant_pain1();
		self.pain_finished = time + 3;
		return;
	}

	if ((random()*200 > damage))
		return; // didn't flinch

	self.pain_finished = time + 3;
	revenant_pain1();
};

float revenant_type;

void() revenant_melee =
{
	revenant_type = revenant_type + 1;

	if (revenant_type < 3)
		revenant_atta1 ();
	else 
	{
		revenant_attb1 ();
		revenant_type = 0;
	}
};


void() revenant_missile =
{
	revenant_type = revenant_type + 1;

	knight_combat ();

	if (revenant_type == 3)
	{
		revenant_missilerl1 ();
		revenant_type = 0;
		return;
	}
	
	if (random() <= 0.5)
		revenant_missilel1();
	else 
		revenant_missiler1();
	
	SUB_AttackFinished (3*random());
};


/*QUAKED monster_death_knight (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/

static void() knight_miss =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/imp/melee/miss_01.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/imp/melee/miss_02.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/imp/melee/miss_03.wav", 1, ATTN_NORM);
};

static void() knight_hit =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/imp/melee/hit_03.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/imp/melee/hit_01.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/imp/melee/hit_04.wav", 1, ATTN_NORM);
};

static void() knight_die =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/revenant/die1_alt1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/revenant/die2_alt1.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/revenant/die3_alt1.wav", 1, ATTN_NORM);
};

static void() knight_pain =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/revenant/pain1_alt1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/revenant/pain2_alt1.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/revenant/pain3_alt1.wav", 1, ATTN_NORM);
};

static void() knight_combat =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/revenant/chatter_combat1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/revenant/chatter_combat2.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/revenant/chatter_combat3.wav", 1, ATTN_NORM);
};

static void() knight_melee =
{
	local float r = rint(random() * 4);	

	if (r == 4)
		    sound(self, CHAN_VOICE, "monsters/revenant/melee1.wav", 1, ATTN_NORM);
	else if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/revenant/melee2.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/revenant/melee3.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/revenant/melee4.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/revenant/melee5.wav", 1, ATTN_NORM);
};

static void() knight_idle =
{
	local float r = rint(random() * 4);	

	if (r == 4)
		    sound(self, CHAN_VOICE, "monsters/revenant/chatter1.wav", 1, ATTN_IDLE);
	else if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/revenant/chatter2.wav", 1, ATTN_IDLE);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/revenant/chatter1.wav", 1, ATTN_IDLE);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/revenant/chatter3.wav", 1, ATTN_IDLE);
	else
		    sound(self, CHAN_VOICE, "monsters/revenant/chatter4.wav", 1, ATTN_IDLE);
};

void() revenant_idle_sound = { knight_idle ();};

static void() hknight_sight =
{
	local float r = rint(random() * 4);	

	if (r == 4)
		    sound(self, CHAN_VOICE, "monsters/revenant/sight1_1_alt1.wav", 1, ATTN_NORM);
	else if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/revenant/sight1_2_alt1.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/revenant/sight1_2_alt1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/revenant/sight2_1_alt1.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/revenant/sight2_1_alt1.wav", 1, ATTN_NORM);
};



void() monster_hell_knight_cache =
{
	precache_model2 ("progs/hknight.md3");
	precache_model2 ("progs/hknightmf.mdl");
	precache_model2 ("progs/hknightdeath.md3");

	//precache_model2 ("progs/revmiss.mdl");

	precache_sound2 ("monsters/revenant/chatter1.wav");
	precache_sound2 ("monsters/revenant/chatter2.wav");
	precache_sound2 ("monsters/revenant/chatter3.wav");
	precache_sound2 ("monsters/revenant/chatter4.wav");

	precache_sound2 ("monsters/revenant/chatter_combat1.wav");
	precache_sound2 ("monsters/revenant/chatter_combat2.wav");
	precache_sound2 ("monsters/revenant/chatter_combat3.wav");

	precache_sound2 ("monsters/revenant/die1_alt1.wav");
	precache_sound2 ("monsters/revenant/die2_alt1.wav");
	precache_sound2 ("monsters/revenant/die3_alt1.wav");

	precache_sound2 ("monsters/revenant/pain1_alt1.wav");
	precache_sound2 ("monsters/revenant/pain2_alt1.wav");
	precache_sound2 ("monsters/revenant/pain3_alt1.wav");

	precache_sound2 ("monsters/revenant/sight1_1_alt1.wav");
	precache_sound2 ("monsters/revenant/sight1_2_alt1.wav");
	precache_sound2 ("monsters/revenant/sight2_1_alt1.wav");
	precache_sound2 ("monsters/revenant/sight2_2_alt1.wav");

	precache_sound("monsters/imp/melee/hit_01.wav");
	precache_sound("monsters/imp/melee/hit_03.wav");
	precache_sound("monsters/imp/melee/hit_04.wav");

	precache_sound("monsters/imp/melee/miss_01.wav");
	precache_sound("monsters/imp/melee/miss_02.wav");
	precache_sound("monsters/imp/melee/miss_03.wav");

	precache_sound2 ("monsters/revenant/melee1.wav");
	precache_sound2 ("monsters/revenant/melee2.wav");
	precache_sound2 ("monsters/revenant/melee3.wav");
	precache_sound2 ("monsters/revenant/melee4.wav");
	precache_sound2 ("monsters/revenant/melee5.wav");

	precache_sound("hknight/hit.wav"); // used by C code, so don't sound2

};

void() monster_hell_knight =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	monster_hell_knight_cache ();

	spawn_death_knight ();
};

void() spawn_death_knight = 
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/hknight.md3");

	setsize(self, '-16 -16 0', '16 16 64');
	self.health = 380;
	self.max_health = 380;
	self.mass = 200;
	self.scale = 0.8;

	self.th_stand = revenant_stand1;
	self.th_walk = revenant_walk1;
	self.th_run = revenant_run1;
	self.th_melee = revenant_melee;
	self.th_missile = revenant_missile;
	self.th_pain = revenant_pain;
	self.th_die = revenant_die;
	self.th_dodge = revenant_dodge;
	self.th_sight = hknight_sight;
	self.th_spawn = spawn_death_knight;
	self.deathtype = "was thrashed by a Revenant";
	
	walkmonster_start();
};
