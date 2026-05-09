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

void() zsec3_fire =
{
	vector dir, org, off = '0 7 48';
	entity en;

	AutofireMachineEnemyNoise ();

// fire somewhat behind the player, so a dodging player is harder to hit
	en = self.enemy;
	
	makevectors(self.angles);
	org = ProjectAim(self.origin, off, v_forward, v_right) + '0 0 -4.5';

	dir = en.origin - en.velocity*0.15 + '0 0 -24';
	dir = normalize(dir - self.origin);

	monster_FireBullets (1, org, dir, '0.05 0.05 0', 4, 4, 2000);

	if (range(self.enemy) < RANGE_CLOSE)
		self.speed = time + 0.02;
	else if (range(self.enemy) < RANGE_NEAR)
		self.speed = time + 0.04;
	else
		self.speed = time + 0.06;

	local entity muzzle = spawn ();
	muzzle.origin = self.origin;
	setmodel(muzzle, "progs/enforcermf.mdl");
	setsize (muzzle, '-16 -16 0', '16 16 64');
	muzzle.think = SUB_Remove;
	muzzle.frame = self.frame;
	muzzle.nextthink = time + 0.05;
	muzzle.angles = self.angles;
	muzzle.scale = self.scale;

};

//============================================================================

void() zsec3_stand1 = [ 64, zsec3_stand2 ] { self.maxs_z = 64; ai_stand();};
void() zsec3_stand2 = [ self.frame, zsec3_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 140) 
	{	
		if (random() < 0.2)
			zsec_idle ();
		zsec3_stand1 ();
		return;
	}
	ai_stand ();
};

void() zsec3_walk1 = [ 165, zsec3_walk2 ] { self.maxs_z = 64; ai_walk(2);};
void() zsec3_walk2 = [ self.frame, zsec3_walk2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 192) 
	{	
		if (random() < 0.2)
			zsec_idle ();
		zsec3_walk1 ();
		return;
	}
	ai_walk (2);
};

void() zsec3_run1 = [ 193, zsec3_run2 ] { self.maxs_z = 64; ai_run(4);};
void() zsec3_run2 = [ self.frame, zsec3_run2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 213) 
	{	
		if (random() < 0.2)
			zsec_idle ();
		zsec3_run1 ();
		return;
	}
	ai_run (4);
};

void() zsec3_atk1 = [ 0, zsec3_atk2 ] {zsec_combat_0 (); self.speed = time + 0.04; self.maxs_z = 64; ai_face(); self.nextthink = time + 0.03;};
void() zsec3_atk2 = [ self.frame, zsec3_atk2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;

	if (self.frame < 49 && self.frame > 15 && self.speed < time)
		zsec3_fire ();

	if (self.frame == 43 && random() <= 0.6 && skill > 0 && self.enemy.health > 0)
		self.frame = 14;

	if (self.frame >= 63) 
	{	
		zsec3_run1 ();	
		//EnfAttackFinished ();	
		return;
	}

	if (self.frame < 50)
		ai_face ();
};


void() zsec3_paina1 = [ 254, zsec3_paina2 ] {self.nextthink = time + 0.035;};
void() zsec3_paina2 = [ self.frame, zsec3_paina2 ] 
{ 	
	self.frame ++;
	self.nextthink = time + 0.035;
	if (self.frame >= 273) 
	{	
		zsec3_run1 ();
		return;
	}
};

void() zsec3_duck1 = [ 141, zsec3_duck2 ] {ai_face(); self.maxs_z = 32; self.nextthink = time + 0.03;};
void() zsec3_duck2 = [ self.frame, zsec3_duck2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;
	
	if (self.frame >= 164) 
	{	
		self.maxs_z = 64;
		self.flags &= ~FL_DODGED;
		zsec3_run1 ();		
		return;
	}

	ai_face ();
};

void(entity attacker, float damage) zsec3_pain =
{
	float r;

	r = random();
	self.skin = 0;

	if (self.flags & FL_DODGED)
		return;
	
	if (damage < 15)
		return;

	if (self.pain_finished > time)
		return;

	zsec_pain ();

	if (r < 0.6)
	{
		self.pain_finished = time + 1;
		zsec3_paina1();
	}
};

//============================================================================

void() zsec3_dodge =
{		
	if (random () <= 0.5)
	{
		zsec3_duck1 ();
		return;
	}

	zsec_combat_0 ();

	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();

	if(self.lefty)
		zsec3_strafel1 ();
	else 
		zsec3_strafer1 ();
	
	self.nextthink = time + frametime;
};

void() zsec3_strafel1 = [ 234, zsec3_strafel2 ] {self.nextthink = time + 0.03;};
void() zsec3_strafel2 = [ self.frame, zsec3_strafel2 ] 
{ 
	self.frame ++;
	if (self.frame >= 253) 
	{	
		zsec3_run1 ();
		self.flags &= ~FL_DODGED;
		return;
	}

	if (self.frame < 249 && self.frame > 236)
		ai_slide (4, 0.03);
	else if (self.frame < 236 && self.frame > 234)
		ai_slide (2, 0.03);
	else
		self.nextthink = time + 0.03;
};

void() zsec3_strafer1 = [ 214, zsec3_strafer2 ] { self.nextthink = time + 0.03;};
void() zsec3_strafer2 = [ self.frame, zsec3_strafer2 ] 
{ 
	self.frame ++;
	if (self.frame >= 233) 
	{	
		zsec3_run1 ();
		self.flags &= ~FL_DODGED;
		return;
	}

	if (self.frame < 379 && self.frame > 217)
		ai_slide (4, 0.03);
	else if (self.frame < 217 && self.frame > 214)
		ai_slide (2, 0.03);
	else
		self.nextthink = time + 0.03;
};


void() zsec3_die =
{	
	if (self.health < -40)
	{	
		self.deadflag = DEAD_DEAD;
		self.solid = SOLID_NOT;
		self.think = zsec1_gib1;
		self.nextthink = time + 0.035;
		return;
	}
	
	if((self.deadflag & DEAD_DEAD))
		return;

	zsec_die ();

	local vector tmpangle;
	local float tempskin;
	tmpangle = self.angles;
	tempskin = self.skin;
	
	setmodel(self, "progs/enforcerdeath.md3");
	setsize(self, '-16 -16 0', '16 16 64');

	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_CORPSE;
	self.think = zsec1_die1;
	self.nextthink = time + 0.035;

	DropItem (weapon_nailgun);

	self.angles = tmpangle;
	//self.skin = tempskin;
};

void() zsec_sight =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/zombie_secur/radio_alert1.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/zombie_secur/radio_alert2.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/zombie_secur/radio_chatter3.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/zombie_secur/radio_chatter10.wav", 1, ATTN_NORM);
};

void() zsec_idle =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/zombie_secur/idle1.wav", 1, ATTN_IDLE);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/zombie_secur/idle2.wav", 1, ATTN_IDLE);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/zombie_secur/idle3.wav", 1, ATTN_IDLE);
	else
		    sound(self, CHAN_VOICE, "monsters/zombie_secur/idle4.wav", 1, ATTN_IDLE);
};

void() zsec_combat_0 =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/zombie_secur/combat_01.wav", 0.5, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/zombie_secur/combat_02.wav", 0.7, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/zombie_secur/combat_03.wav", 0.4, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/zombie_secur/combat_04.wav", 0.8, ATTN_NORM);
};

void() zsec_die =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/zombie_secur/die1.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/zombie_secur/die2.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/zombie_secur/die3.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/zombie_secur/die4.wav", 1, ATTN_NORM);
};

void() zsec_pain =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/zombie_secur/pain1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/zombie_secur/pain2.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/zombie_secur/pain3.wav", 1, ATTN_NORM);
};

void() zsec_precache_sfx =
{
	precache_sound("monsters/zombie_secur/pain1.wav");
	precache_sound("monsters/zombie_secur/pain2.wav");
	precache_sound("monsters/zombie_secur/pain3.wav");
	
	precache_sound("monsters/zombie_secur/radio_alert1.wav");
	precache_sound("monsters/zombie_secur/radio_alert2.wav");
	precache_sound("monsters/zombie_secur/radio_chatter3.wav");	
	precache_sound("monsters/zombie_secur/radio_chatter10.wav");	

	precache_sound("monsters/zombie_secur/idle1.wav");
	precache_sound("monsters/zombie_secur/idle2.wav");
	precache_sound("monsters/zombie_secur/idle3.wav");	
	precache_sound("monsters/zombie_secur/idle4.wav");

	precache_sound("monsters/zombie_secur/combat_01.wav");
	precache_sound("monsters/zombie_secur/combat_02.wav");
	precache_sound("monsters/zombie_secur/combat_03.wav");	
	precache_sound("monsters/zombie_secur/combat_04.wav");

	precache_sound("monsters/zombie_secur/die1.wav");
	precache_sound("monsters/zombie_secur/die2.wav");
	precache_sound("monsters/zombie_secur/die3.wav");	
	precache_sound("monsters/zombie_secur/die4.wav");
};


/*QUAKED monster_enforcer (1 0 0) (-16 -16 -24) (16 16 40) Ambush

*/
void() monster_enforcer =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2 ("progs/enforcer.md3");
	precache_model2 ("progs/enforcerdeath.md3");

	precache_model2 ("progs/enforcermf.mdl");
	precache_model2 ("progs/h_mega.mdl");
	precache_model2 ("progs/laser.mdl");

 	zsec_precache_sfx ();

	spawn_zsec3 ();
};

void() spawn_zsec3 =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/enforcer.md3");

	setsize(self, '-16 -16 0', '16 16 64');
	self.health = 90;
	self.max_health = 90;
	self.scale = 0.74;
	self.mass = 100;
	self.th_sight = zsec_sight;

	self.th_stand = zsec3_stand1;
	self.th_walk = zsec3_walk1;
	self.th_run = zsec3_run1;
	self.th_pain = zsec3_pain;
	self.th_die = zsec3_die;
	self.th_missile = zsec3_atk1;	
	self.th_melee = zsec3_atk1;
	self.th_dodge = zsec3_dodge;
	self.th_spawn = spawn_zsec3;
	self.th_checkatck = Machineg_SoldierCheckAttack;
	self.deathtype = "died in a gunfight with a Machinegunner";

	walkmonster_start();
};