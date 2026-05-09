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

static float(float rad)	inShamRange =
{	
	if (self.aiflags & AI_SCRIPTED_ACTION)
		return FALSE;

	local entity targ = self.enemy;
	local vector spot1 = self.origin + self.view_ofs;
	local vector spot2 = targ.origin + targ.view_ofs;

	if (vlen(spot1 - spot2) <= rad)
		return TRUE;
	
	return FALSE;
};

void() cybrdemon_stand1 = [ 0, cybrdemon_stand2 ] {ai_stand();};
void() cybrdemon_stand2 = [ self.frame, cybrdemon_stand2 ] 
{ 
	self.frame ++;
	if (self.frame >= 99) 
	{	
		if(random () < 0.2)
			cybr_idle ();

		cybrdemon_stand1 ();
		return;
	}
	ai_stand ();
};

void() cybrdemon_walk1 = [ 100, cybrdemon_walk2 ] {ai_walk(3);};
void() cybrdemon_walk2 = [ self.frame, cybrdemon_walk2 ] 
{ 	
	self.frame ++;
	if (self.frame == 115 || self.frame == 135)
		cybr_step ();

	if (self.frame >= 140) 
	{
		if(random () < 0.2)
			cybr_idle ();

		cybrdemon_walk1 ();
		return;
	}
	ai_walk (3);
};

void() cybrdemon_run1 = [ 100, cybrdemon_run2 ] {ai_run(3);};
void() cybrdemon_run2 = [ self.frame, cybrdemon_run2 ] 
{ 
	self.frame ++;
	if (self.frame == 115 || self.frame == 135)
		cybr_step ();
	
	if (self.frame >= 140) 
	{
		if(random () < 0.2)
			cybr_idle ();

		cybrdemon_run1 ();
		return;
	}
	ai_run (3);
};

void() CybrSmash =
{
	vector delta;
	float ldmg;
	
	cybr_step();
	GroundShake (self, 0.7, 0.2);

	vector f, r, u;
	AngleVectors(self.angles, f, r, u);

	pointparticles (particleeffectnum("TE_SHOCK_DUST"), self.origin + f * 100 + r * 24, '0 0 0', 2);
	explosion_wave (self.origin + f * 100 + r * 24);

	if (!CanDamage(self.enemy, self))
		return;

	if (!self.enemy)
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 200)
		return;

	ldmg = 80 + (random() + random() + random()) * 15;
	T_Damage(self.enemy, self, self.origin + v_forward*16, self, ldmg, 40);
//	Cyb_smash_Aoe (350, world);
};

void(float side) cybrbonk =
{
	vector delta;
	float ldmg;

	if (!self.enemy)
		return;

	if (!CanDamage(self.enemy, self))
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 120)
	{
		cybr_melee ();
		return;
	}
	
	makevectors(self.angles);
	ldmg = 60 + (random() + random() + random()) * 15;
	T_Damage(self.enemy, self, self.origin + v_forward*16, self, ldmg, 40);
	cybr_chomp();

	if (side)
	{
		makevectors(self.angles);
		SpawnMeatSpray(self.origin + v_forward*16, side * v_right);
	}
};

void() cybrdemon_stomp1 = [ 578, cybrdemon_stomp2 ] {ai_face(); self.nextthink = time + 0.02;};
void() cybrdemon_stomp2 = [ self.frame, cybrdemon_stomp2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.02;

	if (self.frame < 605)
		ai_face();

	if (self.frame == 605)
	{
	//	cybr_step();
		CybrSmash ();
	}
		
	
	if (self.frame >= 638) 
	{
		cybrdemon_run1 ();
		return;
	}
};

void() cybrdemon_swing1 = [ 639, cybrdemon_swing2 ] {ai_face(); self.nextthink = time + 0.03;};
void() cybrdemon_swing2 = [ self.frame, cybrdemon_swing2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;

	if (self.frame < 661)
		ai_face ();

	if (self.frame == 661)
		cybrbonk (-80);
	
	if (self.frame >= 678) 
	{
		cybrdemon_run1 ();
		return;
	}
};

void() _ShockTouch =
{	
	if (!other.takedamage)
		return;
	if (other == self.owner)
		return;
	if (other != self.enemy)
		return;
	if (self.ltime > time)
		return;

	T_Damage (other, self, self.origin, self, self.dmg, 40);
	self.ltime = time + 0.08;
};

void(vector org, float damage, vector min, vector max, float timer) Shockwave_spawn =
{
	local entity e;
	
	e = spawn();
	setorigin(e, org);
	e.origin[2] = self.origin[2];

	setmodel (e, "progs/muzzleflash.spr");
	setsize (e, min, max);
	e.solid = SOLID_TRIGGER;
	e.movetype = MOVETYPE_FLY;
//	e.emiteffectnum = (particleeffectnum("TE_SHOCK_DUST"));
	e.nextthink = time + timer;
	e.think = SUB_Remove;

	pointparticles (particleeffectnum("TE_SHOCK_DUST"), e.origin, '0 0 0', 2);
	explosion_wave (e.origin);
	e.touch = _ShockTouch;
	e.enemy = self.enemy;
	e.owner = self;
	e.deathtype = "earthquake";
	e.nextthink = time + timer;
	e.think = SUB_Remove;
	e.dmg = damage;

	cybr_step();
};

void() Shockwave_emerge =
{
	Shockwave_spawn (self.origin, 120, '-48 -48 0', '48 48 64', 0.35);
	remove(self);
};

void(float num, vector org) ShockwaveSpot =
{
	entity e;
	e = spawn();
	e.origin = org;
	e.angles = self.angles;
	e.think = Shockwave_emerge;
	e.enemy = self.enemy;
	e.nextthink = time + num;
};

void() CySmash =
{	
	float n = vlen(self.origin - self.enemy.origin);
	n = ceil(n / 64);

	local vector fwd, r, u;
	float num = 64;
	float timer = 0.001;
	
	AngleVectors(self.angles, fwd, r, u);
	vector org = self.origin;
	//makevectors(self.angles);

	//bprint(vtos(fwd),"\n");
	
	for (float i = 0; i < n; i++)
	{	
		//num = 64;
	//	timer =
		ShockwaveSpot (timer, org + fwd * num);
		num = num + 64;
		timer += 0.03;
	}
};		

void() cybrdemon_smash1 = [ 505, cybrdemon_smash2 ] {ai_face(); self.nextthink = time + 0.025;};
void() cybrdemon_smash2 = [ self.frame, cybrdemon_smash2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.025;

	if (self.frame == 535)
	{
		cybr_step2 ();
		GroundShake (self, 1.8, 0.5);
	}
		

	if (self.frame == 539)
		CySmash();
	
	if (self.frame >= 575) 
	{
		cybrdemon_run1 ();
		return;
	}
	
	if (self.frame < 533)
		ai_charge (5);

	if (self.frame > 557 && self.frame < 574)
		ai_forward (-3);
};

void() cybrdemon_melee =
{
	float chance;
	
	//bprint(ftos(self.pissed), "\n");
	cybr_combat ();
	
	chance = random();
	if (chance >= 0.5)
		cybrdemon_swing1();
	else
		cybrdemon_stomp1();
};

static void() cyb_Missile2 =
{
	vector dir, org;

	self.effects = self.effects | EF_MUZZLEFLASH;
	
	makevectors(self.angles);

	org = self.origin + '0 0 30' + v_right * 42 + v_up * 82 + v_forward * 32;
	dir = normalize((self.enemy.origin + '0 0 10') - org);

	launch_thunderball(dir, org, 80, 2, 250);
};

float() CybieCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
//	local float		chance;

	targ = self.enemy;
	makevectors(self.angles);

	vector org = self.origin + '0 0 30' + v_right * 50 + v_up * 82 + v_forward * 32;
	
// see if any entities are in the way of the shot
	spot1 = org;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);
//	line(spot1, trace_endpos);

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_ent != targ)
	{
		return FALSE;	// don't have a clear shot
	}

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
		
// missile attack
	if (enemy_range == RANGE_FAR)
		return FALSE;
		
	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (1.2 + 2*random());
	return TRUE;
};

static void(float damage = 120) cyb_Missile =
{
	entity missile;
	vector dir, org;

	self.last_sighting = self.enemy.origin;
	self.effects = self.effects | EF_MUZZLEFLASH;

	missile = spawn();
	missile.owner = self;

	missile.solid = SOLID_SLIDEBOX; // no collision with homing missiles
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.shake_interval = 0.7;
	missile.shake_time = 0.7;
	//missile.classname = "grenade";
	setmodel(missile, "progs/muzzleflash.spr");

	setsize(missile, '0 0 0', '0 0 0');
	
	makevectors(self.angles);

	vector target = self.enemy.origin;

	if (random() > 0.4)
		target += self.enemy.velocity * 0.15;

	org = self.origin + '0 0 30' + v_right * 50 + v_up * 82 + v_forward * 32;
	dir = normalize((target + '0 0 22') - org);

	setorigin(missile, org);

	
	//missile.traileffectnum = particleeffectnum ("EF_NADETRAIL");
	
	missile.velocity = dir * 800;
	missile.avelocity = '300 300 300';
	missile.enemy = self.enemy;
	missile.speed = 800;

	if(random() > 0.7 || self.pissed == 1)
	{
		missile.nextthink = time + 0.1;
		missile.think = cyb_Missilehome;
		missile.emiteffectnum = particleeffectnum ("TE_CYBIE_FIREBALL");
		missile.traileffectnum = particleeffectnum ("EF_CYBIE_FIRETRAIL");
		missile.aiflags |= IS_PROJECTILE;
	//	missile.dmg = 80;
		missile.classname = "homing_missile";
		cyb_MissileHitbox (missile);
	}
	else
	{	
		missile.emiteffectnum = particleeffectnum ("TE_MANC_FIREBALL");
		missile.traileffectnum = particleeffectnum ("EF_MANC_FIRETRAIL");
		missile.nextthink = time + 6;
		missile.think = SUB_Remove;
	}
	
	missile.touch = cyb_MissileTouch;
	missile.dmg = damage;
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

static void(entity own) cyb_MissileHitbox = 
{
	local entity e;
	e = spawn();
	setsize(e, '-16 -16 -16', '16 16 16');
	setorigin(e, own.origin);
	e.health = 200;
	e.takedamage = DAMAGE_AIM;
	e.solid = SOLID_CORPSE;
	e.classname = "homing_missilebbox";
	e.movetype = MOVETYPE_FLY;
	e.th_die = cyb_MissileDie;
	e.owner = own;
	e.origin = own.origin;
	e.think = followmissile;
	e.nextthink = time;
	e.groundentity = own;
	own.nextbumper = e;
}

static void() cyb_Missilehome =
{
	local vector	dir, vtemp;
	local entity 	targ = self.enemy;

	vtemp = targ.origin + '0 0 22';

//	bprint(ftos(self.speed),"\n");
	if (self.speed > 290)
		self.speed *= 0.95;
	if ((self.enemy.health <= 0))
	{	
		vtemp = targ.origin + '0 0 22';
		dir = normalize(vtemp - self.origin);
		self.velocity = dir * 800;
		self.nextthink = 6 + time;
		self.think = SUB_Remove;
		return;
	}

	dir = normalize(vtemp - self.origin);
	
	self.velocity = dir * self.speed;

	self.angles = vectoangles(self.velocity);
	self.nextthink = time;
	self.think = cyb_Missilehome;	
	GroundShake (self, 0.4, 0.1);
};

static void() cyb_MissileTouch =
{	
	if (other == self.owner)
		return; // don't explode on owner

	if (other.classname == "monster_zombie")
		T_Damage(other, self, self.origin, self, 110, 0);

	if (self.nextbumper)
		remove(self.nextbumper);
		
	T_RadiusDamage(self, self.owner, self.dmg, 100, world);
	//sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
rocketimpact  ();

	  self.origin = self.origin - 32* normalize(self.velocity);
	
	BecomeExplosion ();
};

static void() cyb_MissileDie =
{
	remove(self.owner);
	self.origin = self.origin - 32* normalize(self.velocity);

	BecomeExplosion ();
};

void() cybrdemon_magic1 = [ 250, cybrdemon_magic2 ] { ai_face(); self.nextthink = time + 0.025;};
void() cybrdemon_magic2 = [ self.frame, cybrdemon_magic2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.025;
	
	if (self.frame < 268)
		ai_face();

	if (self.frame == 268)
		cyb_Missile (180);
	
	if (self.frame >= 289) 
	{	
		if (self.pissed)
			self.pissed = 0;

		if (skill > 2)
		{	
			if (random() > 0.4)
				self.pissed = 1;
			if (random() > 0.6)
				cybrdemon_magic1 ();
			else	
				cybrdemon_smash1 ();
			return;
		}

		cybrdemon_run1 ();
		return;
	}
};


void() cybrdemon_turreta1 = [ 290, cybrdemon_turreta2 ] { ai_face(); self.nextthink = time + 0.02;};
void() cybrdemon_turreta2 = [ self.frame, cybrdemon_turreta2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.02;
	
	if (self.frame < 330)
		ai_face();
	
	if (self.frame == 308 || self.frame == 330)
		cyb_Missile ();
	
	if (self.frame >= 354) 
	{	
		if (self.pissed)
			self.pissed = 0;

		cybrdemon_run1 ();
		return;
	}
};

void() cybrdemon_turretb1 = [ 355, cybrdemon_turretb2 ] { ai_face(); self.nextthink = time + 0.02;};
void() cybrdemon_turretb2 = [ self.frame, cybrdemon_turretb2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.02;
	
	if (self.frame < 420)
		ai_face();
	
	if (self.frame == 420 || self.frame == 373 || self.frame == 395)
		cyb_Missile ();
	
	if (self.frame >= 444) 
	{	
		if (self.pissed)
			self.pissed = 0;

		if (skill > 1)
		{	
			if (random() > 0.8 && skill > 2)
				self.pissed = 1;
			if (random() > 0.6)
				cybrdemon_turreta1 ();
			else	
				cybrdemon_smash1 ();
			return;
		}

	//	SUB_CheckRefire (cybrdemon_turretb1);
		cybrdemon_run1 ();
		return;
	}
};

void() cybrdemon_missile =
{	
	
	float r = rint(rand() % 3);

	if (self.enemy.weapon == IT_CHAINGUN && random() > 0.6) // 40% more often to fire homing missiles
	{
		self.pissed = 1;
		cybrdemon_turretb1 ();
	}

	//bprint (ftos(r));
	if (r == 0 )
		cybrdemon_magic1 ();
	else if (r == 1 )
		cybrdemon_turreta1 ();
	else if (r == 2 )
		cybrdemon_turretb1 ();
	else
		cybrdemon_smash1 ();

	cybr_combat ();
};

	// dodged flag makes shit not run immediately which is a good thing
void() cybrdemon_sight = {self.flags |= FL_DODGED; self.think = cybrdemon_sight1; self.nextthink = time;}
void() cybrdemon_sight1 = [ 141, cybrdemon_sight2 ] {cybr_sight(); ai_face(); self.nextthink = time + 0.035;}
void() cybrdemon_sight2 = [ self.frame, cybrdemon_sight2 ] 
{   
    self.frame ++;
    if (self.frame >= 249)
    {	
		self.flags &= ~FL_DODGED;
        cybrdemon_run1();
        return;
    }

    if (self.frame == 243)
        cybr_step();

    if (self.frame > 229)
        ai_charge (3);

    if (self.frame < 167 && self.frame > 148)
        ai_charge(1);
    
    if (self.frame > 167 && self.frame < 209)
        ai_charge(-1);

    self.nextthink = time + 0.035;
}

//============================================================================


void() cybrdemon_pain1 = [ 445, cybrdemon_pain2 ] {self.nextthink = time + 0.02;};
void() cybrdemon_pain2 = [ self.frame, cybrdemon_pain2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.02;
	
	if (self.frame >= 504) 
	{	
		if (random() > 0.6)
			cybrdemon_turreta1 ();
		else	
			cybrdemon_smash1 ();
		return;
	}
};

void(entity attacker, float damage) cybrdemon_pain =
{	
	if (self.flags & FL_DODGED)	
		return;
	
	if (self.pain_finished > time)
		return;

	self.pain_finished = time + 3;
	
	cybr_pain ();

	if (self.health <= 0)
		return; // allready dying, don't go into pain frame

	if (random()*800 > damage)
		return; // didn't flinch

	cybrdemon_pain1 ();
	self.pissed = 1;
};


//============================================================================

void() cybrdemon_death =
{	
	if((self.deadflag & DEAD_DEAD))
		return;

	cybr_die ();
    SUB_ClearBumpers ();

	local vector tmpangle;
	local float tempskin;
	tmpangle = self.angles;
	tempskin = self.skin;
	
	self.think = cybrdemon_die1;
	setmodel(self, "progs/cyberdemondeath.md3");
		
	setsize(self, '-32 -32 0', '32 32 88');

	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_CORPSE;
	self.nextthink = time + 0.035;

	self.angles = tmpangle;
	//self.skin = tempskin;
};

void() cybrdemon_die1 = [ 0, cybrdemon_die2 ] { self.nextthink = time + 0.035;};
void() cybrdemon_die2 = [ self.frame, cybrdemon_die2 ] 
{ 	
	self.nextthink = time + 0.035;

	if (self.frame < 10)
		ai_move (-4);
	self.frame ++;
	if (self.frame == 121)
	{	
		//self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

//============================================================================

static void() cybr_chomp =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/hellknight/chomp1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/hellknight/chomp2.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/hellknight/chomp3.wav", 1, ATTN_NORM);	
};

static void() cybr_melee =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/revenant/melee1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/revenant/melee2.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/revenant/melee3.wav", 1, ATTN_NORM);	
};

static void() cybr_idle =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/hellknight/cybr_chatter_01.wav", 1, ATTN_IDLE);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/hellknight/cybr_chatter_02.wav", 1, ATTN_IDLE);
	else
		    sound(self, CHAN_VOICE, "monsters/hellknight/cybr_chatter_03.wav", 1, ATTN_IDLE);
};

static void() cybr_combat =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/hellknight/ncc_01.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/hellknight/ncc_02.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/hellknight/ncc_03.wav", 1, ATTN_NORM);
};
static void() cybr_die =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/hellknight/die1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/hellknight/die2.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/hellknight/die3.wav", 1, ATTN_NORM);
};

static void() cybr_sight =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_WEAPON, "monsters/hellknight/sight1_1.wav", 1, ATTN_NONE);
	else if (r == 1)
		    sound(self, CHAN_WEAPON, "monsters/hellknight/sight2_1.wav", 1, ATTN_NONE);
	else
		    sound(self, CHAN_WEAPON, "monsters/hellknight/sight3_1.wav", 1, ATTN_NONE);

    GroundShake (self, 0.8, 3.2);
};

static void() cybr_pain =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/hellknight/cybr_pain_01.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/hellknight/cybr_pain_02.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/hellknight/cybr_pain_03.wav", 1, ATTN_NORM);	
};

static void() cybr_step =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_BODY, "monsters/hellknight/Hell_Knight_FS_03.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_BODY, "monsters/hellknight/Hell_Knight_FS_05.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_BODY, "monsters/hellknight/Hell_Knight_FS_03.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_BODY, "monsters/hellknight/Hell_Knight_FS_05.wav", 1,  ATTN_NORM);

	GroundShake (self, 0.8, 0.2);
};

static void() cybr_step2 =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_BODY, "monsters/hellknight/step1.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_BODY, "monsters/hellknight/step2.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_BODY, "monsters/hellknight/step3.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_BODY, "monsters/hellknight/step4.wav", 1,  ATTN_NORM);

//	GroundShake (self, 0.4, 0.2);
};

/*QUAKED monster_nazicultist (1 0 0) (-32 -32 -24) (32 32 64) Ambush
*/
void() monster_chthon_cache =
{
	precache_model("progs/cyberdemon.md3");
	precache_model("progs/cyberdemondeath.md3");

	precache_sound("monsters/revenant/melee1.wav");
	precache_sound("monsters/revenant/melee2.wav");
	precache_sound("monsters/revenant/melee3.wav");

	precache_sound("monsters/hellknight/ncc_01.wav");
	precache_sound("monsters/hellknight/ncc_02.wav");
	precache_sound("monsters/hellknight/ncc_03.wav");
	precache_sound("monsters/hellknight/cybr_chatter_01.wav");
	precache_sound("monsters/hellknight/cybr_chatter_02.wav");
	precache_sound("monsters/hellknight/cybr_chatter_03.wav");

	precache_sound("monsters/hellknight/sight1_1.wav");
	precache_sound("monsters/hellknight/sight2_1.wav");
	precache_sound("monsters/hellknight/sight3_1.wav");

	precache_sound("monsters/hellknight/fb_create_02.wav");

	precache_sound("monsters/hellknight/chomp1.wav");
	precache_sound("monsters/hellknight/chomp2.wav");
	precache_sound("monsters/hellknight/chomp3.wav");

	precache_sound("monsters/hellknight/cybr_pain_01.wav");
	precache_sound("monsters/hellknight/cybr_pain_02.wav");
	precache_sound("monsters/hellknight/cybr_pain_03.wav");

	precache_sound("monsters/hellknight/die1.wav");
	precache_sound("monsters/hellknight/die2.wav");
	precache_sound("monsters/hellknight/die3.wav");

	precache_sound("monsters/hellknight/Hell_Knight_FS_05.wav");
	precache_sound("monsters/hellknight/Hell_Knight_FS_03.wav");

	precache_sound("monsters/hellknight/step1.wav");
	precache_sound("monsters/hellknight/step2.wav");
	precache_sound("monsters/hellknight/step3.wav");
	precache_sound("monsters/hellknight/step4.wav");
};

void() monster_chthon =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	monster_chthon_cache ();
	spawn_chthon ();
};

void() monster_cyberdemon =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	monster_chthon_cache ();
	spawn_chthon ();
};


void() spawn_chthon =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/cyberdemon.md3");

	setsize(self, '-48 -48 0', '48 48 156');
	self.health = 6000;
	self.max_health = 6000;
	self.armortype = 0.7;
	self.armorvalue = 300; 
	self.mass = 0;
	self.scale = 0.7;

	if (world.worldtype == 2)
		self.skin = 1;

	self.th_stand = cybrdemon_stand1;
	self.th_walk = cybrdemon_walk1;
	self.th_run = cybrdemon_run1;
	self.th_die = cybrdemon_death;
	self.th_melee = cybrdemon_melee;
	self.th_missile = cybrdemon_missile;
	self.th_pain = cybrdemon_pain;
	self.th_checkatck = CybieCheckAttack;
	self.th_spawn = spawn_shambler;
	self.th_sight = cybrdemon_sight;
	self.deathtype = "was shot until he died";
	self.pissed = 0;

    SUB_AddBumper('-56 -56 0', FALSE);
	SUB_AddBumper('-56 56 0', FALSE);
	SUB_AddBumper('56 -56 0', FALSE);
	SUB_AddBumper('56 56 0', FALSE);
	SUB_AddBumper('56 0 0', FALSE);
	SUB_AddBumper('-56 0 0', FALSE);
	SUB_AddBumper('0 56 0', FALSE);
	SUB_AddBumper('0 -56 0', FALSE);

	SUB_AddBumper('-56 -56 156', TRUE);
	SUB_AddBumper('-56 56 156', TRUE);
	SUB_AddBumper('56 -56 156', TRUE);
	SUB_AddBumper('56 56 156', TRUE);
	SUB_AddBumper('56 0 156', TRUE);
	SUB_AddBumper('-56 0 156', TRUE);
	SUB_AddBumper('0 56 156', TRUE);
	SUB_AddBumper('0 -56 156', TRUE);

    SUB_AddBumper('-56 -56 19', TRUE);
	SUB_AddBumper('-56 56 19', TRUE);
	SUB_AddBumper('56 -56 19', TRUE);
	SUB_AddBumper('56 56 19', TRUE);
	SUB_AddBumper('56 0 19', TRUE);
	SUB_AddBumper('-56 0 19', TRUE);
	SUB_AddBumper('0 56 19', TRUE);
	SUB_AddBumper('0 -56 19', TRUE);

    SUB_AddBumper('-56 -56 39', TRUE);
	SUB_AddBumper('-56 56 39', TRUE);
	SUB_AddBumper('56 -56 39', TRUE);
	SUB_AddBumper('56 56 39', TRUE);
	SUB_AddBumper('56 0 39', TRUE);
	SUB_AddBumper('-56 0 39', TRUE);
	SUB_AddBumper('0 56 39', TRUE);
	SUB_AddBumper('0 -56 39', TRUE);
    
    SUB_AddBumper('-56 -56 58', TRUE);
	SUB_AddBumper('-56 56 58', TRUE);
	SUB_AddBumper('56 -56 58', TRUE);
	SUB_AddBumper('56 56 58', TRUE);
	SUB_AddBumper('56 0 58', TRUE);
	SUB_AddBumper('-56 0 58', TRUE);
	SUB_AddBumper('0 56 58', TRUE);
	SUB_AddBumper('0 -56 58', TRUE);

    SUB_AddBumper('-56 -56 78', TRUE);
	SUB_AddBumper('-56 56 78', TRUE);
	SUB_AddBumper('56 -56 78', TRUE);
	SUB_AddBumper('56 56 78', TRUE);
	SUB_AddBumper('56 0 78', TRUE);
	SUB_AddBumper('-56 0 78', TRUE);
	SUB_AddBumper('0 56 78', TRUE);
	SUB_AddBumper('0 -56 78', TRUE);

    SUB_AddBumper('-56 -56 97', TRUE);
	SUB_AddBumper('-56 56 97', TRUE);
	SUB_AddBumper('56 -56 97', TRUE);
	SUB_AddBumper('56 56 97', TRUE);
	SUB_AddBumper('56 0 97', TRUE);
	SUB_AddBumper('-56 0 97', TRUE);
	SUB_AddBumper('0 56 97', TRUE);
	SUB_AddBumper('0 -56 97', TRUE);

    SUB_AddBumper('-56 -56 136', TRUE);
	SUB_AddBumper('-56 56 136', TRUE);
	SUB_AddBumper('56 -56 136', TRUE);
	SUB_AddBumper('56 56 136', TRUE);
	SUB_AddBumper('56 0 136', TRUE);
	SUB_AddBumper('-56 0 136', TRUE);
	SUB_AddBumper('0 56 136', TRUE);
	SUB_AddBumper('0 -56 136', TRUE);

    SUB_AddBumper('-56 -56 117', TRUE);
	SUB_AddBumper('-56 56 117', TRUE);
	SUB_AddBumper('56 -56 117', TRUE);
	SUB_AddBumper('56 56 117', TRUE);
	SUB_AddBumper('56 0 117', TRUE);
	SUB_AddBumper('-56 0 117', TRUE);
	SUB_AddBumper('0 56 117', TRUE);
	SUB_AddBumper('0 -56 117', TRUE);

	walkmonster_start();
}