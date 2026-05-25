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

static void(float side) punct_sheol =
{
	vector delta;
	float ldmg;
	
	//sound(self, CHAN_WEAPON, "monsters/vulgar/vulg_swing.wav", 1, ATTN_NORM);

	if (!self.enemy)
		return;
	if (!CanDamage(self.enemy, self))
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 130)
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

static void(float off, float off2 = 0) sheol_fire =
{	
	vul_fire ();
	sheol_Missile (off, off2, 0);
};

 void() sheol_MissileTouch =
{	
	//bprint("buh?", "\n");
	if (other == self.owner)
		return; // don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
    {
        remove(self);
        return;
    }

	if (other.classname == "monster_zombie")
		T_Damage(other, self, self.origin, self, 110, 0);
	T_RadiusDamage(self, self.owner, self.dmg, 90, world);
	//sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);

		rocketimpact  ();

	BecomeExplosion ();
};

static void(float off, float off2, float off3) sheol_Missile =
{
	entity missile;
	vector dir, org;

	self.effects = self.effects | EF_MUZZLEFLASH;

	missile = spawn();
	missile.owner = self;

	missile.solid = SOLID_BBOX;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.classname = "green";
	setmodel(missile, "progs/muzzleflash.spr");
	missile.shake_interval = 0.4;
	missile.shake_time = 0.8;

	setsize(missile, '0 0 0', '0 0 0');
	
	makevectors(self.angles);

	org = self.origin + '0 0 30' + v_right * off + v_up * off2 + v_forward * off3;
	dir = normalize((self.enemy.origin + '0 0 10') - org);

	setorigin(missile, org);
	
	missile.velocity = dir * 400;
	missile.avelocity = '300 300 300';
	missile.nextthink = time + 6;
	missile.think = SUB_Remove;
	missile.dmg = 80;
	missile.touch = sheol_MissileTouch;
	missile.emiteffectnum = particleeffectnum ("TE_HK_FIREBALL");
	missile.traileffectnum = particleeffectnum ("EF_NADETRAIL2");
	
	missile.aiflags |= IS_PROJECTILE;
};

void() sheol_stand1 = [ 0, sheol_stand2 ] { ai_stand();};
void() sheol_stand2 = [ self.frame, sheol_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 143) 
	{	
		if (random() < 0.2)
			vul_idle ();
		sheol_stand1 ();
		return;
	}
	ai_stand ();
};

void() sheol_walk1 = [ 295, sheol_walk2 ] { ai_walk(3); };
void() sheol_walk2 = [ self.frame, sheol_walk2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 319) 
	{	
		if (random() < 0.2)
			vul_idle ();
		sheol_walk1 ();
		return;
	}
	ai_walk (3);
};

void() sheol_run1 = [ 295, sheol_run2 ] { ai_run(6); };
void() sheol_run2 = [ self.frame, sheol_run2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 319) 
	{	
		if (random() < 0.2)
			vul_idle ();
		sheol_run1 ();
		return;
	}
	
	ai_run (6);
};

void() sheol_missile = 
{	
	vul_cc ();
	if (random() < 0.2)
		sheol_atka1 ();
	else if (random() < 0.2)
		sheol_atkb1 ();
	else
		sheol_atkc1 ();
}

void() sheol_atka1 = [ 145, sheol_atka2 ] { RIGHT_spawn_fireball3 (145, 0, 13); ai_face (); self.nextthink = time + 0.03; };
void() sheol_atka2 = [ self.frame, sheol_atka2 ] 
{ 	
	self.frame ++;
	
	if (self.frame == 158)
	{
		sheol_fire (0, 0);
	}

	if (self.frame >= 185) 
	{	
		sheol_run1 ();
		return;
	}
	
	if (self.frame < 158)
		ai_face ();
	
	self.nextthink = time + 0.03;
};

void() sheol_atkb1 = [ 186, sheol_atkb2 ] { LEFT_spawn_fireball3 (186, 41, 55); ai_face (); self.nextthink = time + 0.03; };
void() sheol_atkb2 = [ self.frame, sheol_atkb2 ] 
{ 	
	self.frame ++;
	
	if (self.frame == 200)
	{
		sheol_fire (0, 0);
	}

	if (self.frame >= 216) 
	{	
		sheol_run1 ();
		return;
	}
	
	if (self.frame < 200)
		ai_face ();
	
	self.nextthink = time + 0.03;
};

void() sheol_atkc1 = [ 216, sheol_atkc2 ] 
{ 
	RIGHT_spawn_fireball3 (216, 71, 82); 
	LEFT_spawn_fireball3 (216, 71, 101); 
	ai_face (); self.nextthink = time + 0.03; 
};
void() sheol_atkc2 = [ self.frame, sheol_atkc2 ] 
{ 	
	self.frame ++;

	if (self.frame == 227 || self.frame == 245)
	{
		sheol_fire (0, 0);
	}

	if (self.frame >= 262) 
	{	
		sheol_run1 ();
		return;
	}
	
	if (self.frame > 228)
		ai_charge (2);
	if (self.frame > 253 && self.frame < 258)
		ai_move (-2);
	
	self.nextthink = time + 0.03;
};


void() sheol_melee = 
{	
	vul_melee ();
	if (random() < 0.5)
		sheol_puncha1 ();
	else
		sheol_punchb1 ();
}

void() sheol_puncha1 = [ 145, sheol_puncha2 ] {ai_charge (3); self.nextthink = time + 0.035; };
void() sheol_puncha2 = [ self.frame, sheol_puncha2 ] 
{ 	
	self.frame ++;
	
	if (self.frame == 158)
	{
		punct_sheol (0);
	}

	if (self.frame >= 185) 
	{	
		sheol_run1 ();
		return;
	}
	
	if (self.frame < 158)
		ai_face ();
	
	self.nextthink = time + 0.03;
};

void() sheol_punchb1 = [ 466, sheol_punchb2 ] {ai_charge (1); self.nextthink = time + 0.035; };
void() sheol_punchb2 = [ self.frame, sheol_punchb2 ] 
{ 	
	self.frame ++;
	
	if (self.frame == 200)
	{
		punct_sheol (0);
	}

	if (self.frame >= 216) 
	{	
		sheol_run1 ();
		return;
	}
	
	if (self.frame < 200)
		ai_face ();
	
	self.nextthink = time + 0.03;
};

void() sheol_strafel1 = [ 280, sheol_strafel2 ] 
{ 
	ai_slide(0, 0.03);
};
void() sheol_strafel2 = [ self.frame, sheol_strafel2 ] 
{ 
	self.frame ++;
	if (self.frame >= 294) 
	{	
		//self.attack_state = AS_STRAIGHT;
		self.flags &= ~FL_DODGED;
		sheol_run1 ();
		return;
	}

	if (self.frame < 289)
		ai_slide (12, 0.03);
	else
		self.nextthink = time + 0.03;
};

void() sheol_strafer1 = [ 263, sheol_strafer2 ] 
{ 
	ai_slide(0, 0.03);
};
void() sheol_strafer2 = [ self.frame, sheol_strafer2 ] 
{ 
	self.frame ++;
	if (self.frame >= 278) 
	{	
		//self.attack_state = AS_STRAIGHT;
		self.flags &= ~FL_DODGED;
		sheol_run1 ();
		return;
	}
	
	if (self.frame < 274)
		ai_slide (12, 0.03);
	else
		self.nextthink = time + 0.03;
};

void() sheol_dodge =
{	
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	
	ChangeYaw ();

	if(self.lefty)
		sheol_strafel1 ();
	else
		sheol_strafer1 ();
	
	self.nextthink = time + frametime;
}

//===========================================================================

void(entity attacker, float damage) sheol_pain =
{
	if (self.pain_finished > time)
		return;

	vul_pain();
	self.pain_finished = time + 3;
};

//===========================================================================

void() sheol_die =
{	
	if (self.health < -200)
	{	
		self.deadflag = DEAD_DEAD;
		self.solid = SOLID_NOT;
		self.think = sheol_gib1;
		self.nextthink = time + 0.035;
		return;
	}
	
	if((self.deadflag & DEAD_DEAD))
		return;

	local vector tmpangle;
	local float tempskin;
	tmpangle = self.angles;
	tempskin = self.skin;
	
	vul_death ();
	if (random () <= 0.5)
	{
		self.think = sheol_die1;
		setmodel(self, "progs/sheoldie.md3");
	}
	else
	{
		self.think = sheol_dieb1;
		setmodel(self, "progs/sheoldie2.md3");
	}

	setsize(self, '-32 -32 0', '32 32 88');

	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_CORPSE;
	self.nextthink = time + 0.035;

	self.angles = tmpangle;
	//self.skin = tempskin;
};

void() sheol_die1 = [ 0, sheol_die2 ] { self.nextthink = time + 0.035;};
void() sheol_die2 = [ self.frame, sheol_die2 ] 
{ 	
	self.nextthink = time + 0.035;

	if (self.frame < 7)
		ai_move (-4);
	self.frame ++;
	if (self.frame == 17)
	{	
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() sheol_dieb1 = [ 0, sheol_dieb2 ] { self.nextthink = time + 0.035;};
void() sheol_dieb2 = [ self.frame, sheol_dieb2 ] 
{ 	
	self.nextthink = time + 0.035;

	if (self.frame < 7)
		ai_move (-4);
	self.frame ++;
	if (self.frame == 32)
	{
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() sheol_gib1 = [ self.frame, sheol_gib2 ] 
{MonsterGib (self.health); self.skin = 2; self.alpha = 1; self.nextthink = time + 0.02;};

void() sheol_gib2 = [ self.frame, sheol_gib2 ] 
{ 	
	self.nextthink = time + 0.02;
	self.alpha -= 0.02;
	if (self.alpha <= 0)
	{
		remove(self);
		return;
	}
};


/*QUAKED monster_sheol (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/

void() monster_sheol_cache =
{
	precache_model("progs/sheol.md3");
	precache_model("progs/sheoldie.md3");
	precache_model("progs/sheoldie2.md3");

	precache_sound("monsters/vulgar/sight_01.wav");
	precache_sound("monsters/vulgar/sight_02.wav");
	precache_sound("monsters/vulgar/sight_03.wav");
	precache_sound("monsters/vulgar/sight_04.wav");
	precache_sound("monsters/vulgar/sight_05.wav");

	precache_sound("monsters/vulgar/pain_05.wav");
	precache_sound("monsters/vulgar/pain_06.wav");
	precache_sound("monsters/vulgar/pain_07.wav");
	precache_sound("monsters/vulgar/pain_08.wav");
	precache_sound("monsters/vulgar/pain_09.wav");

	precache_sound("monsters/vulgar/fireball_create_01.wav");
	precache_sound("monsters/vulgar/fireball_create_02.wav");

	precache_sound("monsters/vulgar/death_01.wav");
	precache_sound("monsters/vulgar/death_02.wav");
	precache_sound("monsters/vulgar/death_03.wav");
	precache_sound("monsters/vulgar/death_04.wav");
	precache_sound("monsters/vulgar/death_05.wav");
	precache_sound("monsters/vulgar/melee_01.wav");
	precache_sound("monsters/vulgar/melee_02.wav");
	precache_sound("monsters/vulgar/melee_03.wav");
	precache_sound("monsters/vulgar/melee_04.wav");
	precache_sound("monsters/vulgar/melee_05.wav");

	precache_sound("monsters/vulgar/cc_01.wav");
	precache_sound("monsters/vulgar/cc_02.wav");
	precache_sound("monsters/vulgar/cc_03.wav");
	precache_sound("monsters/vulgar/cc_04.wav");
	precache_sound("monsters/vulgar/cc_05.wav");

	precache_sound("monsters/vulgar/vulg_swing.wav");

	precache_sound("monsters/vulgar/idle_01.wav");
	precache_sound("monsters/vulgar/idle_02.wav");
	precache_sound("monsters/vulgar/idle_03.wav");
	precache_sound("monsters/vulgar/idle_04.wav");
	precache_sound("monsters/vulgar/idle_05.wav");
};

static void() vul_sight =
{
	local float r = rint(random() * 4);	

	if (r == 4)
		    sound(self, CHAN_VOICE, "monsters/vulgar/sight_01.wav", 1, ATTN_NORM);
	else if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/vulgar/sight_02.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/vulgar/sight_03.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/vulgar/sight_04.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/vulgar/sight_05.wav", 1, ATTN_NORM);
};

static void() vul_pain =
{
	local float r = rint(random() * 4);	

	if (r == 4)
		    sound(self, CHAN_VOICE, "monsters/vulgar/pain_05.wav", 1, ATTN_NORM);
	else if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/vulgar/pain_06.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/vulgar/pain_07.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/vulgar/pain_08.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/vulgar/pain_09.wav", 1, ATTN_NORM);
};

static void() vul_idle =
{
	local float r = rint(random() * 4);	

	if (r == 4)
		    sound(self, CHAN_VOICE, "monsters/vulgar/idle_01.wav", 1, ATTN_IDLE);
	else if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/vulgar/idle_02.wav", 1, ATTN_IDLE);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/vulgar/idle_03.wav", 1, ATTN_IDLE);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/vulgar/idle_04.wav", 1, ATTN_IDLE);
	else
		    sound(self, CHAN_VOICE, "monsters/vulgar/idle_05.wav", 1, ATTN_IDLE);
};

static void() vul_fire =
{
	local float r = rint(random() * 1);	

	if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/vulgar/fireball_create_01.wav", 1, ATTN_NORM);
	else 
		    sound(self, CHAN_VOICE, "monsters/vulgar/fireball_create_02.wav", 1, ATTN_NORM);
};

static void() vul_death =
{
	local float r = rint(random() * 4);	

	if (r == 4)
		    sound(self, CHAN_VOICE, "monsters/vulgar/death_01.wav", 1, ATTN_NORM);
	else if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/vulgar/death_02.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/vulgar/death_03.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/vulgar/death_04.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/vulgar/death_05.wav", 1, ATTN_NORM);
};

static void() vul_melee =
{
	local float r = rint(random() * 4);	

	if (r == 4)
		    sound(self, CHAN_VOICE, "monsters/vulgar/melee_01.wav", 1, ATTN_NORM);
	else if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/vulgar/melee_02.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/vulgar/melee_03.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/vulgar/melee_04.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/vulgar/melee_05.wav", 1, ATTN_NORM);
};

static void() vul_cc =
{
	local float r = rint(random() * 4);	

	if (r == 4)
		    sound(self, CHAN_VOICE, "monsters/vulgar/cc_01.wav", 1, ATTN_NORM);
	else if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/vulgar/cc_02.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/vulgar/cc_03.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/vulgar/cc_04.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/vulgar/cc_05.wav", 1, ATTN_NORM);
};

void() monster_sheol =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	monster_sheol_cache ();

	spawn_sheol ();

};

void() spawn_sheol =
{
	setmodel(self, "progs/sheol.md3");

	setsize(self, '-32 -32 0', '32 32 88');
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	self.health = 630;
	self.max_health = 630;
	self.scale = 1;
	self.mass = 400;

	if (world.worldtype == 2)
		self.skin = 1;
	
	self.th_stand = sheol_stand1;
	self.th_walk = sheol_walk1;
	self.th_run = sheol_run1;
	self.th_melee = sheol_melee;
	self.th_missile = sheol_missile;
	self.th_pain = sheol_pain;
	self.th_dodge = sheol_dodge;
	self.th_die = sheol_die;
	self.th_sight = vul_sight;
	self.th_checkatck = vulCheckAttack;
	self.th_spawn = spawn_sheol;
	self.deathtype = "cried when the Vulgar was being really vulgar";

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
		return TRUE;
	
	return FALSE;
};

static float() CheckfiendRange =
{
	if (enemy_range == RANGE_CLOSE)
		return TRUE;
	
	return FALSE;
};


static float() vulCheckAttack =
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
		chance = 0.15;
	else if (enemy_range == RANGE_CLOSE)
		chance = 0.2;
	else if (enemy_range == RANGE_NEAR)
		chance = 0.3;
	else if (enemy_range == RANGE_MID)
		chance = 0.06;
	else
		return FALSE;

	if (skill == 0)
		chance *= 0.5;
	if (skill >= 2)
		chance *= 1.5;

	if (random () < chance)
	{
		self.attack_state = AS_MISSILE;
		SUB_AttackFinished (1 + 2*random());
		return TRUE;
	}

	return FALSE;
};

vector vul_leftspot[] =
{
	'25.69 7.57 26.36', // frame 0
   '25.07 5.78 28.61', // frame 1
   '23.84 2.92 31.82', // frame 2
   '21.98 -0.66 35.36', // frame 3
   '18.88 -5.31 39.54', // frame 4
   '15.78 -9.97 43.39', // frame 5
   '12.07 -14.98 46.61', // frame 6
   '8.35 -19.27 49.18', // frame 7
   '5.87 -21.78 50.46', // frame 8
   '5.26 -22.85 50.14', // frame 9
   '14.55 -17.12 41.79', // frame 10
   '31.89 -2.09 25.71', // frame 11
   '39.94 9.72 20.25', // frame 12
   '39.94 19.03 13.82', // frame 13
   '31.89 34.06 19.29', // frame 14
   '18.26 35.85 30.21', // frame 15
   '13.93 34.78 32.14', // frame 16
   '12.69 35.14 31.82', // frame 17
   '12.07 35.50 32.14', // frame 18
   '12.07 36.21 32.14', // frame 19
   '12.07 37.29 32.14', // frame 20
   '12.07 38.00 32.14', // frame 21
   '12.07 38.72 31.82', // frame 22
   '12.69 39.43 31.50', // frame 23
   '13.93 39.79 31.18', // frame 24
   '14.55 39.79 30.54', // frame 25
   '15.78 39.43 30.21', // frame 26
   '17.02 38.72 29.57', // frame 27
   '18.26 37.29 29.25', // frame 28
   '19.50 35.50 28.61', // frame 29
   '20.74 33.35 28.29', // frame 30
   '21.98 30.84 27.96', // frame 31
   '22.60 28.34 27.64', // frame 32
   '23.84 25.47 27.64', // frame 33
   '23.84 22.25 27.32', // frame 34
   '24.45 19.39 27.32', // frame 35
   '24.45 16.52 27.00', // frame 36
   '25.07 14.02 27.00', // frame 37
   '25.07 11.51 27.00', // frame 38
   '25.69 9.36 26.68', // frame 39
   '25.69 7.57 26.36', // frame 40
   '25.69 7.57 26.36', // frame 41
   '25.07 6.14 28.93', // frame 42
   '21.36 6.50 32.14', // frame 43
   '14.55 9.01 35.68', // frame 44
   '5.26 14.02 38.57', // frame 45
   '-5.89 20.10 40.82', // frame 46
   '-18.90 26.19 42.75', // frame 47
   '-33.14 30.48 44.36', // frame 48
   '-47.39 32.27 46.29', // frame 49
   '-58.54 30.84 49.18', // frame 50
   '-59.78 27.26 53.36', // frame 51
   '-32.52 24.40 58.82', // frame 52
   '3.40 22.61 60.11', // frame 53
   '48.61 21.89 59.46', // frame 54
   '88.25 2.56 44.68', // frame 55
   '91.34 -24.28 28.93', // frame 56
   '62.23 -33.59 18.00', // frame 57
   '38.70 -30.73 18.64', // frame 58
   '21.98 -32.16 15.43', // frame 59
   '16.40 -34.67 13.82', // frame 60
   '19.50 -36.45 16.39', // frame 61
   '24.45 -37.89 17.36', // frame 62
   '33.74 -37.53 18.00', // frame 63
   '39.32 -32.52 19.29', // frame 64
   '41.18 -24.64 20.89', // frame 65
   '41.18 -16.05 22.18', // frame 66
   '38.08 -8.18 23.46', // frame 67
   '33.74 -2.09 24.75', // frame 68
   '29.41 2.92 25.71', // frame 69
   '26.93 6.14 26.04', // frame 70
   '25.69 7.57 26.36', // frame 71
   '25.69 5.07 28.61', // frame 72
   '25.07 1.49 31.82', // frame 73
   '23.22 -3.88 35.04', // frame 74
   '20.74 -9.61 38.89', // frame 75
   '17.02 -16.05 42.11', // frame 76
   '13.31 -21.06 45.00', // frame 77
   '10.83 -23.93 46.93', // frame 78
   '10.21 -23.93 47.57', // frame 79
   '12.69 -16.05 39.86', // frame 80
   '6.49 6.14 23.46', // frame 81
   '13.93 21.18 19.61', // frame 82
   '11.45 35.85 38.57', // frame 83
   '17.02 34.78 46.29', // frame 84
   '21.36 34.42 46.29', // frame 85
   '23.22 34.06 46.61', // frame 86
   '23.22 34.06 46.93', // frame 87
   '21.36 34.42 48.54', // frame 88
   '18.26 35.14 51.11', // frame 89
   '13.31 35.50 54.32', // frame 90
   '6.49 35.50 57.86', // frame 91
   '-1.56 35.50 60.43', // frame 92
   '-10.85 35.50 62.36', // frame 93
   '-19.52 35.85 63.64', // frame 94
   '-28.19 36.21 63.64', // frame 95
   '-34.38 36.21 62.36', // frame 96
   '-33.76 37.29 62.04', // frame 97
   '8.97 35.50 70.07', // frame 98
   '58.52 13.66 58.82', // frame 99
   '89.49 -5.31 51.43', // frame 100
   '96.92 -15.34 45.64', // frame 101
   '63.47 -34.31 32.46', // frame 102
   '36.84 -45.40 31.18', // frame 103
   '33.13 -46.84 29.25', // frame 104
   '31.89 -46.84 27.64', // frame 105
   '31.27 -45.76 26.04', // frame 106
   '31.89 -43.61 24.43', // frame 107
   '33.74 -41.11 23.79', // frame 108
   '36.22 -38.24 23.46', // frame 109
   '38.08 -34.31 23.14', // frame 110
   '39.32 -28.58 22.50', // frame 111
   '40.56 -20.70 22.50', // frame 112
   '38.70 -11.76 22.82', // frame 113
   '34.98 -3.88 23.79', // frame 114
   '30.65 1.85 25.07', // frame 115
   '27.55 5.78 26.04', // frame 116
   '25.69 7.57 26.36' // frame 117
};

vector vul_rightspot[] =
{
	   '-5.89 -21.42 25.07', // frame 0
   '-7.13 -23.57 26.36', // frame 1
   '-8.99 -26.79 28.61', // frame 2
   '-13.33 -31.09 31.50', // frame 3
   '-19.52 -36.10 35.68', // frame 4
   '-28.19 -40.03 39.86', // frame 5
   '-38.10 -42.18 43.71', // frame 6
   '-48.01 -41.47 46.93', // frame 7
   '-56.06 -38.60 49.18', // frame 8
   '-61.01 -34.67 50.79', // frame 9
   '-53.58 -31.09 59.79', // frame 10
   '-9.61 -30.01 79.39', // frame 11
   '14.55 -27.15 67.50', // frame 12
   '79.58 -3.88 47.89', // frame 13
   '87.63 19.39 29.89', // frame 14
   '59.76 35.85 23.14', // frame 15
   '36.84 29.41 20.25', // frame 16
   '25.07 24.04 18.00', // frame 17
   '20.74 22.61 16.71', // frame 18
   '21.36 23.32 15.75', // frame 19
   '23.84 25.47 15.11', // frame 20
   '28.17 27.62 14.14', // frame 21
   '33.74 29.05 13.18', // frame 22
   '36.22 27.62 12.86', // frame 23
   '36.22 25.11 12.86', // frame 24
   '35.60 22.25 12.86', // frame 25
   '34.36 18.67 12.86', // frame 26
   '33.13 15.09 13.50', // frame 27
   '30.65 11.51 14.14', // frame 28
   '28.79 7.93 15.11', // frame 29
   '25.69 4.35 16.07', // frame 30
   '23.22 0.77 17.04', // frame 31
   '20.12 -2.45 18.00', // frame 32
   '17.02 -5.31 18.96', // frame 33
   '13.93 -8.18 20.25', // frame 34
   '10.83 -11.04 21.21', // frame 35
   '7.73 -13.90 21.86', // frame 36
   '4.64 -16.41 22.82', // frame 37
   '0.92 -18.56 23.46', // frame 38
   '-2.18 -20.35 24.43', // frame 39
   '-5.89 -21.42 25.07', // frame 40
   '-5.89 -21.42 25.07', // frame 41
   '-5.27 -24.64 26.36', // frame 42
   '-4.04 -28.22 28.93', // frame 43
   '-2.80 -30.37 32.46', // frame 44
   '-0.94 -30.01 36.64', // frame 45
   '0.30 -26.07 41.14', // frame 46
   '0.92 -19.99 45.00', // frame 47
   '0.30 -12.83 48.21', // frame 48
   '-0.32 -6.03 50.46', // frame 49
   '0.30 -1.37 51.11', // frame 50
   '4.64 1.49 48.54', // frame 51
   '22.60 3.99 37.61', // frame 52
   '40.56 0.42 24.43', // frame 53
   '46.13 -13.55 16.07', // frame 54
   '33.13 -28.58 15.75', // frame 55
   '21.36 -30.01 20.25', // frame 56
   '15.16 -30.01 25.07', // frame 57
   '10.83 -30.01 28.29', // frame 58
   '7.11 -27.86 30.21', // frame 59
   '4.02 -26.43 30.21', // frame 60
   '1.54 -25.72 29.57', // frame 61
   '0.30 -25.72 27.96', // frame 62
   '-0.94 -25.72 27.00', // frame 63
   '-2.18 -25.72 26.04', // frame 64
   '-2.80 -25.36 25.39', // frame 65
   '-3.42 -25.00 25.39', // frame 66
   '-4.04 -23.93 25.07', // frame 67
   '-4.65 -23.21 25.07', // frame 68
   '-5.27 -22.14 25.07', // frame 69
   '-5.89 -21.78 25.07', // frame 70
   '-5.89 -21.42 25.07', // frame 71
   '-7.13 -23.57 26.04', // frame 72
   '-11.47 -26.79 27.64', // frame 73
   '-18.28 -30.37 29.25', // frame 74
   '-26.33 -33.95 31.18', // frame 75
   '-36.24 -36.10 33.75', // frame 76
   '-44.91 -36.45 36.32', // frame 77
   '-51.10 -35.02 38.89', // frame 78
   '-53.58 -33.59 41.79', // frame 79
   '-46.77 -33.95 49.18', // frame 80
   '3.40 -26.79 60.43', // frame 81
   '62.23 -4.95 51.11', // frame 82
   '65.33 31.56 22.82', // frame 83
   '47.99 38.72 23.46', // frame 84
   '34.98 30.84 24.75', // frame 85
   '31.89 28.69 22.82', // frame 86
   '31.27 27.26 22.50', // frame 87
   '30.65 26.19 23.14', // frame 88
   '31.27 25.47 23.79', // frame 89
   '32.51 25.47 25.07', // frame 90
   '34.98 24.76 28.29', // frame 91
   '36.22 22.97 34.07', // frame 92
   '36.22 19.75 41.14', // frame 93
   '34.36 15.09 48.21', // frame 94
   '31.89 10.08 53.68', // frame 95
   '30.03 4.71 57.21', // frame 96
   '31.27 -1.73 57.21', // frame 97
   '44.27 -13.55 47.25', // frame 98
   '51.09 -29.30 34.07', // frame 99
   '46.75 -36.81 28.61', // frame 100
   '40.56 -40.39 28.61', // frame 101
   '33.13 -41.47 30.54', // frame 102
   '26.93 -38.96 32.79', // frame 103
   '20.74 -36.45 35.04', // frame 104
   '16.40 -34.31 36.96', // frame 105
   '12.69 -32.88 37.61', // frame 106
   '8.97 -32.16 37.61', // frame 107
   '6.49 -31.09 36.64', // frame 108
   '4.02 -30.37 35.36', // frame 109
   '1.54 -29.30 33.75', // frame 110
   '-0.32 -28.22 31.82', // frame 111
   '-1.56 -26.79 29.89', // frame 112
   '-2.80 -25.36 28.29', // frame 113
   '-3.42 -23.93 27.00', // frame 114
   '-4.65 -22.49 26.04', // frame 115
   '-5.27 -21.78 25.39', // frame 116
   '-5.89 -21.42 25.07' // frame 117
};

static void()  RIGHT_fireball3_update_pos =
{	
	if ((self.arraynumfire + (self.owner.frame - self.startfire) >= self.endfire) 
		|| self.owner.think == sheol_strafel1 || self.owner.think == sheol_strafel2 
		|| self.owner.think == sheol_strafer1 || self.owner.think == sheol_strafer2 
		|| self.owner.health <= 0)
	{
		remove(self);
		return;
	}

	vector f, r, u;
	AngleVectors(self.owner.angles, f, r, u);
	vector org = ProjectAim(self.owner.origin, vul_rightspot[self.arraynumfire + (self.owner.frame - self.startfire)], f, -1*r);	
	
	//bprint (ftos(self.arraynumfire + (self.owner.frame - self.startfire)),"\n");
	self.origin = org;
	
	self.think = RIGHT_fireball3_update_pos;
	self.nextthink = time;
};

static void(float start, float arrnum, float end)  RIGHT_spawn_fireball3 =
{
	local entity e;

	makevectors(self.angles);
	vector org = ProjectAim(self.origin, vul_rightspot[arrnum + (self.frame - start)], v_forward, -1*v_right);	
	
	e = spawn ();
	setmodel (e, "progs/muzzleflash.spr");
	
	setsize (e, '0 0 0', '0 0 0');
	//
	setorigin (e, self.origin);
	e.origin = org;

	e.emiteffectnum = particleeffectnum ("TE_HK_FIREBALL");
	e.traileffectnum = particleeffectnum ("EF_NADETRAIL2");

	e.startfire = start;
	e.endfire = end - 3;
	e.arraynumfire = arrnum;

	e.owner = self;
	e.think = RIGHT_fireball3_update_pos;
	e.nextthink = time;
	//e.ltime = removeframe;
	
	vul_fire();
};

static void()  LEFT_fireball3_update_pos =
{	
	if ((self.arraynumfire + (self.owner.frame - self.startfire) >= self.endfire) 
		|| self.owner.think == sheol_strafel1 || self.owner.think == sheol_strafel2 
		|| self.owner.think == sheol_strafer1 || self.owner.think == sheol_strafer2 
		|| self.owner.health <= 0)
	{
		remove(self);
		return;
	}

	vector f, r, u;
	AngleVectors(self.owner.angles, f, r, u);
	vector org = ProjectAim(self.owner.origin, vul_leftspot[self.arraynumfire + (self.owner.frame - self.startfire)], f, -1*r);	
	
	//bprint (ftos(self.arraynumfire + (self.owner.frame - self.startfire)),"\n");
	self.origin = org;
	
	self.think = LEFT_fireball3_update_pos;
	self.nextthink = time;
};
static void(float start, float arrnum, float end)  LEFT_spawn_fireball3 =
{
	local entity e;

	makevectors(self.angles);
	vector org = ProjectAim(self.origin, vul_leftspot[arrnum + (self.frame - start)], v_forward, -1*v_right);	
	
	e = spawn ();
	setmodel (e, "progs/muzzleflash.spr");
	
	setsize (e, '0 0 0', '0 0 0');
	//
	setorigin (e, self.origin);
	e.origin = org;

	e.emiteffectnum = particleeffectnum ("TE_HK_FIREBALL");
	e.traileffectnum = particleeffectnum ("EF_NADETRAIL2");

	e.startfire = start;
	e.endfire = end - 3;
	e.arraynumfire = arrnum;

	e.owner = self;
	e.think = LEFT_fireball3_update_pos;
	e.nextthink = time;
	//e.ltime = removeframe;
	
	vul_fire();
};