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

OGRE

==============================================================================
*/

/*
===========
OgreCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() OgreCheckAttack =
{
		local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;

	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);
	
	if (trace_ent != targ)
		return FALSE;		// don't have a clear shot
			
	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (enemy_range == RANGE_MELEE)
	{	
		// don't always melee in easy mode
		if (skill == 0 && (rand()&3) )
			return FALSE;
		if (self.th_melee)
			self.attack_state = AS_MELEE;
		else
			self.attack_state = AS_MISSILE;
	}
	
// missile attack
	
	if (!self.th_missile)
		return FALSE;
	
	if (self.flags & FL_DODGED)
		return FALSE;
		
	if (time < self.attack_finished)
		return FALSE;
		
	if (enemy_range == RANGE_FAR)
		return FALSE;
		
	if (enemy_range == RANGE_MELEE)
		chance = 0.2;
	else if (enemy_range == RANGE_CLOSE)
		chance = 0.15;
	else if (enemy_range == RANGE_NEAR)
		chance = 0.1;
	else if (enemy_range == RANGE_MID)
		chance = 0.06;
	else
		return FALSE;

	if (skill >= 2)
		chance *= 1.5;

	if (random () < chance)
	{
		self.attack_state = AS_MISSILE;
		SUB_AttackFinished (2*random());
		return TRUE;
	}

	return FALSE;
};

//=============================================================================

float MF_GUNNER_MG_1		=	0;
float MF_GUNNER_MG_2		=	1;
float MF_GUNNER_MG_3		=	2;
float MF_GUNNER_MG_4		=	3;
float MF_GUNNER_MG_5		=	4;
float MF_GUNNER_MG_6		=	5;
float MF_GUNNER_MG_7		=	6;
float MF_GUNNER_MG_8		=	7;
float MF_GUNNER_GREN_1		=	9;

vector m_gunner_flashoffset[] = // q2 port i guess idk
{
	'90  3.9 19.6',
	'29.1  2.5 20.7',
	'28.2  2.5 22.2',
	'28.2  3.6 22.0',
	'26.9  2.0 23.4',
	'26.5  0.6 20.8',
	'26.9  0.5 21.5',
	'29.0  2.4 19.5',
	'4.6  -16.8 7.3',
	'4.6  -16.8 7.3',
	'4.6  -16.8 7.3',
	'4.6  -16.8 7.3',
};

static void(float t) OgreCheckForLeap =
{
// check for mad charge
if (!enemy_vis)
	return;
//if (time < self.attack_finished)
//	return;	
if ( fabs(self.origin_z - self.enemy.origin_z) > 20)
	return;		// too much height change
if ( vlen (self.origin - self.enemy.origin) < 80)
	return;		// use regular attack

// charge		
	SUB_AttackFinished (t);
	marksman_jump1 ();

};

static void(float t) OgreCheckForCharge =
{
	local float vis = visible(self.enemy);

// check for mad charge
if (!vis)
	return;
if (time < self.attack_finished)
	return;	
if ( vlen (self.origin - self.enemy.origin) < 80)
	return;		// use regular attack

// charge		
	SUB_AttackFinished (t);
	self.th_char ();

};

//=============================================================================


/*
================
MarksmanFireGrenade
================
*/
void(float dmg) MarksmanFireGrenade =
{
	
	local	vector	dir, org;
	local entity en = self.enemy;
		
	//sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
	
	self.effects = self.effects | EF_MUZZLEFLASH;

	makevectors(self.angles);
	org = ProjectAim(self.origin, m_gunner_flashoffset[1]*1.15, v_forward, v_right);
	
	dir = (en.origin - en.velocity*0.2) - org;
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

	dir = v_forward;
	dir = dir + pitch * v_up;
//PGM	

	monster_FireGravityBall (org, dir, dmg, 2.5);
};

/*
================
chainsaw

FIXME
================
*/
static void(float side) chainsaw =
{
	vector delta;
	float ldmg;

	if (!self.enemy)
		return;
	if (!CanDamage(self.enemy, self))
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
	{
		ogre_miss ();
		return;
	}

	ldmg = (random() + random() + random()) * 16;

	T_Damage(self.enemy, self, self.origin, self, ldmg, 2);
	ogre_hit ();

	if (side)
	{
		makevectors(self.angles);
		if (side == 1)
			SpawnMeatSpray(self.origin + v_forward*16, crandom() * 100 * v_right);
		else
			SpawnMeatSpray(self.origin + v_forward*16, side * v_right);
	}
};

static void() fireball_update_pos =
{	
	if (self.frame == self.ltime
		|| self.owner.health < 1 || (self.owner.flags & FL_DODGED)
		|| (self.owner.think != marksman_achar1 && self.owner.think != marksman_achar2 
		&& self.owner.think != marksman_bchar1 && self.owner.think != marksman_bchar2 &&
		self.owner.think != marksman_nail2 && self.owner.think != marksman_nail1 ))
	{
		if (self.frame == self.ltime)
			sound (self, CHAN_WEAPON, "monsters/imp/fireball_throw_01.wav", 1, ATTN_NORM);
		
		remove(self);
		return;
	}

	self.origin = self.owner.origin;
	self.angles = self.owner.angles;
	self.frame = self.owner.frame;
	
	self.think = fireball_update_pos;
	self.nextthink = time + 0.01;
};

static void(float removeframe) spawn_fireball =
{
	local entity e;
	e = spawn ();
	setmodel (e, "progs/impball.mdl");
	setsize (e, '-32 -32 0', '32 32 88');
	e.scale = 0.9;
	setorigin (e, self.origin);
	e.groundentity = self;
	e.angles = self.angles;
	e.owner = self;
	e.think = fireball_update_pos;
	e.nextthink = time + 0.01;
	e.ltime = removeframe;
	e.frame = self.frame;
	sound (self, CHAN_WEAPON, "monsters/imp/fireball_create_02.wav", 1, ATTN_NORM);
	//e.traileffectnum = (particleeffectnum("EF_IMPFIRE"));
};	

//=============================================================================


void() marksman_stand1 = [ 0, marksman_stand2 ] { ai_stand();};
void() marksman_stand2 = [ self.frame, marksman_stand2 ] 
{ 
	self.frame ++;
	if (self.frame >= 79) 
	{
		if (random() < 0.2)
			ogre_idle ();

		marksman_stand1 ();
		return;
	}
	ai_stand ();
};


void() marksman_walk1 = [ 198, marksman_walk2 ] { ai_walk(2.5);};
void() marksman_walk2 = [ self.frame, marksman_walk2 ] 
{ 
	self.frame ++;
	if (self.frame >= 233) 
	{	
		if (random() < 0.2)
			ogre_idle ();

		marksman_walk1 ();
		return;
	}

	if ( (self.frame > 200 && self.frame < 207) || (self.frame > 214 && self.frame < 222) )
		ai_walk (1);
	else
		ai_walk (2.5);
};

void() marksman_run =
{	
//	bprint (ftos(fabs(self.origin_z - self.enemy.origin_z)), "\n");
	if (random () < 0.4 && fabs(self.origin_z - self.enemy.origin_z) <= 24
		&& visible(self.enemy) && range (self.enemy) <= RANGE_CLOSE)	
		marksman_scurry1 ();
	else
		marksman_run1 ();
};

void() marksman_run1 = [ 198, marksman_run2 ] { self.maxs_z = 88;	OgreCheckForCharge (1 + random()*4); ai_run(2.5); };
void() marksman_run2 = [ self.frame, marksman_run2 ] 
{ 
	self.frame ++;
	if (self.frame >= 233) 
	{	
		if (random() < 0.2)
			ogre_idle ();

		if (random() < 0.4)
		{
			marksman_run ();
			return;
		}
		marksman_run1 ();
		return;
	}
	
	if ( (self.frame > 200 && self.frame < 207) || (self.frame > 214 && self.frame < 222) )
		ai_run (1);
	else
		ai_run (2.5);
};

void() marksman_scurry1 = [ 80, marksman_scurry2 ] { self.maxs_z = 28; ai_run(4); };
void() marksman_scurry2 = [ self.frame, marksman_scurry2 ] 
{ 
	self.frame ++;
	if (self.frame >= 97) 
	{	
		if (random() < 0.6)
		{
			marksman_run ();
			return;
		}

		marksman_scurry1 ();
		return;
	}
	
	ai_run (4);
};

void() marksman_JumpTouch =
{
	float ldmg;

	if (self.health <= 0)
		return;

	if (other.takedamage)
	{
		if (vlen(self.velocity) > 300)
		{
			ldmg = 30 + 10*random();
			T_Damage(other, self, self.origin, self, ldmg, 50);
			ogre_hit ();
		}
	}

	if (!checkbottom(self) || other.classname == self.classname && other.maxs_z < 88) // not onground or landed on a friend
	{
		if (self.flags & FL_ONGROUND)
		{	// jump randomly to not get hung up
//dprint ("popjump\n");
			self.touch = SUB_Null;
			self.frame = 110;
			self.think = marksman_jump2;
			self.nextthink = time + 0.04;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
};

void() marksman_jump1 = [ 98, marksman_jump2 ] 
{ 	
	ai_face();
	self.nextthink = time + 0.04;
};
void() marksman_jump2 = [ self.frame, marksman_jump2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.04;

	if (self.frame == 113)
		ogre_sight2 ();

	if (self.frame == 117)
	{
		self.touch = marksman_JumpTouch;
		makevectors(self.angles);
		self.origin_z = self.origin_z + 1;
		self.velocity = v_forward * 800 + '0 0 250';
		if (self.flags & FL_ONGROUND)
			self.flags = self.flags - FL_ONGROUND;
	
		self.flags |= FL_LEAP;
	}

	if (self.frame == 129)
		self.flags &= ~FL_LEAP;

	if (self.frame > 129 && self.frame < 134)
		ai_charge (2);
	
	if (self.frame >= 145) 
	{
		marksman_run1 ();
		return;
	}

	ai_face ();
};

void() marksman_char =
{	
	self.maxs_z = 88;
	if(random() <= 0.5)
		marksman_achar1 ();
	else
		marksman_bchar1 ();
	
	ogre_sight2 ();
};

void() marksman_achar1 = [ 247, marksman_achar2 ] {spawn_fireball(291); ai_charge(2.5); self.nextthink = time + 0.03;};
void() marksman_achar2 = [ self.frame, marksman_achar2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;
	if (self.frame >= 306) 
	{	
		marksman_run1 ();
		return;
	}

	if (self.frame == 291)
		MarksmanFireGrenade (80);
	
	if ( (self.frame > 265 && self.frame < 267) || (self.frame > 282 && self.frame < 284) )
		return;
	
	if ( (self.frame > 301 && self.frame < 307) )
		ai_charge(6);
	else
		ai_charge(8);
};

void() marksman_bchar1 = [ 307, marksman_bchar2 ] {spawn_fireball(328); ai_charge(2.5); self.nextthink = time + 0.04;};
void() marksman_bchar2 = [ self.frame, marksman_bchar2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.04;

	if (self.frame == 328)
		MarksmanFireGrenade (60);

	if (self.frame >= 339) 
	{	
		marksman_run1 ();
		return;
	}
	
	if ( (self.frame > 310 && self.frame < 314) || (self.frame > 324 && self.frame < 328) )
		return;

	ai_charge (2.5);
};

void() marksman_missile 
{
	if (self.maxs_z < 88)
	{	
		if (inNaziRange (300))
			marksman_jump1();
		else
			marksman_run1();
		return;
	}
	
	ogre_sight2 ();

	self.maxs_z = 88;
	marksman_nail1 ();
};

void() marksman_nail1 = [ 339, marksman_nail2 ] {spawn_fireball(361); self.maxs_z = 88; ai_face(); self.nextthink = time + 0.04;};
void() marksman_nail2 = [ self.frame, marksman_nail2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.04;

	if (self.frame == 361)
		MarksmanFireGrenade (30);

	if (self.frame >= 375) 
	{	
		SUB_CheckRefire (marksman_nail1);
		marksman_run ();
		return;
	}

	ai_face();
};

void() marksman_meleea1 = [ 491, marksman_meleea2 ] {	ai_face ();	 self.nextthink = time + 0.04;};
void() marksman_meleea2 = [ self.frame, marksman_meleea2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.04;
	if (self.frame >= 511) 
	{	
		marksman_run1 ();
		return;
	}

	if (self.frame == 496)
		chainsaw (0);
	
	if (self.frame < 497)
		ai_face ();	
};

void() marksman_meleeb1 = [ 512, marksman_meleeb2 ] { ai_face ();	self.nextthink = time + 0.04;};
void() marksman_meleeb2 = [ self.frame, marksman_meleeb2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.04;

	if (self.frame >= 537) 
	{	
		marksman_run1 ();
		return;
	}

	if (self.frame == 521 || self.frame == 528)
		chainsaw (0);
	
	if ( (self.frame > 518 && self.frame < 521))
		ai_charge (5);

	else if (self.frame > 530 && self.frame < 537) 
		ai_charge (2.5);
	
	else
		ai_face ();
};

void() marksman_pain1 = [ 234, marksman_pain2 ] {self.nextthink = time + 0.04;};
void() marksman_pain2 = [ self.frame, marksman_pain2 ] 
{
	self.frame ++;
	self.nextthink = time + 0.04;

	if (self.frame >= 246) 
	{	
		marksman_run ();
		return;
	}

};

void() marksman_strafel1 = [ 385, marksman_strafel2 ] { self.nextthink = time + 0.03;};
void() marksman_strafel2 = [ self.frame, marksman_strafel2 ] 
{ 
	self.frame ++;
	if (self.frame >= 419) 
	{	
		self.flags &= ~FL_DODGED;
		marksman_run ();
		return;
	}

	if (self.frame > 385 && self.frame < 396)
		ai_run_slide (10, 0.03);
	else if (self.frame < 412 && self.frame > 396)
		ai_run_slide (5, 0.03);
	else
		self.nextthink = time + 0.03;
};

void() marksman_strafer1 = [ 428, marksman_strafer2 ] {self.nextthink = time + 0.03;};
void() marksman_strafer2 = [ self.frame, marksman_strafer2 ] 
{ 
	self.frame ++;
	if (self.frame >= 464) 
	{	
		self.flags &= ~FL_DODGED;
		marksman_run ();
		return;
	}

	if (self.frame > 429 && self.frame < 444)
		ai_run_slide (12, 0.03);
	else if (self.frame < 455 && self.frame > 444)
		ai_run_slide (6, 0.03);
	else
		self.nextthink = time + 0.03;
};

void() marksman_dodge =
{	
	if (self.maxs_z < 88) // is scurrying ? gtfo
		return;
	
	self.maxs_z = 28; 
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	
	ChangeYaw ();
	
	if(self.lefty)
		marksman_strafel1 ();
	else
		marksman_strafer1 ();
	
	self.nextthink = time + frametime;
}


void(entity attacker, float damage) marksman_pain =
{
// don't make multiple pain sounds right after each other
	if (self.pain_finished > time)
		return;
	
	if (self.flags & FL_DODGED)
		return;

	if (self.touch == marksman_JumpTouch)
		return;

	if (damage < 25)
		return;
	
	ogre_pain ();

	marksman_pain1();
	self.pain_finished = time + 3;
};

void() marksman_die =
{	
	if((self.deadflag & DEAD_DEAD))
		return;

	ogre_die();

	local vector tmpangle;
	local float tmpframe;
	tmpframe = self.frame;
	tmpangle = self.angles;

	setmodel(self, "progs/ogre1.mdl");
	setsize(self, '-32 -32 0', '32 32 88');
	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_NOT;
	self.think = fiend_die1;
	self.nextthink = time + 0.04;

	self.frame = tmpframe;
	self.angles = tmpangle;

	MonsterGib (self.health);
};

void() marksman_die1 = [ self.frame, fiend_die2 ] {self.alpha = 1; self.nextthink = time + 0.02;};
void() marksman_die2 = [ self.frame, fiend_die2 ] 
{ 	
	self.nextthink = time + 0.02;
	self.alpha -= 0.02;
	if (self.alpha <= 0)
	{
		remove(self);
		return;
	}	
};

void() marksman_melee =
{		
	if (self.maxs_z < 88)
		marksman_jump1 ();
	else if (random() <= 0.5)
		marksman_meleea1 ();
	else
		marksman_meleeb1 ();

	return;
};

static void() ogre_sight2 =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/imp/sight2_01.wav", 0.8, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/imp/sight2_02.wav", 0.8, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/imp/sight2_03.wav", 0.8, ATTN_NORM);
};

static void() ogre_idle =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/imp/breath_test2.wav", 1, ATTN_IDLE);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/imp/breath_test22.wav", 1, ATTN_IDLE);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/imp/breath_test23.wav", 1, ATTN_IDLE);
	else
		    sound(self, CHAN_VOICE, "monsters/imp/breath_test24.wav", 1, ATTN_IDLE);
};

static void() ogre_pain =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/imp/pain_test3.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/imp/pain_test4.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/imp/pain_test5.wav", 1, ATTN_NORM);
};

static void() ogre_miss =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/imp/melee/miss_01.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/imp/melee/miss_02.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/imp/melee/miss_03.wav", 1, ATTN_NORM);
};

static void() ogre_hit =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/imp/melee/hit_03.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/imp/melee/hit_01.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/imp/melee/hit_04.wav", 1, ATTN_NORM);
};

static void() ogre_sight =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/imp/imp_sight_01.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/imp/imp_sight_02.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/imp/imp_sight_03.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/imp/imp_sight_04.wav", 1, ATTN_NORM);
};

static void() ogre_die =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/imp/imp_death_01.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/imp/imp_death_02.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/imp/imp_death_03.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/imp/imp_death_04.wav", 1, ATTN_NORM);
};

/*QUAKED monster_ogre (1 0 0) (-32 -32 -24) (32 32 64) Ambush

*/
void() monster_ogre =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/ogre.mdl");
	precache_model("progs/impball.mdl");
	precache_model("progs/ogre1.mdl");
	precache_model("progs/h_ogre.mdl");
	precache_model("progs/grenade.mdl");

	precache_sound("monsters/imp/imp_sight_01.wav");
	precache_sound("monsters/imp/imp_sight_02.wav");
	precache_sound("monsters/imp/imp_sight_03.wav");
	precache_sound("monsters/imp/imp_sight_04.wav");
	
	precache_sound("monsters/imp/sight2_01.wav");
	precache_sound("monsters/imp/sight2_02.wav");
	precache_sound("monsters/imp/sight2_03.wav");

	precache_sound("monsters/imp/fireball_create_02.wav");
	precache_sound("monsters/imp/fireball_throw_01.wav");

	precache_sound("monsters/imp/imp_death_01.wav");
	precache_sound("monsters/imp/imp_death_02.wav");
	precache_sound("monsters/imp/imp_death_03.wav");
	precache_sound("monsters/imp/imp_death_04.wav");

	precache_sound("monsters/imp/melee/hit_01.wav");
	precache_sound("monsters/imp/melee/hit_03.wav");
	precache_sound("monsters/imp/melee/hit_04.wav");

	precache_sound("monsters/imp/melee/miss_01.wav");
	precache_sound("monsters/imp/melee/miss_02.wav");
	precache_sound("monsters/imp/melee/miss_03.wav");

	precache_sound("monsters/imp/breath_test2.wav");
	precache_sound("monsters/imp/breath_test21.wav");
	precache_sound("monsters/imp/breath_test22.wav");
	precache_sound("monsters/imp/breath_test23.wav");
	precache_sound("monsters/imp/breath_test24.wav");

	precache_sound("monsters/imp/pain_test3.wav");
	precache_sound("monsters/imp/pain_test4.wav");
	precache_sound("monsters/imp/pain_test5.wav");

	spawn_marksman ();
};

void() spawn_marksman =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/ogre.mdl");
	setsize(self, '-32 -32 0', '32 32 88');
	self.health = 200;
	self.max_health = 200;
	self.scale = 0.9;
	self.mass = 300;
	self.pissed = 0;
	self.dcnt = 0;

	if (world.worldtype == 2)
		self.skin = 1;

	self.th_stand = marksman_stand1;
	self.th_walk = marksman_walk1;
	self.th_run = marksman_run;
	self.th_die = marksman_die;
	self.th_melee = marksman_melee;
	self.th_missile = marksman_missile;
	self.th_char = marksman_char;
	self.th_pain = marksman_pain;
	self.th_checkatck = OgreCheckAttack;
	self.th_spawn = spawn_marksman;	
	self.th_dodge = marksman_dodge;	
	self.th_sight = ogre_sight;

	walkmonster_start();
};



