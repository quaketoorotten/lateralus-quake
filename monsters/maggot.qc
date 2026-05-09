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

KNIGHT

==============================================================================
*/

static void(float side) chainsaw_maggot =
{
	vector delta;
	float ldmg;
	
	sound(self, CHAN_WEAPON, "monsters/maggot/attack_01_swish.wav", 1, ATTN_NORM);

	if (!self.enemy)
		return;
	if (!CanDamage(self.enemy, self))
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;

	ldmg = (random() + random() + random()) * 16 + 10;

	T_Damage(self.enemy, self, self.origin, self, ldmg, 2);
	//ogre_hit ();

	if (side)
	{
		makevectors(self.angles);
		if (side == 1)
			SpawnMeatSpray(self.origin + v_forward*16, crandom() * 100 * v_right);
		else
			SpawnMeatSpray(self.origin + v_forward*16, side * v_right);
	}
};

void() maggot_stand1 = [ 83, maggot_stand2 ] { ai_stand();};
void() maggot_stand2 = [ self.frame, maggot_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 262) 
	{	
		if (random() < 0.2)
			maggotsfx_idle();
		maggot_stand1 ();
		return;
	}
	ai_stand ();
};

void() maggot_walk1 = [ 54, maggot_walk2 ] { ai_walk(0); };
void() maggot_walk2 = [ self.frame, maggot_walk2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 81) 
	{	
		if (random() < 0.2)
			maggotsfx_run();
		maggot_walk1 ();
		return;
	}
	if (self.frame > 56 && self.frame < 80)
		ai_walk (3);
	else 
		ai_walk (0);
};

void() maggot_run1 =
{	
	if (random () <= 0.3)	
		maggot_runa1 ();
	else
		maggot_runb1 ();
};

void() maggot_runa1 = [ 54, maggot_runa2 ] { ai_run(0); };
void() maggot_runa2 = [ self.frame, maggot_runa2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 81) 
	{	
		if (random() < 0.2)
			maggotsfx_idle();
		maggot_run1 ();
		return;
	}
	
	if (self.frame > 56 && self.frame < 80)
		ai_run (3);
	else 
		ai_run (0.5);
};

void() maggot_runb1 = [ 0, maggot_runb2 ] { ai_run(0); };
void() maggot_runb2 = [ self.frame, maggot_runb2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 53) 
	{	
		if (random() < 0.2)
			maggotsfx_idle();
		maggot_run1 ();
		return;
	}
	
	if ( (self.frame > 2 && self.frame < 16) || 
		(self.frame > 22 && self.frame < 52) )
		ai_run (6);
	else 
		ai_run (0.6);
};

void() maggot_melee = 
{	
	maggotsfx_melee ();

	if (random() < 0.5)
		maggot_atka1 ();
	else
		maggot_atkb1 ();
}

void() maggot_atka1 = [ 263, maggot_atka2 ] { ai_face(); self.nextthink = time + 0.035; };
void() maggot_atka2 = [ self.frame, maggot_atka2 ] 
{ 	
	self.frame ++;
	
	if (self.frame == 282)
		chainsaw_maggot (0);

	if (self.frame >= 294) 
	{	
		maggot_run1 ();
		return;
	}
	
	if ( (self.frame > 274 && self.frame < 287) )
		ai_charge (6);
	else 
		ai_face ();
	
	self.nextthink = time + 0.035;
};

void() maggot_atkb1 = [ 340, maggot_atkb2 ] { ai_face(); self.nextthink = time + 0.035; };
void() maggot_atkb2 = [ self.frame, maggot_atkb2 ] 
{ 	
	self.frame ++;
	
	if (self.frame == 357)
		chainsaw_maggot (0);

	if (self.frame >= 374) 
	{	
		maggot_run1 ();
		return;
	}
	
	if ( (self.frame > 349 && self.frame < 360) )
		ai_charge (6);
	else 
		ai_face ();
	
	self.nextthink = time + 0.035;
};

void() maggot_strafel1 = [ 374, maggot_strafel2 ] 
{ 
	sound(self, CHAN_VOICE, "monsters/maggot/evade_left.wav", 1, ATTN_IDLE);
	ai_slide(0, 0.02);
};
void() maggot_strafel2 = [ self.frame, maggot_strafel2 ] 
{ 
	self.frame ++;
	if (self.frame >= 396) 
	{	
		//self.attack_state = AS_STRAIGHT;
		self.flags &= ~FL_DODGED;
		maggot_run1 ();
		return;
	}

	if (self.frame > 375 && self.frame < 394)
		ai_slide (9, 0.02);
	else
		self.nextthink = time + 0.02;
};

void() maggot_strafer1 = [ 398, maggot_strafer2 ] 
{ 
	sound(self, CHAN_VOICE, "monsters/maggot/evade_right.wav", 1, ATTN_IDLE);
	ai_slide(0, 0.02);
};
void() maggot_strafer2 = [ self.frame, maggot_strafer2 ] 
{ 
	self.frame ++;
	if (self.frame >= 421) 
	{	
		//self.attack_state = AS_STRAIGHT;
		self.flags &= ~FL_DODGED;
		maggot_run1 ();
		return;
	}

	if (self.frame > 403 && self.frame < 412)
		ai_slide (9, 0.02);
	else
		self.nextthink = time + 0.02;
};

void() maggot_dodge =
{	
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	
	ChangeYaw ();

	if(self.lefty)
		maggot_strafel1 ();
	else
		maggot_strafer1 ();
	
	self.nextthink = time + frametime;
}

void() maggotsfx_JumpTouch =
{
	float ldmg;

	if (self.health <= 0)
		return;

	if (other.takedamage)
	{
		if (vlen(self.velocity) > 100)
		{
			ldmg = 10 + 10*random();
			T_Damage(other, self, self.origin, self, ldmg, 50);
		}
	}

	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{	// jump randomly to not get hung up
//dprint ("popjump\n");
			self.touch = SUB_Null;
			self.frame = 312;
			self.think = maggot_jump2;
			self.nextthink = time + 0.035;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
};

void() maggot_jump1 = [ 309, maggot_jump2 ] {ai_face (); maggotsfx_melee();}
void() maggot_jump2 = [ self.frame, maggot_jump2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.035;
	
	if (self.frame >= 316) 
	{	
		self.touch = maggotsfx_JumpTouch;
		makevectors(self.angles);
		self.origin_z = self.origin_z + 1;
		self.velocity = v_forward * 700 + '0 0 150';
		if (self.flags & FL_ONGROUND)
			self.flags = self.flags - FL_ONGROUND;
	
		self.flags |= FL_LEAP;

		maggot_jump4 ();
		return;
	}
	ai_face ();
};
void() maggot_jump4 = [ self.frame, maggot_jump4 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.035;

	if (self.frame == 327)
		self.flags &= ~FL_LEAP;
	
	if (self.frame >= 339) 
	{
		maggot_run1 ();
		return;
	}
	ai_face ();
};

//===========================================================================

void(entity attacker, float damage) maggot_pain =
{
	if (self.flags & FL_DODGED)
		return;

	if (self.pain_finished > time)
		return;

	maggotsfx_pain ();
	self.pain_finished = time + 3;
};

//===========================================================================


void() maggot_die =
{	
	if (self.health < -65)
	{	
		self.deadflag = DEAD_DEAD;
		self.solid = SOLID_NOT;
		self.think = maggot_gib1;
		self.nextthink = time + 0.035;
		return;
	}
	
	if((self.deadflag & DEAD_DEAD))
		return;

	local vector tmpangle;
	local float tempskin;
	tmpangle = self.angles;
	tempskin = self.skin;

	maggotsfx_death ();
	
	if (random () <= 0.5)
	{
		self.think = maggot_die1;
		setmodel(self, "progs/knightdeath.md3");
	}
	else
	{
		self.think = maggot_dieb1;
		setmodel(self, "progs/knightdeath2.md3");
	}
	setsize(self, '-16 -16 0', '16 16 64');

	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_CORPSE;
	
	self.nextthink = time + 0.035;

	self.angles = tmpangle;
	//self.skin = tempskin;
};

void() maggot_die1 = [ 0, maggot_die2 ] { self.nextthink = time + 0.035;};
void() maggot_die2 = [ self.frame, maggot_die2 ] 
{ 	
	self.nextthink = time + 0.035;

	self.frame ++;
	if (self.frame < 8)
		ai_move (-4);
	
	if (self.frame == 23)
	{	
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() maggot_dieb1 = [ 0, maggot_dieb2 ] { self.nextthink = time + 0.035;};
void() maggot_dieb2 = [ self.frame, maggot_dieb2 ] 
{ 	
	self.nextthink = time + 0.035;

	self.frame ++;
	if (self.frame < 8)
		ai_move (-4);
	
	if (self.frame == 25)
	{	
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};


void() maggot_gib1 = [ self.frame, maggot_gib2 ] 
{MonsterGib (self.health); self.skin = 1; self.alpha = 1; self.nextthink = time + 0.02;};

void() maggot_gib2 = [ self.frame, maggot_gib2 ] 
{ 	
	self.nextthink = time + 0.02;
	self.alpha -= 0.02;
	if (self.alpha <= 0)
	{
		remove(self);
		return;
	}
};


/*QUAKED monster_knight (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/


static void() maggotsfx_sight =
{
	local float r = rint(random() * 4);	

	if (r == 4)
		    sound(self, CHAN_VOICE, "monsters/maggot/sight/sight_01.wav", 1, ATTN_NORM);
	else if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/maggot/sight/sight_02.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/maggot/sight/sight_03.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/maggot/sight/sight_04.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/maggot/sight/sight_05.wav", 1, ATTN_NORM);
};

static void() maggotsfx_run =
{
	local float r = rint(random());	

	if (r == 1)
		sound(self, CHAN_VOICE, "monsters/maggot/distant_screams_03.wav", 0.9, ATTN_IDLE);
	else
		sound(self, CHAN_VOICE, "monsters/maggot/distant_screams_01.wav", 0.9, ATTN_IDLE);
};

static void() maggotsfx_idle =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/maggot/idle_01.wav", 1, ATTN_IDLE);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/maggot/idle_02.wav", 1, ATTN_IDLE);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/maggot/idle_03.wav", 1, ATTN_IDLE);
	else
		    sound(self, CHAN_VOICE, "monsters/maggot/idle_04.wav", 1, ATTN_IDLE);
};

static void() maggotsfx_death =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/maggot/death/death_01.wav", 0.85, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/maggot/death/death_02.wav", 0.85, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/maggot/death/death_03.wav", 0.85, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/maggot/death/death_04.wav", 0.85, ATTN_NORM);
};

static void() maggotsfx_melee =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/maggot/attack_01_solo.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/maggot/attack_03_solo.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/maggot/attack_04_solo.wav", 1, ATTN_NORM);
};

static void() maggotsfx_pain =
{
	local float r = rint(random() * 4);	

	if (r == 4)
		    sound(self, CHAN_VOICE, "monsters/maggot/pain/pain_01.wav", 1, ATTN_NORM);
	else if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/maggot/pain/pain_02.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/maggot/pain/pain_03.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/maggot/pain/pain_04.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/maggot/pain/pain_05.wav", 1, ATTN_NORM);
};


void() monster_knight_cache =
{
	precache_model("progs/knight.md3");
	precache_model("progs/knightdeath.md3");
	precache_model("progs/knightdeath2.md3");

	precache_sound("monsters/maggot/sight/sight_01.wav");
	precache_sound("monsters/maggot/sight/sight_02.wav");
	precache_sound("monsters/maggot/sight/sight_03.wav");
	precache_sound("monsters/maggot/sight/sight_04.wav");
	precache_sound("monsters/maggot/sight/sight_05.wav");

	precache_sound("monsters/maggot/pain/pain_01.wav");
	precache_sound("monsters/maggot/pain/pain_02.wav");
	precache_sound("monsters/maggot/pain/pain_03.wav");
	precache_sound("monsters/maggot/pain/pain_04.wav");
	precache_sound("monsters/maggot/pain/pain_05.wav");

	precache_sound("monsters/maggot/death/death_01.wav");
	precache_sound("monsters/maggot/death/death_02.wav");
	precache_sound("monsters/maggot/death/death_03.wav");
	precache_sound("monsters/maggot/death/death_04.wav");

	precache_sound("monsters/maggot/distant_screams_01.wav");
	precache_sound("monsters/maggot/distant_screams_03.wav");

	precache_sound("monsters/maggot/idle_01.wav");
	precache_sound("monsters/maggot/idle_02.wav");
	precache_sound("monsters/maggot/idle_03.wav");
	precache_sound("monsters/maggot/idle_04.wav");

	precache_sound("monsters/maggot/attack_01_solo.wav");
	precache_sound("monsters/maggot/attack_03_solo.wav");
	precache_sound("monsters/maggot/attack_04_solo.wav");

	precache_sound("monsters/maggot/evade_left.wav");
	precache_sound("monsters/maggot/evade_right.wav");

	precache_sound("monsters/maggot/attack_01_swish.wav");
};


void() monster_knight =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	monster_knight_cache ();
	monster_spectre_cache ();
	monster_puncturer_cache ();

	if (random() < 0.4)
		spawn_maggot ();
	else if (random() < 0.3)
		spawn_spectre ();
	else
		spawn_puncturer ();
};

void() monster_knight2 =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	monster_knight_cache ();

	spawn_maggot ();
};

void() spawn_maggot =
{
	setmodel(self, "progs/knight.md3");

	setsize(self, '-16 -16 0', '16 16 64');
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	self.health = 120;
	self.max_health = 120;
	self.scale = 0.76;
	self.mass = 150;

	self.th_stand = maggot_stand1;
	self.th_walk = maggot_walk1;
	self.th_run = maggot_run1;
	self.th_melee = maggot_melee;
	self.th_pain = maggot_pain;
	self.th_die = maggot_die;
	self.th_dodge = maggot_dodge;
	self.th_checkatck = maggotCheckAttack;
	self.th_missile = maggot_jump1;
	self.th_spawn = spawn_maggot;
	self.th_sight = maggotsfx_sight;
	self.deathtype = "became food for Maggots";

	walkmonster_start();
};	


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

	if (d > 160)
		return FALSE;

	return TRUE;
};

static float() maggotCheckAttack =
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
		//sound(self, CHAN_VOICE, "demon/djump.wav", 1, ATTN_NORM);
		SUB_AttackFinished (1 + 3*random());
		return TRUE;
	}

	return FALSE;
};