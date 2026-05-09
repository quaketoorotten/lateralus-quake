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
	
	makevectors(self.angles);
	vector org = ProjectAim(self.origin, m_gunner_flashoffset[0], v_forward, v_right);

	spot1 = org ;
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
	'0  0  30.7',
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
	imp_jump1 ();

};

//=============================================================================


/*
================
MarksmanFireGrenade
================
*/

void(float dmg) MarksmanFireGrenade =
{
	
	local	vector	dir, org, target;
	local entity en = self.enemy;
		
	sound (self, CHAN_WEAPON, "monsters/imp/fireball_throw_01.wav", 1, ATTN_NORM);
	
	self.effects = self.effects | EF_MUZZLEFLASH;

	makevectors(self.angles);
	org = ProjectAim(self.origin, m_gunner_flashoffset[0], v_forward, v_right);
	
	target = (en.origin - en.velocity*0.2);
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

	dir = v_forward;
	dir = dir + pitch * v_up;
//PGM	

	if (M_CalculatePitchToFire (target, org, dir, 700, 2.5, 0, 0))
		monster_FireGravityBall (org, dir, dmg, 2.5,(crandom() * 10), crandom() * 10, 700);
	else
		monster_FireGravityBall (org, dir, dmg, 2.5,(crandom() * 10), 200 + (crandom() * 10), 700);
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
	
	ogre_miss ();

	if (!self.enemy)
		return;
	if (!CanDamage(self.enemy, self))
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;

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

//=============================================================================


void() imp_stand1 = [ 0, imp_stand2 ] { ai_stand();};
void() imp_stand2 = [ self.frame, imp_stand2 ] 
{ 	
	//bprint("how","\n");
	self.frame ++;
	if (self.frame >= 79) 
	{
		if (random() < 0.2)
			ogre_idle ();

		imp_stand1 ();
		return;
	}
	ai_stand ();
};


void() imp_walk1 = [ 198, imp_walk2 ] { ai_walk(2.5);};
void() imp_walk2 = [ self.frame, imp_walk2 ] 
{ 
	self.frame ++;
	if (self.frame >= 233) 
	{	
		if (random() < 0.2)
			ogre_idle ();

		imp_walk1 ();
		return;
	}

	if ( (self.frame > 200 && self.frame < 207) || (self.frame > 214 && self.frame < 222) )
		ai_walk (1);
	else
		ai_walk (2.5);
};

void() imp_run =
{	
//	bprint (ftos(fabs(self.origin_z - self.enemy.origin_z)), "\n");
	if (random () <= 0.5 && fabs(self.origin_z - self.enemy.origin_z) <= 24
		&& visible(self.enemy) && range (self.enemy) <= RANGE_CLOSE)	
	{
		imp_scurry1 ();
	}
	else
	{
		//self.maxs_z = 64; 
		imp_run1 ();
	}
};

void() imp_run1 = [ 198, imp_run2 ] {self.maxs_z = 64;  ai_run(2.5); };
void() imp_run2 = [ self.frame, imp_run2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 233) 
	{	
		if (random() < 0.2)
			ogre_idle ();

		if (random() < 0.4)
		{
			imp_run ();
			return;
		}
		imp_run1 ();
		return;
	}
	
	if ( (self.frame > 200 && self.frame < 207) || (self.frame > 214 && self.frame < 222) )
		ai_run (1);
	else
		ai_run (2.5);
};

void() imp_scurry1 = [ 80, imp_scurry2 ] {self.maxs_z = 28;  ai_run(4); };
void() imp_scurry2 = [ self.frame, imp_scurry2 ] 
{ 
	self.frame ++;
	if (self.frame >= 97) 
	{	
		if (random() < 0.6)
		{
			imp_run ();
			return;
		}

		imp_scurry1 ();
		return;
	}
	
	ai_run (4);
};

void() imp_JumpTouch =
{
	float ldmg;

	if (self.health <= 0)
		return;

	if (other.takedamage)
	{
		if (vlen(self.velocity) > 100)
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
			self.think = imp_jump2;
			self.nextthink = time + 0.035;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
};

void() imp_jump1 = [ 98, imp_jump2 ] 
{ 	
	ai_face();
	self.nextthink = time + 0.035;
};
void() imp_jump2 = [ self.frame, imp_jump2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.035;

	if (self.frame == 113)
		ogre_sight2 ();

	if (self.frame == 117)
	{
		self.touch = imp_JumpTouch;
		makevectors(self.angles);
		self.origin_z = self.origin_z + 1;
		self.velocity = v_forward * 600 + '0 0 250';
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
		imp_run1 ();
		return;
	}

	ai_face ();
};

void() imp_char =
{	
	self.maxs_z = 64;
	if(random() <= 0.5)
		imp_achar1 ();
	else
		imp_bchar1 ();
	
	ogre_sight2 ();
};

void() imp_achar1 = [ 247, imp_achar2 ] {spawn_fireball(247, 0, 44); ai_charge(2.5); self.nextthink = time + 0.03;};
void() imp_achar2 = [ self.frame, imp_achar2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;
	if (self.frame >= 306) 
	{	
		imp_run1 ();
		return;
	}

	if (self.frame == 291)
		MarksmanFireGrenade (60);
	
	if ( (self.frame > 265 && self.frame < 267) || (self.frame > 282 && self.frame < 284) )
		return;
	
	if ( (self.frame > 301 && self.frame < 307) )
		ai_charge(5);
	else
		ai_charge(6);
};

void() imp_bchar1 = [ 307, imp_bchar2 ] {spawn_fireball(307, 60, 81); ai_charge(2.5); self.nextthink = time + 0.035;};
void() imp_bchar2 = [ self.frame, imp_bchar2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.035;

	if (self.frame == 328)
		MarksmanFireGrenade (60);

	if (self.frame >= 339) 
	{	
		imp_run1 ();
		return;
	}
	
	if ( (self.frame > 310 && self.frame < 314) || (self.frame > 324 && self.frame < 328) )
		return;

	ai_charge (2.5);
};

static float(float rad2)	inNaziRange2 =
{	
	local entity targ = self.enemy;
	local vector spot1 = self.origin + self.view_ofs;
	local vector spot2 = targ.origin + targ.view_ofs;

	if (vlen(spot1 - spot2) <= rad2)
		return TRUE;
	
	return FALSE;
};

static float(float rad2)	inNaziRange =
{	
	local entity targ = self.enemy;
	local vector spot1 = self.origin + self.view_ofs;
	local vector spot2 = targ.origin + targ.view_ofs;

	if (vlen(spot1 - spot2) >= rad2)
		return TRUE;
	
	return FALSE;
};

void() imp_missile 
{
	if (self.maxs_z < 64)
	{	
		if (inNaziRange2 (200))
			imp_jump1();
		else
			imp_run1();
		return;
	}
	
	ogre_sight2 ();
	self.maxs_z = 64;

	if (inNaziRange (500) && random() <= 0.4)
	{
		imp_achar1();
		return;
	}	

	imp_nail1 ();
};

void() imp_nail1 = [ 339, imp_nail2 ] {spawn_fireball(339, 93, 115); self.maxs_z = 64; ai_face(); self.nextthink = time + 0.035;};
void() imp_nail2 = [ self.frame, imp_nail2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.035;

	if (self.frame == 361)
		MarksmanFireGrenade (60);

	if (self.frame >= 375) 
	{	
		SUB_CheckRefire (imp_nail1);
		imp_run ();
		return;
	}

	ai_face();
};

void() imp_meleea1 = [ 491, imp_meleea2 ] {	ai_face ();	 self.nextthink = time + 0.035;};
void() imp_meleea2 = [ self.frame, imp_meleea2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.035;
	if (self.frame >= 511) 
	{	
		imp_run1 ();
		return;
	}

	if (self.frame == 496)
		chainsaw (0);
	
	if (self.frame < 497)
		ai_face ();	
};

void() imp_meleeb1 = [ 512, imp_meleeb2 ] { ai_face ();	self.nextthink = time + 0.035;};
void() imp_meleeb2 = [ self.frame, imp_meleeb2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.035;

	if (self.frame >= 537) 
	{	
		imp_run1 ();
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

void() imp_pain1 = [ 234, imp_pain2 ] {self.nextthink = time + 0.035;};
void() imp_pain2 = [ self.frame, imp_pain2 ] 
{
	self.frame ++;
	self.nextthink = time + 0.035;

	if (self.frame >= 246) 
	{	
		imp_run ();
		return;
	}

};

void() imp_strafel1 = [ 385, imp_strafel2 ] { self.nextthink = time + 0.03;};
void() imp_strafel2 = [ self.frame, imp_strafel2 ] 
{ 
	self.frame ++;
	if (self.frame >= 419) 
	{	
		self.flags &= ~FL_DODGED;
		imp_run ();
		return;
	}

	if (self.frame > 385 && self.frame < 396)
		ai_slide (3.5, 0.03);
	else if (self.frame < 412 && self.frame > 396)
		ai_slide (1.5, 0.03);
	else
		self.nextthink = time + 0.03;
};

void() imp_strafer1 = [ 428, imp_strafer2 ] {self.nextthink = time + 0.03;};
void() imp_strafer2 = [ self.frame, imp_strafer2 ] 
{ 
	self.frame ++;
	if (self.frame >= 464) 
	{	
		self.flags &= ~FL_DODGED;
		imp_run ();
		return;
	}

	if (self.frame > 429 && self.frame < 444)
		ai_slide (4.5, 0.03);
	else if (self.frame < 455 && self.frame > 444)
		ai_slide (2.2, 0.03);
	else
		self.nextthink = time + 0.03;
};

void() imp_dodge =
{	
	self.maxs_z = 28; 
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	
	ChangeYaw ();
	
	if(self.lefty)
		imp_strafel1 ();
	else
		imp_strafer1 ();
	
	self.nextthink = time + frametime;
}


void(entity attacker, float damage) imp_pain =
{
// don't make multiple pain sounds right after each other
	if (self.pain_finished > time)
		return;
	
	if (self.flags & FL_DODGED)
		return;

	if (self.touch == imp_JumpTouch)
		return;

	if (damage < 25)
		return;
	
	ogre_pain ();

	imp_pain1();
	self.pain_finished = time + 3;
};

void() imp_die =
{	
	if (self.health < -90)
	{	
		
		self.deadflag = DEAD_DEAD;
		self.solid = SOLID_NOT;
		self.think = imp_gib1;
		self.nextthink = time + 0.035;
		return;
	}
	
	if((self.deadflag & DEAD_DEAD))
		return;

	ogre_die ();

	local vector tmpangle;
	local float tempskin;
	tmpangle = self.angles;
	tempskin = self.skin;

	if (self.maxs_z < 64) // is scurrying ? gtfo
	{
		setmodel(self, "progs/ogredeath2.md3");
		self.think = imp_diec1;
	}
	else if (random() <= 0.5)
	{
		setmodel(self, "progs/ogredeath.md3");
		self.think = imp_diea1;
	}
	else 
	{
		setmodel(self, "progs/ogredeath3.md3");
		self.think = imp_dieb1;
	}
	
	setsize(self, '-16 -16 0', '16 16 64');

	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_CORPSE;
	
	self.nextthink = time + 0.035;
	//bprint ("hi","/n");

	self.angles = tmpangle;
	//self.skin = tempskin;
};

void() imp_diea1 = [ 0, imp_diea2 ] { self.nextthink = time + 0.035;};
void() imp_diea2 = [ self.frame, imp_diea2 ] 
{ 	
	//bprint("eek","\n");
	self.nextthink = time + 0.035;

	if (self.frame < 10)
		ai_move (-4);
	self.frame ++;
	if (self.frame == 20)
	{
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() imp_dieb1 = [ 0, imp_dieb2 ] { self.nextthink = time + 0.035;};
void() imp_dieb2 = [ self.frame, imp_dieb2 ] 
{ 	
	self.nextthink = time + 0.035;
	//bprint("eek","\n");
	if (self.frame < 10)
		ai_move (-4);
	self.frame ++;
	if (self.frame == 22)
	{
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() imp_diec1 = [ 0, imp_diec2 ] { self.nextthink = time + 0.035;};
void() imp_diec2 = [ self.frame, imp_diec2 ] 
{ 	
	self.nextthink = time + 0.035;

	self.frame ++;
	if (self.frame == 26)
	{
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() imp_gib1 = [ self.frame, imp_gib2 ] 
{MonsterGib (self.health); self.skin = 2; self.alpha = 1; self.nextthink = time + 0.02;};

void() imp_gib2 = [ self.frame, imp_gib2 ] 
{ 	
	self.nextthink = time + 0.02;
	self.alpha -= 0.02;
	if (self.alpha <= 0)
	{
		remove(self);
		return;
	}
};

void() imp_melee =
{		
	if (self.maxs_z < 64)
		imp_jump1 ();
	else if (random() <= 0.5)
		imp_meleea1 ();
	else
		imp_meleeb1 ();

	return;
};

static void() ogre_sight2 =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/imp/sight2_01.wav", 0.97, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/imp/sight2_02.wav", 0.97, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/imp/sight2_03.wav", 0.97, ATTN_NORM);
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
		    sound(self, CHAN_VOICE, "monsters/imp/imp_death_01.wav", 0.97, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/imp/imp_death_02.wav", 0.97, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/imp/imp_death_03.wav", 0.97, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/imp/imp_death_04.wav", 0.97, ATTN_NORM);
};

/*QUAKED monster_ogre (1 0 0) (-32 -32 -24) (32 32 64) Ambush

*/

void() monster_ogre_cache =
{
	precache_model("progs/ogre.md3");
	precache_model("progs/ogredeath.md3");
	precache_model("progs/ogredeath2.md3");
	precache_model("progs/ogredeath3.md3");

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
};

void() monster_ogre =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	monster_ogre_cache ();

	spawn_imp ();
};

void() spawn_imp =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/ogre.md3");
	setsize(self, '-16 -16 0', '16 16 64');
	self.health = 168;
	self.max_health = 168;
	self.scale = 0.86;
	self.mass = 150;
	self.pissed = 0;
	self.dcnt = 0;

	if (world.worldtype == 2)
		self.skin = 1;

	self.th_stand = imp_stand1;
	self.th_walk = imp_walk1;
	self.th_run = imp_run;
	self.th_die = imp_die;
	self.th_melee = imp_melee;
	self.th_missile = imp_missile;
	self.th_char = imp_char;
	self.th_pain = imp_pain;
	self.th_checkatck = OgreCheckAttack;
	self.th_spawn = spawn_imp;	
	self.th_dodge = imp_dodge;	
	self.th_sight = ogre_sight;
	self.deathtype = "was jumpscared by an Imp";

	walkmonster_start();
};

vector impmissile_org[] = {
'26.24 -8.20 59.39', // frame 0
'26.24 -4.73 59.39', // frame 1
'25.45 0.01 59.79', // frame 2
'23.87 4.74 59.39', // frame 3
'21.89 8.84 58.99', // frame 4
'19.53 11.68 58.60', // frame 5
'17.55 13.58 58.20', // frame 6
'16.37 14.21 57.40', // frame 7
'16.76 13.26 57.00', // frame 8
'18.34 10.42 56.60', // frame 9
'20.32 3.48 54.61', // frame 10
'21.10 -7.57 53.01', // frame 11
'17.55 -20.82 52.61', // frame 12
'7.29 -30.92 51.01', // frame 13
'-5.34 -34.07 49.42', // frame 14
'-14.82 -31.55 48.62', // frame 15
'-19.95 -28.08 48.22', // frame 16
'-24.68 -23.66 47.82', // frame 17
'-27.84 -19.24 48.22', // frame 18
'-31.00 -14.51 48.62', // frame 19
'-32.97 -10.09 49.42', // frame 20
'-34.95 -4.73 50.22', // frame 21
'-36.53 1.58 50.22', // frame 22
'-36.92 7.26 49.82', // frame 23
'-37.32 10.42 49.02', // frame 24
'-37.32 12.00 48.22', // frame 25
'-36.92 12.95 47.42', // frame 26
'-35.74 13.89 45.03', // frame 27
'-33.76 14.84 41.84', // frame 28
'-31.00 15.79 38.25', // frame 29
'-28.63 16.10 34.26', // frame 30
'-27.05 16.10 30.27', // frame 31
'-26.26 15.15 27.07', // frame 32
'-25.87 13.89 24.28', // frame 33
'-25.47 10.42 21.89', // frame 34
'-23.89 7.26 21.09', // frame 35
'-21.13 3.48 21.49', // frame 36
'-19.95 -0.31 22.28', // frame 37
'-27.45 -3.78 23.88', // frame 38
'-39.68 -8.20 29.07', // frame 39
'-46.79 -20.50 54.61', // frame 40
'-38.10 -29.66 70.57', // frame 41
'-24.68 -33.44 83.33', // frame 42
'22.29 -35.34 88.92', // frame 43
'49.92 4.74 64.58', // frame 44
'29.00 27.15 41.84', // frame 45
'8.47 31.88 41.44', // frame 46
'-4.95 33.14 46.23', // frame 47
'-13.63 33.14 50.22', // frame 48
'-18.37 30.93 51.41', // frame 49
'-19.16 27.78 49.82', // frame 50
'-17.58 25.25 47.42', // frame 51
'-15.21 23.36 45.83', // frame 52
'-12.05 23.36 44.23', // frame 53
'-6.53 24.62 39.44', // frame 54
'2.55 23.67 35.45', // frame 55
'13.60 17.68 33.46', // frame 56
'22.29 6.32 34.26', // frame 57
'25.05 -8.83 36.65', // frame 58
'21.10 -22.71 40.24', // frame 59
'28.21 -1.26 51.01', // frame 60
'27.03 -1.26 50.62', // frame 61
'25.45 -1.89 50.22', // frame 62
'23.47 -3.15 50.62', // frame 63
'21.50 -4.73 51.41', // frame 64
'19.13 -6.62 52.61', // frame 65
'15.97 -8.51 54.61', // frame 66
'12.82 -9.78 57.40', // frame 67
'9.26 -10.09 60.19', // frame 68
'6.50 -10.41 62.59', // frame 69
'6.89 -9.78 64.18', // frame 70
'4.13 -10.41 66.18', // frame 71
'7.29 -12.93 71.76', // frame 72
'5.71 -14.82 78.55', // frame 73
'3.34 -14.51 88.52', // frame 74
'-4.55 -11.98 96.50', // frame 75
'-12.84 -10.41 99.30', // frame 76
'-22.32 -18.30 94.11', // frame 77
'-23.89 -29.02 84.93', // frame 78
'-7.71 -45.12 72.96', // frame 79
'37.29 -32.50 68.57', // frame 80
'47.55 -14.51 56.20', // frame 81
'47.16 -1.89 47.82', // frame 82
'34.13 12.31 35.05', // frame 83
'21.50 12.31 28.67', // frame 84
'12.82 11.05 29.47', // frame 85
'11.24 11.05 34.65', // frame 86
'13.21 8.84 39.84', // frame 87
'15.97 0.95 41.44', // frame 88
'18.74 -8.83 42.63', // frame 89
'22.29 -13.88 46.23', // frame 90
'25.45 -13.88 51.81', // frame 91
'26.24 -11.98 56.60', // frame 92
'26.24 -1.57 45.03', // frame 93
'23.87 -2.83 44.63', // frame 94
'21.10 -4.41 44.63', // frame 95
'18.34 -6.30 44.63', // frame 96
'15.18 -8.51 44.63', // frame 97
'11.63 -10.41 45.43', // frame 98
'7.68 -11.67 46.23', // frame 99
'4.13 -12.30 47.42', // frame 100
'0.58 -12.62 48.22', // frame 101
'0.18 -11.98 49.02', // frame 102
'-3.37 -12.93 50.62', // frame 103
'-1.39 -16.09 55.40', // frame 104
'-3.37 -19.24 62.98', // frame 105
'-5.34 -20.19 74.16', // frame 106
'-10.08 -19.56 84.53', // frame 107
'-16.79 -19.87 90.52', // frame 108
'-29.82 -25.24 88.92', // frame 109
'-37.32 -29.97 81.34', // frame 110
'-22.32 -43.22 67.77', // frame 111
'25.45 -42.28 64.98', // frame 112
'43.60 -34.70 54.21', // frame 113
'52.29 -22.71 46.62', // frame 114
'51.10 0.32 36.65', // frame 115
'42.03 9.16 32.26', // frame 116
'33.74 12.00 32.66', // frame 117
'30.18 13.89 36.25', // frame 118
'29.39 15.47 39.44', // frame 119
'29.39 14.84 40.64', // frame 120
'30.18 12.63 41.44', // frame 121
'30.97 11.05 44.63', // frame 122
'31.37 9.79 47.82', // frame 123
'32.95 7.58 50.22', // frame 124
'33.74 3.16 49.02', // frame 125
'31.37 0.01 46.23', // frame 126
'29.39 0.32 44.63', // frame 127
'28.60 0.64 44.63', // frame 128
'-10.87 -28.39 48.62', // frame 129
};

static void() imp_fireball_update_pos =
{	
	if ((self.arraynumfire + (self.owner.frame - self.startfire) >= self.endfire) || self.owner.think == imp_pain1 
		|| self.owner.think == imp_pain2 || self.owner.think == imp_strafel1 || self.owner.think == imp_strafel2 
		|| self.owner.think == imp_strafer1 || self.owner.think == imp_strafer2 
		|| self.owner.health <= 0)
	{
		remove(self);
		return;
	}

	vector f, r, u;
	AngleVectors(self.owner.angles, f, r, u);
	vector org = ProjectAim(self.owner.origin, impmissile_org[self.arraynumfire + (self.owner.frame - self.startfire)] * 0.7, f, -1*r);	
	
	//bprint (ftos(self.arraynumfire + (self.owner.frame - self.startfire)),"\n");
	self.origin = org;
	
	self.think = imp_fireball_update_pos;
	self.nextthink = time;
};

static void(float start, float arrnum, float end) spawn_fireball =
{
	local entity e;

	makevectors(self.angles);
	vector org = ProjectAim(self.origin, impmissile_org[arrnum + (self.frame - start)] * 0.7, v_forward, -1*v_right);	
	
	e = spawn ();
	setmodel (e, "progs/muzzleflash.spr");
	
	setsize (e, '0 0 0', '0 0 0');
	//
	setorigin (e, self.origin);
	e.origin = org;
	e.emiteffectnum = particleeffectnum ("TE_IMP_FIREBALL");
	e.traileffectnum = particleeffectnum ("EF_NADETRAIL");
	
	e.startfire = start;
	e.endfire = end - 3;
	e.arraynumfire = arrnum;

	e.owner = self;
	e.think = imp_fireball_update_pos;
	e.nextthink = time;
	//e.ltime = removeframe;
	
	sound(self, CHAN_WEAPON, "monsters/imp/fireball_create_02.wav", 1, ATTN_NORM);	
};


