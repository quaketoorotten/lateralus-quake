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

static void(float side) punct_t =
{
	vector delta;
	float ldmg;
	
	punct_whoosh();
	if (!self.enemy)
		return;
	if (!CanDamage(self.enemy, self))
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
	{
		//ogre_miss ();
		return;
	}

	ldmg = (random() + random() + random()) * 16;

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

static void(float side, float r = 170) chainsaw_puncture =
{	
	punct_squish ();
	vector dir, loc, org;

	makevectors(self.angles);
	org = self.origin + '0 0 48';
	loc = org + v_right * 8;

	dir = self.pos1 - org;
	dir = normalize (dir);

//	THING(loc);

	fireRail (loc, dir, self, self, 6 + random()*18, 15, r);

};

void() tcommando_stand1 = [ 0, tcommando_stand2 ] { ai_stand();};
void() tcommando_stand2 = [ self.frame, tcommando_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 199) 
	{	
		if (random() < 0.2)
			punct_idle ();
		tcommando_stand1 ();
		return;
	}
	ai_stand ();
};

void() tcommando_walk1 = [ 200, tcommando_walk2 ] { ai_walk(3); };
void() tcommando_walk2 = [ self.frame, tcommando_walk2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 259) 
	{	
		if (random() < 0.2)
			punct_idle ();
		tcommando_walk1 ();
		return;
	}
	ai_walk (3);
};

void() tcommando_run1 = [ 260, tcommando_run2 ] { ai_run(8); };
void() tcommando_run2 = [ self.frame, tcommando_run2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 315) 
	{	
		if (random() < 0.2)
			punct_idle ();
		tcommando_run1 ();
		return;
	}
	
	ai_run (8);
};

void() tcommando_strafe1 = [ 260, tcommando_strafe2 ] { ai_slide(5, 0.03); };
void() tcommando_strafe2 = [ self.frame, tcommando_strafe2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 270) 
	{	
		self.flags &= ~FL_DODGED;
		tcommando_run1 ();
		return;
	}
	
	ai_slide (5, 0.03);
};

void() tcommando_dodge =
{	
	if (random() <= 0.3)
		return;

	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	
	ChangeYaw ();

	tcommando_strafe1 ();
	
	self.nextthink = time + frametime;
}

void() tcommando_missile = 
{	
	punct_range ();
	if (random() < 0.5)
		tcommando_atka1 ();
	else
		tcommando_atkb1 ();
}

void() tcommando_atka1 = [ 316, tcommando_atka2 ] { ai_charge (6); self.nextthink = time + 0.035; };
void() tcommando_atka2 = [ self.frame, tcommando_atka2 ] 
{ 	
	self.frame ++;
	
	if(self.frame == 342)
		self.pos1 = self.enemy.origin;

	if (self.frame > 344 && self.frame < 347)
	{
		chainsaw_puncture (0);
	}

	if (self.frame >= 360) 
	{	
		tcommando_run1 ();
		return;
	}
	
	if (self.frame < 340)
		ai_charge (6.7);
	if (self.frame > 340 && self.frame < 342)
		ai_face ();
	if (self.frame > 354)
		ai_move (3);
	if (self.frame > 340 && self.frame < 352)
		ai_move (1.5);
	
	self.nextthink = time + 0.035;
};

void() tcommando_atkb1 = [ 361, tcommando_atkb2 ] {ai_charge (3); self.nextthink = time + 0.035; };
void() tcommando_atkb2 = [ self.frame, tcommando_atkb2 ] 
{ 	
	self.frame ++;
	
	if(self.frame == 379)
		self.pos1 = self.enemy.origin;

	if (self.frame > 383 && self.frame < 386)
	{	
		chainsaw_puncture (0);
	}

	if (self.frame >= 399) 
	{	
		tcommando_run1 ();
		return;
	}
	
	if (self.frame < 379)
		ai_charge (3);
	else 	
		ai_move (3);
	
	self.nextthink = time + 0.035;
};

void() tcommando_melee = 
{	
	punct_melee ();
	if (random() < 0.5)
		tcommando_puncha1 ();
	else
		tcommando_punchb1 ();
}

void() tcommando_puncha1 = [ 440, tcommando_puncha2 ] {ai_charge (3); self.nextthink = time + 0.035; };
void() tcommando_puncha2 = [ self.frame, tcommando_puncha2 ] 
{ 	
	self.frame ++;

	if (self.frame == 450)
	{	
		punct_t (0);
	}

	if (self.frame >= 464) 
	{	
		tcommando_run1 ();
		return;
	}
	
	if (self.frame < 450)
		ai_charge (3);
	else 	
		ai_move (3);
	
	self.nextthink = time + 0.035;
};

void() tcommando_punchb1 = [ 466, tcommando_punchb2 ] {ai_charge (1); self.nextthink = time + 0.035; };
void() tcommando_punchb2 = [ self.frame, tcommando_punchb2 ] 
{ 	
	self.frame ++;
	
	if(self.frame == 474)
		self.pos1 = self.enemy.origin;

	if (self.frame > 475 && self.frame < 480)
	{	
		chainsaw_puncture (0, 130);
	}

	if (self.frame >= 492) 
	{	
		tcommando_run1 ();
		return;
	}
	
	if (self.frame < 466)
		ai_charge (2);
	if (self.frame > 466 && self.frame < 483)	
		ai_move (3);
	if (self.frame > 483 && self.frame < 490)
		ai_move (-1);
	if (self.frame > 492)
		ai_move (1);	
	
	self.nextthink = time + 0.035;
};

void() tcommando_pain1 = [ 493, tcommando_pain2 ] {ai_move (1); self.nextthink = time + 0.035; };
void() tcommando_pain2 = [ self.frame, tcommando_pain2 ] 
{ 	
	self.frame ++;

	if (self.frame >= 512) 
	{	
		tcommando_run1 ();
		return;
	}
	
	ai_move (1);
	
	self.nextthink = time + 0.035;
};


//===========================================================================

void(entity attacker, float damage) tcommando_pain =
{
	if (self.pain_finished > time)
		return;

	if (random()*200 > damage)
		return; // didn't flinch

	if (self.flags & FL_DODGED)
		return;

	tcommando_pain1 ();

	punct_pain();
	self.pain_finished = time + 3;
};

//===========================================================================


void() tcommando_die =
{	
	if (self.health < -100)
	{	
		self.deadflag = DEAD_DEAD;
		self.solid = SOLID_NOT;
		self.think = tcommando_gib1;
		self.nextthink = time + 0.035;
		return;
	}
	
	if((self.deadflag & DEAD_DEAD))
		return;

	local vector tmpangle;
	local float tempskin;
	tmpangle = self.angles;
	tempskin = self.skin;
	
	if (random () <= 0.5)
	{
		self.think = tcommando_die1;
		setmodel(self, "progs/puncturerdie.md3");
	}
	else
	{
		self.think = tcommando_dieb1;
		setmodel(self, "progs/puncturerdie2.md3");
	}

	setsize(self, '-16 -16 0', '16 16 64');
	
	punct_die();
	
	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_CORPSE;
	self.nextthink = time + 0.035;

	self.angles = tmpangle;
	//self.skin = tempskin;
};

void() tcommando_die1 = [ 0, tcommando_die2 ] { self.nextthink = time + 0.035;};
void() tcommando_die2 = [ self.frame, tcommando_die2 ] 
{ 	
	self.nextthink = time + 0.035;

	self.frame ++;
	if (self.frame < 6)
		ai_move (-6);
	
	if (self.frame == 22)
	{
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() tcommando_dieb1 = [ 0, tcommando_dieb2 ] { self.nextthink = time + 0.035;};
void() tcommando_dieb2 = [ self.frame, tcommando_dieb2 ] 
{ 	
	self.nextthink = time + 0.035;

	self.frame ++;
	if (self.frame < 6)
		ai_move (-6);
	
	if (self.frame == 22)
	{
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() tcommando_gib1 = [ self.frame, tcommando_gib2 ] 
{MonsterGib (self.health); self.skin = 1; self.alpha = 1; self.nextthink = time + 0.02;};

void() tcommando_gib2 = [ self.frame, tcommando_gib2 ] 
{ 	
	self.nextthink = time + 0.02;
	self.alpha -= 0.02;
	if (self.alpha <= 0)
	{
		remove(self);
		return;
	}
};


/*QUAKED monster_puncturer (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/

static void() punct_sight =
{
	local float r = rint(random() * 4);	

	if (r == 4)
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/site1.wav", 1, ATTN_NORM);
	else if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/site3_you.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/site6_die.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/site11_youwilldie.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/site2.wav", 1, ATTN_NORM);
};


static void() punct_idle =
{
	local float r = rint(random() * 4);	

	if (r == 4)
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/idle_breath1.wav", 1, ATTN_IDLE);
	else if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/idle_breath2.wav", 1, ATTN_IDLE);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/idle_breath3.wav", 1, ATTN_IDLE);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/idle_breath4.wav", 1, ATTN_IDLE);
	else
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/idle_breath10.wav", 1, ATTN_IDLE);
};

static void() punct_die =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/death1.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/death2.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/death3.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/death4.wav", 1, ATTN_NORM);
};

static void() punct_melee =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/melee1_1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/melee2_1.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/melee3_1.wav", 1, ATTN_NORM);
};

static void() punct_range =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/range1_1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/range2_1.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/range3_1.wav", 1, ATTN_NORM);
};

static void() punct_pain =
{
	local float r = rint(random() * 4);	

	if (r == 4)
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/pain1.wav", 1, ATTN_NORM);
	else if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/pain2.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/pain3.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/pain4.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/zombie_commando/pain1.wav", 1, ATTN_NORM);
};

static void() punct_whoosh =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_WEAPON, "monsters/zombie_commando/whooshes/whoosh1_deep.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_WEAPON, "monsters/zombie_commando/whooshes/whoosh2_deep.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_WEAPON, "monsters/zombie_commando/whooshes/whoosh5_deeper.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_WEAPON, "monsters/zombie_commando/whooshes/whoosh6_deeper.wav", 1, ATTN_NORM);
};

static void() punct_squish =
{
	local float r = rint(random() * 4);	

	if (r == 4)
		    sound(self, CHAN_WEAPON, "monsters/zombie_commando/squishes/squish4.wav", 1, ATTN_NORM);
	else if (r == 3)
		    sound(self, CHAN_WEAPON, "monsters/zombie_commando/squishes/squish5.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_WEAPON, "monsters/zombie_commando/squishes/squish6.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_WEAPON, "monsters/zombie_commando/squishes/squish7.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_WEAPON, "monsters/zombie_commando/squishes/squish8.wav", 1, ATTN_NORM);
};


void() monster_puncturer_cache =
{
	precache_model("progs/puncturer.md3");
	precache_model("progs/puncturerdie.md3");
	precache_model("progs/puncturerdie2.md3");

	precache_sound("monsters/zombie_commando/site1.wav");
	precache_sound("monsters/zombie_commando/site2.wav");
	precache_sound("monsters/zombie_commando/site3_you.wav");
	precache_sound("monsters/zombie_commando/site6_die.wav");
	precache_sound("monsters/zombie_commando/site11_youwilldie.wav");

	precache_sound("monsters/zombie_commando/whooshes/whoosh1_deep.wav");
	precache_sound("monsters/zombie_commando/whooshes/whoosh2_deep.wav");
	precache_sound("monsters/zombie_commando/whooshes/whoosh5_deeper.wav");
	precache_sound("monsters/zombie_commando/whooshes/whoosh6_deeper.wav");

	precache_sound("monsters/zombie_commando/squishes/squish4.wav");
	precache_sound("monsters/zombie_commando/squishes/squish5.wav");
	precache_sound("monsters/zombie_commando/squishes/squish6.wav");
	precache_sound("monsters/zombie_commando/squishes/squish7.wav");
	precache_sound("monsters/zombie_commando/squishes/squish8.wav");

	precache_sound("monsters/zombie_commando/melee1_1.wav");
	precache_sound("monsters/zombie_commando/melee2_1.wav");
	precache_sound("monsters/zombie_commando/melee3_1.wav");

	precache_sound("monsters/zombie_commando/range1_1.wav");
	precache_sound("monsters/zombie_commando/range2_1.wav");
	precache_sound("monsters/zombie_commando/range3_1.wav");

	precache_sound("monsters/zombie_commando/idle_breath1.wav");
	precache_sound("monsters/zombie_commando/idle_breath2.wav");
	precache_sound("monsters/zombie_commando/idle_breath3.wav");
	precache_sound("monsters/zombie_commando/idle_breath4.wav");
	precache_sound("monsters/zombie_commando/idle_breath10.wav");

	precache_sound("monsters/zombie_commando/pain1.wav");
	precache_sound("monsters/zombie_commando/pain2.wav");
	precache_sound("monsters/zombie_commando/pain3.wav");
	precache_sound("monsters/zombie_commando/pain4.wav");

	precache_sound("monsters/zombie_commando/death1.wav");
	precache_sound("monsters/zombie_commando/death2.wav");
	precache_sound("monsters/zombie_commando/death3.wav");
	precache_sound("monsters/zombie_commando/death4.wav");
};

void() monster_puncturer =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	monster_puncturer_cache ();

	spawn_puncturer ();

};

void() spawn_puncturer =
{
	setmodel(self, "progs/puncturer.md3");

	setsize(self, '-16 -16 0', '16 16 64');
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	self.health = 270;
	self.max_health = 270;
	self.scale = 0.76;
	self.mass = 180;
	
	self.th_stand = tcommando_stand1;
	self.th_walk = tcommando_walk1;
	self.th_run = tcommando_run1;
	self.th_melee = tcommando_melee;
	self.th_missile = tcommando_missile;
	self.th_pain = tcommando_pain;
	self.th_die = tcommando_die;
	self.th_checkatck = punctCheckAttack;
	self.th_spawn = spawn_puncturer;
	self.th_sight = punct_sight;
	self.th_dodge = tcommando_dodge;
	self.deathtype = "was penetrated by a Commando";

	walkmonster_start();
};	


/*
==============
CheckDemonMelee

Returns TRUE if a melee attack would hit right now
==============
*/

static float() punctCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;

	targ = self.enemy;

	vector loc, org;

	makevectors(self.angles);
	org = self.origin + '0 0 48';
	loc = org + v_right * 8;
	
// see if any entities are in the way of the shot
	spot1 = org + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);
	
	if (trace_ent != targ)
		return FALSE;		// don't have a clear shot
			
	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (enemy_range == RANGE_MELEE)
	{	
		self.attack_state = AS_MELEE;
		return TRUE;
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
	else
		return FALSE;

	if (skill == 0)
		chance *= 0.5;
	if (skill >= 2)
		chance *= 1.5;

	if (random () < chance)
	{
		self.attack_state = AS_MISSILE;
		SUB_AttackFinished (0.5 + 2*random());
		return TRUE;
	}

	return FALSE;
};
