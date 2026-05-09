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

	sound(self, CHAN_WEAPON, "monsters/maggot/attack_01_swish.wav", 1, ATTN_NORM);

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


void() spectre_stand1 = [ 0, spectre_stand2 ] { ai_stand();};
void() spectre_stand2 = [ self.frame, spectre_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 69) 
	{	
		if (random() < 0.2)
			sound(self, CHAN_VOICE, "monsters/wraith/idle.wav", 1, ATTN_IDLE);
		spectre_stand1 ();
		return;
	}
	ai_stand ();
};

void() spectre_walk1 = [ 70, spectre_walk2 ] { ai_walk(2); };
void() spectre_walk2 = [ self.frame, spectre_walk2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 101) 
	{	
		if (random() < 0.2)
			sound(self, CHAN_VOICE, "monsters/wraith/idle.wav", 1, ATTN_IDLE);
		spectre_walk1 ();
		return;
	}
	ai_walk (2);
};

void() spectre_run1 =
{	
	//if (random () <= 0.3)	
		spectre_runa1 ();
	//else
	//	spectre_runb1 ();
};

static void(vector o) SpawnPentagram =
{
	local entity e2 = spawn ();
	setorigin(e2, o);
	setmodel (e2, "progs/muzzleflash.spr");
	setsize (e2, '-32 -32 0', '32 32 88');
	
	e2.solid = SOLID_NOT;
	e2.emiteffectnum = (particleeffectnum("TE_SUMMON"));
	pointparticles (particleeffectnum("EF_SUMMONLIGHT"), o);
	e2.think = SUB_Remove;
	e2.nextthink = time + 0.8; 
};

void() spectre_runa1 = [ 102, spectre_runa2 ] 
{ 
	ai_run(6);  
	self.nextthink = time + 0.035; 
};
void() spectre_runa2 = [ self.frame, spectre_runa2 ] 
{ 	
	self.frame ++;

	if (random() > 0.6 && self.invisible_finished < time && visible(self.enemy) && self.invisible_time != TRUE)
	{
		self.invisible_finished = time + 1.2 + random()*4;
		self.invisible_time = TRUE;
		SpawnPentagram (self.origin + '0 0 16');
	//	bprint ("hey","\n");
	}
	
	if (self.invisible_finished < time && self.invisible_time == TRUE)
	{	
		SpawnPentagram (self.origin + '0 0 16');
		self.model = "progs/spectre.mdl";
		self.solid = SOLID_SLIDEBOX;
		self.invisible_time = FALSE;
		self.invisible_finished = time + 2.3 + random()*4;
	//	bprint ("out of time","\n");
	}
	else	if (self.invisible_time == TRUE)
	{
		self.model = "";
		self.solid = SOLID_NOT;
	}

	if (self.frame >= 116) 
	{	
		if (random() < 0.2)
			sound(self, CHAN_VOICE, "monsters/wraith/idle.wav", 1, ATTN_IDLE);
		spectre_runa1 ();
		return;
	}
	
	if (self.invisible_time == TRUE)
		ai_run (9);
	else
		ai_run (6);
};

void() spectre_melee = 
{		

	wraith_melee ();
	if (self.invisible_time == TRUE)
	{
		SpawnPentagram (self.origin + '0 0 16');
		self.model = "progs/spectre.mdl";
		self.solid = SOLID_SLIDEBOX;
		self.invisible_time = FALSE;
		self.invisible_finished = time + 0.3 + random()*4;	
	}

	if (random() < 0.5)
		spectre_atka1 ();
	else
		spectre_atkb1 ();
}

void() spectre_atka1 = [ 117, spectre_atka2 ] { ai_face(); self.nextthink = time + 0.03; };
void() spectre_atka2 = [ self.frame, spectre_atka2 ] 
{ 	
	self.frame ++;
	
	if (self.frame == 128)
		chainsaw (0);

	if (self.frame >= 148) 
	{	
		spectre_runa1 ();
		return;
	}
	
	if ( (self.frame < 123) )
		ai_charge (-2);
	else if ( (self.frame > 126 && self.frame < 139) )
		ai_charge (6);
	
	self.nextthink = time + 0.03;
};

void() spectre_atkb1 = [ 178, spectre_atkb2 ] { ai_face(); self.nextthink = time + 0.03; };
void() spectre_atkb2 = [ self.frame, spectre_atkb2 ] 
{ 	
	self.frame ++;
	
	if (self.frame == 189)
		chainsaw (0);

	if (self.frame >= 208) 
	{	
		spectre_runa1 ();
		return;
	}
	
	if ( (self.frame < 186) )
		ai_charge (-2);
	else if ( (self.frame > 186 && self.frame < 197) )
		ai_charge (6);
	
	self.nextthink = time + 0.03;
};


void() spectre_dodge =
{	
	/*enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	
	ChangeYaw ();

	if(self.lefty)
		spectre_strafel1 ();
	else
		spectre_strafer1 ();
	
	self.nextthink = time + frametime;*/
}

//===========================================================================

void() spectre_pain1 = [ 210, spectre_pain2 ] { self.nextthink = time + 0.035; };
void() spectre_pain2 = [ self.frame, spectre_pain2 ] 
{ 	
	self.frame ++;

	if (self.frame >= 224) 
	{	
		spectre_run1 ();
		return;
	}
	
	self.nextthink = time + 0.035;
};

void(entity attacker, float damage) spectre_pain =
{
	if (self.flags & FL_DODGED)
		return;

	if (self.pain_finished > time)
		return;

	spectre_pain1 ();

	wraith_pain();
	self.pain_finished = time + 3;
};

//===========================================================================


void() spectre_die =
{	
	if (self.health < -65)
	{	
		self.deadflag = DEAD_DEAD;
		self.solid = SOLID_NOT;
		self.think = spectre_gib1;
		self.nextthink = time + 0.035;
		return;
	}
	
	if((self.deadflag & DEAD_DEAD))
		return;

	local vector tmpangle;
	local float tempskin;
	tmpangle = self.angles;
	tempskin = self.skin;

	wraith_die ();
	
	if (random () <= 0.5)
	{
		self.think = spectre_die1;
		setmodel(self, "progs/spectredie.md3");
	}
	else
	{
		self.think = spectre_dieb1;
		setmodel(self, "progs/spectredie2.md3");
	}

	setsize(self, '-16 -16 0', '16 16 64');

	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_CORPSE;
	self.nextthink = time + 0.035;

	self.angles = tmpangle;
	//self.skin = tempskin;
};

void() spectre_die1 = [ 0, spectre_die2 ] { self.nextthink = time + 0.035;};
void() spectre_die2 = [ self.frame, spectre_die2 ] 
{ 	
	self.nextthink = time + 0.035;

	self.frame ++;
	if (self.frame < 6)
		ai_move (-4);
	
	if (self.frame == 18)
	{	
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() spectre_dieb1 = [ 0, spectre_dieb2 ] { self.nextthink = time + 0.035;};
void() spectre_dieb2 = [ self.frame, spectre_dieb2 ] 
{ 	
	self.nextthink = time + 0.035;

	self.frame ++;
	if (self.frame < 6)
		ai_move (-4);
	
	if (self.frame == 18)
	{
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() spectre_gib1 = [ self.frame, spectre_gib2 ] 
{MonsterGib (self.health); self.skin = 1; self.alpha = 1; self.nextthink = time + 0.02;};

void() spectre_gib2 = [ self.frame, spectre_gib2 ] 
{ 	
	self.nextthink = time + 0.02;
	self.alpha -= 0.02;
	if (self.alpha <= 0)
	{
		remove(self);
		return;
	}
};
/*QUAKED monster_wraith (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/

static void() wraith_die =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/wraith/death_01.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/wraith/death_02.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/wraith/death_03.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/wraith/death_04.wav", 1, ATTN_NORM);
};

static void() wraith_pain =
{
	sound(self, CHAN_VOICE, "monsters/wraith/pain.wav", 1, ATTN_NORM);
};

static void() wraith_melee =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/wraith/attack1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/wraith/attack2.wav", 1, ATTN_NORM);
	else 
		    sound(self, CHAN_VOICE, "monsters/wraith/attack3.wav", 1, ATTN_NORM);
};

static void() wraith_sight =
{

	sound(self, CHAN_VOICE, "monsters/wraith/sight.wav", 0.9, ATTN_NORM);

	self.invisible_finished = time + 1.6;
};

void() monster_spectre_cache =
{
	precache_model("progs/spectre.md3");
	precache_model("progs/spectredie.md3");
	precache_model("progs/spectredie2.md3");

	precache_sound("monsters/maggot/attack_01_swish.wav");

	precache_sound("monsters/wraith/attack1.wav");
	precache_sound("monsters/wraith/attack2.wav");
	precache_sound("monsters/wraith/attack3.wav");

	precache_sound("monsters/wraith/death_01.wav");
	precache_sound("monsters/wraith/death_02.wav");
	precache_sound("monsters/wraith/death_03.wav");
	precache_sound("monsters/wraith/death_04.wav");

	precache_sound("monsters/wraith/pain.wav");
	precache_sound("monsters/wraith/sight.wav");
	precache_sound("monsters/wraith/idle.wav");

	precache_sound("monsters/wraith/idle.wav");

};

void() monster_spectre =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	monster_spectre_cache ();

	spawn_spectre ();
};

void() spawn_spectre =
{
	setmodel(self, "progs/spectre.md3");

	setsize(self, '-16 -16 0', '16 16 64');
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	self.health = 120;
	self.max_health = 120;
	self.scale = 0.85;
	self.mass = 150;

	self.th_stand = spectre_stand1;
	self.th_walk = spectre_walk1;
	self.th_run = spectre_run1;
	self.th_melee = spectre_melee;
	self.th_pain = spectre_pain;
	self.th_die = spectre_die;
	self.th_dodge = spectre_dodge;
//	self.th_checkatck = maggotCheckAttack;
	self.th_sight = wraith_sight;
	self.th_spawn = spawn_spectre;
	self.invisible_time = 0;
	self.deathtype = "was clawed by a Wraith";

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


static float() wraithCheckAttack =
{
	// if close enough for slashing, go for it
	if (CheckfiendMelee())
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}

	return FALSE;
};