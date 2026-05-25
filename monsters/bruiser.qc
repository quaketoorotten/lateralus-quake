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

void() terminal_stand1 = [ 0, terminal_stand2 ] { ai_stand();};
void() terminal_stand2 = [ self.frame, terminal_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 36) 
	{	
		if (random() < 0.2)
			brui_idle ();
		terminal_stand1 ();
		return;
	}
	ai_stand ();
};

void() terminal_walk1 = [ 37, terminal_walk2 ] { ai_walk(3);};
void() terminal_walk2 = [ self.frame, terminal_walk2 ] 
{ 	
	self.frame ++;

	if (self.frame == 49 || self.frame == 65)
		brui_step ();
	if (self.frame >= 69) 
	{	
		if (random() < 0.2)
			brui_idle ();
		terminal_walk1 ();
		return;
	}
	ai_walk (3);
};

void() terminal_run1 = [ 37, terminal_run2 ] { ai_run(3.2);};
void() terminal_run2 = [ self.frame, terminal_run2 ] 
{ 	
	self.frame ++;
	
	if (self.frame == 49 || self.frame == 65)
		brui_step ();
	if (self.frame >= 69) 
	{	
		if (random() < 0.2)
			brui_idle ();
		terminal_run1 ();
		return;
	}
	ai_run (3.2);
};

void() terminal_atka1 = [ 136, terminal_atka2 ] {ai_charge(3); self.nextthink = time + 0.035; };
void() terminal_atka2 = [ self.frame, terminal_atka2 ] 
{ 	
	self.frame ++;	

	if (self.frame == 137)
		terminal_fire (-30, 32);

	if (self.frame == 154)
		terminal_fire (30, 32);
	
	if (self.frame >= 168) 	
	{	
		if (random() > 0.6)
			SUB_CheckRefire (terminal_atkb1);
		else
			terminal_run1 ();	

		return;
	}
	if (self.frame < 160)
		ai_charge(3);
	else
		ai_move(3);
	self.nextthink = time + 0.035;
};

void() terminal_atkb1 = [ 169, terminal_atkb2 ] {ai_charge(3); self.nextthink = time + 0.035; };
void() terminal_atkb2 = [ self.frame, terminal_atkb2 ] 
{ 	
	self.frame ++;	
	
	if (self.frame == 170 || self.frame == 182)
		terminal_fire (-10, 32);

	if (self.frame == 186 || self.frame == 175)
		terminal_fire (10, 32);
	
	if (self.frame >= 201) 	
	{
		terminal_run1 ();
		return;
	}
	if (self.frame < 189)
		ai_charge(3);
	else
		ai_move(3);
	self.nextthink = time + 0.035;
};

void() terminal_range =
{	
	brui_attack ();

	if (random() < 0.4)
		terminal_atka1 ();
	else
		terminal_atkb1 ();
}

void() terminal_melee =
{	
	brui_melee ();

	if (random() <= 0.5)
		terminal_meleea1 ();
	else
		terminal_meleeb1 ();
}

void() terminalMelee =
{
	vector delta;
	float ldmg;

	if (!self.enemy)
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 120)
		return;

	ldmg = 50 + (random() + random() + random()) * 15;
	T_Damage(self.enemy, self, self.origin + v_forward*16, self, ldmg, 40);
};

void() terminal_meleea1 = [ 70, terminal_meleea2 ] {ai_face(); self.nextthink = time + 0.035; };
void() terminal_meleea2 = [ self.frame, terminal_meleea2 ] 
{ 	
	self.frame ++;	

	if (self.frame == 84)
		terminalMelee ();
	
	if (self.frame >= 102) 
	{	
		terminal_run1 ();
		return;
	}

	if (self.frame < 81)
		ai_charge(3);
	else if (self.frame < 85)
		ai_charge(4);
	else
		ai_move(3);

	self.nextthink = time + 0.035;
};

void() terminal_meleeb1 = [ 103, terminal_meleeb2 ] {ai_face(); self.nextthink = time + 0.035; };
void() terminal_meleeb2 = [ self.frame, terminal_meleeb2 ] 
{ 	
	self.frame ++;	

	if (self.frame == 119)
		terminalMelee ();
	
	if (self.frame >= 135) 
	{	
		terminal_run1 ();
		return;
	}

	if (self.frame < 115)
		ai_charge(3);
	else if (self.frame < 119)
		ai_charge(1);
	else
		ai_move(3);

	self.nextthink = time + 0.035;
};


void() terminal_strafel1 = [ 202, terminal_strafel2 ] 
{ 
	ai_slide(0, 0.03);
};
void() terminal_strafel2 = [ self.frame, terminal_strafel2 ] 
{ 
	self.frame ++;
	if (self.frame >= 220) 
	{	
		//self.attack_state = AS_STRAIGHT;
		self.flags &= ~FL_DODGED;
		terminal_run1 ();
		return;
	}

	if (self.frame > 203 && self.frame < 219)
		ai_slide (8, 0.02);
	else
		self.nextthink = time + 0.03;
};

void() terminal_strafer1 = [ 221, terminal_strafer2 ] 
{ 
	ai_slide(0, 0.03);
};
void() terminal_strafer2 = [ self.frame, terminal_strafer2 ] 
{ 
	self.frame ++;
	if (self.frame >= 240) 
	{	
		//self.attack_state = AS_STRAIGHT;
		self.flags &= ~FL_DODGED;
		terminal_run1 ();
		return;
	}

	if (self.frame > 223 && self.frame < 237)
		ai_slide (8, 0.03);
	else
		self.nextthink = time + 0.03;
};

void() terminal_dodge =
{	
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	
	ChangeYaw ();

	if(self.lefty)
		terminal_strafel1 ();
	else
		terminal_strafer1 ();
	
	self.nextthink = time + frametime;
}

void() terminal_pain1 = [ 241, terminal_pain2 ] {ai_charge (3); self.nextthink = time + 0.035; };
void() terminal_pain2 = [ self.frame, terminal_pain2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 272) 
	{	
		terminal_run1 ();
		return;
	}
	
	ai_charge (3);
	self.nextthink = time + 0.035;
};


void(entity attacker, float damage) terminal_pain =
{	
	if (self.flags & FL_DODGED)
		return;

	if (self.pain_finished > time)
		return;

	if (random()*100 > damage)
		return; // didn't flinch

	brui_pain();
	terminal_pain1();
	self.pain_finished = time + 3;
};

void() terminal_die =
{	
	if (self.health < -400)
	{	
		self.deadflag = DEAD_DEAD;
		self.solid = SOLID_NOT;
		self.think = terminal_gib1;
		self.nextthink = time + 0.035;
		return;
	}
	
	if((self.deadflag & DEAD_DEAD))
		return;

	local vector tmpangle;
	local float tempskin;
	tmpangle = self.angles;
	tempskin = self.skin;

	brui_die ();
	
		self.think = terminal_die1;
		setmodel(self, "progs/terminaldeath.md3");

	setsize(self, '-32 -32 0', '32 32 88');

	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_CORPSE;
	self.nextthink = time + 0.035;

	self.angles = tmpangle;
	//self.skin = tempskin;
};

void() terminal_die1 = [ 0, terminal_die2 ] { self.nextthink = time + 0.035;};
void() terminal_die2 = [ self.frame, terminal_die2 ] 
{ 	
	self.nextthink = time + 0.035;

	if (self.frame < 9)
		ai_move (-4);
	self.frame ++;
	if (self.frame == 22)
	{	
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() terminal_gib1 = [ self.frame, terminal_gib2 ] 
{MonsterGib (self.health); self.skin = 1; self.alpha = 1; self.nextthink = time + 0.02;};

void() terminal_gib2 = [ self.frame, terminal_gib2 ] 
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
terminal_Missile
================
*/
static void(float off, float off2 = 0) terminal_fire =
{
	terminal_Missile (off, off2, 0);
};


static void(float off, float off2, float off3) terminal_Missile =
{
	entity missile;
	vector dir, org;

	self.effects = self.effects | EF_MUZZLEFLASH;

	missile = spawn();
	missile.owner = self;

	missile.solid = SOLID_BBOX;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.classname = "grenade";
	setmodel(missile, "progs/muzzleflash.spr");
	missile.shake_interval = 0.4;
	missile.shake_time = 0.7;

	setsize(missile, '0 0 0', '0 0 0');
	
	makevectors(self.angles);

	org = self.origin + '0 0 30' + v_right * off + v_up * off2 + v_forward * off3;
	dir = normalize((self.enemy.origin + '0 0 10') - org + v_right*crandom()*6);

	setorigin(missile, org);

	missile.emiteffectnum = particleeffectnum ("TE_MANC_FIREBALL");
	missile.traileffectnum = particleeffectnum ("EF_MANC_FIRETRAIL");
	
	missile.velocity = dir * 800;
	missile.dmg = 60;
	missile.avelocity = '300 300 300';
	missile.nextthink = time + 6;
	missile.think = SUB_Remove;
	missile.aiflags |= IS_PROJECTILE;
	missile.touch = terminal_MissileTouch;
};

static void() terminal_MissileTouch =
{
	if (other == self.owner)
		return; // don't explode on owner

	if (other.classname == "monster_zombie")
		T_Damage(other, self, self.origin, self, 110, 0);

	T_RadiusDamage(self, self.owner, self.dmg, 40, world);
//	sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);

rocketimpact  ();

  self.origin = self.origin - 32* normalize(self.velocity);

	BecomeExplosion ();
};

//=================================================================

/*QUAKED monster_shalrath (1 0 0) (-32 -32 -24) (32 32 48) Ambush
*/

static void() brui_step =
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

static void() brui_die =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/bruiser/death_01.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/bruiser/death_02.wav", 1, ATTN_NORM);
	else 
		    sound(self, CHAN_VOICE, "monsters/bruiser/death_03.wav", 1, ATTN_NORM);
};

static void() brui_sight =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/bruiser/sight_01.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/bruiser/sight_02.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/bruiser/sight_03.wav", 1, ATTN_NORM);
};

static void() brui_pain =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/bruiser/pain_01.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/bruiser/pain_02.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/bruiser/pain_03.wav", 1, ATTN_NORM);
};

static void() brui_attack =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/bruiser/combat_chatter_01.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/bruiser/combat_chatter_02.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/bruiser/combat_chatter_01.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/bruiser/combat_chatter_02.wav", 1, ATTN_NORM);
};

static void() brui_melee =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/bruiser/melee_01.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/bruiser/melee_02.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/bruiser/melee_01.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/bruiser/melee_02.wav", 1, ATTN_NORM);
};


static void() brui_idle =
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

void() monster_terminal_cache =
{
	precache_model2 ("progs/terminal.md3");
	precache_model2 ("progs/terminaldeath.md3");

	precache_model2 ("progs/v_spike.mdl");

	precache_sound2 ("monsters/bruiser/melee_01.wav");
	precache_sound2 ("monsters/bruiser/melee_02.wav");
	
	precache_sound2 ("monsters/bruiser/sight_01.wav");
	precache_sound2 ("monsters/bruiser/sight_02.wav");
	precache_sound2 ("monsters/bruiser/sight_03.wav");

	precache_sound2 ("monsters/bruiser/pain_01.wav");
	precache_sound2 ("monsters/bruiser/pain_02.wav");
	precache_sound2 ("monsters/bruiser/pain_03.wav");

	precache_sound2 ("monsters/bruiser/death_01.wav");
	precache_sound2 ("monsters/bruiser/death_02.wav");
	precache_sound2 ("monsters/bruiser/death_03.wav");

	precache_sound2 ("monsters/bruiser/combat_chatter_01.wav");
	precache_sound2 ("monsters/bruiser/combat_chatter_02.wav");

	precache_sound2 ("monsters/mancubus/chatter1.wav");
	precache_sound2 ("monsters/mancubus/chatter2.wav");

	precache_sound2 ("monsters/bruiser/fs_01.wav");
	precache_sound2 ("monsters/bruiser/fs_02.wav");
	precache_sound2 ("monsters/bruiser/fs_03.wav");
	precache_sound2 ("monsters/bruiser/fs_04.wav");
};

void() monster_terminal =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	monster_terminal_cache ();

	spawn_terminal();
};

void() spawn_terminal =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/terminal.md3");
	setsize(self, '-32 -32 0', '32 32 88');
	self.health = 1100;
	self.max_health = 1100;
	self.scale = 0.88;
	self.mass = 600;

	self.th_stand = terminal_stand1;
	self.th_walk = terminal_walk1;
	self.th_run = terminal_run1;
	self.th_die = terminal_die;
	self.th_pain = terminal_pain;
	self.th_melee = terminal_melee;
	self.th_dodge = terminal_dodge;

	self.th_missile = terminal_range;
	self.th_sight = brui_sight;
	self.deathtype = "was bruised by a Bruiser";

	self.think = walkmonster_start;
	self.nextthink = time + 0.1 + random()*0.1;
};
