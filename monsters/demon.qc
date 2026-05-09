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

DEMON

==============================================================================
*/

//============================================================================

void() demon_stand1 = [ 37, demon_stand2 ] { ai_stand();};
void() demon_stand2 = [ self.frame, demon_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 216) 
	{	
		if (random() < 0.2)
			pinky_idle ();
		demon_stand1 ();
		return;
	}
	ai_stand ();
};

void() demon_walk1 = [ 217, demon_walk2 ] { ai_walk(4);};
void() demon_walk2 = [ self.frame, demon_walk2 ] 
{ 
	self.frame ++;
	if (self.frame >= 238) 
	{
		demon_walk1 ();
		return;
	}
	ai_walk (4);
};

void() demon_run1 = [ 217, demon_run2 ] { ai_run(9);};
void() demon_run2 = [ self.frame, demon_run2 ] 
{ 
	self.frame ++;
	if (self.frame >= 238) 
	{
		if (random() < 0.3)
			pinky_idle ();

		demon_run1 ();
		return;
	}
	ai_run (9);
};

void() demon_strafel1 = [ 240, demon_strafel2 ] { ai_slide(7, 0.03);};
void() demon_strafel2 = [ self.frame, demon_strafel2 ] 
{ 
	self.frame ++;
	if (self.frame >= 264) 
	{	
		//self.attack_state = AS_STRAIGHT;
		self.flags &= ~FL_DODGED;
		demon_run1 ();
		return;
	}

	if (self.frame < 248)
		ai_slide (16, 0.03);
	else
		self.nextthink = time + 0.03;
};

void() demon_strafer1 = [ 265, demon_strafer2 ] { ai_slide(7, 0.03);};
void() demon_strafer2 = [ self.frame, demon_strafer2 ] 
{ 
	self.frame ++;
	if (self.frame >= 288) 
	{	
		//self.attack_state = AS_STRAIGHT;
		self.flags &= ~FL_DODGED;
		demon_run1 ();
		return;
	}

	if (self.frame < 274)
		ai_slide (16, 0.03);
	else
		self.nextthink = time + 0.03;
};

void() demon_dodge =
{	
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	
	ChangeYaw ();

	if(self.lefty)
		demon_strafel1 ();
	else
		demon_strafer1 ();
	
	self.nextthink = time + frametime;
}


void() demon_jump1 = [ 0, demon_jump2 ] 
{ 
	ai_face();
	self.nextthink = time + 0.035;
	self.touch = demon_JumpTouch;
	makevectors(self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 400 + '0 0 150';
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
	
	self.flags |= FL_LEAP;
};
void() demon_jump2 = [ self.frame, demon_jump2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.035;

	if (self.frame == 9)
		self.flags &= ~FL_LEAP;
	
	if (self.frame >= 16) 
	{
		demon_run1 ();
		return;
	}
	ai_face ();
};

void() demon_atta1 = [ 17, demon_atta2 ] {ai_face(); self.nextthink = time + 0.035;};
void() demon_atta2 = [ self.frame, demon_atta2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.035;

	if (self.frame == 21)
		demon_Melee (0);
	
	if (self.frame >= 35) 
	{
		demon_run1 ();
		return;
	}

	if (self.frame < 21)
		ai_charge (4);
	else
		ai_charge (-4);
};

void() demon_pain1 = [ 289, demon_pain2 ] { self.nextthink = time + 0.035;};
void() demon_pain2 = [ self.frame, demon_pain2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.035;
	
	if (self.frame >= 303) 
	{
		demon_run1 ();
		return;
	}
};

void(entity attacker, float damage) demon_pain =
{
	if (self.touch == demon_JumpTouch)
		return;

	if (self.flags & FL_DODGED)
		return;

	if (self.pain_finished > time)
		return;

	self.pain_finished = time + 1;
	pinky_pain ();

	if (random()*200 > damage)
		return; // didn't flinch

	demon_pain1();
};

void() demon_die =
{	
	if (self.health < -120)
	{	
		self.deadflag = DEAD_DEAD;
		self.solid = SOLID_NOT;
		self.think = demon_gib1;
		self.nextthink = time + 0.035;
		return;
	}
	
	if((self.deadflag & DEAD_DEAD))
		return;

	pinky_death ();

	local vector tmpangle;
	local float tempskin;
	tmpangle = self.angles;
	tempskin = self.skin;

	if (self.alpha == 0.12)
		self.alpha = 0.5;
	
	if (random () <= 0.5)
	{
		self.think = demon_die1;
		setmodel(self, "progs/demondeath.md3");
	}
	else
	{
		self.think = demon_dieb1;
		setmodel(self, "progs/demondeath2.md3");
	}

	setsize(self, '-32 -32 0', '32 32 88');

	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_CORPSE;
	self.nextthink = time + 0.035;

	self.angles = tmpangle;
	//self.skin = tempskin;
};

void() demon_die1 = [ 0, demon_die2 ] { self.nextthink = time + 0.035;};
void() demon_die2 = [ self.frame, demon_die2 ] 
{ 	
	self.nextthink = time + 0.035;

	self.frame ++;
	if (self.frame == 27)
	{
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() demon_dieb1 = [ 0, demon_dieb2 ] { self.nextthink = time + 0.035;};
void() demon_dieb2 = [ self.frame, demon_dieb2 ] 
{ 	
	self.nextthink = time + 0.035;

	self.frame ++;
	if (self.frame == 22)
	{	
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() demon_gib1 = [ self.frame, demon_gib2 ] 
{MonsterGib (self.health); self.skin = 1; self.alpha = 1; self.nextthink = time + 0.02;};

void() demon_gib2 = [ self.frame, demon_gib2 ] 
{ 	
	self.nextthink = time + 0.02;
	self.alpha -= 0.02;
	if (self.alpha <= 0)
	{
		remove(self);
		return;
	}
};


void() demon_MeleeAttack =
{
	pinky_melee ();
	demon_atta1();
};

static void() pinky_pain =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/pinky/pain_test1.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/pinky/pain_test2.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/pinky/pain_test3.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/pinky/pain_test4.wav", 1, ATTN_NORM);
};

static void() pinky_melee =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/pinky/melee_test1.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/pinky/melee_test2.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/pinky/melee_test3.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/pinky/melee_test4.wav", 1, ATTN_NORM);
};

static void() pinky_death =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/pinky3/death_test1.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/pinky3/death_test2.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/pinky3/death_test3.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/pinky3/death_test4.wav", 1, ATTN_NORM);
};

static void() pinky_idle =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/pinky3/idle_test1.wav", 1, ATTN_IDLE);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/pinky3/idle_test2.wav", 1, ATTN_IDLE);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/pinky3/idle_test3.wav", 1, ATTN_IDLE);
	else
		    sound(self, CHAN_VOICE, "monsters/pinky3/idle_test4.wav", 1, ATTN_IDLE);
};

static void() pinky_sight =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_WEAPON, "monsters/pinky3/sight_test21.wav", 1, 0.7);
	else if (r == 1)
		    sound(self, CHAN_WEAPON, "monsters/pinky3/sight_test22.wav", 1, 0.7);
	else
		    sound(self, CHAN_WEAPON, "monsters/pinky3/sight_test23.wav", 1, 0.7);
};

/*QUAKED monster_demon (1 0 0) (-32 -32 -24) (32 32 64) Ambush

*/
void() monster_demon1_cache =
{
	precache_model("progs/demon.md3");
	precache_model("progs/demondeath.md3");
	precache_model("progs/demondeath2.md3");

	precache_sound("monsters/pinky/melee_test1.wav");
	precache_sound("monsters/pinky/melee_test2.wav");
	precache_sound("monsters/pinky/melee_test3.wav");
	precache_sound("monsters/pinky/melee_test4.wav");
	
	precache_sound("monsters/pinky/pain_test1.wav");
	precache_sound("monsters/pinky/pain_test2.wav");
	precache_sound("monsters/pinky/pain_test3.wav");
	precache_sound("monsters/pinky/pain_test4.wav");	

	precache_sound("monsters/pinky3/sight_test21.wav");
	precache_sound("monsters/pinky3/sight_test22.wav");
	precache_sound("monsters/pinky3/sight_test23.wav");

	precache_sound("monsters/pinky3/idle_test1.wav");
	precache_sound("monsters/pinky3/idle_test2.wav");
	precache_sound("monsters/pinky3/idle_test3.wav");
	precache_sound("monsters/pinky3/idle_test4.wav");

	precache_sound("monsters/pinky3/death_test1.wav");
	precache_sound("monsters/pinky3/death_test2.wav");
	precache_sound("monsters/pinky3/death_test3.wav");
	precache_sound("monsters/pinky3/death_test4.wav");

	precache_sound("monsters/imp/melee/hit_01.wav");
	precache_sound("monsters/imp/melee/hit_03.wav");
	precache_sound("monsters/imp/melee/hit_04.wav");	

//	spawn_demon ();
};

void() monster_demon1 =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	monster_demon1_cache ();	
	monster_sheol_cache ();
		
	if (random () < 0.2)
		spawn_sheol ();
	else
		spawn_demon ();
};

void() monster_demon2 =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	monster_demon1_cache ();	
	spawn_demon ();
};

void() spawn_demon =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/demon.md3");

	setsize(self, '-32 -32 0', '32 32 88');
	self.health = 500;
	self.max_health = 500;
	self.mass = 400;
	if (random () > 0.8)
	{	
		self.health = 350;
		self.max_health = 350;
		self.skin = 2;
		self.alpha = 0.1;
		self.items |= IT_INVISIBILITY;
		self.scale = 0.75;
	}

	self.scale = 0.8;

	self.th_stand = demon_stand1;
	self.th_walk = demon_walk1;
	self.th_run = demon_run1;
	self.th_die = demon_die;
	self.th_melee = demon_MeleeAttack; // one of two attacks
	self.th_missile = demon_jump1; // jump attack
	self.th_pain = demon_pain;
	self.th_checkatck = demonCheckAttack;
	self.th_spawn = spawn_demon;
	self.th_dodge = demon_dodge;
	self.th_sight = pinky_sight;
	self.deathtype = "was mauled and eviscerated by a Demon";

	walkmonster_start();
};


/*
==============================================================================

DEMON

==============================================================================
*/

/*
==============
CheckDemonMelee

Returns TRUE if a melee attack would hit right now
==============
*/
static float() CheckdemonMelee =
{
	if (enemy_range == RANGE_MELEE)
	{ // FIXME: check canreach
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	return FALSE;
};

/*
==============
CheckDemonJump

==============
*/
static float() CheckdemonJump =
{
	vector dist;
	float d;

	if (self.attack_finished > time)
		return FALSE;

	if (self.items & IT_INVISIBILITY)
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

	if (d < 80)
		return FALSE;

	if (d > 200)
		return FALSE;

	return TRUE;
};

static float() demonCheckAttack =
{
	// if close enough for slashing, go for it
	if (CheckdemonMelee())
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}

	if (CheckdemonJump())
	{
		self.attack_state = AS_MISSILE;
		pinky_melee();
		SUB_AttackFinished (1 + 3*random());
		return TRUE;
	}

	return FALSE;
};


//===========================================================================

static void() pinky_hit =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/imp/melee/hit_03.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/imp/melee/hit_01.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/imp/melee/hit_04.wav", 1, ATTN_NORM);
};

void(float side) demon_Melee =
{
	float ldmg;
	vector delta;

	ai_face();

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 120)
		return;
	if (!CanDamage(self.enemy, self))
		return;

	pinky_hit ();
	ldmg = 12 + 5*random();
	T_Damage(self.enemy, self, self.origin + v_forward*16, self, ldmg, 15);

	makevectors(self.angles);
	SpawnMeatSpray(self.origin + v_forward*16, side * v_right);
};


void() demon_JumpTouch =
{
	float ldmg;

	if (self.health <= 0)
		return;

	if (other.takedamage)
	{
		if (vlen(self.velocity) > 100)
		{
			ldmg = 40 + 10*random();
			T_Damage(other, self, self.origin, self, ldmg, 50);
		}
	}

	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{	// jump randomly to not get hung up
//dprint ("popjump\n");
			self.touch = SUB_Null;
			self.think = demon_jump1;
			self.nextthink = time + 0.035;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
};

