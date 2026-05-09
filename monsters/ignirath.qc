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

void() salamander_stand1 = [ 0, salamander_stand2 ] { ai_stand();};
void() salamander_stand2 = [ self.frame, salamander_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 170) 
	{	
		if (random() < 0.2)
			sal_idle ();
		salamander_stand1 ();
		return;
	}
	ai_stand ();
};

void() salamander_walk1 = [ 171, salamander_walk2 ] { ai_walk(3);};
void() salamander_walk2 = [ self.frame, salamander_walk2 ] 
{ 	
	self.frame ++;

	if (self.frame == 188 || self.frame == 203)
		sal_step ();
	if (self.frame >= 203) 
	{	
		if (random() < 0.2)
			sal_idle ();
		salamander_walk1 ();
		return;
	}
	ai_walk (3);
};

void() salamander_run1 = [ 171, salamander_run2 ] { ai_run(3.5);};
void() salamander_run2 = [ self.frame, salamander_run2 ] 
{ 	
	self.frame ++;
	
	if (self.frame == 188 || self.frame == 203)
		sal_step ();
	if (self.frame >= 203) 
	{	
		if (random() < 0.2)
			sal_idle ();
		salamander_run1 ();
		return;
	}
	ai_run (3.5);
};

void() salamander_atka1 = [ 348, salamander_atka2 ] {ai_face(); self.nextthink = time + 0.03; };
void() salamander_atka2 = [ self.frame, salamander_atka2 ] 
{ 	
	self.frame ++;	

	//bprint("attack a", "\n");
	if (self.frame == 364)
		salamander_fire (30, 32);
	
	if (self.frame >= 380) 	
	{	
			salamander_run1 ();	

		return;
	}
	if (self.frame < 364)
		ai_face();
	
	self.nextthink = time + 0.03;
};

void() salamander_atkb1 = [ 381, salamander_atkb2 ] {ai_face(); self.nextthink = time + 0.03; };
void() salamander_atkb2 = [ self.frame, salamander_atkb2 ] 
{ 	
	self.frame ++;		
	
	//	bprint("attack b", "\n");
	if (self.frame == 397)
		salamander_fire (-30, 32);
	
	if (self.frame >= 413) 	
	{
		salamander_run1 ();
		return;
	}
	if (self.frame < 397)
		ai_face();

	self.nextthink = time + 0.03;
};

void() salamander_atkc1 = [ 414, salamander_atkc2 ] {ai_face(); self.nextthink = time + 0.03; };
void() salamander_atkc2 = [ self.frame, salamander_atkc2 ] 
{ 	
	self.frame ++;	

	if (self.frame >= 436 && self.frame < 438)
	{
		salamander_fire (0, 32);
	//	salamander_fire (0, 32);
	}
		
	if (self.frame >= 454) 	
	{	
			salamander_run1 ();	

		return;
	}
	if (self.frame < 444)
		ai_face();
	
	self.nextthink = time + 0.03;
};

void() salamander_atka_a1 = [ 217, salamander_atka_a2 ] {ai_charge(3.5); self.nextthink = time + 0.03; };
void() salamander_atka_a2 = [ self.frame, salamander_atka_a2 ] 
{ 	
	self.frame ++;	

	//bprint("attack a", "\n");
	if (self.frame == 236)
		salamander_fire (-30, 32);
	
	if (self.frame >= 250) 	
	{	
			salamander_run1 ();	

		return;
	}
	if (self.frame < 236)
		ai_charge(3.5);
	else	
		ai_move(3.5);
	
	self.nextthink = time + 0.03;
};

void() salamander_atkb_b1 = [ 251, salamander_atkb_b2 ] {ai_charge(3.5); self.nextthink = time + 0.03; };
void() salamander_atkb_b2 = [ self.frame, salamander_atkb_b2 ] 
{ 	
	self.frame ++;	
	
	//	bprint("attack b", "\n");
	if (self.frame == 267)
		salamander_fire (30, 32);
	
	if (self.frame >= 280) 	
	{
		salamander_run1 ();
		return;
	}

	if (self.frame < 267)
		ai_charge(3.5);
	else	
		ai_move(3.5);

	self.nextthink = time + 0.03;
};

void() salamander_left_atk = 
{
	if(random() <= 0.5)
		salamander_atka_a1 ();
	else
		salamander_atka1 ();
}


void() salamander_right_atk = 
{
	if(random() <= 0.5)
		salamander_atkb_b1 ();
	else
		salamander_atkb1 ();
}

void() salamander_range =
{	
	sal_attack ();

	float r = rint(rand() % 2);
	if (r == 0)
		salamander_left_atk ();
	else if (r == 1)
		salamander_right_atk ();
	else
		salamander_atkc1 ();
}

void() salamander_melee =
{	
	sal_attack ();

	if (random() <= 0.5)
		salamander_meleea1 ();
	else
		salamander_meleeb1 ();
}

void() salamanderMelee =
{
	vector delta;
	float ldmg;

	if (!self.enemy)
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 120)
		return;

	ldmg = 38 + (random() + random() + random()) * 15;
	T_Damage(self.enemy, self, self.origin + v_forward*16, self, ldmg, 40);
};

void() salamander_meleea1 = [ 283, salamander_meleea2 ] {ai_face(); self.nextthink = time + 0.035; };
void() salamander_meleea2 = [ self.frame, salamander_meleea2 ] 
{ 	
	self.frame ++;	

	if (self.frame == 298)
		salamanderMelee ();
	
	if (self.frame >= 315) 
	{	
		salamander_run1 ();
		return;
	}

	if (self.frame < 298)
		ai_face();

	self.nextthink = time + 0.035;
};

void() salamander_meleeb1 = [ 316, salamander_meleeb2 ] {ai_face(); self.nextthink = time + 0.035; };
void() salamander_meleeb2 = [ self.frame, salamander_meleeb2 ] 
{ 	
	self.frame ++;	

	if (self.frame == 328)
		salamanderMelee ();
	
	if (self.frame >= 347) 
	{	
		salamander_run1 ();
		return;
	}

	if (self.frame < 115)
		ai_face();

	self.nextthink = time + 0.035;
};

void() salamander_pain1 = [ 206, salamander_pain2 ] {self.nextthink = time + 0.035; };
void() salamander_pain2 = [ self.frame, salamander_pain2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 216) 
	{	
		salamander_run1 ();
		return;
	}
	
	self.nextthink = time + 0.035;
};


void(entity attacker, float damage) salamander_pain =
{	
	if (self.flags & FL_DODGED)
		return;

	if (self.pain_finished > time)
		return;

	if (random()*300 > damage)
		return; // didn't flinch

	sal_pain();
	salamander_pain1();
	self.pain_finished = time + 3;
};

void() salamander_die =
{	
	if (self.health < -400)
	{	
		self.deadflag = DEAD_DEAD;
		self.solid = SOLID_NOT;
		self.think = salamander_gib1;
		self.nextthink = time + 0.035;
		return;
	}
	
	if((self.deadflag & DEAD_DEAD))
		return;

	local vector tmpangle;
	local float tempskin;
	tmpangle = self.angles;
	tempskin = self.skin;

	sal_die ();
	
		self.think = salamander_die1;
	//	setmodel(self, "progs/salamanderdeath.md3");

	//setsize(self, '-32 -32 0', '32 32 88');

	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_CORPSE;
	self.nextthink = time + 0.035;

	self.angles = tmpangle;
	//self.skin = tempskin;
};

void() salamander_die1 = [ 488, salamander_die2 ] { self.nextthink = time + 0.03;};
void() salamander_die2 = [ self.frame, salamander_die2 ] 
{ 	
	self.nextthink = time + 0.03;

	if (self.frame > 516)
		ai_move (-1);
	self.frame ++;
	if (self.frame == 558)
	{	
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() salamander_gib1 = [ self.frame, salamander_gib2 ] 
{MonsterGib (self.health); self.skin = 1; self.alpha = 1; self.nextthink = time + 0.02;};

void() salamander_gib2 = [ self.frame, salamander_gib2 ] 
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
salamander_Missile
================
*/
static void(float off, float off2 = 0) salamander_fire = 
{	
	for (float i = 0; i<2;i++)
		salamander_spew (off, off2);	
}

static void(float off, float off2 = 0) salamander_spew =
{	
	vector dir, org, f, r, u;
	vector target;

	AngleVectors(self.angles, f, r, u);
	org = self.origin + '0 0 30' + r * off + u * off2 + f * 24;
	
	target = self.enemy.origin;
	dir = target - org;
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

	dir = f;
	dir = dir + pitch * u;
//PGM	
	
	salamander_Missile (org, dir, (crandom() * 100), 200 + (crandom() * 80));
};


static void(vector org, vector dir, float right_adjust, float up_adjust) salamander_Missile =
{
	local	entity missile;
	float grav = cvar("sv_gravity");
	
	//self.effects = self.effects | EF_MUZZLEFLASH;

	missile = spawn ();
	missile.owner = self;
	missile.enemy = self.enemy;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
// set missile speed	

	makevectors (dir);
	missile.velocity = dir * 600;
	
	if (up_adjust)
	{
		float gravityAdjustment = grav / 800;
		missile.velocity += v_up * up_adjust * gravityAdjustment ;
	}

	if (right_adjust)
		missile.velocity += v_right * right_adjust;

	//missile.dmg = damage;

//	vector org = ;

	missile.touch = salamander_MissileTouch;

	setmodel(missile, "progs/muzzleflash.spr");
	setsize(missile, '0 0 0', '0 0 0');
	missile.emiteffectnum = particleeffectnum("TE_ARCHVILEFLAME");

	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, org);

	sound(self, CHAN_WEAPON, "monsters/hellknight/fb_create_02.wav", 1, ATTN_NORM);	
};

static void() salamander_MissileTouch =
{
	if (other == self.owner)
		return; // don't explode on owner

	if (other.classname == "monster_zombie")
		T_Damage(other, self, self.origin, self, 110, 0);

	T_RadiusDamage(self, self.owner, 60, 60, world);
		SpawnFlameWall (self.origin, 4, '-16 -16 0', '16 16 24', 2.6);
	//sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);

rocketimpact  ();

  self.origin = self.origin - 32* normalize(self.velocity);

	BecomeExplosion ();

	//remove(self);
};

//=================================================================

/*QUAKED monster_shalrath (1 0 0) (-32 -32 -24) (32 32 48) Ambush
*/

static void() sal_step =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_BODY, "monsters/bruiser/fs_01.wav", 0.8, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_BODY, "monsters/bruiser/fs_02.wav", 0.8, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_BODY, "monsters/bruiser/fs_03.wav", 0.8, ATTN_NORM);
	else
		    sound(self, CHAN_BODY, "monsters/bruiser/fs_04.wav", .8, ATTN_NORM);
	
	GroundShake (self, 0.3, 0.2);
};

static void() sal_die =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/bruiser/death_01.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/bruiser/death_02.wav", 1, ATTN_NORM);
	else 
		    sound(self, CHAN_VOICE, "monsters/bruiser/death_03.wav", 1, ATTN_NORM);
};

static void() sal_sight =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/baronofhell/sight1_1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/baronofhell/sight2_1.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/baronofhell/sight3_1.wav", 1, ATTN_NORM);
};

static void() sal_pain =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/baronofhell/ba_pain_01.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/baronofhell/ba_pain_02.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/baronofhell/ba_pain_03.wav", 1, ATTN_NORM);
};

static void() sal_attack =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/baronofhell/ncc_01.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/baronofhell/ncc_02.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/baronofhell/ncc_01.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/baronofhell/ncc_02.wav", 1, ATTN_NORM);
};

static void() sal_idle =
{
	local float r = (random());	

	if (r < 0.5)
		    sound(self, CHAN_VOICE, "monsters/baronofhell/ba_chatter_01.wav", 1, ATTN_IDLE);
	else 
		    sound(self, CHAN_VOICE, "monsters/baronofhell/ba_chatter_02.wav", 1, ATTN_IDLE);
};

void() monster_salamander_cache =
{
	precache_model2 ("progs/salamander.md3");
	precache_model2 ("progs/salamanderdeath.md3");

	precache_model2 ("progs/v_spike.mdl");

	precache_sound2 ("monsters/baronofhell/ba_chatter_01.wav");
	precache_sound2 ("monsters/baronofhell/ba_chatter_02.wav");
	
	precache_sound2 ("monsters/baronofhell/sight1_1.wav");
	precache_sound2 ("monsters/baronofhell/sight2_1.wav");
	precache_sound2 ("monsters/baronofhell/sight3_1.wav");

	precache_sound2 ("monsters/baronofhell/ba_pain_01.wav");
	precache_sound2 ("monsters/baronofhell/ba_pain_02.wav");
	precache_sound2 ("monsters/baronofhell/ba_pain_03.wav");

	precache_sound2 ("monsters/bruiser/death_01.wav");
	precache_sound2 ("monsters/bruiser/death_02.wav");
	precache_sound2 ("monsters/bruiser/death_03.wav");

	precache_sound2 ("monsters/baronofhell/ncc_01.wav");
	precache_sound2 ("monsters/baronofhell/ncc_02.wav");
	precache_sound2 ("monsters/baronofhell/ncc_03.wav");

	precache_sound2 ("monsters/bruiser/fs_01.wav");
	precache_sound2 ("monsters/bruiser/fs_02.wav");
	precache_sound2 ("monsters/bruiser/fs_03.wav");
	precache_sound2 ("monsters/bruiser/fs_04.wav");

	precache_sound ("monsters/archvile/fire_01.wav");
	precache_sound ("monsters/archvile/fire_02.wav");
	precache_sound ("monsters/archvile/fire_03.wav");
	precache_sound ("monsters/archvile/fire_04.wav");
	precache_sound ("monsters/archvile/fire_05.wav");
};

void() monster_salamander =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	monster_salamander_cache ();

	spawn_salamander();
};

void() spawn_salamander =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/salamander.md3");
	setsize(self, '-32 -32 0', '32 32 88');
	self.health = 825;
	self.max_health = 825;
	self.scale = 0.756;
	self.mass = 600;

	self.th_stand = salamander_stand1;
	self.th_walk = salamander_walk1;
	self.th_run = salamander_run1;
	self.th_die = salamander_die;
	self.th_pain = salamander_pain;
	self.th_melee = salamander_melee;
//	self.th_dodge = salamander_dodge;

	self.th_missile = salamander_range;
	self.th_sight = sal_sight;
	self.deathtype = "was barbecued by an Ignirath";

	self.think = walkmonster_start;
	self.nextthink = time + 0.1 + random()*0.1;
};
