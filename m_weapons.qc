

/*
==============================================================================

MULTI-DAMAGE

Collects multiple small damages into a single damage

==============================================================================
*/

entity multi_ent;
float	multi_damage;
float multi_knock;

void() tracer_think = {
	if (time > self.attack_finished || self.frame >= 4) {
		remove(self);
		return;
	}

	self.frame++;
	self.nextthink = time + 0.02;
};

void(vector org, vector direction, vector dest) MonsterTracer = 
{ // alkaline :3	

	float dist = vlen(org - dest);
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_NOT;

	newmis.angles = vectoangles(direction);
	
	newmis.classname = "tracer";
	newmis.think = tracer_think;
	newmis.nextthink = time + 0.02;
	newmis.alpha = 0.5;
	
	newmis.velocity = direction * 1024;
	newmis.attack_finished = time + dist/7500;
	//newmis.attack_finished = time + dist/((dist*dist/120) + 3000);

	setmodel (newmis, "progs/tracer.mdl");  //Precache model in WORLD.QC
	setsize (newmis, '0 0 0', '0 0 0');
	setorigin (newmis, org);

	
};

void() ClearMultiDamage =
{
	multi_ent = world;
	multi_damage = 0;
	multi_knock = 0;
};

void(float kick) ApplyMultiDamage =
{
	if (!multi_ent)
		return;

	T_Damage (multi_ent, self, trace_endpos, self, multi_damage, multi_knock);
};

void(entity hit, float damage, float kick) AddMultiDamage =
{
	if (!hit)
		return;
	
	if (hit != multi_ent)
	{
		multi_knock = 1;
		ApplyMultiDamage (kick);
		multi_damage = damage;
		multi_ent = hit;
		multi_knock = 0;
	}
	else
	{
		multi_damage = multi_damage + damage;
		multi_knock += kick;
	}
};

void(float damage, vector dir, float kick) m_TraceAttack =
{
	local	vector	vel, org;

	vel = normalize(dir + v_up*crandom() + v_right*crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	org = trace_endpos - dir*4;

	if (trace_ent.takedamage)
	{	
		SpawnBlood (org, vel*0.2);

		AddMultiDamage (trace_ent, damage, kick);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SPIKE);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};


void(float shotcount, vector start, vector dir, vector spread, float damage, float kick) monster_FireBullets =
{
    local vector direction;
    local vector src;

    makevectors(self.angles);
	
   // m_puff (start + v_forward * 10);
    src = start + v_forward * 10;
  //  src_z = self.absmin_z + self.size_z * 0.7;

    ClearMultiDamage();

    while (  shotcount --)
    {
        direction = dir + crandom() * spread_x * v_right + crandom() * spread_y * v_up;
		
        traceline(src, src + direction * 2048, FALSE, self);
	  if (!(vlen(src - trace_endpos) < 96 && trace_ent.solid == SOLID_BSP))
			MonsterTracer (src, direction, trace_endpos);

        if (trace_fraction != 1.0)
        {
            m_TraceAttack(damage, direction, kick);
        }
    }
    ApplyMultiDamage(kick);
};

void() m_GrenadeExplode =
{
	if (self.owner.classname == "monster_shambler")
		self.classname = "missile";

	T_RadiusDamage (self, self.owner, self.dmg, self.dmg + 40, world);
	sound (self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	pointparticles (particleeffectnum("TE_ROCKETIMPAC"), self.origin);
	pointparticles (particleeffectnum("TE_ROCKETIMPAC2"), self.origin);

	BecomeExplosion ();
};

void() m_GrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage == DAMAGE_AIM)
	{
		m_GrenadeExplode();
		return;
	}
	sound (self, CHAN_VOICE, "weapons/bounce.wav", 1, ATTN_NORM);	// bounce sound
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

void(vector org, vector dir, float damage, float timer = 1.5) monster_FireGravityBall=
{
	local	entity missile;
	
	self.effects = self.effects | EF_MUZZLEFLASH;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
		
// set missile speed	

	makevectors (dir);

	missile.velocity = dir * 600;
	missile.velocity += (200 + crandom() * 10)* v_up;
	missile.velocity += (crandom() * 10) * v_right;
	missile.dmg = damage;

	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = m_GrenadeTouch;

// set missile duration
	missile.nextthink = time + timer;
	missile.think = m_GrenadeExplode;
	
	setmodel (missile, "progs/lavaball.mdl");

	if (self.classname == "monster_shambler")
	{
		missile.traileffectnum = particleeffectnum ("EF_PLASMA2");
		missile.skin = 1;
	}
	else
		missile.traileffectnum = particleeffectnum ("EF_NADETRAIL");
	
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, org);
};

void(vector org, vector dir, float damage) monster_FireNade =
{
	local	entity missile;
	
	self.effects = self.effects | EF_MUZZLEFLASH;

	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
		
// set missile speed	

	makevectors (dir);
	missile.traileffectnum = particleeffectnum ("EF_NADETRAIL");


	missile.velocity = dir * 600;
	missile.velocity += (200 + crandom() * 10)* v_up;
	missile.velocity += (crandom() * 10) * v_right;
	missile.dmg = damage;

	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = m_GrenadeTouch;
	
// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = m_GrenadeExplode;
	
	setmodel (missile, "progs/grenade.mdl");

	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, org);
};