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

void() fiend_stand1 = [ 37, fiend_stand2 ] { ai_stand();};
void() fiend_stand2 = [ self.frame, fiend_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 216) 
	{	
		if (random() < 0.2)
			pinky_idle ();
		fiend_stand1 ();
		return;
	}
	ai_stand ();
};

void() fiend_walk1 = [ 217, fiend_walk2 ] { ai_walk(4);};
void() fiend_walk2 = [ self.frame, fiend_walk2 ] 
{ 
	self.frame ++;
	if (self.frame >= 238) 
	{
		fiend_walk1 ();
		return;
	}
	ai_walk (4);
};

void() fiend_run1 = [ 217, fiend_run2 ] { ai_run(9);};
void() fiend_run2 = [ self.frame, fiend_run2 ] 
{ 
	self.frame ++;
	if (self.frame >= 238) 
	{
		if (random() < 0.2)
			pinky_idle ();

		fiend_run1 ();
		return;
	}
	ai_run (9);
};

void() fiend_strafel1 = [ 240, fiend_strafel2 ] { ai_run_slide(7, 0.03);};
void() fiend_strafel2 = [ self.frame, fiend_strafel2 ] 
{ 
	self.frame ++;
	if (self.frame >= 264) 
	{	
		//self.attack_state = AS_STRAIGHT;
		self.flags &= ~FL_DODGED;
		fiend_run1 ();
		return;
	}

	if (self.frame < 248)
		ai_run_slide (16, 0.03);
	else
		self.nextthink = time + 0.03;
};

void() fiend_strafer1 = [ 265, fiend_strafer2 ] { ai_run_slide(7, 0.03);};
void() fiend_strafer2 = [ self.frame, fiend_strafer2 ] 
{ 
	self.frame ++;
	if (self.frame >= 288) 
	{	
		//self.attack_state = AS_STRAIGHT;
		self.flags &= ~FL_DODGED;
		fiend_run1 ();
		return;
	}

	if (self.frame < 274)
		ai_run_slide (16, 0.03);
	else
		self.nextthink = time + 0.03;
};

void() fiend_dodge =
{	
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	
	ChangeYaw ();

	if(self.lefty)
		fiend_strafel1 ();
	else
		fiend_strafer1 ();
	
	self.nextthink = time + frametime;
}


void() fiend_jump1 = [ 0, fiend_jump2 ] 
{ 
	ai_face();
	self.nextthink = time + 0.04;
	self.touch = fiend_JumpTouch;
	makevectors(self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 400 + '0 0 150';
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
	
	self.flags |= FL_LEAP;
};
void() fiend_jump2 = [ self.frame, fiend_jump2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.04;

	if (self.frame == 9)
		self.flags &= ~FL_LEAP;
	
	if (self.frame >= 16) 
	{
		fiend_run1 ();
		return;
	}
	ai_face ();
};

void() fiend_atta1 = [ 17, fiend_atta2 ] {ai_face(); self.nextthink = time + 0.04;};
void() fiend_atta2 = [ self.frame, fiend_atta2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.04;

	if (self.frame == 21)
		fiend_Melee (0);
	
	if (self.frame >= 35) 
	{
		fiend_run1 ();
		return;
	}

	if (self.frame < 21)
		ai_charge (4);
	else
		ai_charge (-4);
};

void() fiend_pain1 = [ 289, fiend_pain2 ] { self.nextthink = time + 0.04;};
void() fiend_pain2 = [ self.frame, fiend_pain2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.04;
	
	if (self.frame >= 303) 
	{
		fiend_run1 ();
		return;
	}
};

void(entity attacker, float damage) fiend_pain =
{
	if (self.touch == fiend_JumpTouch)
		return;

	if (self.flags & FL_DODGED)
		return;

	if (self.pain_finished > time)
		return;

	self.pain_finished = time + 1;
	pinky_pain ();

	if (random()*200 > damage)
		return; // didn't flinch

	fiend_pain1();
};

void() fiend_die =
{	
	if((self.deadflag & DEAD_DEAD))
		return;

	local vector tmpangle;
	local float tmpframe;
	tmpframe = self.frame;
	tmpangle = self.angles;

	pinky_death ();

	setmodel(self, "progs/demon1.mdl");
	setsize(self, '-32 -32 0', '32 32 88');
	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_NOT;
	self.think = fiend_die1;
	self.nextthink = time + 0.04;

	self.frame = tmpframe;
	self.angles = tmpangle;

	MonsterGib (self.health);
};

void() fiend_die1 = [ self.frame, fiend_die2 ] {self.alpha = 1; self.nextthink = time + 0.02;};
void() fiend_die2 = [ self.frame, fiend_die2 ] 
{ 	
	self.nextthink = time + 0.02;
	self.alpha -= 0.02;
	if (self.alpha <= 0)
	{
		remove(self);
		return;
	}	
};


void() fiend_MeleeAttack =
{
	pinky_melee ();
	fiend_atta1();
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
		    sound(self, CHAN_VOICE, "monsters/pinky3/sight_test21.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/pinky3/sight_test22.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/pinky3/sight_test23.wav", 1, ATTN_NORM);
};

/*QUAKED monster_fiend (1 0 0) (-32 -32 -24) (32 32 64) Ambush

*/
void() monster_demon1 =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/demon.mdl");
	precache_model("progs/demon1.mdl");

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

	spawn_fiend ();
};

void() spawn_fiend =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/demon.mdl");

	setsize(self, '-32 -32 0', '32 32 88');
	self.health = 400;
	self.max_health = 400;
	self.mass = 400;
	self.scale = 0.85;

	self.th_stand = fiend_stand1;
	self.th_walk = fiend_walk1;
	self.th_run = fiend_run1;
	self.th_die = fiend_die;
	self.th_melee = fiend_MeleeAttack; // one of two attacks
	self.th_missile = fiend_jump1; // jump attack
	self.th_pain = fiend_pain;
	self.th_checkatck = fiendCheckAttack;
	self.th_spawn = spawn_fiend;
	self.th_dodge = fiend_dodge;
	self.th_sight = pinky_sight;

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
static float() CheckfiendMelee =
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
static float() CheckfiendJump =
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

	if (d < 80)
		return FALSE;

	if (d > 200)
		return FALSE;

	return TRUE;
};

static float() fiendCheckAttack =
{
	// if close enough for slashing, go for it
	if (CheckfiendMelee())
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}

	if (CheckfiendJump())
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

void(float side) fiend_Melee =
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


void() fiend_JumpTouch =
{
	float ldmg;

	if (self.health <= 0)
		return;

	if (other.takedamage)
	{
		if (vlen(self.velocity) > 300)
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
			self.think = fiend_jump1;
			self.nextthink = time + 0.04;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
};

