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

DOG

==============================================================================
*/

/*
================
rotweiler_bite

================
*/
void() rotweiler_bite =
{
	vector delta;
	float ldmg;

	sound(self, CHAN_VOICE, "dog/dattack1.wav", 1, ATTN_NORM);

	if (!self.enemy)
		return;

	if (!CanDamage(self.enemy, self))
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;

	ldmg = (random() + random() + random()) * 8;
	T_Damage(self.enemy, self, self.origin, self, ldmg, 10);
};

void() Dog_JumpTouch =
{
	float ldmg;

	if (self.health <= 0)
		return;

	if (other.takedamage)
	{
		if (vlen(self.velocity) > 300)
		{
			ldmg = 10 + 10*random();
			T_Damage(other, self, self.origin, self, ldmg, 10);
		}
	}

	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{ // jump randomly to not get hung up
//dprint("popjump\n");
			self.frame = 17;
			self.think = rotweiler_jump2;
			self.nextthink = time + 0.01;

		}
		return; // not on ground yet
	}

	self.touch = SUB_Null;
};


void() rotweiler_stand1 = [ 169, rotweiler_stand2 ] { ai_stand();};
void() rotweiler_stand2 = [ self.frame, rotweiler_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 268) 
	{	
		if (random() < 0.2)
			sound(self, CHAN_VOICE, "dog/idle.wav", 1, ATTN_NORM);
		rotweiler_stand1 ();
		return;
	}
	ai_stand ();
};

void() rotweiler_walk1 = [ 43, rotweiler_walk2 ] { ai_walk(4);};
void() rotweiler_walk2 = [ self.frame, rotweiler_walk2 ] 
{ 
	self.frame ++;
	if (self.frame >= 82) 
	{
		rotweiler_walk1 ();
		return;
	}
	ai_walk (4);
};

void() rotweiler_run1 = [ 43, rotweiler_run2 ] { ai_run(4);};
void() rotweiler_run2 = [ self.frame, rotweiler_run2 ] 
{ 
	self.frame ++;
	if (self.frame >= 82) 
	{
		if (random() < 0.2)
			sound(self, CHAN_VOICE, "dog/idle.wav", 1, ATTN_NORM);

		rotweiler_run1 ();
		return;
	}
	ai_run (4);
};

void() rotweiler_mele =
{
	if (random () <= 0.5)
		rotweiler_atta1 ();
	else 	
		rotweiler_attb1 ();
};

void() rotweiler_atta1 = [ 85, rotweiler_atta2 ] {ai_face (); self.nextthink = time + 0.04; };
void() rotweiler_atta2 = [ self.frame, rotweiler_atta2 ] 
{ 
	self.frame ++;

	if (self.frame == 89)
		rotweiler_bite ();

	if (self.frame >= 108) 
	{
		HknightAttackFinished ();		
		return;
	}
	
	if (self.frame > 85 && self.frame < 96)
		ai_charge (15);
	else if (self.frame > 97 && self.frame < 102)
		ai_charge (2);
	else if (self.frame > 102)
		ai_charge (3);
	else 
		ai_face ();

	 self.nextthink = time + 0.04;
};

void() rotweiler_attb1 = [ 109, rotweiler_attb2  ] {ai_face (); self.nextthink = time + 0.04; };
void() rotweiler_attb2 = [ self.frame, rotweiler_attb2 ] 
{ 
	self.frame ++;

	if (self.frame == 127)
		rotweiler_bite ();

	if (self.frame >= 148) 
	{
		HknightAttackFinished ();
		return;
	}
	
	if (self.frame > 123 && self.frame < 134)
		ai_charge (15);
	else if (self.frame > 134 && self.frame < 140)
		ai_charge (5);
	else if (self.frame > 141)
		ai_charge (3);
	else 
		ai_face ();

	 self.nextthink = time + 0.04;
};

void() rotweiler_jump1 = [ 0, rotweiler_jump2 ] 
{ 	
	//if (random() < 0.4)
	sound(self, CHAN_VOICE, "dog/dattack1.wav", 1, ATTN_NORM);

	ai_face();
	self.nextthink = time + 0.04;
};
void() rotweiler_jump2 = [ self.frame, rotweiler_jump2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.04;

	if (self.frame == 14)
	{
		self.touch = Dog_JumpTouch;
		makevectors(self.angles);
		self.origin_z = self.origin_z + 1;
		self.velocity = v_forward * 600 + '0 0 200';
		if (self.flags & FL_ONGROUND)
			self.flags = self.flags - FL_ONGROUND;
	
		self.flags |= FL_LEAP;
	}

	if (self.frame == 28)
		self.flags &= ~FL_LEAP;
	
	if (self.frame >= 36) 
	{	
		HknightAttackFinished ();
	//	rotweiler_run1 ();
		return;
	}

	ai_face ();
};
void() rotweiler_pain1 = [ 150 , rotweiler_pain2 ] {self.nextthink = time + 0.04;};
void() rotweiler_pain2 = [ self.frame , rotweiler_pain2 ] 
{
		self.frame ++;
	self.nextthink = time + 0.04;
	
	if (self.frame >= 160) 
	{
		HknightAttackFinished  ();
		return;
	}
};

void(entity attacker, float damage) rotweiler_pain =
{
	sound(self, CHAN_VOICE, "dog/dpain1.wav", 1, ATTN_NORM);

	if (random() > 0.5)
		return;

	rotweiler_pain1();
};

static void(vector org) spawn_triteblood =
{
	local entity e;
	e = spawn();
	e.origin = org;
	e.emiteffectnum = (particleeffectnum("TE_TRITESPLOSION"));
	e.nextthink = time + 0.3;
	setmodel (e, "progs/muzzleflash.spr");
	e.think = SUB_Remove;
};	

void() rotweiler_die =
{	
	if((self.deadflag & DEAD_DEAD))
		return;

	self.movetype = MOVETYPE_BOUNCE;
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_CORPSE;
	
	//setsize(self, '-16 -16 0', '16 16 32');
	self.deadflag = DEAD_DEAD;
	//self.avelocity = '600 600 600';
	self.velocity = '0 0 -200';
	//self.touch = rotweiler_touch;
	self.origin_z += 24;

	self.think = rotweiler_die1;
	self.frame = 319;
	self.nextthink = time + 0.15;
};

void() rotweiler_die1 =
{
	spawn_triteblood (self.origin  + '0 0 24');
	spawn_triteblood (self.origin  + '0 0 24');
	spawn_triteblood (self.origin  + '0 0 24');
	remove(self);
	
};

static void() HknightAttackFinished =
{
	if (!visible(self.enemy))
	{
		self.think = self.th_run;
	}
	else
	{
		self.think = rotweiler_strafe;
	}
	self.nextthink = time + frametime;
};

void() rotweiler_strafe =
{		
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();

	if(self.lefty)
		rotweiler_strafel1 ();
	else 
		rotweiler_strafer1 ();
	
	self.nextthink = time + frametime;
};

void() rotweiler_strafel1 = [ 269, rotweiler_strafel2 ] { ai_run_slide (0, 0.04); };
void() rotweiler_strafel2 = [ self.frame, rotweiler_strafel2 ] 
{ 
	self.frame ++;
	if (self.frame >= 293)
	{	
		rotweiler_run1 ();
		return;
	}

	if (self.frame > 272 && self.frame < 277)
		ai_run_slide (10, 0.04);
	else if (self.frame > 277 && self.frame < 288)
		ai_run_slide (4, 0.04);
	else if (self.frame > 288)
		ai_run_slide (1, 0.04);
	else 
		self.nextthink = time + 0.04;
};

void() rotweiler_strafer1 = [ 294, rotweiler_strafer2 ] { self.nextthink = time + 0.04; };
void() rotweiler_strafer2 = [ self.frame, rotweiler_strafer2 ] 
{ 
	self.frame ++;
	if (self.frame >= 318) 
	{	
		rotweiler_run1 ();
		return;
	}

	if (self.frame > 297 && self.frame < 304)
		ai_run_slide (10, 0.04);
	else if (self.frame > 306 && self.frame < 310)
		ai_run_slide (4, 0.04);
	else if (self.frame > 310)
		ai_run_slide (1, 0.04);
	else 
		self.nextthink = time + 0.04;

};

//============================================================================

/*
==============
CheckDogMelee

Returns TRUE if a melee attack would hit right now
==============
*/
float() CheckDogMelee =
{
	local vector dist;
	local float d;
	dist = self.enemy.origin - self.origin;
	dist_z = 0;

	d = vlen(dist);

	if (d < 150)
		return TRUE;

	return FALSE;
};

/*
==============
CheckDogJump

==============
*/
float() CheckDogJump =
{
	vector dist;
	float d;

	if (self.attack_finished > time)
		return FALSE;

	if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z
	+ 0.75 * self.enemy.size_z)
		return FALSE;

	if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z
	+ 0.25 * self.enemy.size_z)
		return FALSE;

	dist = self.enemy.origin - self.origin;
	dist_z = 0;

	d = vlen(dist);

	if (d < 150)
		return FALSE;

	if (d > 300)
		return FALSE;

	return TRUE;
};

float() DogCheckAttack =
{
	// if close enough for slashing, go for it
	if (CheckDogMelee())
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}

	if (CheckDogJump())
	{
		self.attack_state = AS_MISSILE;
		SUB_AttackFinished (1 + random()*2);
		return TRUE;
	}

	return FALSE;
};


//===========================================================================

/*QUAKED monster_dog (1 0 0) (-32 -32 -24) (32 32 40) Ambush

*/
void() monster_dog =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/h_dog.mdl");
	precache_model("progs/dog.mdl");

	precache_sound("dog/dattack1.wav");
	precache_sound("dog/ddeath.wav");
	precache_sound("dog/dpain1.wav");
	precache_sound("dog/dsight.wav");
	precache_sound("dog/idle.wav");
	particleeffectnum("TE_TRITESPLOSION");


	spawn_rotweiler ();
};

void() spawn_rotweiler =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/dog.mdl");
	setsize(self, '-16 -16 0', '16 16 40');
	self.health = 80;
	self.max_health = 80;
	self.scale = 0.9;
	self.mass = 100;

	self.th_stand = rotweiler_stand1;
	self.th_walk = rotweiler_walk1;
	self.th_run = rotweiler_run1;
	self.th_pain = rotweiler_pain;
	self.th_die = rotweiler_die;
	self.th_melee = rotweiler_mele;
	self.th_missile = rotweiler_jump1;
	self.th_checkatck = DogCheckAttack;
	self.th_spawn = spawn_rotweiler;

	walkmonster_start();
};
