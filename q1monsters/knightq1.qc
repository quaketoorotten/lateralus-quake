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

void() knightq1_stand1 = [ 83, knightq1_stand2 ] { ai_stand();};
void() knightq1_stand2 = [ self.frame, knightq1_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 262) 
	{	
		if (random() < 0.2)
			sound(self, CHAN_VOICE, "knight/idle.wav", 1, ATTN_IDLE);
		knightq1_stand1 ();
		return;
	}
	ai_stand ();
};

void() knightq1_walk1 = [ 54, knightq1_walk2 ] { ai_walk(0); };
void() knightq1_walk2 = [ self.frame, knightq1_walk2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 81) 
	{	
		if (random() < 0.2)
			sound(self, CHAN_VOICE, "knight/idle.wav", 1, ATTN_IDLE);
		knightq1_walk1 ();
		return;
	}
	if (self.frame > 56 && self.frame < 80)
		ai_walk (2);
	else 
		ai_walk (0);
};

void() knightq1_run1 =
{	
	if (random () <= 0.3)	
		knightq1_runa1 ();
	else
		knightq1_runb1 ();
};

void() knightq1_runa1 = [ 54, knightq1_runa2 ] { ai_run(0); };
void() knightq1_runa2 = [ self.frame, knightq1_runa2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 81) 
	{	
		if (random() < 0.2)
			sound(self, CHAN_VOICE, "knight/idle.wav", 1, ATTN_IDLE);
		knightq1_run1 ();
		return;
	}
	
	if (self.frame > 56 && self.frame < 80)
		ai_run (3);
	else 
		ai_run (0);
};

void() knightq1_runb1 = [ 0, knightq1_runb2 ] { ai_run(0); };
void() knightq1_runb2 = [ self.frame, knightq1_runb2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 53) 
	{	
		if (random() < 0.2)
			sound(self, CHAN_VOICE, "knight/idle.wav", 1, ATTN_IDLE);
		knightq1_run1 ();
		return;
	}
	
	if ( (self.frame > 2 && self.frame < 16) || 
		(self.frame > 22 && self.frame < 52) )
		ai_run (6);
	else 
		ai_run (0);
};

void() knightq1_melee = 
{
	if (random() < 0.5)
		knightq1_atka1 ();
	else
		knightq1_atkb1 ();
}

void() knightq1_atka1 = [ 263, knightq1_atka2 ] { ai_face(); self.nextthink = time + 0.04; };
void() knightq1_atka2 = [ self.frame, knightq1_atka2 ] 
{ 	
	self.frame ++;
	
	if (self.frame == 282)
		chainsaw (0);

	if (self.frame >= 294) 
	{	
		knightq1_run1 ();
		return;
	}
	
	if ( (self.frame > 274 && self.frame < 287) )
		ai_charge (6);
	else 
		ai_face ();
	
	self.nextthink = time + 0.04;
};

void() knightq1_atkb1 = [ 340, knightq1_atkb2 ] { ai_face(); self.nextthink = time + 0.04; };
void() knightq1_atkb2 = [ self.frame, knightq1_atkb2 ] 
{ 	
	self.frame ++;
	
	if (self.frame == 357)
		chainsaw (0);

	if (self.frame >= 374) 
	{	
		knightq1_run1 ();
		return;
	}
	
	if ( (self.frame > 349 && self.frame < 360) )
		ai_charge (6);
	else 
		ai_face ();
	
	self.nextthink = time + 0.04;
};

void() knightq1_strafel1 = [ 374, knightq1_strafel2 ] { ai_run_slide(0, 0.02);};
void() knightq1_strafel2 = [ self.frame, knightq1_strafel2 ] 
{ 
	self.frame ++;
	if (self.frame >= 396) 
	{	
		//self.attack_state = AS_STRAIGHT;
		self.flags &= ~FL_DODGED;
		knightq1_run1 ();
		return;
	}

	if (self.frame > 375 && self.frame < 394)
		ai_run_slide (8, 0.02);
	else
		self.nextthink = time + 0.02;
};

void() knightq1_strafer1 = [ 398, knightq1_strafer2 ] { ai_run_slide(0, 0.02);};
void() knightq1_strafer2 = [ self.frame, knightq1_strafer2 ] 
{ 
	self.frame ++;
	if (self.frame >= 421) 
	{	
		//self.attack_state = AS_STRAIGHT;
		self.flags &= ~FL_DODGED;
		knightq1_run1 ();
		return;
	}

	if (self.frame > 403 && self.frame < 412)
		ai_run_slide (8, 0.02);
	else
		self.nextthink = time + 0.02;
};

void() knightq1_dodge =
{	
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	
	ChangeYaw ();

	if(self.lefty)
		knightq1_strafel1 ();
	else
		knightq1_strafer1 ();
	
	self.nextthink = time + frametime;
}

void() maggot_JumpTouch =
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
			self.think = knightq1_jump2;
			self.nextthink = time + 0.04;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
};

void() knightq1_jump1 = [ 309, knightq1_jump2 ] {ai_face ();}
void() knightq1_jump2 = [ self.frame, knightq1_jump2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.04;
	
	if (self.frame >= 316) 
	{	
		self.touch = maggot_JumpTouch;
		makevectors(self.angles);
		self.origin_z = self.origin_z + 1;
		self.velocity = v_forward * 600 + '0 0 100';
		if (self.flags & FL_ONGROUND)
			self.flags = self.flags - FL_ONGROUND;
	
		self.flags |= FL_LEAP;

		knightq1_jump4 ();
		return;
	}
	ai_face ();
};
void() knightq1_jump4 = [ self.frame, knightq1_jump4 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.04;

	if (self.frame == 327)
		self.flags &= ~FL_LEAP;
	
	if (self.frame >= 339) 
	{
		knightq1_run1 ();
		return;
	}
	ai_face ();
};

//===========================================================================

void(entity attacker, float damage) knightq1_pain =
{
	float r;

	if (self.flags & FL_DODGED)
		return;

	if (self.pain_finished > time)
		return;

	r = random();

	sound(self, CHAN_VOICE, "knight/khurt.wav", 1, ATTN_NORM);
	self.pain_finished = time + 3;
};

//===========================================================================


void() knightq1_die =
{	
	if((self.deadflag & DEAD_DEAD))
		return;

	self.skin = 1;
	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_NOT;
	self.think = fiend_die1;
	self.nextthink = time + 0.04;

	MonsterGib (self.health);
};


/*QUAKED monster_knight (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_knight =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/knight.mdl");
	precache_model("progs/h_knight.mdl");

	precache_sound("knight/kdeath.wav");
	precache_sound("knight/khurt.wav");
	precache_sound("knight/ksight.wav");
	precache_sound("knight/sword1.wav");
	precache_sound("knight/sword2.wav");
	precache_sound("knight/idle.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	spawn_knightq1 ();
};

void() spawn_knightq1 =
{
	setmodel(self, "progs/knight.mdl");

	setsize(self, '-16 -16 0', '16 16 88');
	self.health = 160;
	self.max_health = 160;
	self.scale = 0.9;
	self.mass = 150;

	self.th_stand = knightq1_stand1;
	self.th_walk = knightq1_walk1;
	self.th_run = knightq1_run1;
	self.th_melee = knightq1_melee;
	self.th_pain = knightq1_pain;
	self.th_die = knightq1_die;
	self.th_dodge = knightq1_dodge;
	self.th_checkatck = maggotCheckAttack;
	self.th_missile = knightq1_jump1;
	self.th_spawn = spawn_knightq1;

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