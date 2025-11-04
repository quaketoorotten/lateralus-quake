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

void(vector org, vector vel) SpawnBlood;
void() SuperDamageSound;

.void() weaponthink;
.void() weaponnoise;
.void() weaponuse;

.int weaponstate;

int WEAPON_IDLE = 0;
int WEAPON_USED = 1;
int WEAPON_ACTIVATE = 2;
int WEAPON_DEACTIVATE = 3;
int WEAPON_RELOAD = 5;

.float weapontype;
.float oldweapon;
.float newweapon;

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

	precache_sound("weapons/machinegun/machgun_shot_1v2.wav");
	precache_sound("weapons/machinegun/machgun_shot_2v2.wav");
	precache_sound("weapons/machinegun/machgun_shot_3v2.wav");	
	precache_sound("weapons/machinegun/machgun_shot_4v2.wav");
	precache_sound("weapons/machinegun/machgun_shot_5v2.wav");	

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

	precache_sound("weapons/rocket/blast1.wav");
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

	precache_sound("weapons/chain_gun_shot_v3/chaingun_shot_1v3.wav");
	precache_sound("weapons/chain_gun_shot_v3/chaingun_shot_2v3.wav");
	precache_sound("weapons/chain_gun_shot_v3/chaingun_shot_3v3.wav");	
	precache_sound("weapons/chain_gun_shot_v3/chaingun_shot_4v3.wav");	

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


	precache_sound("weapons/wepchg1a.wav");
	precache_sound("weapons/wepchg1b.wav");
};

void() AutofireMachineNoise =
{
	local float r = rint(random() * 4);

	if(r == 4)
		sound(self, CHAN_WEAPON, "weapons/machinegun/machgun_shot_1v2.wav", 1, ATTN_NORM);
	else	if(r == 3)
		sound(self, CHAN_WEAPON, "weapons/machinegun/machgun_shot_3v2.wav", 1, ATTN_NORM);
	else	if(r == 2)
		sound(self, CHAN_WEAPON, "weapons/machinegun/machgun_shot_4v2.wav", 1, ATTN_NORM);
	else	if(r == 1)
		sound(self, CHAN_WEAPON, "weapons/machinegun/machgun_shot_2v2.wav", 1, ATTN_NORM);
	else
		sound(self, CHAN_WEAPON, "weapons/machinegun/machgun_shot_5v2.wav", 1, ATTN_NORM);
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
		sound(self, CHAN_WEAPON, "weapons/chain_gun_shot_v3/chaingun_shot_1v3.wav", 1, ATTN_NORM);
	else	if(r == 2)
		sound(self, CHAN_WEAPON, "weapons/chain_gun_shot_v3/chaingun_shot_2v3.wav", 1, ATTN_NORM);
	else	if(r == 1)
		sound(self, CHAN_WEAPON, "weapons/chain_gun_shot_v3/chaingun_shot_3v3.wav", 1, ATTN_NORM);
	else	
		sound(self, CHAN_WEAPON, "weapons/chain_gun_shot_v3/chaingun_shot_4v3.wav", 1, ATTN_NORM);
}

void() RocketNoise =
{
	local float r = rint(random() * 3);

	if(r == 3)
		sound(self, CHAN_WEAPON, "weapons/rocket/blast1.wav", 1, ATTN_NORM);
	else	if(r == 2)
		sound(self, CHAN_WEAPON, "weapons/rocket/blast2.wav", 1, ATTN_NORM);
	else	if(r == 1)
		sound(self, CHAN_WEAPON, "weapons/rocket/blast3.wav", 1, ATTN_NORM);
	else
		sound(self, CHAN_WEAPON, "weapons/rocket/blast4.wav", 1, ATTN_NORM);
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
	local float dtime;
	local float dist;
	local entity targ, oself;

	if(skill <= 1)
		if(random() > 0.6)
			return;

	if(skill == 2)
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
		
		if(targ.th_dodge)
		{		
			dist = vlen(trace_endpos - src);
			dtime = (dist - targ.maxs_x) / speed;

			if(dtime <= 0) 
				dtime = 0.2;

			targ.enemy = self;
			targ.flags = targ.flags | FL_DODGED;
			targ.dspeed = dtime;

			oself = self;
			self = targ;

			self.th_dodge (); 
			self.dodge_finished = time + 3 + random()*2;
			
			self = oself;
		}
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

void(vector org, vector vel) SpawnBloodSplat =
{
    local entity missile;

    missile = spawn();
    missile.owner = self;
    missile.movetype = MOVETYPE_TOSS;
    missile.solid = SOLID_TRIGGER;

    makevectors(self.angles);

    missile.velocity = vel;
    missile.velocity_z = missile.velocity_z - 1000 + 50 * random();

    // set missile duration

    setmodel(missile, "progs/muzzleflash.spr");

    setsize(missile, '0 0 0', '0 0 0');
    setorigin(missile, org);
    missile.touch = _splatter;
};

/*
================
SpawnBlood
================
*/
void(vector org, vector vel) SpawnBlood =
{	
	//te_bloodshower (org, vel, 100, damage);
    pointparticles (particleeffectnum("TE_BLOODSPRAY"), org);
	SpawnBloodSplat (org, vel);
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
    SpawnBlood(self.origin + vel * 0.01, vel);
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
			SpawnBlood (org, vel * 0.2);
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


void() A_explode = [self.frame, A_explode]
{
	self.frame ++;
	self.alpha = self.alpha - 0.02;

	if (time > self.dspeed && self.skin < 6)
	{
		self.dspeed = time + 0.15;
		self.skin ++;
	}

	if (self.frame >= self.dcnt)
		remove(self);
};

void() BecomeExplosion3D =
{
	self.frame = 0;
	self.skin = 0;
	self.alpha = 1;
	self.dspeed = time + 0.15;
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;

	self.solid = SOLID_NOT;
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(self, self.origin);
	setmodel (self, "progs/r_explode.mdl"); 
	
	self.angles_x = 0;
	self.angles_z = 0;

	if ((self.flags & FL_ONGROUND) && !(self.flags & FL_MONSTER))
	{
		self.frame = 30;
		self.dcnt = 49;
	}
	else if (!(self.flags & FL_ONGROUND) && (pointcontents(self.origin) == CONTENT_WATER))
	{
		self.frame = 16;
		self.dcnt = 29;
	}
	else
	{
		self.frame = 0;
		self.dcnt = 15;
	}

	self.think = A_explode;
	self.nextthink = time + frametime;

	
    WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte(MSG_BROADCAST, TE_EXPLOSION);
    WriteCoord(MSG_BROADCAST, self.origin_x);
    WriteCoord(MSG_BROADCAST, self.origin_y);
    WriteCoord(MSG_BROADCAST, self.origin_z);
};


void()	s3_explode_	=	[self.frame,		s3_explode_] 
{

	if (self.frame == 3)
		self.emiteffectnum = (particleeffectnum("TE_EXPLOSION_DUST3"));
	
	if (self.frame == 20)
		self.emiteffectnum = 0;
	
	if (self.frame > 31)
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
	self.nextthink = time + frametime;
	
	pointparticles (particleeffectnum("TE_EXPLOD"), self.origin, self.origin, 1);
	self.angles = '0 0 0';

	setmodel (self, "progs/s_explo2.spr");
	self.think = s3_explode_;
	self.scale = 0.1;

};

void()	s2_explode_	=	[self.frame,		s2_explode_] 
{

	if (self.frame == 3)
	{
		if (self.classname != "grenade")
			self.emiteffectnum = (particleeffectnum("TE_EXPLOSION_DUST"));
		else
			self.emiteffectnum = (particleeffectnum("TE_EXPLOSION_DUST2"));
	}

	if (self.frame == 20)
		self.emiteffectnum = 0;
	
	if (self.frame > 31)
	{
		remove(self);
		return;
	}
	self.frame++;

	self.nextthink = time + 0.02;
};

void() BecomeExplosion =
{
	self.frame = 0;
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;

	self.solid = SOLID_NOT;
	setorigin(self, self.origin);
	self.nextthink = time + frametime;
	
	self.angles = '0 0 0';

	setmodel (self, "progs/s_explo2.spr");
	self.think = s2_explode_;
	self.scale = 0.1;
	
	pointparticles (particleeffectnum("TE_EXPLOD"), self.origin, self.origin, 1);
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

void(vector p1, vector p2, entity anchor, entity shooter, float dmg, float kick, float tempent, float len) fireRail =
{
	local vector end;
	local vector from;
	local entity ignore;

	end = p1 + p2 * len;
	from = p1;

	ignore = self;

	while(ignore)
	{
		traceline (from, end, FALSE, ignore);

		if((trace_ent.flags & FL_MONSTER) || (trace_ent.flags & FL_CLIENT))
			ignore = trace_ent;
		else
			ignore = __NULL__;
		
		if((trace_ent != self) && (trace_ent.takedamage))
		{
			particle (trace_endpos, '0 0 100', 225, dmg*4);
			T_Damage (trace_ent, shooter, trace_endpos, shooter, dmg, kick);
		}
		
		from = trace_endpos;
	}

	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
    	WriteByte(MSG_BROADCAST, tempent);
    	WriteEntity(MSG_BROADCAST, anchor);
    	WriteCoord (MSG_BROADCAST, p1_x);
    	WriteCoord (MSG_BROADCAST, p1_y);
    	WriteCoord (MSG_BROADCAST, p1_z);
    	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);
};

.float dmg_rad;
.float dmg_lsr;


void()	TE_BFGEXPLOD1	=	[0,		TE_BFGEXPLOD2] {};
void()	TE_BFGEXPLOD2	=	[1,		TE_BFGEXPLOD3] {};
void()	TE_BFGEXPLOD3	=	[2,		TE_BFGEXPLOD4] {};
void()	TE_BFGEXPLOD4	=	[3,		TE_BFGEXPLOD5] {};
void()	TE_BFGEXPLOD5	=	[3,		SUB_Remove]    {};


void(vector to) TE_BFGEXPLOD =
{
	local entity thingamabob;
	thingamabob = spawn();
	thingamabob.origin = to;
	thingamabob.movetype = MOVETYPE_NONE;
	thingamabob.velocity = '0 0 0';
	thingamabob.touch = SUB_Null;
	setmodel (thingamabob , "progs/bfg3.spr");
	thingamabob.solid = SOLID_NOT;
	thingamabob.think = TE_BFGEXPLOD1;
	thingamabob.nextthink = time + 0.1;
	thingamabob.alpha = 0.6;
	//thingamabob.effects = EF_BLUE;
};


void() tbspray =
{
	local	entity target; 
	local float points = self.dmg; // DEADASS B UH
	local vector org;
	
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

		dprint (ftos(self.dmg));
		T_Damage (target, self, self.origin, self.owner, points, points * 0.5);  

		if(target.classname != "gib")
		{
			org = target.origin + (target.mins + target.maxs)*0.5;
			TE_BFGEXPLOD (org);
		}
	}
};

void() tbThink =
{      
	local	entity ent, ignore;
	local vector point, dir, end, from;
	
	if (self.frame < 1)
		self.frame += 1;
	else 
		self.frame = 0;

	if(time > self.dspeed)
		remove(self);

// literal copy of quake 2's code
	
	for (ent= findradius(self.origin, 256); ent; ent = ent.chain)
	{
		if(!ent.takedamage)
                	continue;
        	if(ent== self.owner)
                	continue;
        	if(!CanDamage(ent, self))
            	continue;
		if(!(ent.flags & FL_MONSTER) && !(ent.flags & FL_CLIENT) && (ent.classname != "explo_box"))
			continue;
		
		point = (ent.maxs - ent.mins) * 0.5 + ent.absmin;	
		dir = normalize (point - self.origin);
		
		ignore = self;
		
		from = self.origin;
		end = self.origin + dir*2048;	
		
		while(1)
		{
			traceline (from, end, FALSE, ignore);

			if (!trace_ent)
				break;
		
			if((trace_ent != self.owner) && (trace_ent.takedamage))
			{
				local entity targ = trace_ent;
				T_Damage (targ, self, self.origin, self, self.dmg_lsr, 0);
				particle (targ.origin, '0 0 100', 73, self.dmg_lsr* 8);
			}
			
			if(!(trace_ent.flags & FL_MONSTER) && !(trace_ent.flags & FL_CLIENT))
			{
				WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
				WriteByte (MSG_BROADCAST, TE_SPIKE);
				WriteCoord (MSG_BROADCAST, trace_endpos_x);
				WriteCoord (MSG_BROADCAST, trace_endpos_y);
				WriteCoord (MSG_BROADCAST, trace_endpos_z);
				//m_puff (trace_endpos);
			}
			
			ignore = trace_ent;
			from = trace_endpos;
		}

		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, 6);

		if(self.owner.flags & FL_CLIENT)
			WriteEntity(MSG_BROADCAST, ent);
		else
			WriteEntity(MSG_BROADCAST, self);

		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
		WriteCoord(MSG_BROADCAST, trace_endpos_x);
		WriteCoord(MSG_BROADCAST, trace_endpos_y);
		WriteCoord(MSG_BROADCAST, trace_endpos_z);

		sound (self, CHAN_VOICE, "weapons/lhit.wav", 1, ATTN_NORM);
	}

	self.think = tbThink;
	self.nextthink = time + 0.1;
};

void()	bfg_explode1	=	[0,		bfg_explode2] { };
void()	bfg_explode2	=	[1,		bfg_explode3] {};
void()	bfg_explode3	=	[2,		bfg_explode4] {self.emiteffectnum = particleeffectnum("TE_BFG_BIGEXPLOSION");};	
void()	bfg_explode4	=	[3,		bfg_explode5] {tbspray ();};
void()	bfg_explode5	=	[4,		bfg_explode6] {};
void()	bfg_explode6	=	[5,		SUB_Remove	] {self.emiteffectnum = 0;};

void() BecomeExplosionBFG =
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/bfg2.spr");
	self.solid = SOLID_NOT;
	
	bfg_explode1 ();
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

	pointparticles (particleeffectnum("TE_BFGIMPACT"), self.origin);
	pointparticles (particleeffectnum("TE_BFGIMPACT2"), self.origin);

	self.origin = self.origin - 16*normalize(self.velocity);

	T_RadiusDamage (self, self.owner, 200, 200, other);

	BecomeExplosionBFG ();
	
	local float rand = rint(random() * 3);
		
	switch(rand)
	{
		case 3:
		sound(self, CHAN_AUTO, "weapons/bfg/bfg_explode1.wav", 1, ATTN_NORM);
		break;

		case 2:
		sound(self, CHAN_AUTO, "weapons/bfg/bfg_explode2.wav", 1, ATTN_NORM);
		break;

		case 1:	
		sound(self, CHAN_AUTO, "weapons/bfg/bfg_explode3.wav", 1, ATTN_NORM);
		break;

		default:
		sound(self, CHAN_AUTO, "weapons/bfg/bfg_explode4.wav", 1, ATTN_NORM);
		break;
	}
	
	self.owner.punchangle = setvector (crandom() * 1.2, crandom() * 1.2, crandom() * 1.2);
};

void(vector dir, vector org, float damage, float damage_lsr, float damage_rad) launch_thunderball =
{	
	local entity missile;

	missile= spawn ();
	missile.angles = vectoangles(dir);
	// missile.effects = missile.effects | EF_BLUE;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;

	missile.dmg = damage;
	missile.dmg_lsr = damage_lsr;
	missile.dmg_rad = damage_rad;
	
	missile.owner = self;
	missile.classname = "thunderball";
	missile.dspeed = time + 6;
	missile.avelocity = '300 300 300';

	missile.think = tbThink;
	missile.touch = T_tbTouch;
	missile.nextthink = time + frametime;
	missile.velocity = dir * 400;
	missile.alpha = 0.4;
	missile.traileffectnum = particleeffectnum("EF_BFGBALL"); // no trails for now, beware the ballsacks
		
	setmodel (missile, "progs/bfg1.spr");
	setsize (missile, VEC_ORIGIN, VEC_ORIGIN);	
	setorigin (missile, org);
	//sound(missile, CHAN_BODY, "weapons/bfg__l1a.wav", 1, ATTN_STATIC);
	
	if (self.flags & FL_CLIENT)
		CheckDodge(missile.origin, dir, 1000);
};

float BLACKHOLE_TIMER = 0.5;

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
	if (self.owner.classname == "player")
	{
		pointparticles (particleeffectnum("TE_PLASIMPACT"), self.origin);
		pointparticles (particleeffectnum("TE_PLASIMPACT2"), self.origin);
		return;
	}

	local entity explode;
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

	particle (org , v_forward * -8, self.color, 25);
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
	
	org = self.origin - 8*normalize(self.velocity);

	if (other.takedamage)
	{
		SpawnBlood (org, self.velocity*0.2);
		T_Damage (other, self, self.origin, self.owner, self.dmg, 2);
	}
	else
	{	
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

void(vector org, vector vec) LaunchLaser =
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
		missile.dmg = 32;
	else if(self.classname == "monster_tank" || self.classname == "monster_commander" || self.classname == "monster_makron")
		missile.dmg = 30;
	
	switch (self.classname)
	{	
		case "player":
			missile.think = SUB_Remove;
			missile.nextthink = time + 6;
			setmodel (missile, "progs/plasma.mdl");
			missile.alpha = 0.6;
			missile.scale = 1.4;
			missile.traileffectnum = particleeffectnum ("EF_PLASMA");
			break;
		default:
			missile.ltime = time + 5;
			missile.think = laserThink;
			missile.nextthink = time + 0.01;
			setmodel (missile, "progs/laser.mdl");
			missile.traileffectnum = particleeffectnum ("EF_BLASTER");
			break;
	}

	setsize (missile, '0 0 0', '0 0 0');		

	setorigin (missile, org);
	
	if(self.classname == "monster_tank" || self.classname == "monster_medic")
		spd = 800;
	else if((self.flags & FL_FLY))
		spd = 1000;
	else if (self.flags & FL_CLIENT)
		spd = 1800;
	else
		spd = 600;

	missile.velocity = vec * spd;
	missile.angles = vectoangles(missile.velocity);

	missile.touch = Laser_Touch;

	if (self.classname != "player")
		sound(missile, CHAN_BODY, "misc/lasfly.wav", 1, ATTN_STATIC);
	else
		sound(missile, CHAN_BODY, "weapons/plasmagun/flight_01.wav", 1, ATTN_STATIC);
};

void(vector org, vector vec) LaunchMissile =
{
	local float speed;	

	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	newmis.effects = EF_DIMLIGHT;
	newmis.classname = "spike";

	setmodel (newmis, "progs/laser.mdl");
	setsize (newmis, '0 0 0', '0 0 0');		

	setorigin (newmis, org);
	
	if(self.classname == "monster_tank" || self.classname == "monster_medic" || self.classname == "monster_chick")
		speed = 800;
	else if((self.flags & FL_FLY))
		speed = 1000;
	else if(self.classname == "player")
		speed = 1500;
	else
		speed = 600;

	newmis.velocity = normalize(vec) * speed;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;

	sound(newmis, CHAN_BODY, "weapons/rockfly.wav", 1, ATTN_STATIC);
};

void(vector org, vector dir, float speed = 1000) launch_spike =
{	
    newmis = spawn();
    newmis.owner = self;
    newmis.movetype = MOVETYPE_FLY;
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
    self.currentammo = self.ammo_nails = self.ammo_nails - 2;
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
    self.currentammo = self.ammo_nails = self.ammo_nails - 1;
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

/*
=====================================================================

player use weapons 

=====================================================================
*/

void()	player_run;

.entity pweaponmodel;
entity gunpmodel;

void(string weapon) player_get_gunmodel =
{
//	setmodel(self, "progs/male/tris.mdl");
//	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
//	self.vw_index = getmodelindex(weapon);
	
	if (!self.pweaponmodel)
	{
		gunpmodel = spawn();
		gunpmodel.owner = self;
		self.pweaponmodel = gunpmodel;
		self.pweaponmodel.exteriormodeltoclient = gunpmodel.owner;
	}

	setmodel(self.pweaponmodel, weapon);
	setorigin(self.pweaponmodel, self.origin);
	self.pweaponmodel.solid = SOLID_NOT;
	setsize (self.pweaponmodel, VEC_ORIGIN, VEC_ORIGIN);
};

void(float item) W_SetCurrentAmmo =
{	
    self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));
	
	if (self.weapon == self.oldweapon || item == TRUE)
	{
		switch(self.weapontype)
		{
			case 2:
			self.currentammo = self.savedammo_shells;
			self.items = self.items | IT_SHELLS;
			break;
			
			case 3:
			self.currentammo = self.savedammo_nails;
			self.items = self.items | IT_NAILS;
			break;

			case 4:
			self.currentammo = self.savedammo_rockets;
			self.items = self.items | IT_ROCKETS;
			break;

			case 9:
			self.currentammo = self.ammo_rockets;
			self.items = self.items | IT_ROCKETS;
			break;

			case 5:
			self.currentammo = self.savedammo_cells;
			self.items = self.items | IT_CELLS;
			break;

			case 6:
			self.currentammo = self.savedammo_nails2;
			self.items = self.items | IT_NAILS;
			break;

			case 7:
			self.currentammo = self.savedammo_cells2;
			self.items = self.items | IT_CELLS;
			break;

			case 8:
			self.currentammo = self.savedammo_shells2;
			self.items = self.items | IT_SHELLS;
			break;

			default:
			self.currentammo = 0;
			self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));
			break;
		}
			
		return;
	}
	
   if (self.weapon == IT_AXE)
    {
	self.weaponnoise = W_WeaponBlasterNoise;
        self.currentammo = 0;
        self.weaponmodel = "progs/v_blast.mdl";
        	
	  self.weaponthink = W_WeaponBlaster;	
	  self.weapontype = 1;
	  self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));
	  player_get_gunmodel("progs/male/w_blaster.mdl");
    }
    else if (self.weapon == IT_SHOTGUN)
    {	
	  self.weaponnoise = W_WeaponPistolNoise ;
        self.currentammo = self.savedammo_shells2;
        self.weaponmodel = "progs/v_shotg.mdl";
        	
	  self.weaponthink = W_WeaponShotgun;
        self.items = self.items | IT_SHELLS;
	  self.weapontype = 8;
	  player_get_gunmodel("progs/male/w_shotgun.mdl");
    }
    else if (self.weapon == IT_SUPER_SHOTGUN)
    {
        self.currentammo = self.savedammo_shells;
        self.weaponmodel = "progs/v_shotg2.mdl";
	
	  self.weaponnoise = W_WeaponShotgunNoise;

        self.weaponthink = W_WeaponSShotgun;
        self.items = self.items | IT_SHELLS;
        self.weapontype = 2;
	  player_get_gunmodel("progs/male/w_sshotgun.mdl");
    }
    else if (self.weapon == IT_NAILGUN)
    {
	self.weaponnoise = W_WeaponMachineGunNoise;
        self.currentammo = self.savedammo_nails;
        self.weaponmodel = "progs/v_machn.mdl";
	
	  self.weaponthink = W_WeaponMachineGun;
        self.items = self.items | IT_NAILS;
        self.weapontype = 3;
	  player_get_gunmodel("progs/male/w_machinegun.mdl");
    }
    else if (self.weapon == IT_SUPER_NAILGUN)
    {
	self.weaponnoise = W_WeaponChainGunNoise;
        self.currentammo = self.savedammo_nails2;
        self.weaponmodel = "progs/v_chain.mdl";

	  self.weaponthink = W_WeaponChainGun;	
        self.items = self.items | IT_NAILS;
        self.weapontype = 6;
	  player_get_gunmodel("progs/male/w_chaingun.mdl");
    }
    else if (self.weapon == IT_GRENADE_LAUNCHER)
    {
	self.weaponnoise = W_WeaponGrenadeLaunNoise;
        self.currentammo = self.ammo_rockets;
        self.weaponmodel = "progs/v_launch.mdl";

	  self.weaponthink = W_WeaponGrenadeLaun;
        self.items = self.items | IT_ROCKETS;
        self.weapontype = 9;
	  player_get_gunmodel("progs/male/w_glauncher.mdl");
    }
    else if (self.weapon == IT_ROCKET_LAUNCHER)
    {
	self.weaponnoise = W_WeaponRocketLaunNoise;
        self.currentammo = self.savedammo_rockets;
        self.weaponmodel = "progs/v_rocket.mdl";
        
	  self.weaponthink = W_WeaponRocketLaun;
        self.items = self.items | IT_ROCKETS;
        self.weapontype = 4;
	  player_get_gunmodel("progs/male/w_rlauncher.mdl");
    }
    else if (self.weapon == IT_LIGHTNING)
    {
	self.weaponnoise = W_WeaponHyperBlasNoise ;
        self.currentammo = self.savedammo_cells;
        self.weaponmodel = "progs/v_hyperb.mdl";
        
	  self.weaponthink = W_WeaponHyperBlas;
        self.items = self.items | IT_CELLS;
        self.weapontype = 5;
	  player_get_gunmodel("progs/male/w_hyperblaster.mdl");
    }
    else if (self.weapon == IT_BFG)
    {
	self.weaponnoise = W_WeaponBFGNoise;
        self.currentammo = self.savedammo_cells2;
        self.weaponmodel = "progs/v_bfg.mdl";
        
	  self.weaponthink = W_WeaponBFG;
        self.items = self.items | IT_CELLS;
        self.weapontype = 7;
	  player_get_gunmodel("progs/male/w_bfg.mdl");
    }
	else if (self.weapon == IT_HANDGR)
    {
	self.weaponnoise = W_flashnoise;
        self.currentammo = 0;
        self.weaponmodel = "progs/v_handgr.mdl";
        
	self.weaponthink = W_WeaponHandGr;
        	  self.weapontype = 1;
	  self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));
	  player_get_gunmodel("progs/male/a_grenades.mdl");
    }
	else if (self.weapon == IT_RAILGUN)
    {
	self.weaponnoise = W_WeaponChainsawNoise;
        self.currentammo = 0;
        self.weaponmodel = "progs/v_rail.mdl";
        	
	  self.weaponthink = W_WeaponChainsaw;	
	  self.weapontype = 1;
	  self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));
	  player_get_gunmodel("progs/male/w_blaster.mdl");
    }
	
    else
    {
        	self.weaponnoise = W_WeaponBlasterNoise;
        self.currentammo = 0;
        self.weaponmodel = "progs/v_blast.mdl";
        	
	  self.weaponthink = W_WeaponBlaster;	
	  self.weapontype = 1;
	  self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));
	  player_get_gunmodel("progs/male/w_blaster.mdl");
	self.weapon = IT_AXE;
    }
	
	self.newweapon = 0;
	  self.weaponframe = 0;
	 self.weaponstate = WEAPON_ACTIVATE;
};


float() W_BestWeapon =
{
    local float it;

    it = self.items;

    if (self.waterlevel <= 1 && self.ammo_cells >= 50 && (it & IT_BFG))
    {
        return IT_BFG;
    }
    if (self.ammo_cells >= 1 && (it & IT_LIGHTNING))
    {
        return IT_LIGHTNING;
    }
    if (self.ammo_nails >= 2 && (it & IT_SUPER_NAILGUN))
    {
        return IT_SUPER_NAILGUN;
    }
    if (self.ammo_shells >= 2 && (it & IT_SUPER_SHOTGUN))
    {
        return IT_SUPER_SHOTGUN;
    }
    if (self.ammo_nails >= 1 && (it & IT_NAILGUN))
    {
        return IT_NAILGUN;
    }
    if (self.ammo_shells >= 1 && (it & IT_SHOTGUN))
    {
        return IT_SHOTGUN;
    }

    return IT_AXE;
};


float(float w) RankForWeapon =
{
	if (w == IT_LIGHTNING)
		return 1;
	if (w == IT_BFG)
		return 2;
	if (w == IT_ROCKET_LAUNCHER)
		return 3;
	//if (w == IT_RAILGUN)
	//	return 4;
	if (w == IT_SUPER_SHOTGUN)
		return 4;
	if (w == IT_SUPER_NAILGUN)
		return 5;
	if (w == IT_GRENADE_LAUNCHER)
		return 6;
	if (w == IT_SHOTGUN)
		return 7;
	if (w == IT_NAILGUN)
		return 8;
	return 10;
};

float() W_CheckNoAmmo =
{
	local float ammo_type = 0;

	switch(self.weapontype)
	{
		case 2:
		ammo_type = self.ammo_shells;
		break;

		case 8:
		ammo_type = self.ammo_shells;
		break;
			
		case 6:
		ammo_type = self.ammo_nails;
		break;

		case 3:
		ammo_type = self.ammo_nails;
		break;

		case 4:
		ammo_type = self.ammo_rockets;
		break;
		
		case 7:
		ammo_type = self.ammo_cells;
		break;

		case 5:
		ammo_type = self.ammo_cells;
		break;

		default:
		ammo_type = 0;
		break;
	}
	
    if (self.currentammo > 0)
    {
        return TRUE; // has at least one ammo
    }

    if (self.weapontype == 1)
    {
        return TRUE; // weapon doesn't need ammo
    }

	if (ammo_type > 0 && self.currentammo < 1)
	{	
		self.currentammo = 0;
		self.weaponstate = WEAPON_RELOAD;
		return FALSE; // just reload the gun
	}

    self.newweapon = W_BestWeapon();
	
	self.weaponstate = WEAPON_DEACTIVATE;

    // drop the weapon down
    return FALSE;
};

/*
============
W_ChangeWeapon
============
*/
void() W_ChangeWeapon =
{
    local float it, am, fl;

    it = self.items;
    am = FALSE;

    if (self.impulse == 1)
    {
        fl = IT_AXE;
    }
    else if (self.impulse == 2)
    {
        fl = IT_SHOTGUN;
        if (self.savedammo_shells < 1)
        {	
            am = TRUE;

		if (self.ammo_shells > 1)
			am = FALSE;
        }
    }
    else if (self.impulse == 3)
    {
        fl = IT_SUPER_SHOTGUN;
        if (self.savedammo_shells < 1)
        {
            am = TRUE;

		if (self.ammo_shells > 1)
			am = FALSE;
        }
    }
    else if (self.impulse == 4)
    {
        fl = IT_NAILGUN;
        if (self.savedammo_nails < 1)
        {	
            am = TRUE;

		if (self.ammo_nails > 1)
			am = FALSE;
        }
    }
    else if (self.impulse == 5)
    {
        fl = IT_SUPER_NAILGUN;
        if (self.ammo_nails < 1)
        {
            am = TRUE;
        }
    }
    else if (self.impulse == 6)
    {
        fl = IT_GRENADE_LAUNCHER;
        if (self.ammo_rockets < 1)
        {
            am = TRUE;
        }
    }
    else if (self.impulse == 7)
    {
        fl = IT_LIGHTNING;
        if (self.ammo_cells < 1)
        {
            am = TRUE;
        }
    }
    else if (self.impulse == 8)
    {
        fl = IT_ROCKET_LAUNCHER;
        if (self.ammo_rockets < 1)
        {
            am = TRUE;
        }
    }
    else if (self.impulse == 14)
    {
        fl = IT_BFG;
        if (self.ammo_cells < 2)
        {
            am = TRUE;
        }
    }
	else if (self.impulse == 13)
    {
        fl = IT_RAILGUN;
    }
	else if (self.impulse == 15)
    {	
	  if (self.weapon == IT_HANDGR)
		fl = self.oldweapon;
        else
		fl = IT_HANDGR;
    }


    self.impulse = 0;

    if (!(self.items & fl))
    {
        // don't have the weapon or the ammo
        sprint(self, "no weapon.\n");
        return;
    }

    if (am)
    {
        // don't have the ammo
        sprint(self, "not enough ammo.\n");
        return;
    }

    //
    // set weapon, set ammo
    //

	if (self.weaponstate == WEAPON_USED)
		return;

	if (self.weapon == fl)
		return;
	
    	self.newweapon = fl;
	self.oldweapon = self.weapon;
	self.weaponstate = WEAPON_DEACTIVATE;
};

/*
============
CycleWeaponCommand

Go to the next weapon with ammo
============
*/
.float nextweapon;

void() CycleWeaponCommand =
{
    local float it, am, nextweapon;

    it = self.items;
    self.impulse = 0;
	//self.weaponstate = WEAPON_SCROLLING;
	nextweapon = self.weapon;

    while (TRUE)
    {
        am = FALSE;

	if (nextweapon == IT_RAILGUN)
        {
            nextweapon = IT_AXE;
        }
        else if (nextweapon == IT_AXE)
        {
            nextweapon= IT_SHOTGUN;
            if (self.savedammo_shells2 < 1)
            {
                am = TRUE;
            }
        }
        else if (nextweapon== IT_SHOTGUN)
        {
            nextweapon= IT_SUPER_SHOTGUN;
            if (self.savedammo_shells < 1)
            {
                am = TRUE;
            }
        }
        else if (nextweapon== IT_SUPER_SHOTGUN)
        {
            nextweapon= IT_NAILGUN;
            if (self.savedammo_nails < 1)
            {
                am = TRUE;
            }
        }
        else if (nextweapon== IT_NAILGUN)
        {
            nextweapon = IT_SUPER_NAILGUN;
            if (self.savedammo_nails2 < 1)
            {
                am = TRUE;
            }
        }
        else if (nextweapon== IT_SUPER_NAILGUN)
        {
            nextweapon= IT_GRENADE_LAUNCHER;
            if (self.ammo_rockets < 1)
            {
                am = TRUE;
            }
        }
        else if (nextweapon== IT_GRENADE_LAUNCHER)
        {
		nextweapon= IT_LIGHTNING;
            if (self.savedammo_cells < 1)
            {
                am = TRUE;
            }
        }
	else if (nextweapon== IT_LIGHTNING)
        {
            nextweapon= IT_ROCKET_LAUNCHER;
            if (self.savedammo_rockets < 1)
            {
                am = TRUE;
            }
        }
        else if (nextweapon== IT_ROCKET_LAUNCHER)  
        {
            nextweapon= IT_BFG;
            if (self.savedammo_cells2 < 10)
            {
                am = TRUE;
            }
        }
        else if (nextweapon== IT_BFG)  
        {
            nextweapon= IT_RAILGUN;

        }

        if ((it & nextweapon) && am == FALSE)
        {
		self.newweapon = nextweapon;	
		self.weaponstate = WEAPON_DEACTIVATE;
		self.oldweapon = self.weapon;
            return;
        }
    }
};

/*
============
CycleWeaponReverseCommand

Go to the prev weapon with ammo
============
*/
void() CycleWeaponReverseCommand =
{
    local float it, am, nextweapon;

    it = self.items;
    self.impulse = 0;
	//self.weaponstate = WEAPON_SCROLLING;
	nextweapon = self.weapon;

    while (TRUE)
    {
        am = FALSE;
	
	if (nextweapon == IT_RAILGUN)
        {
            nextweapon = IT_BFG;
            if (self.savedammo_cells2 < 10)
            {
                am = TRUE;
            }
        }
	  else if (nextweapon == IT_BFG)
        {
            nextweapon = IT_ROCKET_LAUNCHER;
            if (self.savedammo_rockets < 1)
            {
                am = TRUE;
            }
        }
	 else if (nextweapon == IT_ROCKET_LAUNCHER)
        {
            nextweapon = IT_LIGHTNING;
            if (self.savedammo_cells < 1)
            {
                am = TRUE;
            }
        }
        else if (nextweapon == IT_LIGHTNING)
        {
            nextweapon = IT_GRENADE_LAUNCHER;
            if (self.ammo_rockets < 1)
            {
                am = TRUE;
            }
        }
        else if (nextweapon == IT_GRENADE_LAUNCHER)
        {
            nextweapon = IT_SUPER_NAILGUN;
            if (self.savedammo_nails2 < 1)
            {
                am = TRUE;
            }
        }
        else if (nextweapon == IT_SUPER_NAILGUN)
        {
            nextweapon = IT_NAILGUN;
            if (self.savedammo_nails < 1)
            {
                am = TRUE;
            }
        }
        else if (nextweapon == IT_NAILGUN)
        {
            nextweapon = IT_SUPER_SHOTGUN;
            if (self.savedammo_shells < 1)
            {
                am = TRUE;
            }
        }
        else if (nextweapon == IT_SUPER_SHOTGUN)
        {
            nextweapon = IT_SHOTGUN;
            if (self.savedammo_shells2 < 1)
            {
                am = TRUE;
            }
        }
        else if (nextweapon == IT_SHOTGUN)
        {
            nextweapon = IT_AXE;
        }
	  else if (nextweapon == IT_AXE)
        {
            nextweapon = IT_RAILGUN;
        }

        if ((it & nextweapon) && am == FALSE)
        {
           	self.newweapon = nextweapon;
		self.oldweapon = self.weapon;
		self.weaponstate = WEAPON_DEACTIVATE;
            return;
        }
    }
};

//============================================

/*
============
CheatCommand
============
*/
void() CheatCommand =
{
    if (deathmatch || coop)
    {
        return;
    }

    self.ammo_rockets = 100;
    self.ammo_nails = 300;
    self.ammo_shells = 200;
    self.items = self.items |
                 IT_AXE |
                 IT_SHOTGUN |
                 IT_SUPER_SHOTGUN |
                 IT_NAILGUN |
                 IT_SUPER_NAILGUN |
                 IT_GRENADE_LAUNCHER |
                 IT_ROCKET_LAUNCHER;

    self.ammo_cells = 300;
    self.items = self.items | 
			IT_LIGHTNING |
			IT_RAILGUN |
			IT_BFG;

    self.impulse = 0;
	self.savedammo_rockets = 5;
    self.savedammo_nails = 50;
    self.savedammo_nails2 = 60;

    self.savedammo_shells = 6;
    self.savedammo_shells2 = 16;
	self.savedammo_cells = 50;
	self.savedammo_cells2 = 40;

    W_SetCurrentAmmo(TRUE);
};


/*
============
ServerflagsCommand

Just for development
============
*/
void() ServerflagsCommand =
{
    serverflags = serverflags * 2 + 1;
};


void() QuadCheat =
{
    if (deathmatch || coop)
    {
        return;
    }

    self.super_time = 1;
    self.super_damage_finished = time + 30;
    self.items = self.items | IT_QUAD;
    dprint("quad cheat\n");
};

void() SuitCheat =
{
    if (deathmatch || coop)
    {
        return;
    }

    self.rad_time = 1;
    self.radsuit_finished = time + 30;
    self.items = self.items | IT_SUIT;
    dprint("suit cheat\n");
};

void() InvisCheat =
{
    if (deathmatch || coop)
    {
        return;
    }

    self.invisible_time = 1;
    self.invisible_finished = time + 30;
    self.items = self.items | IT_INVISIBILITY;
    dprint("invis cheat\n");
};

void() PentaCheat =
{
    if (deathmatch || coop)
    {
        return;
    }

    self.invincible_time = 1;
    self.invincible_finished = time + 30;
    self.items = self.items | IT_INVULNERABILITY;
    dprint("penta cheat\n");
};

void() AllPower =
{
    if (deathmatch || coop)
    {
        return;
    }

      PentaCheat ();
	InvisCheat ();
	SuitCheat ();
	QuadCheat ();
};

void() KeyCheat =
{
    if (deathmatch || coop)
    {
        return;
    }

    self.items = self.items | IT_KEY1  | IT_KEY2;
};

/*
============
ImpulseCommands

============
*/
void() ImpulseCommands =
{
	switch(self.impulse)
	{
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		case 6:
		case 7:
		case 8:
		case 13:
		case 14:
		case 15:
			W_ChangeWeapon();
			break;
		case 9:
			CheatCommand ();
			break;
		case 10:
			CycleWeaponCommand();
			break;
		case 12:
			CycleWeaponReverseCommand ();
			break;
		case 11:
			ServerflagsCommand();
			break;
		case 121:
			KeyCheat();
			break;
		case 251:
			SuitCheat ();
			break;
		case 252:
			PentaCheat ();
			break;
		case 253:
			InvisCheat ();
			break;
		case 254:
			QuadCheat ();
			break;
		case 255:
			AllPower ();
			break;
		default:
			return;	
	}	
		
	self.impulse = 0;
};

/*
============
W_WeaponFrame

Called every frame so impulse events can be handled as well as possible
============
*/

float() getammotype =
{
	if (self.weapontype == 2 || self.weapontype == 8)
		return self.ammo_shells;
	else if (self.weapontype == 3 || self.weapontype == 6)
		return self.ammo_nails;
	else if (self.weapontype == 4 || self.weapontype == 9)
		return self.ammo_rockets;
	else if (self.weapontype == 5 || self.weapontype == 7)
		return self.ammo_cells;
	else
		return 0;
};

void(float ammo_type) SaveAmmo =
{
	if (self.weapontype == 2 || self.weapontype == 8)
		self.ammo_shells = ammo_type;
	else if (self.weapontype == 3 || self.weapontype == 6)
		self.ammo_nails = ammo_type;
	else if (self.weapontype == 4 || self.weapontype == 9)
		self.ammo_rockets = ammo_type;
	else if (self.weapontype == 5 || self.weapontype == 7)
		self.ammo_cells = ammo_type;
	
	if (self.weapontype == 2)
		self.savedammo_shells = self.currentammo;
	else if (self.weapontype == 8)
		self.savedammo_shells2 = self.currentammo;
	else if (self.weapontype == 3)
		self.savedammo_nails = self.currentammo;
	else if (self.weapontype == 6)
		self.savedammo_nails2 = self.currentammo;
	else if (self.weapontype == 4)
		self.savedammo_rockets = self.currentammo;
	else if (self.weapontype == 9)
		self.currentammo = self.ammo_rockets;
	else if (self.weapontype == 5)
		self.savedammo_cells = self.currentammo;			
	else if (self.weapontype == 7) // bruh
		self.savedammo_cells2 = self.currentammo;		
};

void(float start_fire, float idle_start, float idle_end, float change_end, 
	float change_start, optional float reload_start, float reload_loop_start, float reload_insert,
	 float reload_end_start, optional float reload_end_end, optional float ammo_load, float max_ammo_load) W_WeaponFrame = 
{	
	if (!self.weaponmodel)
		return;

	if (self.dspeed > time)
		return;

	change_end = change_end + 1;
	local float ammo_type = 0;

	if (self.impulse == 67 && self.weaponstate != WEAPON_RELOAD)
	{	
		ammo_type = getammotype();
		if(self.currentammo < max_ammo_load && ammo_type > 0 && reload_start)
		{
			player_run();	
			self.weaponstate = WEAPON_RELOAD;
		}

		self.impulse = 0;

		return;
	}

	if (self.weaponstate == WEAPON_ACTIVATE)
	{
		self.weaponnoise ();
		self.weaponframe ++;
		self.attack_finished = time + 20;

		if (self.weaponframe >= start_fire)
		{	
			self.weaponstate = WEAPON_IDLE;
			self.weaponframe = idle_start;
			self.attack_finished = 0;
		}

		self.dspeed = time + 0.03;
		return;
	}
	
	// WEAPON_SPIN_OUT_OF_AMMO removed
	
	if (self.weaponstate == WEAPON_DEACTIVATE)
	{	
		self.weaponuse = __NULL__;

		if (self.weaponframe < change_start)
			self.weaponframe = change_start - 1;
		
		self.weaponframe ++;
		self.attack_finished = time + 20;
				
		if (self.weaponframe > change_end)
		{	
			if (random() <= 0.5)
				sound(self, CHAN_RELOAD, "weapons/wepchg1a.wav", 1, ATTN_NORM);
			else
				sound(self, CHAN_RELOAD, "weapons/wepchg1b.wav", 1, ATTN_NORM);
				
			self.attack_finished = 0;
			self.weapon = self.newweapon;	
			
			self.weaponstate = WEAPON_IDLE;
			W_SetCurrentAmmo(FALSE);
			player_deactivate1 ();
		}

		self.dspeed = time + 0.03;
		return;
	}

	if (self.weaponstate == WEAPON_RELOAD)
	{	
		ammo_type = getammotype ();
		
		if ((self.currentammo >= max_ammo_load || ammo_type < 1) && self.weaponframe >= reload_end_end && self.currentammo > 0)
		{
			self.weaponstate = WEAPON_IDLE;
			self.weaponframe = idle_start;
			return;		
		}

		if (self.weaponframe < reload_start && (self.weaponframe >= idle_start || self.weaponframe <= idle_start))
			self.weaponframe = reload_start;

		self.weaponnoise ();	

		if (self.currentammo < max_ammo_load && self.weaponframe == reload_insert)
		{	
			if (ammo_type <= ammo_load && max_ammo_load >= ammo_load)
				ammo_load = ammo_type;

			self.currentammo = self.currentammo + ammo_load;
			ammo_type -= ammo_load;

			if (self.currentammo > max_ammo_load)
			{
				ammo_type += self.currentammo - max_ammo_load;
				self.currentammo = self.currentammo - (self.currentammo - max_ammo_load);
			}
			SaveAmmo (ammo_type);
		}

		if (self.currentammo < max_ammo_load && ammo_type > 0 && self.weaponframe > reload_end_start - 1)
			self.weaponframe = reload_loop_start;

		self.weaponframe ++;

		if ( self.weaponframe < reload_end_start - 1)
			self.attack_finished = time + 20;
		else
			self.attack_finished = 0;

		self.dspeed = time + 0.03; // wtf
		return;
	}

	if (self.button0 && self.weaponstate == WEAPON_USED)
    		return;

	if (self.attack_finished > time)
            return;

	if (self.currentammo < 1 && ammo_type < 0)
	{	
		self.weaponstate = WEAPON_DEACTIVATE;
		self.newweapon = W_BestWeapon();
		return;
	}
	
	self.dspeed = time + 0.04;

	if ((self.weaponframe == start_fire))
		self.weaponframe = idle_start;
	
	self.weaponstate = WEAPON_IDLE;
	self.attack_finished = 0;

	self.weaponframe ++;
		
	if (self.weaponframe >= idle_end)
		self.weaponframe = idle_start;
};

void() W_Attack =
{	
	if (!self.weaponuse)
		return;

	if (!W_CheckNoAmmo ())
		return;

      makevectors(self.v_angle); // calculate forward angle for velocity
      self.show_hostile = time + 1; // wake monsters up
	
      self.weaponuse();
};

void() W_WeaponUse =
{		
	// WEAPON_SPIN_OUT_OF_AMMO removed

	if (self.weaponstate == WEAPON_ACTIVATE)
		return;

	if (self.weaponstate == WEAPON_DEACTIVATE)
		return;

    if (time < self.attack_finished)
        return;
	
	    ImpulseCommands();

    // check for attack
    if (self.button0)
        W_Attack();
};


/*
========
SuperDamageSound

Plays sound if needed
========
*/
void() SuperDamageSound =
{
    if (self.super_damage_finished > time)
    {
        if (self.super_sound < time)
        {
            self.super_sound = time + 1;
            sound(self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
        }
    }
    return;
};


