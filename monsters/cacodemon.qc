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

WIZARD

==============================================================================
*/

/*
==============================================================================

WIZARD

If the player moves behind cover before the missile is launched, launch it
at the last visible spot with no velocity leading, in hopes that the player
will duck back out and catch it.
==============================================================================
*/

/*
=================
FliesCheckAttack
=================
*/
float()	FliesCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;
	
	if ((enemy_range == RANGE_MELEE) && self.th_melee)
	{
		self.th_melee();
		return TRUE;
	}

	if (time < self.attack_finished)
		return FALSE;
	if (!enemy_vis)
		return FALSE;

	if (enemy_range == RANGE_FAR)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			self.th_run ();
		}
		return FALSE;
	}
		
	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_ent != targ)
	{	// don't have a clear shot, so move to a side
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			self.th_run ();
		}
		return FALSE;
	}
			
	if (enemy_range == RANGE_MELEE)
		chance = 0.9;
	else if (enemy_range == RANGE_CLOSE)
		chance = 0.6;
	else if (enemy_range == RANGE_NEAR)
		chance = 0.2;
	else if (enemy_range == RANGE_MID)
		chance = 0.1;
	else
		chance = 0;

	if (random () < chance)
	{
		self.attack_state = AS_MISSILE;
		self.attack_finished = time + 0.2 + random()*4;
		return TRUE;
	}

	if (enemy_range == RANGE_MID)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			self.th_run ();
		}
	}
	else
	{
		if (self.attack_state != AS_SLIDING)
		{
			self.attack_state = AS_SLIDING;
		}
	}
	
	return FALSE;
};

/*
=================
WizardAttackFinished
=================
*/
void()	FliesAttackFinished =
{
	if (enemy_range >= RANGE_MID || !enemy_vis)
	{
		self.attack_state = AS_STRAIGHT;
		self.think = self.th_run;
	}
	else
	{
		self.attack_state = AS_SLIDING;
	}
};



void() cacodemon_run1;

/*
==============================================================================

FAST ATTACKS

==============================================================================
*/

void() cacospike_touch =
{
    if (other == self.owner)
    {
        return; // don't explode on owner
    }

    if (pointcontents(self.origin) == CONTENT_SKY)
    {
        remove(self);
        return;
    }
	
    self.origin = self.origin - 32* normalize(self.velocity);

    T_RadiusDamage(self, self.owner, self.dmg, 80, self.owner);
    self.traileffectnum = 0;

//    sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
    BecomeExplosion ();
};

void(float speed) WizShoot =
{
	local	vector	org, dir;
	local entity	targ = self.enemy;
	local vector	targorg = targ.origin + targ.view_ofs;
	
	makevectors (self.angles);

	caco_fire();
	
	self.effects = self.effects | EF_MUZZLEFLASH;

	org = self.origin;
	dir = normalize (targorg - org);
	
	launch_spike (org, dir);
	newmis.classname = "grenade";
	newmis.velocity = dir * speed;
	setmodel (newmis, "progs/w_spike.mdl");
	newmis.scale = 0.001;
	newmis.touch = cacospike_touch;
	newmis.think = SUB_Remove;
	newmis.dmg = 40;
	newmis.nextthink = time + 5;
	newmis.avelocity_z = crandom()*200;
	newmis.ltime = time + 6;
	newmis.traileffectnum = (particleeffectnum("EF_CACO_FIREBALL"));
	newmis.emiteffectnum = particleeffectnum ("TE_CACO_FIREBALL");
	newmis.aiflags |= IS_PROJECTILE;
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
};

void() Scrag_idlesound =
{
	float wr;
	wr = random() * 5;

	if (self.waitmin < time)
	{
		self.waitmin = time + 2;
		if (wr > 4.5)
			caco_idle ();
		if (wr < 1.5)
			caco_idle ();
	}
	return;
};

void() cacodemon_stand1 = [ 0, cacodemon_stand2 ] { ai_stand();};
void() cacodemon_stand2 = [ self.frame, cacodemon_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 99) 
	{	
		Scrag_idlesound ();
		cacodemon_stand1 ();
		return;
	}
	ai_stand ();
};

void() cacodemon_walk1 = [ 176, cacodemon_walk2 ] { ai_walk(2); ai_adjustflyangle (2);};
void() cacodemon_walk2 = [ self.frame, cacodemon_walk2 ] 
{ 
	self.frame ++;
	if (self.frame >= 235) 
	{
		cacodemon_walk1 ();
		return;
	}
	ai_walk (2);
	ai_adjustflyangle (2);
};


void() cacodemon_run1 = [ 236, cacodemon_run2 ] {Scrag_idlesound (); ai_run(4); };
void() cacodemon_run2 = [ self.frame, cacodemon_run2 ] 
{ 
	self.frame ++;
	if (self.frame >= 275) 
	{
		cacodemon_run1 ();
		return;
	}
	ai_run (4);
};

void() cacodemon_fast1 = [ 100, cacodemon_fast2 ] {caco_breath(); ai_face(); self.nextthink = time + 0.03;};
void() cacodemon_fast2 = [ self.frame, cacodemon_fast2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;

	if (self.frame == 119)
		WizShoot (800);

	if (self.frame >= 139) 
	{	
	//	SUB_CheckRefire (cacodemon_fast1 );
		cacodemon_run1 ();
		return;
	}
	
	if (self.frame < 112)
		ai_charge (-6);
	else if (self.frame > 118 && self.frame < 125)
		ai_charge (6);
	
	
	ai_face();
	ai_adjustflyangle (2);
};

void() cacabite =
{
	vector delta;
	float ldmg;

	if (!self.enemy)
		return;
	if (!CanDamage(self.enemy, self))
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 90)
		return;

	ldmg = (random() + random() + random()) + 18;

	T_Damage(self.enemy, self, self.origin, self, ldmg, 2);
};

void() cacodemon_melee1 = [ 140, cacodemon_melee2 ] {caco_melee (); ai_charge (7); ai_face(); self.nextthink = time + 0.035;};
void() cacodemon_melee2 = [ self.frame, cacodemon_melee2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.035;

	if (self.frame == 152)
		cacabite ();

	if (self.frame >= 176) 
	{	
		cacodemon_run1 ();
		return;
	}
	
	if (self.frame < 174)
		ai_charge (7);

	ai_face();
};


void() cacodemon_pain1 = [ 276, cacodemon_pain2 ] {self.nextthink = time + 0.035;};
void() cacodemon_pain2 = [ self.frame, cacodemon_pain2 ] 
{
	self.frame ++; self.nextthink = time + 0.035; 
	if (self.frame >= 294) 
		{cacodemon_run1(); return; } 
};

void() cacodemon_die =
{	
	if (self.health < -80)
	{	
		self.deadflag = DEAD_DEAD;
		self.solid = SOLID_NOT;
		self.think = cacodemon_gib1;
		self.nextthink = time + 0.035;
		return;
	}
	
	if((self.deadflag & DEAD_DEAD))
		return;

	caco_death ();

	local vector tmpangle;
	local float tempskin;
	tmpangle = self.angles;
	tempskin = self.skin;

	self.movetype = MOVETYPE_BOUNCE;
	
	setmodel(self, "progs/wizarddeath.md3");
	setsize(self, '-16 -16 0', '16 16 64');
	self.emiteffectnum = 0;

	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_CORPSE;
	self.think = cacodemon_die1;
	self.nextthink = time + 0.035;

	self.angles = tmpangle;
	//self.skin = tempskin;
};

void() cacodemon_die1 = [ 7, cacodemon_die2 ] { self.nextthink = time + 0.035;};
void() cacodemon_die2 = [ self.frame, cacodemon_die2 ] 
{ 	
	self.nextthink = time + 0.035;

	self.frame ++;
	if (self.frame == 37)
	{
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() cacodemon_gib1 = [ self.frame, cacodemon_gib2 ] 
{MonsterGib (self.health); self.skin = 1; self.alpha = 1; self.nextthink = time + 0.02;
self.emiteffectnum = 0;};

void() cacodemon_gib2 = [ self.frame, cacodemon_gib2 ] 
{ 	
	self.nextthink = time + 0.02;
	self.alpha -= 0.02;
	if (self.alpha <= 0)
	{	
		remove(self);
		return;
	}
};

void() cacodemon_dodge =
{	
	if (random() <= 0.3)
		return;

	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	
	ChangeYaw ();

	cacodemon_strafe1 ();
	
	self.nextthink = time + frametime;
}

void() cacodemon_strafe1 = [ 236, cacodemon_strafe2 ] {	Scrag_idlesound (); ai_slide(2, 0.02); ai_adjustflyangle (2);};
void() cacodemon_strafe2 = [ self.frame, cacodemon_strafe2 ] 
{ 
	self.frame ++;
	if (self.frame >= 275) 
	{
		self.flags &= ~FL_DODGED;
		cacodemon_run1 ();
		return;
	}
	ai_slide(2, 0.02);
	ai_adjustflyangle (2);
};

void(entity attacker, float damage) Scrag_Pain =
{
	if (random()*300 > damage)
		return; // didn't flinch

	if (self.flags & FL_DODGED)
		return;

	caco_pain ();
	cacodemon_pain1();
};


void() Scrag_Missile =
{
	
		cacodemon_fast1();
//	else
	//	cacodemon_slow1();
};

static void() caco_idle =
{
	local float r = rint(random() * 5);	

	if (r == 5)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_chatter1.wav", 1, ATTN_IDLE);
	else if (r == 4)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_chatter2.wav", 1, ATTN_IDLE);
	else if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_chatter3.wav", 1, ATTN_IDLE);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_chatter4.wav", 1, ATTN_IDLE);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_chatter5.wav", 1, ATTN_IDLE);
	else 
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_chatter6.wav", 1, ATTN_IDLE);
};

static void() caco_pain =
{
	local float r = rint(random() * 4);	

	if (r == 4)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_pain1.wav", 1, ATTN_NORM);
	else if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_pain2.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_pain3.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_pain4.wav", 1, ATTN_NORM);
	else 
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_pain5.wav", 1, ATTN_NORM);
};

static void() caco_death =
{
	local float r = rint(random() * 4);	

	if (r == 4)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_death1.wav", 1, ATTN_NORM);
	else if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_death2.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_death3.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_death4.wav", 1, ATTN_NORM);
	else 
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_death5.wav", 1, ATTN_NORM);
};

static void() caco_sight =
{
	local float r = rint(random() * 5);	

	if (r == 5)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_sight2_1.wav", 1, ATTN_NORM);
	else if (r == 4)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_sight2_2.wav", 1, ATTN_NORM);
	else if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_sight3.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_sight4.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_sight5.wav", 1, ATTN_NORM);
	else 
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_sight6.wav", 1, ATTN_NORM);
};

static void() caco_melee =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_attack1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_attack2.wav", 1, ATTN_NORM);
	else 
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_attack3.wav", 1, ATTN_NORM);
};

static void() caco_breath =
{
	local float r = rint(random() * 1);	

	if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_breath2.wav", 1, ATTN_NORM);
	else 
		    sound(self, CHAN_VOICE, "monsters/cacodemon/caco_breath6.wav", 1, ATTN_NORM);
};

static void() caco_fire =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/fire_01.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/fire_02.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/cacodemon/fire_03.wav", 1, ATTN_NORM);
	else 
		    sound(self, CHAN_VOICE, "monsters/cacodemon/fire_04.wav", 1, ATTN_NORM);
};

/*QUAKED monster_wizard (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/

void() monster_wizard_cache =
{	
	precache_model("progs/wizard.md3");
	precache_model("progs/wizarddeath.md3");
	precache_model("progs/w_spike.mdl");

	precache_sound("monsters/cacodemon/caco_chatter1.wav"); 
	precache_sound("monsters/cacodemon/caco_chatter2.wav");
	precache_sound("monsters/cacodemon/caco_chatter3.wav");
	precache_sound("monsters/cacodemon/caco_chatter4.wav");
	precache_sound("monsters/cacodemon/caco_chatter5.wav");
	precache_sound("monsters/cacodemon/caco_chatter6.wav");

	precache_sound("monsters/cacodemon/caco_pain1.wav"); 
	precache_sound("monsters/cacodemon/caco_pain2.wav");
	precache_sound("monsters/cacodemon/caco_pain3.wav");
	precache_sound("monsters/cacodemon/caco_pain4.wav");
	precache_sound("monsters/cacodemon/caco_pain5.wav");

	precache_sound("monsters/cacodemon/caco_death1.wav"); 
	precache_sound("monsters/cacodemon/caco_death2.wav");
	precache_sound("monsters/cacodemon/caco_death3.wav");
	precache_sound("monsters/cacodemon/caco_death4.wav");
	precache_sound("monsters/cacodemon/caco_death5.wav");

	precache_sound("monsters/cacodemon/caco_breath2.wav"); 
	precache_sound("monsters/cacodemon/caco_breath6.wav");

	precache_sound("monsters/cacodemon/caco_attack1.wav");
	precache_sound("monsters/cacodemon/caco_attack2.wav");
	precache_sound("monsters/cacodemon/caco_attack3.wav");

	precache_sound("monsters/cacodemon/caco_sight2_1.wav"); 
	precache_sound("monsters/cacodemon/caco_sight2_2.wav");
	precache_sound("monsters/cacodemon/caco_sight3.wav");
	precache_sound("monsters/cacodemon/caco_sight4.wav");
	precache_sound("monsters/cacodemon/caco_sight5.wav");
	precache_sound("monsters/cacodemon/caco_sight6.wav");

	precache_sound("monsters/cacodemon/fire_01.wav"); 
	precache_sound("monsters/cacodemon/fire_02.wav");
	precache_sound("monsters/cacodemon/fire_03.wav");
	precache_sound("monsters/cacodemon/fire_04.wav");
};

void() monster_wizard =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	monster_wizard_cache ();

	spawn_wizard();
};

void() spawn_wizard =
{

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/wizard.md3");

	setsize(self, '-16 -16 -24', '16 16 40');
	self.health = 200;
	self.max_health = 200;
	self.mass = 200;
	self.scale = 0.86;

	self.th_stand = cacodemon_stand1;
	self.th_walk = cacodemon_walk1;
	self.th_run = cacodemon_run1;
	self.th_missile = Scrag_Missile;
	self.th_pain = Scrag_Pain;
	self.th_die = cacodemon_die;
	self.th_melee = cacodemon_melee1;
	self.th_checkatck = FliesCheckAttack;
	self.th_spawn = spawn_wizard;
	self.emiteffectnum = (particleeffectnum("TE_CACO_FLAME"));
	self.th_sight = caco_sight;
	self.th_dodge = cacodemon_dodge;
	self.deathtype = "ate a Cacodemon ball";
	
	flymonster_start();
};
