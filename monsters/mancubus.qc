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

SHAL-RATH

==============================================================================
*/

void() mancubus_stand1 = [ 104, mancubus_stand2 ] { ai_stand();};
void() mancubus_stand2 = [ self.frame, mancubus_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 343) 
	{	
		if (random() < 0.2)
			manc_idle ();
		mancubus_stand1 ();
		return;
	}
	ai_stand ();
};

void() mancubus_walk1 = [ 0, mancubus_walk2 ] { ai_walk(2);};
void() mancubus_walk2 = [ self.frame, mancubus_walk2 ] 
{ 	
	self.frame ++;

	if (self.frame == 8 || self.frame == 25)
		manc_step ();
	if (self.frame >= 31) 
	{	
		if (random() < 0.2)
			manc_idle ();
		mancubus_walk1 ();
		return;
	}
	ai_walk (2);
};

void() mancubus_run1 = [ 0, mancubus_run2 ] { ai_run(2);};
void() mancubus_run2 = [ self.frame, mancubus_run2 ] 
{ 	
	self.frame ++;
	
	if (self.frame == 8 || self.frame == 25)
		manc_step ();
	if (self.frame >= 31) 
	{	
		if (random() < 0.2)
			manc_idle ();
		mancubus_run1 ();
		return;
	}
	ai_run (2);
};

void() mancubus_startatk1 = [ 52, mancubus_startatk2 ] {manc_attack (); ai_face(); self.nextthink = time + 0.03; };
void() mancubus_startatk2 = [ self.frame, mancubus_startatk2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 61) 
	{	
		mancubus_atk1 ();
		return;
	}
	ai_face();
	self.nextthink = time + 0.03;
};

void() mancubus_atk1 = [ 62, mancubus_atk2 ] {ai_face(); self.nextthink = time + 0.03; };
void() mancubus_atk2 = [ self.frame, mancubus_atk2 ] 
{ 	
	self.frame ++;	

	if (self.frame == 65)
		mancubus_fire (-30, 16);
	
	if (self.frame == 80)
		mancubus_fire (30);
	
	if (self.frame >= 91) 	
	{
		local float r = range(self.enemy);	
		if(random() < 0.8 && r >= RANGE_CLOSE && visible(self.enemy) && SUB_CheckRefireFrame ( 63))
			 return; 

		mancubus_endatk1 ();
		return;
	}
	ai_face();
	self.nextthink = time + 0.03;
};

void() mancubus_endatk1 = [ 92, mancubus_endatk2 ] { self.nextthink = time + 0.02; };
void() mancubus_endatk2 = [ self.frame, mancubus_endatk2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 103) 
	{	
		local vector delta = self.enemy.origin - self.origin;

		if (vlen(delta) < 200)
		{
			self.th_melee ();
			return;
		}

		mancubus_run1 ();
		return;
	}
	self.nextthink = time + 0.02;
};

void() mancubus_melee =
{	
	if (random() < 0.6)
		mancubus_startatk1 ();
	else
		mancubus_melee1 ();
}

void() mancubusMelee =
{
	vector delta;
	float ldmg;

	sound(self, CHAN_VOICE, "demon/dland2.wav", 1, ATTN_NORM);

	if (!CanDamage(self.enemy, self))
		return;

	if (!self.enemy)
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 180)
		return;

	makevectors(self.angles);

	ldmg = 75 + (random() + random() + random()) * 15;
	T_Damage(self.enemy, self, self.origin + v_forward*16, self, ldmg, 40);
};

void() mancubus_melee1 = [ 344, mancubus_melee2 ] { manc_attack (); ai_face(); self.nextthink = time + 0.03; };
void() mancubus_melee2 = [ self.frame, mancubus_melee2 ] 
{ 	
	self.frame ++;	

	if (self.frame == 359)
		mancubusMelee ();
	
	if (self.frame >= 383) 
	{	
		if(random() <= 0.4)
		{
			self.th_missile ();
			return;
		}

		mancubus_run1 ();
		return;
	}
	ai_face();
	self.nextthink = time + 0.03;
};


void() mancubus_pain1 = [ 32, mancubus_pain2 ] { self.nextthink = time + 0.035; };
void() mancubus_pain2 = [ self.frame, mancubus_pain2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 52) 
	{	
		mancubus_run1 ();
		return;
	}
	self.nextthink = time + 0.035;
};


void(entity attacker, float damage) mancubus_pain =
{	
	if (self.pain_finished > time)
		return;

	if (random()*300 > damage)
		return; // didn't flinch

	manc_pain();
	mancubus_pain1();
	self.pain_finished = time + 3;
};

void() mancubus_die =
{	
	if (self.health < -400)
	{	
		self.deadflag = DEAD_DEAD;
		self.solid = SOLID_NOT;
		self.think = mancubus_gib1;
		self.nextthink = time + 0.035;
		return;
	}
	
	if((self.deadflag & DEAD_DEAD))
		return;

	local vector tmpangle;
	local float tempskin;
	tmpangle = self.angles;
	tempskin = self.skin;

	manc_die ();
	
	if (random () <= 0.5)
	{
		self.think = mancubus_die1;
		setmodel(self, "progs/shalrathdeath.md3");
	}
	else
	{
		self.think = mancubus_dieb1;
		setmodel(self, "progs/shalrathdeath2.md3");
	}

	setsize(self, '-32 -32 0', '32 32 88');

	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_CORPSE;
	self.nextthink = time + 0.035;

	self.angles = tmpangle;
	//self.skin = tempskin;
};

void() mancubus_die1 = [ 0, mancubus_die2 ] { self.nextthink = time + 0.035;};
void() mancubus_die2 = [ self.frame, mancubus_die2 ] 
{ 	
	self.nextthink = time + 0.035;

	if (self.frame < 10)
		ai_move (2);
	self.frame ++;
	if (self.frame == 32)
	{	
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() mancubus_dieb1 = [ 0, mancubus_dieb2 ] { self.nextthink = time + 0.035;};
void() mancubus_dieb2 = [ self.frame, mancubus_dieb2 ] 
{ 	
	self.nextthink = time + 0.035;

	if (self.frame < 10)
		ai_move (-2);
	self.frame ++;
	if (self.frame == 32)
	{
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() mancubus_gib1 = [ self.frame, mancubus_gib2 ] 
{MonsterGib (self.health); self.skin = 1; self.alpha = 1; self.nextthink = time + 0.02;};

void() mancubus_gib2 = [ self.frame, mancubus_gib2 ] 
{ 	
	self.nextthink = time + 0.02;
	self.alpha -= 0.02;
	if (self.alpha <= 0)
	{
		remove(self);
		return;
	}
};

/*
================
mancubus_Missile
================
*/
static void(float off, float off2 = 0) mancubus_fire =
{
	//if (random() > 0.6)
	//	 mancubus_Missile (off, off2, 128);

	mancubus_Missile (off, off2, 0);
};


static void(float off, float off2, float off3) mancubus_Missile =
{
	entity missile;
	vector dir, org;

	self.effects = self.effects | EF_MUZZLEFLASH;

	missile = spawn();
	missile.owner = self;

	missile.solid = SOLID_BBOX;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.shake_interval = 0.4;
	missile.shake_time = 0.7;
	//missile.classname = "grenade";
	setmodel(missile, "progs/muzzleflash.spr");

	setsize(missile, '0 0 0', '0 0 0');
	
	makevectors(self.angles);

	org = self.origin + '0 0 30' + v_right * off + v_up * off2 + v_forward * off3;
	dir = normalize((self.enemy.origin + '0 0 10') - org + v_right*crandom()*6);

	setorigin(missile, org);

	missile.emiteffectnum = particleeffectnum ("TE_MANC_FIREBALL");
	missile.traileffectnum = particleeffectnum ("EF_MANC_FIRETRAIL");
	
	missile.velocity = dir * 800;
	missile.avelocity = '300 300 300';
	missile.nextthink = time + 6;
	missile.think = SUB_Remove;
	missile.touch = mancubus_MissileTouch;
	missile.dmg = 80;
	missile.aiflags |= IS_PROJECTILE;
};

static void() mancubus_MissileTouch =
{
	if (other == self.owner)
		return; // don't explode on owner

	if (other.classname == "monster_zombie")
		T_Damage(other, self, self.origin, self, 110, 0);
	T_RadiusDamage(self, self.owner, self.dmg, 60, world);
//	sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
rocketimpact  ();

	  self.origin = self.origin - 32* normalize(self.velocity);

	BecomeExplosion ();
};

//=================================================================

/*QUAKED monster_shalrath (1 0 0) (-32 -32 -24) (32 32 48) Ambush
*/

static void() manc_step =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_BODY, "monsters/mancubus/ft_01.wav", 0.8, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_BODY, "monsters/mancubus/ft_02.wav", 0.8, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_BODY, "monsters/mancubus/ft_03.wav", 0.8, ATTN_NORM);
	else
		    sound(self, CHAN_BODY, "monsters/mancubus/ft_04.wav", 0.8, ATTN_NORM);

	GroundShake (self, 0.4, 0.2);
};

static void() manc_die =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/mancubus/die1.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/mancubus/die2.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/mancubus/die3.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/mancubus/die4_long.wav", 1, ATTN_NORM);
};

static void() manc_sight =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/mancubus/sight1.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/mancubus/sight2.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/mancubus/sight3.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/mancubus/sight4.wav", 1, ATTN_NORM);
};

static void() manc_pain =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/mancubus/pain5.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/mancubus/pain6.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/mancubus/pain7.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/mancubus/pain8.wav", 1, ATTN_NORM);
};

static void() manc_attack =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/mancubus/chatter_combat1.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/mancubus/chatter_combat2.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/mancubus/chatter_combat3.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/mancubus/chatter_combat4.wav", 1, ATTN_NORM);
};

static void() manc_idle =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/mancubus/chatter1.wav", 1, ATTN_IDLE);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/mancubus/chatter2.wav", 1, ATTN_IDLE);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/mancubus/chatter1.wav", 1, ATTN_IDLE);
	else
		    sound(self, CHAN_VOICE, "monsters/mancubus/chatter2.wav", 1, ATTN_IDLE);
};

void() monster_shalrath_cache =
{
	precache_model2 ("progs/shalrath.md3");
	precache_model2 ("progs/shalrathdeath.md3");
	precache_model2 ("progs/shalrathdeath2.md3");

	precache_model2 ("progs/v_spike.mdl");

	precache_sound2 ("monsters/mancubus/sight1.wav");
	precache_sound2 ("monsters/mancubus/sight2.wav");
	precache_sound2 ("monsters/mancubus/sight3.wav");
	precache_sound2 ("monsters/mancubus/sight4.wav");

	precache_sound2 ("monsters/mancubus/pain5.wav");
	precache_sound2 ("monsters/mancubus/pain6.wav");
	precache_sound2 ("monsters/mancubus/pain7.wav");
	precache_sound2 ("monsters/mancubus/pain8.wav");

	precache_sound2 ("monsters/mancubus/die1.wav");
	precache_sound2 ("monsters/mancubus/die2.wav");
	precache_sound2 ("monsters/mancubus/die3.wav");
	precache_sound2 ("monsters/mancubus/die4_long.wav");

	precache_sound2 ("monsters/mancubus/chatter_combat1.wav");
	precache_sound2 ("monsters/mancubus/chatter_combat2.wav");
	precache_sound2 ("monsters/mancubus/chatter_combat3.wav");
	precache_sound2 ("monsters/mancubus/chatter_combat4.wav");

	precache_sound2 ("monsters/mancubus/chatter1.wav");
	precache_sound2 ("monsters/mancubus/chatter2.wav");

	precache_sound2 ("monsters/mancubus/ft_01.wav");
	precache_sound2 ("monsters/mancubus/ft_02.wav");
	precache_sound2 ("monsters/mancubus/ft_03.wav");
	precache_sound2 ("monsters/mancubus/ft_04.wav");
};

void() monster_shalrath =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	monster_shalrath_cache ();
	monster_terminal_cache ();

	if (random() <= 0.4)
		spawn_terminal ();
	else
		spawn_mancubus();
};

void() monster_shalrath2 =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	monster_shalrath_cache ();

	spawn_mancubus();
};

void() spawn_mancubus =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/shalrath.md3");
	setsize(self, '-32 -32 0', '32 32 88');
	self.health = 1300;
	self.max_health = 1300;
	self.scale = 0.85;
	self.mass = 600;

	self.th_stand = mancubus_stand1;
	self.th_walk = mancubus_walk1;
	self.th_run = mancubus_run1;
	self.th_die = mancubus_die;
	self.th_pain = mancubus_pain;
	self.th_melee = mancubus_melee;
	self.th_missile = mancubus_startatk1;
	self.th_sight = manc_sight;
	self.th_spawn = spawn_mancubus;
	self.deathtype = "was pommeled to death by a Mancubus";

	self.think = walkmonster_start;
	self.nextthink = time + 0.1 + random()*0.1;
};
