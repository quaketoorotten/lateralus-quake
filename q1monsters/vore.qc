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

SHAL-RATH

==============================================================================
*/

void() vore_stand1 = [ 104, vore_stand2 ] { ai_stand();};
void() vore_stand2 = [ self.frame, vore_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 343) 
	{	
		if (random() < 0.2)
			sound(self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_IDLE);
		vore_stand1 ();
		return;
	}
	ai_stand ();
};

void() vore_walk1 = [ 0, vore_walk2 ] { ai_walk(2);};
void() vore_walk2 = [ self.frame, vore_walk2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 31) 
	{	
		if (random() < 0.2)
			sound(self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_IDLE);
		vore_walk1 ();
		return;
	}
	ai_walk (2);
};

void() vore_run1 = [ 0, vore_run2 ] { ai_run(2);};
void() vore_run2 = [ self.frame, vore_run2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 31) 
	{	
		if (random() < 0.2)
			sound(self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_IDLE);
		vore_run1 ();
		return;
	}
	ai_run (2);
};

void() vore_startatk1 = [ 52, vore_startatk2 ] {ai_face(); self.nextthink = time + 0.03; };
void() vore_startatk2 = [ self.frame, vore_startatk2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 61) 
	{	
		vore_atk1 ();
		return;
	}
	ai_face();
	self.nextthink = time + 0.03;
};

void() vore_atk1 = [ 62, vore_atk2 ] {ai_face(); self.nextthink = time + 0.03; };
void() vore_atk2 = [ self.frame, vore_atk2 ] 
{ 	
	self.frame ++;	

	if (self.frame == 65)
		vore_fire (-30, 16);
	
	if (self.frame == 80)
		vore_fire (30);
	
	if (self.frame >= 91) 	
	{
		local float r = range(self.enemy);	
		if(random() < 0.8 && r >= RANGE_CLOSE && visible(self.enemy) && SUB_CheckRefireFrame ( 63))
			 return; 

		vore_endatk1 ();
		return;
	}
	ai_face();
	self.nextthink = time + 0.03;
};

void() vore_endatk1 = [ 92, vore_endatk2 ] { self.nextthink = time + 0.02; };
void() vore_endatk2 = [ self.frame, vore_endatk2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 103) 
	{	
		local vector delta = self.enemy.origin - self.origin;

		if (vlen(delta) < 200)
		{
			self.th_melee ();
			return;
		}

		vore_run1 ();
		return;
	}
	self.nextthink = time + 0.02;
};

void() vore_melee =
{
	if (random() < 0.6)
		vore_startatk1 ();
	else
		vore_melee1 ();
}

void() voreMelee =
{
	vector delta;
	float ldmg;

	if (!self.enemy)
		return;
	
	sound(self, CHAN_VOICE, "demon/dland2.wav", 1, ATTN_NORM);

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 180)
		return;

	ldmg = 75 + (random() + random() + random()) * 15;
	T_Damage(self.enemy, self, self.origin + v_forward*16, self, ldmg, 40);
};

void() vore_melee1 = [ 344, vore_melee2 ] {ai_face(); self.nextthink = time + 0.03; };
void() vore_melee2 = [ self.frame, vore_melee2 ] 
{ 	
	self.frame ++;	

	if (self.frame == 359)
		voreMelee ();
	
	if (self.frame >= 383) 
	{	
		if(random() <= 0.4)
		{
			self.th_missile ();
			return;
		}

		vore_run1 ();
		return;
	}
	ai_face();
	self.nextthink = time + 0.03;
};


void() vore_pain1 = [ 32, vore_pain2 ] { self.nextthink = time + 0.04; };
void() vore_pain2 = [ self.frame, vore_pain2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 52) 
	{	
		vore_run1 ();
		return;
	}
	self.nextthink = time + 0.04;
};


void(entity attacker, float damage) vore_pain =
{	
	if (self.think == vore_atk2)
		return;

	if (self.pain_finished > time)
		return;

	sound(self, CHAN_VOICE, "shalrath/pain.wav", 1, ATTN_NORM);
	vore_pain1();
	self.pain_finished = time + 3;
};

void() vore_die =
{	
	if((self.deadflag & DEAD_DEAD))
		return;

	local vector tmpangle;
	local float tmpframe;
	tmpframe = self.frame;
	tmpangle = self.angles;

	setmodel(self, "progs/shalrath1.mdl");
	setsize(self, '-32 -32 0', '32 32 88');	
	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_NOT;
	self.think = sham_die1;
	self.nextthink = time + 0.04;

	self.frame = tmpframe;
	self.angles = tmpangle;

	MonsterGib (self.health);
};

/*
================
vore_Missile
================
*/
void(float off, float off2 = 0) vore_fire =
{
	if (random() > 0.6)
		 vore_Missile (off, off2, 24);

	vore_Missile (off, off2, 0);
};


void(float off, float off2, float off3) vore_Missile =
{
	entity missile;
	vector dir, org;

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self, CHAN_WEAPON, "shalrath/attack2.wav", 1, ATTN_NORM);

	missile = spawn();
	missile.owner = self;

	missile.solid = SOLID_BBOX;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.classname = "grenade";
	setmodel(missile, "progs/v_spike.mdl");

	setsize(missile, '0 0 0', '0 0 0');
	
	makevectors(self.angles);

	org = self.origin + '0 0 30' + v_right * off + v_up * off2 + v_forward * off3;
	dir = normalize((self.enemy.origin + '0 0 10') - org + v_right*crandom()*6);

	setorigin(missile, org);
	
	missile.velocity = dir * 800;
	missile.avelocity = '300 300 300';
	missile.nextthink = time + 6;
	missile.think = SUB_Remove;
	missile.touch = vore_MissileTouch;
};

void() vore_MissileTouch =
{
	if (other == self.owner)
		return; // don't explode on owner

	if (other.classname == "monster_zombie")
		T_Damage(other, self, self.origin, self, 110, 0);
	T_RadiusDamage(self, self.owner, 60, 40, world);
	sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);

	pointparticles (particleeffectnum("TE_ROCKETIMPAC"), self.origin);
	pointparticles (particleeffectnum("TE_ROCKETIMPAC2"), self.origin);

	BecomeExplosion ();
};

//=================================================================

/*QUAKED monster_shalrath (1 0 0) (-32 -32 -24) (32 32 48) Ambush
*/
void() monster_shalrath =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2 ("progs/shalrath.mdl");
	precache_model2 ("progs/shalrath1.mdl");

	precache_model2 ("progs/h_shal.mdl");
	precache_model2 ("progs/v_spike.mdl");

	precache_sound2 ("shalrath/attack.wav");
	precache_sound2 ("shalrath/attack2.wav");
	precache_sound2 ("shalrath/death.wav");
	precache_sound2 ("shalrath/idle.wav");
	precache_sound2 ("shalrath/pain.wav");
	precache_sound2 ("shalrath/sight.wav");

	spawn_vore();
};

void() spawn_vore =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel(self, "progs/shalrath.mdl");
	setsize(self, '-32 -32 0', '32 32 88');
	self.health = 1400;
	self.max_health = 1400;
	self.scale = 0.9;
	self.mass = 600;

	self.th_stand = vore_stand1;
	self.th_walk = vore_walk1;
	self.th_run = vore_run1;
	self.th_die = vore_die;
	self.th_pain = vore_pain;
	self.th_melee = vore_melee;
	self.th_missile = vore_startatk1;

	self.think = walkmonster_start;
	self.nextthink = time + 0.1 + random()*0.1;
};
