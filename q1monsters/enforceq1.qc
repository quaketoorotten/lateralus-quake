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

void() lasergrunt_fire =
{
	vector dir, org, off = '0 7 48';
	entity en;

	AutofireMachineEnemyNoise ();

// fire somewhat behind the player, so a dodging player is harder to hit
	en = self.enemy;
	
	makevectors(self.angles);
	org = ProjectAim(self.origin, off, v_forward, v_right);

	dir = en.origin - en.velocity*0.2;
	dir = normalize(dir - self.origin - '0 0 16');

	monster_FireBullets (1, org, dir, '0.05 0.05 0', 4, 4);

	if (range(self.enemy) < RANGE_CLOSE)
		self.speed = time + 0.02;
	else if (range(self.enemy) < RANGE_NEAR)
		self.speed = time + 0.04;
	else
		self.speed = time + 0.06;
};

static void() EnfAttackFinished =
{
	if (enemy_range >= RANGE_MID || !enemy_vis)
	{
		self.attack_state = AS_STRAIGHT;
		self.think = self.th_run;
	}
	else
	{
		lasergrunt_strafe ();
	}
};

//============================================================================

void() lasergrunt_stand1 = [ 64, lasergrunt_stand2 ] { self.maxs_z = 64; ai_stand();};
void() lasergrunt_stand2 = [ self.frame, lasergrunt_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 140) 
	{	
		if (random() < 0.2)
			zsec_idle ();
		lasergrunt_stand1 ();
		return;
	}
	ai_stand ();
};

void() lasergrunt_walk1 = [ 165, lasergrunt_walk2 ] { self.maxs_z = 64; ai_walk(2);};
void() lasergrunt_walk2 = [ self.frame, lasergrunt_walk2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 192) 
	{	
		if (random() < 0.2)
			zsec_idle ();
		lasergrunt_walk1 ();
		return;
	}
	ai_walk (2);
};

void() lasergrunt_run1 = [ 193, lasergrunt_run2 ] { self.maxs_z = 64; ai_run(4);};
void() lasergrunt_run2 = [ self.frame, lasergrunt_run2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 213) 
	{	
		if (random() < 0.2)
			zsec_idle ();
		lasergrunt_run1 ();
		return;
	}
	ai_run (4);
};

void() lasergrunt_atk1 = [ 0, lasergrunt_atk2 ] {zsec_combat_0 (); self.speed = time + 0.04; self.maxs_z = 64; ai_face(); self.nextthink = time + 0.03;};
void() lasergrunt_atk2 = [ self.frame, lasergrunt_atk2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;

	if (self.frame < 49 && self.frame > 15 && self.speed < time)
		lasergrunt_fire ();

	if (self.frame == 14 || self.frame == 18 || self.frame == 21 
	|| self.frame == 24 || self.frame == 28 || self.frame == 31 || 
	self.frame == 34 || self.frame == 38 || self.frame == 41 || self.frame == 44)
		self.skin = 1;
	else
		self.skin = 0;

	if (self.frame == 43 && random() <= 0.6 && skill > 0 && self.enemy.health > 0)
		self.frame = 14;

	if (self.frame >= 63) 
	{	
		lasergrunt_run1 ();	
		EnfAttackFinished ();	
		return;
	}

	if (self.frame < 50)
		ai_face ();
};


void() lasergrunt_paina1 = [ 254, lasergrunt_paina2 ] {self.nextthink = time + 0.04;};
void() lasergrunt_paina2 = [ self.frame, lasergrunt_paina2 ] 
{ 	
	self.frame ++;
	self.nextthink = time + 0.04;
	if (self.frame >= 273) 
	{	
		lasergrunt_run1 ();
		return;
	}
};

void() lasergrunt_duck1 = [ 141, lasergrunt_duck2 ] {ai_face(); self.maxs_z = 32; self.nextthink = time + 0.03;};
void() lasergrunt_duck2 = [ self.frame, lasergrunt_duck2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;
	
	if (self.frame >= 164) 
	{	
		self.maxs_z = 64;
		self.flags &= ~FL_DODGED;
		lasergrunt_run1 ();		
		return;
	}

	ai_face ();
};

void(entity attacker, float damage) lasergrunt_pain =
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
		lasergrunt_paina1();
	}
};

//============================================================================

void() lasergrunt_strafe =
{		
	ChangeYaw ();

	zsec_combat_0 ();

	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);

	if(self.lefty)
		lasergrunt_strafel1 ();
	else 
		lasergrunt_strafer1 ();
	
	self.nextthink = time + frametime;
};

void() lasergrunt_strafel1 = [ 234, lasergrunt_strafel2 ] {self.nextthink = time + 0.03;};
void() lasergrunt_strafel2 = [ self.frame, lasergrunt_strafel2 ] 
{ 
	self.frame ++;
	if (self.frame >= 253) 
	{	
		lasergrunt_run1 ();
		return;
	}

	if (self.frame < 249 && self.frame > 236)
		ai_run_slide (4, 0.03);
	else if (self.frame < 236 && self.frame > 234)
		ai_run_slide (2, 0.03);
	else
		self.nextthink = time + 0.03;
};

void() lasergrunt_strafer1 = [ 214, lasergrunt_strafer2 ] { self.nextthink = time + 0.03;};
void() lasergrunt_strafer2 = [ self.frame, lasergrunt_strafer2 ] 
{ 
	self.frame ++;
	if (self.frame >= 233) 
	{	
		lasergrunt_run1 ();
		return;
	}

	if (self.frame < 379 && self.frame > 217)
		ai_run_slide (4, 0.03);
	else if (self.frame < 217 && self.frame > 214)
		ai_run_slide (2, 0.03);
	else
		self.nextthink = time + 0.03;
};


void() lasergrunt_die =
{	
	if((self.deadflag & DEAD_DEAD))
		return;
	
	zsec_die ();

	self.skin = 2;

	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_NOT;
	self.think = grunt_die1;
	self.nextthink = time + 0.04;

	self.ammo_nails = 5;
	DropBackpack();

	MonsterGib (self.health);
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
	precache_model2 ("progs/enforcer.mdl");
	precache_model2 ("progs/h_mega.mdl");
	precache_model2 ("progs/laser.mdl");

 	zsec_precache_sfx ();

	spawn_lasergrunt ();
};

void() spawn_lasergrunt =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/enforcer.mdl");

	setsize(self, '-16 -16 0', '16 16 64');
	self.health = 90;
	self.max_health = 90;
	self.scale = 0.76;
	self.mass = 200;
	self.th_sight = zsec_sight;

	self.th_stand = lasergrunt_stand1;
	self.th_walk = lasergrunt_walk1;
	self.th_run = lasergrunt_run1;
	self.th_pain = lasergrunt_pain;
	self.th_die = lasergrunt_die;
	self.th_missile = lasergrunt_atk1;	
	self.th_melee = lasergrunt_atk1;
	self.th_dodge = lasergrunt_duck1;
	self.th_spawn = spawn_lasergrunt;

	walkmonster_start();
};