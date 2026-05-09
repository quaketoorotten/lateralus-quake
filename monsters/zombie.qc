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

ZOMBIE

==============================================================================
*/

//=============================================================================

.float inpain;

void() zombie_stand1 = [ 0, zombie_stand2 ] { ai_stand();};
void() zombie_stand2 = [ self.frame, zombie_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 45) 
	{	
		if (random() < 0.2)
			boney_chatter();
		zombie_stand1 ();
		return;
	}
	ai_stand ();
};

void() zombie_cruc1 = [ 0, zombie_cruc2 ]
{
	self.nextthink = time + 0.035; 
};
void() zombie_cruc2 = [ self.frame, zombie_cruc2 ] 
{
	if (self.frame >= 79)
	{
		zombie_cruc1();
		return;
	}
	self.frame++; 
	self.nextthink = time + 0.035; 
};

void() zombie_walk1 = [ 82, zombie_walk2 ] { ai_walk(1);};
void() zombie_walk2 = [ self.frame, zombie_walk2 ] 
{ 
	self.frame ++;
	if (self.frame >= 176) 
	{	
		if (random() < 0.2)
			boney_chatter();

		zombie_walk1 ();
		return;
	}
	ai_walk (1);
};

void() zombie_run1 = [ 82, zombie_run2 ] { ai_run(1);};
void() zombie_run2 = [ self.frame, zombie_run2 ] 
{ 
	self.frame ++;
	if (self.frame >= 176) 
	{
		if (random() < 0.2)
			boney_chatter();

		zombie_run1 ();
		return;
	}
	ai_run (1);
};
/*
=============================================================================

ATTACKS

=============================================================================
*/

void() zombiedamagertouch =
{	
	if (!other.takedamage)
		return;
	if (other.classname != "player")
		return;
	if (other.dmgtime > time)
		return;

	T_Damage (other, self, self.origin, self, self.dmg, 0);
	other.dmgtime = time + 0.3;
};

void(vector org) spawn_damagerzombie =
{
	local entity e;
	
	e = spawn();
	setorigin(e, org);
	//e.origin[2] += 4;

	setmodel (e, "progs/muzzleflash.spr");
	setsize (e, '-16 -16 -16', ' 16 16 16');
	e.solid = SOLID_TRIGGER;
	e.movetype = MOVETYPE_STEP;
	e.emiteffectnum = (particleeffectnum("TE_ZOMBIEFLESHSPLAT2"));
	e.touch = zombiedamagertouch ;
	e.deathtype = "acid";
	//e.enemy = enemy1;
	//e.owner = owner1;
	e.nextthink = time + 4;
	e.think = SUB_Remove;
	e.dmg = 8;
};

void() zombie_GrenadeTouch =
{
	if (other == self.owner)
		return; // don't explode on owner
	if (other.takedamage)
	{
		T_Damage(other, self, self.origin, self.owner, 3, 0 );
		sound(self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
		remove(self);
		return;
	}
	if (random() <= 0.5)
		sound(self, CHAN_WEAPON, "monsters/boney/acid_burn.wav", 0.7, ATTN_NORM); // bounce sound
	else	
		sound(self, CHAN_WEAPON, "monsters/boney/acid_burn2.wav", 0.7, ATTN_NORM); // bounce sound

	self.velocity = '0 0 0';
	self.avelocity = '0 0 0';
	pointparticles (particleeffectnum("TE_ZOMBIEFLESHSPLAT"), self.origin - 16* normalize(self.velocity), '0 0 0', 2);

	if (pointcontents (self.origin) == CONTENT_WATER || pointcontents (self.origin) == CONTENT_SLIME || pointcontents (self.origin) == CONTENT_LAVA)
	{
		remove(self);
		return;
	}
	if (random() >= 0.4)
		spawn_damagerzombie (self.origin);
	
	remove(self);
};

/*
================
zombie_FireGrenade
================
*/

void () zombie_grenadeeffect =
{
	self.traileffectnum = particleeffectnum("EF_ZOMBIEFLESHSPRAY");
	self.nextthink = time + 6;
	self.think = SUB_Remove;
}

void(vector org, vector dir, float right_adjust, float up_adjust, float speed)  zombie_flesh =
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
	missile.velocity = dir * speed;

	if (up_adjust)
	{
		float gravityAdjustment = grav / 800;
		missile.velocity += v_up * up_adjust * gravityAdjustment ;
	}

	if (right_adjust)
		missile.velocity += v_right * right_adjust;

	//missile.dmg = damage;

	missile.avelocity = '300 300 300';

	missile.touch = zombie_GrenadeTouch;

// set missile duration
	missile.nextthink = time + 0.4;
	missile.think = zombie_grenadeeffect;

	setmodel(missile, "progs/muzzleflash.spr");
	setsize(missile, '0 0 0', '0 0 0');
	missile.traileffectnum = particleeffectnum("EF_ZOMBIEFLESHSPRAY2");

	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, org);
};

void() zombie_FireGrenade2 =
{
	entity en = self.enemy;
	vector org, dir, target;
	vector fwd, r, u;

	sound(self, CHAN_WEAPON, "zombie/z_shot1.wav", 1, ATTN_NORM);

// calc org
	AngleVectors(self.angles, fwd, r, u);
	org = self.origin + '0 0 40' + fwd * 16;

	target = en.origin;
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

	dir = fwd;
	dir = dir + pitch * u;
//PGM	

	zombie_flesh (org, dir,(crandom() * 50), 200 + (crandom() * 50), 600);
};



void() zom_missile =
{
	//zombie_FireGrenade2 ();
	//zombie_FireGrenade2 ();
	zombie_FireGrenade2 ();		
	// MarksmanFireGrenade(20);
}

void() zom_Melee =
{
	float ldmg;
	vector delta;

	ai_face();

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 60)
	{
		boney_miss();
		return;
	}
		
	if (!CanDamage(self.enemy, self))
		return;

//	sound(self, CHAN_WEAPON, "demon/dhit2.wav", 1, ATTN_NORM);
	ldmg = 14 + 5*random();
	T_Damage(self.enemy, self, self.origin + v_forward*16, self, ldmg, 15);
	boney_hit();
	makevectors(self.angles);
};



void() zombie_atka1 = [ 198, zombie_atka2 ] {boney_attack(); ai_face (); self.nextthink = time + 0.03;};
void() zombie_atka2 = [ self.frame, zombie_atka2 ] 
{	
	self.frame ++;
		
	if(self.frame < 237)
		ai_face ();

	if (self.frame > 228 && self.frame < 237)
		zom_missile ();
	
	if (self.frame >= 251)
	{	
		zombie_run1 ();
		return;
	}
	
	self.nextthink = time + 0.03; 
};


void() zombie_melee =
{	
	
	if (vlen(self.origin - self.enemy.origin) > 60)
	{
		ai_charge(2);
		return;
	}
	boney_attack();
	zombie_atkb1 ();
};

void() zombie_atkb1 = [ 46, zombie_atkb2 ] {self.nextthink = time + 0.03;};
void() zombie_atkb2 = [ self.frame, zombie_atkb2 ] 
{	
	self.frame ++;

	if (self.frame == 55)
		zom_Melee ();
	
	if (self.frame >= 84)
	{	
		zombie_run1 ();
		return;
	}

	self.nextthink = time + 0.03; 
};


/*
=============================================================================

PAIN

=============================================================================
*/


void() zombie_paina1 = [ 177, zombie_paina2 ] { self.nextthink = time + 0.035; };
void() zombie_paina2 = [ self.frame, zombie_paina2 ] 
{	
	self.frame ++;
	
	if (self.frame >= 197)
	{	
		zombie_run1 ();
		return;
	}

	self.nextthink = time + 0.035; 
};

void() zombie_die =
{	
	if (self.health < -100)
	{	
		self.deadflag = DEAD_DEAD;
		self.solid = SOLID_NOT;
		self.think = zombie_gib1;
		self.nextthink = time + 0.035;
		return;
	}
	
	if((self.deadflag & DEAD_DEAD))
		return;

	local vector tmpangle;
	local float tempskin;
	tmpangle = self.angles;
	tempskin = self.skin;

	//knight_death ();
	boney_die();
	if (random () <= 0.5)
	{
		self.think = zombie_die1;
		setmodel(self, "progs/zombiedie1.md3");
	}
	else
	{
		self.think = zombie_dieb1;
		setmodel(self, "progs/zombiedie2.md3");
	}
	setsize(self, '-16 -16 0', '16 16 64');

	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_CORPSE;
	
	self.nextthink = time + 0.035;

	self.angles = tmpangle;
	//self.skin = tempskin;
};

void() zombie_die1 = [ 0, zombie_die2 ] { self.nextthink = time + 0.035;};
void() zombie_die2 = [ self.frame, zombie_die2 ] 
{ 	
	self.nextthink = time + 0.035;

	self.frame ++;
	if (self.frame < 8)
		ai_move (-4);
	
	if (self.frame == 21)
	{	
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() zombie_dieb1 = [ 0, zombie_dieb2 ] { self.nextthink = time + 0.035;};
void() zombie_dieb2 = [ self.frame, zombie_dieb2 ] 
{ 	
	self.nextthink = time + 0.035;

	self.frame ++;
	if (self.frame < 8)
		ai_move (-4);
	
	if (self.frame == 21)
	{	
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() zombie_gib1 = [ self.frame, zombie_gib2 ] 
{MonsterGib (self.health); self.skin = 1; self.alpha = 1; self.nextthink = time + 0.02;};

void() zombie_gib2 = [ self.frame, zombie_gib2 ] 
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
=================
zombie_pain

fart
=================
*/
void(entity attacker, float take) zombie_pain =
{
	if (take < 9)
		return; // totally ignore

	//bprint(ftos(self.health));


	if (self.inpain)
	{
// if hit again in next gre seconds while not in pain frames, definately drop
		self.pain_finished = time + 1;
		return; // currently going through an animation, don't change
	}

// gp into one of the fast pain animations
	self.inpain = 1;
	boney_pain();
	zombie_paina1();
};

//============================================================================

static void() boney_sight =
{
	local float r = random();	

	if (r >= 0.5)
		    sound(self, CHAN_VOICE, "monsters/boney/sight_01.wav", 1, ATTN_NORM);
	else 
		    sound(self, CHAN_VOICE, "monsters/boney/sight_02.wav", 1, ATTN_NORM);
};

static void() boney_die =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/boney/death_01.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/boney/death_02.wav", 1, ATTN_NORM);
	else 
		    sound(self, CHAN_VOICE, "monsters/boney/death_03.wav", 1, ATTN_NORM);
};

static void() boney_idle =
{
	if (random() <= 0.5)
		    sound(self, CHAN_VOICE, "monsters/boney/chatter_01.wav", 0.8, ATTN_IDLE);
	else
		    sound(self, CHAN_VOICE, "monsters/boney/chatter_02.wav", 0.8, ATTN_IDLE);
};

static void() boney_pain =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/boney/pain_01.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/boney/pain_02.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/boney/pain_03.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/boney/pain_04.wav", 1, ATTN_NORM);
};

static void() boney_chatter =
{
	local float r = random();	

	if (r >= 0.5)
		    sound(self, CHAN_VOICE, "monsters/boney/chatter_01.wav", 1, ATTN_IDLE);
	else
		    sound(self, CHAN_VOICE, "monsters/boney/chatter_02.wav", 1, ATTN_IDLE);
};

static void() boney_attack =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_BODY, "monsters/boney/attack_01.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_BODY, "monsters/boney/attack_02.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_BODY, "monsters/boney/attack_03.wav", 1, ATTN_NORM);
};

static void() boney_miss =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/imp/melee/miss_01.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/imp/melee/miss_02.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/imp/melee/miss_03.wav", 1, ATTN_NORM);
};

static void() boney_hit =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/imp/melee/hit_03.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/imp/melee/hit_01.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/imp/melee/hit_04.wav", 1, ATTN_NORM);
};


/*QUAKED monster_zombie (1 0 0) (-16 -16 -24) (16 16 32) Crucified ambush

If crucified, stick the bounding box 12 pixels back into a wall to look right.
*/
void() monster_zombie =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model("progs/zombie.md3");
	precache_model("progs/zombiedie1.md3");
	precache_model("progs/zombiedie2.md3");

	precache_model("progs/helldoll.md3");

	precache_sound("zombie/z_shot1.wav");
	precache_sound("zombie/z_miss.wav");
	precache_sound("zombie/z_hit.wav");

	precache_sound("monsters/boney/attack_01.wav");
	precache_sound("monsters/boney/attack_02.wav");
	precache_sound("monsters/boney/attack_03.wav");

	precache_sound("monsters/boney/death_01.wav");
	precache_sound("monsters/boney/death_02.wav");
	precache_sound("monsters/boney/death_03.wav");

	precache_sound("monsters/boney/sight_01.wav");
	precache_sound("monsters/boney/sight_02.wav");

	precache_sound("monsters/boney/pain_01.wav");
	precache_sound("monsters/boney/pain_02.wav");
	precache_sound("monsters/boney/pain_03.wav");
	precache_sound("monsters/boney/pain_04.wav");

	precache_sound("monsters/boney/chatter_01.wav");
	precache_sound("monsters/boney/chatter_02.wav");

	precache_sound("monsters/imp/melee/hit_01.wav");
	precache_sound("monsters/imp/melee/hit_03.wav");
	precache_sound("monsters/imp/melee/hit_04.wav");

	precache_sound("monsters/imp/melee/miss_01.wav");
	precache_sound("monsters/imp/melee/miss_02.wav");
	precache_sound("monsters/imp/melee/miss_03.wav");

	precache_sound("monsters/boney/acid_burn2.wav");
	precache_sound("monsters/boney/acid_burn.wav");

	particleeffectnum("EF_ZOMBIEFLESHSPRAY");
	particleeffectnum("EF_ZOMBIEFLESHSPRAY2");
	particleeffectnum("TE_ZOMBIEFLESHSPLAT");
	particleeffectnum("TE_ZOMBIEFLESHSPLAT2");

	
	if (self.spawnflags & SPAWN_CRUCIFIED)
	{
		self.movetype = MOVETYPE_NONE;
		zombie_cruc ();
	}
	else
		spawn_zombie ();
};

float	SPAWN_CRUCIFIED	= 1;

void() spawn_zombie =
{
		self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/zombie.md3");

	setsize(self, '-16 -16 0', '16 16 64');
	self.health = 100;
	self.max_health = 100;
	self.mass = 100;
	self.scale = 0.72;

	self.th_stand = zombie_stand1;
	self.th_walk = zombie_walk1;
	self.th_run = zombie_run1;
	self.th_pain = zombie_pain;
	self.th_die = zombie_die;
	self.th_missile = zombie_atka1;
	self.th_melee = zombie_melee;
	self.th_sight = boney_sight;
	self.th_spawn = spawn_zombie;
	self.deathtype = "joins the zombies";
	
		walkmonster_start();
};

void() zombie_cruc =
{
	self.solid = SOLID_SLIDEBOX;

	setmodel(self, "progs/helldoll.md3");

	setsize(self, '-16 -16 -24', '16 16 32');
	self.health = 60;
	self.max_health = 60;
	self.mass = 300;
	self.scale = 0.6;

	zombie_cruc1 ();
};

