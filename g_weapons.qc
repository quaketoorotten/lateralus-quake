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

// called by worldspawn
void() W_Precache =
{
    precache_sound("weapons/r_exp3.wav"); // new rocket explosion
    precache_sound("weapons/ric1.wav"); // ricochet (used in C code)
    precache_sound("weapons/ric2.wav"); // ricochet (used in C code)
    precache_sound("weapons/ric3.wav"); // ricochet (used in C code)
    precache_sound("weapons/spike2.wav"); // super spikes
    precache_sound("weapons/tink1.wav"); // spikes tink (used in C code)
    precache_sound("weapons/bounce.wav"); // grenade bounce
	precache_sound ("weapons/grenade.wav");
	precache_sound ("weapons/sgun1.wav");

	precache_sound("weapons/lashit.wav");
	precache_sound("misc/lasfly.wav");
	precache_sound("weapons/rockfly.wav");

	precache_sound("weapons/machgf1b.wav");
	precache_sound("weapons/machgf2b.wav");
	precache_sound("weapons/machgf3b.wav");
	precache_sound("weapons/machgf4b.wav");
	precache_sound("weapons/machgf5b.wav");

	precache_sound("weapons/shotgun/fire/sgfire_01.wav");
	precache_sound("weapons/shotgun/fire/sgfire_02.wav");
	precache_sound("weapons/shotgun/fire/sgfire_03.wav");
	precache_sound("weapons/shotgun/fire/sgfire_04.wav");
	precache_sound("weapons/shotgun/fire/sgfire_05.wav");

	precache_sound("weapons/shotgun/dryfire_01.wav");
	precache_sound("weapons/shotgun/dryfire_02.wav");
	precache_sound("weapons/shotgun/dryfire_03.wav");

	precache_sound("weapons/shotgun/reload/sgreload_addshell_01.wav");
	precache_sound("weapons/shotgun/reload/sgreload_addshell_02.wav");
	precache_sound("weapons/shotgun/reload/sgreload_addshell_03.wav");
	precache_sound("weapons/shotgun/reload/sgreload_addshell_04.wav");

	precache_sound("weapons/shotgun/reload/sgreload_start_01.wav");
	precache_sound("weapons/shotgun/reload/sgreload_start_02.wav");
	precache_sound("weapons/shotgun/reload/sgreload_start_03.wav");

	precache_sound("weapons/shotgun/shotgun_cock_01.wav");
	precache_sound("weapons/shotgun/shotgun_use_01.wav");

	precache_sound("weapons/machinegun/mg_reload_01.wav");
	precache_sound("weapons/machinegun/mg_use_01.wav");
	precache_sound("weapons/machinegun/mg_mech_01.wav");
	precache_sound("weapons/machinegun/mg_mech_02.wav");
	precache_sound("weapons/machinegun/mg_mech_03.wav");

	precache_sound("weapons/machinegun/fire1e.wav");
	precache_sound("weapons/machinegun/fire2e.wav");
	precache_sound("weapons/machinegun/fire3e.wav");

	precache_sound("weapons/machinegun/machineGunSingle4a.wav");
	precache_sound("weapons/machinegun/machineGunSingle4b.wav");
	precache_sound("weapons/machinegun/machineGunSingle4c.wav");	
	precache_sound("weapons/machinegun/machineGunSingle4d.wav");
	precache_sound("weapons/machinegun/machineGunSingle4e.wav");	

	precache_sound("weapons/plasma/2plasma_fire1.wav");
	precache_sound("weapons/plasma/2plasma_fire3.wav");
	precache_sound("weapons/plasma/2plasma_fire6.wav");	
	precache_sound("weapons/plasmagun/plasma_use_01.wav");
	precache_sound("weapons/plasmagun/plasma_reload_01.wav");	
	precache_sound("weapons/plasmagun/flight_01.wav");	

	precache_sound("weapons/pistol/pistol_shot_02a.wav");
	precache_sound("weapons/pistol/pistol_shot_03a.wav");
	precache_sound("weapons/pistol/pistol_shot_04a.wav");	
	precache_sound("weapons/pistol/pistol_use_01.wav");
	precache_sound("weapons/pistol/pistol_reload_01.wav");

	precache_sound("weapons/rocket/rocklf1a.wav");
	precache_sound("weapons/rocket/blast2.wav");
	precache_sound("weapons/rocket/blast3.wav");	
	precache_sound("weapons/rocket/blast4.wav");	
	precache_sound("weapons/rocket/reload.wav");	
	precache_sound("weapons/rocket/raise.wav");	

	precache_sound("weapons/bfg/bfg_firebegin.wav");
	precache_sound("weapons/bfg/bfg_fire.wav");
	precache_sound("weapons/bfg/bfg_raise.wav");	
	precache_sound("weapons/bfg/bfg_reload.wav");	

	precache_sound("weapons/bfg/bfg_explode1.wav");
	precache_sound("weapons/bfg/bfg_explode2.wav");
	precache_sound("weapons/bfg/bfg_explode3.wav");	
	precache_sound("weapons/bfg/bfg_explode4.wav");	

	precache_sound("weapons/fists/raise_fists_01.wav");	

	precache_sound("weapons/fists/default_punch_04.wav");
	precache_sound("weapons/fists/default_punch_03.wav");
	precache_sound("weapons/fists/default_punch_02.wav");	
	precache_sound("weapons/fists/default_punch_01.wav");	

	precache_sound("weapons/chain_gun_shot_v3/cgun_shot_01.wav");
	precache_sound("weapons/chain_gun_shot_v3/cgun_shot_02.wav");
	precache_sound("weapons/chain_gun_shot_v3/cgun_shot_03.wav");	
	precache_sound("weapons/chain_gun_shot_v3/cgun_shot_04.wav");	

	precache_sound("weapons/chaingun/cg_use_01.wav");
	precache_sound("weapons/chaingun/cg_reload_twist_01.wav");
	precache_sound("weapons/chaingun/cg_winddown_mix_01.wav");	
	precache_sound("weapons/chaingun/cg_windup_mix_01.wav");	
	precache_sound("weapons/chaingun/cg_motor_loop_01.wav");	

	precache_sound("weapons/chainsaw/attack.wav");	
	precache_sound("weapons/chainsaw/start_attack.wav");	
	precache_sound("weapons/chainsaw/stop_attack.wav");	
	precache_sound("weapons/chainsaw/pull.wav");	
	precache_sound("weapons/chainsaw/pull_zip.wav");	
	precache_sound("weapons/chainsaw/put_away.wav");	

	precache_sound("weapons/chainsaw/hit_01.wav");	
	precache_sound("weapons/chainsaw/hit_02.wav");	
	precache_sound("weapons/chainsaw/hit_03.wav");	
	precache_sound("weapons/chainsaw/hit_04.wav");	

	precache_sound("weapons/chainsaw/hit_metal_01.wav");	
	precache_sound("weapons/chainsaw/hit_metal_02.wav");	
	precache_sound("weapons/chainsaw/hit_metal_03.wav");	
	precache_sound("weapons/chainsaw/hit_metal_04.wav");	
	precache_sound("weapons/chainsaw/idle.wav");	

	precache_sound("weapons/grenades/gren_use.wav");	
	precache_sound("weapons/grenades/gren_throw_mix.wav");

	precache_sound("weapons/ssg/insert_01.wav");	
	precache_sound("weapons/ssg/insert_02.wav");	
	precache_sound("weapons/ssg/insert_03.wav");	
	precache_sound("weapons/ssg/fire_04.wav");	
	precache_sound("weapons/ssg/click_01.wav");
	precache_sound("weapons/ssg/clack_01.wav");

	precache_sound("weapons/soulcube/soulcube_shred.wav");	
	precache_sound("weapons/soulcube/fly_loop_01.wav");	
	precache_sound("weapons/soulcube/raise_01.wav");	
	precache_sound("weapons/soulcube/raise_02.wav");	
	precache_sound("weapons/soulcube/putaway_01.wav");
	precache_sound("weapons/soulcube/fly_start_02.wav");
	precache_sound("weapons/soulcube/fly_start_03.wav");
	precache_sound("weapons/soulcube/energize_01.wav");
	precache_sound("weapons/soulcube/recharge.wav");

	precache_sound("weapons/wepchg1a.wav");
	precache_sound("weapons/wepchg1b.wav");
};

void() AutofireMachineNoise =
{
	local float r = rint(random() * 4);

	if(r == 4)
		sound(self, CHAN_WEAPON, "weapons/machinegun/machineGunSingle4a.wav", 1, ATTN_NORM);
	else	if(r == 3)
		sound(self, CHAN_WEAPON, "weapons/machinegun/machineGunSingle4b.wav", 1, ATTN_NORM);
	else	if(r == 2)
		sound(self, CHAN_WEAPON, "weapons/machinegun/machineGunSingle4c.wav", 1, ATTN_NORM);
	else	if(r == 1)
		sound(self, CHAN_WEAPON, "weapons/machinegun/machineGunSingle4d.wav", 1, ATTN_NORM);
	else
		sound(self, CHAN_WEAPON, "weapons/machinegun/machineGunSingle4e.wav", 1, ATTN_NORM);
};

void() AutofireMachineEnemyNoise =
{
	local float r = rint(random() * 2);

	if(r == 2)
		sound(self, CHAN_WEAPON, "weapons/machinegun/fire1e.wav", 1, ATTN_NORM);
	else	if(r == 1)
		sound(self, CHAN_WEAPON, "weapons/machinegun/fire2e.wav", 1, ATTN_NORM);
	else
		sound(self, CHAN_WEAPON, "weapons/machinegun/fire3e.wav", 1, ATTN_NORM);
}

void() AutofireChainGunNoise =
{
	local float r = rint(random() * 3);

	if(r == 3)
		sound(self, CHAN_WEAPON, "weapons/chain_gun_shot_v3/cgun_shot_01.wav", 1, ATTN_NORM);
	else	if(r == 2)
		sound(self, CHAN_WEAPON, "weapons/chain_gun_shot_v3/cgun_shot_02.wav", 1, ATTN_NORM);
	else	if(r == 1)
		sound(self, CHAN_WEAPON, "weapons/chain_gun_shot_v3/cgun_shot_03.wav", 1, ATTN_NORM);
	else	
		sound(self, CHAN_WEAPON, "weapons/chain_gun_shot_v3/cgun_shot_04.wav", 1, ATTN_NORM);
}

void() RocketNoise =
{
	local float r = rint(random() * 3);

	if(r == 3)
		sound(self, CHAN_WEAPON, "weapons/rocket/rocklf1a.wav", 1, ATTN_NORM);
	else	if(r == 2)
		sound(self, CHAN_WEAPON, "weapons/rocket/rocklf1a.wav", 1, ATTN_NORM);
	else	if(r == 1)
		sound(self, CHAN_WEAPON, "weapons/rocket/rocklf1a.wav", 1, ATTN_NORM);
	else
		sound(self, CHAN_WEAPON, "weapons/rocket/rocklf1a.wav", 1, ATTN_NORM);
}


float() crandom =
{
    return 2 * (random() - 0.5);
};

float() crand
{
	return (rand()&32767)* (2.0/32767) - 1;
};

float(entity viewer, entity targ) infront_notasself =
{
	local vector	vec;
	local float		dot;
	
	makevectors (viewer.angles);
	vec = normalize (targ.origin - viewer.origin);
	dot = vec * v_forward;
	
	if ( dot > 0.3)
	{
		return TRUE;
	}
	return FALSE;
};

void (vector src, vector dir, float speed) CheckDodge = // deimos code rip
{
	local float dist;
	local entity targ, oself;

	if(skill <= 1)
		if(random() > 0.6)
			return;

	if(skill >= 2)
		if(random() > 0.9)
			return;

	traceline (src, src + dir*8192, FALSE, self);
	
	if (!trace_ent)
		return;

	targ = trace_ent;
	
	if( (targ.flags & FL_MONSTER) && (targ.health > 0) && infront_notasself(targ, self) )
	{	
		if(targ.flags & FL_MEDIC)
			return;

		if(targ.flags & FL_DODGED)
			return;
	
		if(targ.dodge_finished > time)
			return;	
		
		if(!targ.th_dodge)
			return;
				
		dist = vlen(trace_endpos - src);

		targ.enemy = self;
		targ.flags = targ.flags | FL_DODGED;

		oself = self;
		self = targ;

		self.th_dodge (); 

		if(skill == 0)
			self.dodge_finished = time + 3 + random()*2;
		if(skill == 1)
			self.dodge_finished = time + 2 + random()*2;
		if(skill >= 2)
			self.dodge_finished = time + 1 + random()*2;
			
		self = oself;	
	}
};


//============================================================================

vector() wall_velocity =
{
    local vector vel;

    vel = normalize(self.velocity);
    vel = normalize(vel + v_up * (random() - 0.5) + v_right * (random() - 0.5));
    vel = vel + 2 * trace_plane_normal;
    vel = vel * 200;

    return vel;
};


/*
================
SpawnMeatSpray
================
*/
void(vector org, vector vel) SpawnMeatSpray =
{
    local entity missile;

    missile = spawn();
    missile.owner = self;
    missile.movetype = MOVETYPE_BOUNCE;
    missile.solid = SOLID_NOT;

    makevectors(self.angles);

    missile.velocity = vel;
    missile.velocity_z = missile.velocity_z + 250 + 50 * random();

    missile.avelocity = '3000 1000 2000';

    // set missile duration
    missile.nextthink = time + 1;
    missile.think = SUB_Remove;

    setmodel(missile, "progs/zom_gib.mdl");
	missile.traileffectnum = particleeffectnum("EF_GIBSPRAY");

    setsize(missile, '0 0 0', '0 0 0');
    setorigin(missile, org);
};

void() _splatter =
{	
	if (other.solid != SOLID_BSP)
		return;

	pointparticles (particleeffectnum("TE_BLOODSPLAT"), self.origin);

	if(self.classname == "gib")
		return;

	remove(self);
}

void(vector org, vector vel, float dmg) SpawnBloodSplat =
{
    local entity missile;

    missile = spawn();
    missile.owner = self;
    missile.movetype = MOVETYPE_TOSS;
    missile.solid = SOLID_TRIGGER;

    makevectors(self.angles);

    missile.velocity = vel + v_forward *500;
    missile.velocity_z = -300 * random();

    missile.think = SUB_Remove;
    missile.nextthink = time + 0.7;

    // set missile duration

    setmodel(missile, "progs/muzzleflash.spr");
	missile.traileffectnum = particleeffectnum("EF_GIBSPRAY");

    setsize(missile, '0 0 0', '0 0 0');
    setorigin(missile, org);
    missile.touch = _splatter;
};

/*
================
SpawnBlood
================
*/
void(vector org, vector vel, float damage) SpawnBlood =
{	
	//te_bloodshower (org, vel, 100, damage);
    pointparticles (particleeffectnum("TE_BLOODSPRAY"), org);
	SpawnBloodSplat (org, vel, damage);
};


/*
================
spawn_touchblood
================
*/
void(float damage) spawn_touchblood =
{
    local vector vel;

    vel = wall_velocity() * 0.2;
    SpawnBlood(self.origin + vel * 0.01, vel, damage);
};


/*
================
SpawnChunk
================
*/
void(vector org, vector vel) SpawnChunk =
{
    particle(org, vel * 0.02, 0, 10);
};


/*
================
FireLead 
================
*/

void() _impact =
{	
	if (other.solid != SOLID_BSP)
		return;

	pointparticles (particleeffectnum("TE_LEADIMPACT"), self.origin);

	remove(self);
}

void(vector org, vector dir) SpawnImpact =
{
    local entity missile;

    missile = spawn();
    missile.owner = self;
    missile.movetype = MOVETYPE_FLY;
    missile.solid = SOLID_TRIGGER;

    //makevectors(self.angles);

	missile.velocity = normalize(dir) * 1000;

    // set missile duration

    setmodel(missile, "progs/muzzleflash.spr");

    setsize(missile, '0 0 0', '0 0 0');
    setorigin(missile, org);
     missile.touch = _impact;
};


void(float shotcount, vector start, vector dir, float hspread, float vspread, float damage, float kick, float te) FireLead =
{
	local	vector end;
	local	vector	src;
	local float		up = crandom() * vspread
			    , right = crandom() * hspread;
	
	makevectors(self.v_angle);

	src = start + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;
	
	end= src + (8192 * dir);
	end= end + right*v_right + up*v_up;

	traceline (src, end, FALSE, self);
//	 if (!(vlen(src - trace_endpos) < 96 && trace_ent.solid == SOLID_BSP))
//			MonsterTracer (src, dir, trace_endpos);

	if (trace_fraction != 1.0)
	{
		local	vector	vel, org;
		
		vel = normalize(dir + v_up*crandom() + v_right*crandom());
		vel = vel + 2*trace_plane_normal;
		vel = vel * -200;

		org = trace_endpos - dir*4;
		
		if (trace_ent.takedamage)
		{	
			T_Damage (trace_ent, self, trace_endpos, self, damage, kick);
			SpawnBlood (org, vel * 0.2, kick * 2.5);
			// pointparticles (particleeffectnum("TE_BLOOD2"), org);
		}
		else
		{	
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, te);
			WriteCoord (MSG_BROADCAST, org_x);
			WriteCoord (MSG_BROADCAST, org_y);
			WriteCoord (MSG_BROADCAST, org_z);

			SpawnImpact (org, dir);
		}
	}

};


void(float shotcount, vector start, vector dir, float hspread, float vspread, float dmg, float kick, float te) FirePallets =
{
	for(float i = 0; i < shotcount; i++)
		FireLead (shotcount, start, dir, hspread, vspread, dmg, kick, te);
};

void(vector start, vector dir, float hspread, float vspread, float dmg, float kick, float te) FireBullet =
{	
	FireLead (1, start, dir, hspread, vspread, dmg, kick, te);
};


/*
==============================================================================

EXPLOSIONS

==============================================================================
*/

void(vector org) explosion_wave = 
{
	local entity e;
	e = spawn();
	org_z += 8;
	setorigin(e, org);
	setmodel(e, "progs/explo_wave.md3");
	e.scale = 0.1;
	e.think = _increasesize;
	e.nextthink = time;
	e.flags |= EF_ADDITIVE;
	e.flags |= EF_FULLBRIGHT;
	e.alpha = 0.5;
}

static void() _increasesize =
{	
	if (self.scale > 3)
	{
		remove(self);
		return;
	}
	self.scale += .1;
	self.think = _increasesize;
	self.nextthink = time + 0.01;
}

void()	s3_explode_	=	[self.frame,		s3_explode_] 
{
	
	if (self.frame == 4)
		self.emiteffectnum = (particleeffectnum("TE_EXPLOSION_DUST3"));
	
	if (self.frame > 13)
	{
		remove(self);
		return;
	}
	self.frame++;

	self.nextthink = time + 0.02;
};

void() BecomeExplosion2 =
{
	self.frame = 0;
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;

	self.solid = SOLID_NOT;
	setorigin(self, self.origin);
	self.nextthink = time;
	
	pointparticles (particleeffectnum("TE_EXPLOSION_BLAST"), self.origin, self.origin, 2);
	pointparticles (particleeffectnum("TE_EXPLOD"), self.origin, self.origin, 1);
	self.angles = '0 0 0';

	setmodel (self, "progs/s_explo2.spr");
	self.think = s3_explode_;
	self.scale = 0.001;

	GroundShake (self, self.shake_interval, self.shake_time);
};

void()	s2_explode_	=	[self.frame,		s2_explode_] 
{
	if (self.frame == 4)
	{
		if (self.classname != "grenade")
			self.emiteffectnum = (particleeffectnum("TE_EXPLOSION_DUST"));
		else
			self.emiteffectnum = (particleeffectnum("TE_EXPLOSION_DUST2"));
	}
	
	if (self.frame > 13)
	{
		remove(self);
		return;
	}
	self.frame++;

	self.nextthink = time + 0.02;
};

void()	sp_explode_	=	[self.frame,		sp_explode_] 
{
	//self.owner.punchangle = setvector (crandom() * 0.6, crandom() * 0.6, crandom() * 0.6);
	if (self.frame == 4)
	{
		self.emiteffectnum = (particleeffectnum("TE_EXPLOSION_DUST"));
	}
	
	if (self.frame > 13)
	{
		remove(self);
		return;
	}
	self.frame++;

	self.nextthink = time + 0.02;
};

void() BecomeExplosionPlayer =
{
	self.frame = 0;
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;

	self.solid = SOLID_NOT;
	setorigin(self, self.origin);
	self.nextthink = time;
	
	self.angles = '0 0 0';

	setmodel (self, "progs/s_explo2.spr");
	self.think = sp_explode_;
	self.scale = 0.001;
	
	pointparticles (particleeffectnum("TE_EXPLOSION_BLAST"), self.origin, self.origin, 2);
	pointparticles (particleeffectnum("TE_EXPLOD"), self.origin, self.origin, 1);
	//pointparticles (particleeffectnum("EF_EXPLODLIGHT"), self.origin);

	GroundShake (self, self.shake_interval, self.shake_time);
	//explosion_wave (self.origin);
};

void() BecomeExplosion =
{
	self.frame = 0;
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;

	self.solid = SOLID_NOT;
	setorigin(self, self.origin);
	self.nextthink = time;
	
	self.angles = '0 0 0';

	setmodel (self, "progs/s_explo2.spr");
	self.think = s2_explode_;
	self.scale = 0.001;
	
	if(self.classname == "green")
		pointparticles (particleeffectnum("TE_EXPLOSION_BLAST2"), self.origin, self.origin, 2);
	else
		pointparticles (particleeffectnum("TE_EXPLOSION_BLAST"), self.origin, self.origin, 2);

	pointparticles (particleeffectnum("TE_EXPLOD"), self.origin, self.origin, 1);
	//pointparticles (particleeffectnum("EF_EXPLODLIGHT"), self.origin);

	GroundShake (self, self.shake_interval, self.shake_time);
//	bprint("wow");
};

/*
===============================================================================

LIGHTNING

===============================================================================
*/

/*
=================
LightningDamage
=================
*/

void(vector p1, vector p2, entity anchor, entity shooter, float dmg, float kick, float len) fireRail =
{
	local vector end;
	local vector from;
	local entity ignore;

	end = p1 + p2 * len;
	from = p1;

	ignore = self;

	while(ignore)
	{
		traceline (from, end, 2, ignore);

		if((trace_ent.flags & FL_MONSTER) || (trace_ent.flags & FL_CLIENT))
			ignore = trace_ent;
		else
			ignore = __NULL__;
		
		if((trace_ent != self) && (trace_ent.takedamage))
		{
			SpawnBlood (trace_ent.origin, '0 0 -100', kick * 2.5);
			T_Damage (trace_ent, shooter, trace_endpos, shooter, dmg, kick);
		}
		
		from = trace_endpos;
	}

/*	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
    	WriteByte(MSG_BROADCAST, TE_LIGHTNING1);
    	WriteEntity(MSG_BROADCAST, anchor);
    	WriteCoord (MSG_BROADCAST, p1_x);
    	WriteCoord (MSG_BROADCAST, p1_y);
    	WriteCoord (MSG_BROADCAST, p1_z);
    	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);*/
};

.float dmg_rad;
.float dmg_lsr;

void(vector to) TE_BFGEXPLOD =
{
	local entity thingamabob;
	thingamabob = spawn();
	thingamabob.origin = to;
	thingamabob.movetype = MOVETYPE_NONE;
	thingamabob.velocity = '0 0 0';
	thingamabob.touch = SUB_Null;
	setmodel (thingamabob , "progs/muzzleflash.spr");
	thingamabob.solid = SOLID_NOT;
	thingamabob.think = SUB_Remove;
	thingamabob.nextthink = time + 0.2;
	thingamabob.emiteffectnum = particleeffectnum("TE_BFG_BIGEXPLOSION");

	for (float i = 0; i < 6; i++)
		SpawnBlood (to, '0 0 0', 0);
};

vector bfg_laser_pos(vector  p, float  dist) = // q2 rerelease
{
	float theta = random(2 * M_PI);
	float phi = acos(crandom());

	vector d;
	d[0] = sin(phi) * cos(theta);
	d[1] = sin(phi) * sin(theta);
	d[2] = cos(phi);

	return p + (d * dist);
};

void() bfg_laser_update = // q2 rerelease
{
	if (time > self.ltime || !self.owner.velocity)
	{
		remove(self);
		return;
	}
	
	trailparticles (particleeffectnum (self.classname), self, self.origin, self.oldorigin);

	self.origin = self.owner.origin;
	self.nextthink = time + 0.01;
	self.think = bfg_laser_update;
};

void(float rad = 256, string trailname = "te_lightning2") bfg_spawn_laser = // q2 rerelease
{
	vector end = bfg_laser_pos(self.origin, rad);
	traceline(self.origin, end, TRUE, self);
	//	

	if (trace_fraction == 1)
		return;

	entity laser = spawn();

	laser.think = bfg_laser_update;
	laser.nextthink = time + 0.01;
	laser.ltime = time + 0.4;
	laser.oldorigin = trace_endpos;
	laser.classname = trailname;
	laser.owner = self;
	setorigin(laser, self.origin);
};

void() tbspray =
{
	local	entity target; 
	local float points = self.dmg; // DEADASS B UH
	
// literal copy of quake 2's code
	for (target = findradius(self.origin, self.dmg_rad); target; target= target.chain)
	{
    		if(!target.takedamage)
                	continue;
        	if(target == self.owner)
                	continue;
        	if(!CanDamage(target, self.owner))
            	continue;
        	if(!CanDamage(target, self))
            	continue;
		if(target.solid == SOLID_CORPSE)
                	continue;
		
		T_Damage (target, self, self.origin, self.owner, points, points*0.15);  
		SpawnBlood ((target.absmin + target.absmax) * 0.5, '0 0 0', 0);
		
		if (target.flags & FL_MONSTER)
		{
			makevectors(target.angles);
			TE_BFGEXPLOD((target.absmin + target.absmax) * 0.5 + v_forward * 24);
		}
	}	
};

void() tbThink =
{      
	local	entity ent; local vector point, end, dir;
	
	if(time > self.dspeed)
		remove(self);

// literal copy of quake 2's code
	
	if (time > self.ltime)
		bfg_spawn_laser (); // rerelease
	
	for (ent= findradius(self.origin, self.dmg_rad); ent; ent = ent.chain)
	{
		if(!ent.takedamage)
            continue;
        if(ent== self.owner)
            continue;
        if(!CanDamage(ent, self))
            continue;
		if(!(ent.flags & FL_MONSTER) && !(ent.flags & FL_CLIENT))
			continue;
		if(ent.solid == SOLID_CORPSE)
            continue;
		
		point = (ent.maxs - ent.mins) * 0.5 + ent.absmin;	
		dir = normalize (point - self.origin);

		end = self.origin + dir*2048;	

		//traceline(self.origin, end, TRUE, self);
		trailparticles (particleeffectnum ("te_lightning2"), ent, self.origin, end);
		
		local entity targ = ent;

		if (time > self.ltime)
		{		
			T_Damage (ent, self, self.origin, self.owner, self.dmg_lsr, 0);
			SpawnBlood (point, '0 0 0', 0);
		}
		//particle (point, '0 0 100', 73, self.dmg_lsr* 8);

		sound (self, CHAN_VOICE, "weapons/lhit.wav", 1, ATTN_NORM);
	}
	
	if (time > self.ltime)
		self.ltime = time + 0.05;

	self.think = tbThink;
	self.nextthink = time;
};

void()	sbfg_explode1 =	[self.frame,		sbfg_explode1 ] 
{
	//self.owner.punchangle = setvector (crandom() * 0.7, crandom() * 0.7, crandom() * 0.7);

	if (self.cnt == 3)
	 	tbspray ();
	//if (self.cnt == 12)
		
	
	if (self.cnt == 32)
	{
		remove(self);
		return;
	}
	self.cnt++;
	self.scale = self.scale + 0.8;
	self.alpha -= 0.05;
	self.nextthink = time + 0.04;
};

void() BecomeExplosionBFG =
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/bfgballblast.md3");
	self.effects = self.effects | EF_ADDITIVE | EF_FULLBRIGHT;

	self.solid = SOLID_NOT;
	self.scale = 1;
	self.angles_x = random()*300 + 100;
	self.angles_y = random()*300 + 100;
	self.angles_z = random()*300 + 100;
	self.scale = 1.2;
	
	self.frame = 0;
	self.cnt =0;
	self.alpha = 1;
	self.think = sbfg_explode1;
	self.nextthink = time;
	self.emiteffectnum = 0;
	//for (float i = 0; i < 10; i++)
	//	 bfg_spawn_laser (2048);
};

void() T_tbTouch =
{ 
	self.effects = 0;

	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	if (other.takedamage)
	{
		T_Damage (other, self, self.origin, self.owner, self.dmg, 0);
	}
	
	pointparticles (particleeffectnum("TE_BFGIMPACT2"), self.origin);
	pointparticles (particleeffectnum("TE_BFGIMPACT"), self.origin, '0 0 0', 1);
	
	pointparticles (particleeffectnum("EF_EXPLODLIGHT2"), self.origin);

	T_RadiusDamage (self, self.owner, 200, 200, other);
	GroundShake (self, 0.7, 0.8);

	self.origin = self.origin - 32*normalize(self.velocity);

	self.traileffectnum = 0; 
	//self.emiteffectnum = particleeffectnum("TE_BFG_BIGEXPLOSION2"); 
	pointparticles (particleeffectnum("TE_BFG_BIGEXPLOSION2"), self.origin);
	//pointparticles (particleeffectnum("TE_BFG_BIGEXPLOSION2"), self.movedir);

	BecomeExplosionBFG ();
	
/*	local float rand = rint(random() * 3);
		
	switch(rand)
	{
		case 3:
		sound(self, CHAN_BODY, "weapons/bfg/bfg_explode1.wav", 1, ATTN_NORM);
		break;

		case 2:
		sound(self, CHAN_BODY, "weapons/bfg/bfg_explode2.wav", 1, ATTN_NORM);
		break;

		case 1:	
		sound(self, CHAN_BODY, "weapons/bfg/bfg_explode3.wav", 1, ATTN_NORM);
		break;

		default:
		sound(self, CHAN_BODY, "weapons/bfg/bfg_explode4.wav", 1, ATTN_NORM);
		break;
	}*/
};

void(vector dir, vector org, float damage, float damage_lsr, float damage_rad) launch_thunderball =
{	
	local entity missile;

	missile= spawn ();
	missile.angles = vectoangles(dir);
	missile.effects = missile.effects | EF_ADDITIVE | EF_FULLBRIGHT;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;

	missile.dmg = damage;
	missile.dmg_lsr = damage_lsr;
	missile.dmg_rad = damage_rad;
	
	missile.owner = self;
	missile.classname = "thunderball";
	missile.dspeed = time + 6;
	//missile.avelocity = '0 300 0';

	missile.think = tbThink;
	missile.touch = T_tbTouch;
	missile.nextthink = time + frametime;
	missile.velocity = dir * 400;
	missile.ltime = 0;
	missile.alpha = 0.99;
	missile.deathtype = "bfglaser";
	missile.traileffectnum = particleeffectnum("EF_BFGBALL"); // no trails for now, beware the ballsacks
	missile.emiteffectnum = particleeffectnum("TE_BFGBALLSAC"); // no trails for now, beware the ballsacks
	
	
//	setmodel (missile, "progs/bfgsac.md3");
	setmodel (missile, "progs/muzzleflash.spr");

	setsize (missile, VEC_ORIGIN, VEC_ORIGIN);	
	setorigin (missile, org);
	//sound(missile, CHAN_BODY, "weapons/bfg__l1a.wav", 1, ATTN_STATIC);
	
	if (self.flags & FL_CLIENT)
		CheckDodge(missile.origin, dir, 1000);
};

float BLACKHOLE_TIMER = 4.5;

void() blackhole_eat =
{	
	local vector org;

	org = self.enemy.origin + (self.enemy.mins + self.enemy.maxs) * 0.5;
	self.origin = org;	

	if (self.enemy.health < 2) // always gib enemy before disappearing
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_TELEPORT);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);

		T_Damage (self.enemy, self, self.origin, self.owner, 1500, 0);
		remove(self);
		return;
	}

	if ( ((time - self.ltime) > BLACKHOLE_TIMER) || !self.enemy)
	{
		remove(self);
		return;
	}

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	
	if (self.enemy)
		T_Damage (self.enemy, self, self.origin, self.owner, self.dmg_lsr, 0);

	self.think = blackhole_eat;
	self.nextthink = time + 0.1;
};

void() T_blackholetouch =
{ 
	self.effects = 0;

	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	if (!other.takedamage)
	{
		remove(self);
		return;
	}
	
	self.think = blackhole_eat;
	self.nextthink = time + frametime;
	self.enemy = other;
	self.touch = __NULL__;
	self.ltime = time;
};

void() blackhole_fx =
{ 
	if (time > self.ltime)
		remove(self);

	makevectors(self.angles);
	particle (self.origin + normalize(v_forward * -20), '0 0 0', 11, 45);
	particle (self.origin + normalize(v_forward * -20), '0 0 -2', 11, 5);
	
	self.think = blackhole_fx;
	self.nextthink = time + 0.2*frametime;
};

void(vector dir, vector org, float damage) launch_blackhole =
{	
	local entity missile;

	missile= spawn ();
	missile.angles = vectoangles(dir);
	missile.movetype = MOVETYPE_FLYMISSILE;	
	missile.solid = SOLID_BBOX;

	missile.dmg_lsr = damage;
	
	missile.owner = self;
	missile.classname = "backhole";
	missile.ltime = time + 6;

	missile.touch = T_blackholetouch;
	
	missile.think = blackhole_fx;
	missile.nextthink = time + frametime;

	missile.velocity = dir * 800;
		
	setmodel (missile, "");
	setsize (missile, VEC_ORIGIN, VEC_ORIGIN);
	
	setorigin (missile, org);
//	sound(missile, CHAN_BODY, "weapons/bfg__l1a.wav", 1, ATTN_STATIC);
	
	if (self.flags & FL_CLIENT)
		CheckDodge(missile.origin, dir, 1000);
};

//=============================================================================


void() spike_touch;
void() superspike_touch;

/*
===============
launch_spike

Used for both the player and the ogre
===============
*/

void()	_explode1	=	[0,		_explode2] {self.alpha = 0.8; };
void()	_explode2	=	[1,		_explode3] {self.alpha = 0.8; };
void()	_explode3	=	[2,		_explode4] {self.alpha = 0.6; };
void()	_explode4	=	[3,	     SUB_Remove] {self.alpha = 0.3; };

void(vector org, vector vel) TE_BLASTER = 
{	
	
	
		pointparticles (particleeffectnum("TE_PLASIMPACT2"), self.origin,'0 0 0', 1);
		pointparticles (particleeffectnum("TE_PLASIMPACT"), self.origin,'0 0 0', 1);
		
		return;
	

/*	local entity explode;
	local vector dir, end;
	local float time_left = time;
	
	explode = spawn();

	setmodel (explode , "progs/explode.mdl");
	setorigin (explode , org);
	setsize (explode , '0 0 0', '0 0 0');		
	explode.think = _explode1;
	explode.nextthink = time + frametime;
	explode.solid = SOLID_NOT;
	explode.movetype = MOVETYPE_NONE;
			
	end = self.origin + time_left*vel;
	traceline(self.origin, end, FALSE, self); // guessing how q2 returns *cplane_t plane
	
	if (!trace_plane_normal)
		dir = '0 0 0';
	else
		dir = trace_plane_normal;
	
// i'm really confused to why i had to make some of them negative numbers
	explode.angles_x = -acos(dir_z)/M_PI*180;
	if (dir_x)
		explode.angles_y = atan2(dir_y, dir_x)/M_PI*180;
	else if (dir_y > 0)
		explode.angles_y = -90;
	else if (dir_y < 0)
		explode.angles_y = 270;
	else
		explode.angles_y = 0;

	particle (org , v_forward * -8, self.color, 25);*/
};

void() Laser_Touch =
{
	local vector org;
	
	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	
	self.classname = "plasma";
	org = self.origin - 12*normalize(self.velocity);
	//T_RadiusDamage(self, self.owner, 15, 20, other);	

	if (other.takedamage)
	{
		SpawnBlood (org, self.velocity*0.2, self.dmg * 2.5);
		T_Damage (other, self, self.origin, self.owner, self.dmg, 15);
	}
	else
	{		
		pointparticles (particleeffectnum("TE_PLASIMPACT3"), org, '0 0 0', 1);
		sound(self, CHAN_BODY, "weapons/lashit.wav", 1, ATTN_STATIC);
		TE_BLASTER (org, self.velocity);
	}
	remove(self);
};

void() laserThink = 
{	
	if (time > self.ltime)
		remove(self);

	makevectors(self.angles);
	particle (self.origin + normalize(v_forward * -20), '0 0 0', 235, 1);
	self.think = laserThink ;
	self.nextthink = time + 0.01;
};

void() laserThink2 = 
{	
	if (time > self.ltime)
		remove(self);

	if (self.frame < 2)
		self.frame += 1;
	else 
		self.frame = 0;

	self.think = laserThink2 ;
	self.nextthink = time + 0.01;
};


void(vector org, vector vec, vector right, vector up) LaunchLaser =
{
	vec = normalize(vec);
	local float spd;	
	local entity missile;

	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLY;
	missile.solid = SOLID_BBOX;

	missile.dmg = 15;
	if (self.flags & FL_FLY)
		missile.dmg = 3;
	else if(self.classname == "player" && !deathmatch)
		missile.dmg = 34;
	else if(self.classname == "monster_tank" || self.classname == "monster_commander" || self.classname == "monster_makron")
		missile.dmg = 30;
	
	
			setmodel (missile, "progs/muzzleflash.spr");
			missile.effects = missile.effects | EF_ADDITIVE | EF_FULLBRIGHT;

		//	missile.scale = 1.4;
		//	missile.ltime = time + 5;
		//	missile.alpha = 0.99;
			missile.think = SUB_Remove;
			missile.nextthink = time + 6;
			missile.traileffectnum = particleeffectnum ("EF_PLASMA");
			missile.emiteffectnum = particleeffectnum ("TE_PLASMA");
	

	setsize (missile, '0 0 0', '0 0 0');		

	setorigin (missile, org);
	
	if(self.classname == "monster_tank" || self.classname == "monster_medic")
		spd = 800;
	else if((self.flags & FL_FLY))
		spd = 1000;
	else if (self.flags & FL_CLIENT)
		spd = 2000;
	else
		spd = 600;
	
	//makevectors(vec);
	missile.velocity = vec * spd + up + right;
	missile.angles = vectoangles(missile.velocity);

	missile.touch = Laser_Touch;

	if (self.classname != "player")
		sound(missile, CHAN_BODY, "misc/lasfly.wav", 1, ATTN_STATIC);
	else
		sound(missile, CHAN_BODY, "weapons/plasmagun/flight_01.wav", 1, ATTN_STATIC);
};

void(vector org, vector dir, float speed = 1000, float slidebox = 0) launch_spike =
{	
    newmis = spawn();
    newmis.owner = self;
    newmis.movetype = MOVETYPE_FLY;

	if(slidebox)
		newmis.solid = SOLID_SLIDEBOX;
	else
    	newmis.solid = SOLID_BBOX;

    newmis.angles = vectoangles(dir);

    newmis.touch = spike_touch;
    newmis.classname = "spike";
    newmis.think = SUB_Remove;
    newmis.nextthink = time + 6;
    setmodel(newmis, "progs/spike.mdl");
    setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
    setorigin(newmis, org);

    newmis.velocity = dir * speed;
};


void() W_FireSuperSpikes =
{
    local vector dir;

    sound(self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
    self.attack_finished = time + 0.2;
  //  self.currentammo = self.ammo_nails = self.ammo_nails - 2;
    dir = aim(self, 1000);
    launch_spike(self.origin + '0 0 16', dir);
    newmis.touch = superspike_touch;
    setmodel(newmis, "progs/s_spike.mdl");
    setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
    self.punchangle_x = -2;
	CheckDodge(newmis.origin, aim(self, 10000), 1000);
};


void(float ox) W_FireSpikes =
{
    local vector dir;

    makevectors(self.v_angle);

    sound(self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
    self.attack_finished = time + 0.2;
  //  self.currentammo = self.ammo_nails = self.ammo_nails - 1;
    dir = aim(self, 1000);
    launch_spike (self.origin + '0 0 16' + v_right * ox, dir);

    self.punchangle_x = -2;

	CheckDodge(newmis.origin, aim(self, 10000), 1000);

};


void() spike_touch =
{
	local float dmg;
	
	if(self.owner.classname == "player")
		dmg = 10;
	else
		dmg = 8;
	
    if (other == self.owner)
    {
        return;
    }
    if (other.solid == SOLID_TRIGGER)
    {
        return; // trigger field, do nothing
    }

    if (pointcontents(self.origin) == CONTENT_SKY)
    {
        remove(self);
        return;
    }

    // hit something that bleeds
    if (other.takedamage)
    {
        spawn_touchblood(dmg);
        T_Damage(other, self, self.origin, self.owner, dmg, 3);
    } 
	else
    {
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
         WriteByte(MSG_BROADCAST, TE_SPIKE);
	WriteCoord(MSG_BROADCAST, self.origin_x);
        WriteCoord(MSG_BROADCAST, self.origin_y);
        WriteCoord(MSG_BROADCAST, self.origin_z);
		 

	//m_puff (self.origin);
    }
	 remove(self);


};


void() superspike_touch =
{	
	local float dmg;
	
	if(self.owner.classname == "player")
		dmg = 20;
	else
		dmg = 16;

    if (other == self.owner)
    {
        return;
    }
    if (other.solid == SOLID_TRIGGER)
    {
        return; // trigger field, do nothing
    }

    if (pointcontents(self.origin) == CONTENT_SKY)
    {
        remove(self);
        return;
    }

    // hit something that bleeds
    if (other.takedamage)
    {
        spawn_touchblood(dmg);
        T_Damage(other, self, self.origin, self.owner, dmg, 3);
    } 
	else
    {
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
         WriteByte(MSG_BROADCAST, TE_SUPERSPIKE);
	WriteCoord(MSG_BROADCAST, self.origin_x);
        WriteCoord(MSG_BROADCAST, self.origin_y);
        WriteCoord(MSG_BROADCAST, self.origin_z);
		 

	//m_puff (self.origin);
    }
	 remove(self);
  
};

