

/*
==============================================================================

MULTI-DAMAGE

Collects multiple small damages into a single damage

==============================================================================
*/


void() tracer_touch = 
{
	if (other == self.owner)
		return;
	vector org = self.origin;

	if (other.takedamage)
	{	
		T_Damage (other, self, self.origin, self.owner, self.dmg, self.dspeed);
		SpawnBlood (org, self.velocity * 0.2, self.dspeed * 2.5);
		// pointparticles (particleeffectnum("TE_BLOOD2"), org);
	}
	else
	{	
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SPIKE);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);

		SpawnImpact (org, self.velocity);
	}

	remove(self);
};

void(vector org, vector direction, float damage, float kick, float speed) TracerBullet = 
{ 

	local entity tracer = spawn();
	tracer.owner = self;
	tracer.movetype = MOVETYPE_FLY;
	tracer.solid = SOLID_BBOX;

	tracer.angles = vectoangles(direction);
	
	tracer.classname = "tracer";
	tracer.effects = tracer.effects | EF_ADDITIVE | EF_FULLBRIGHT;
	tracer.think = SUB_Remove;
	tracer.nextthink = time + 6;
	tracer.touch = tracer_touch;
	tracer.alpha = 0.7;
	tracer.scale = 0.7;
	tracer.dmg = damage;
	
	tracer.velocity = direction * speed;
	tracer.dspeed = kick;

	setmodel (tracer, "progs/tracer.md3");  //Precache model in WORLD.QC
	setsize (tracer, '0 0 0', '0 0 0');
	setorigin (tracer, org);

	
};

void(float shotcount, vector start, vector dir, vector spread, float damage, float kick, float speed) monster_FireBullets =
{
    local vector direction;
    local vector src;

    makevectors(self.angles);
	
   // m_puff (start + v_forward * 10);
    src = start + v_forward * 10;
  //  src_z = self.absmin_z + self.size_z * 0.7;

    while (  shotcount --)
    {
        direction = dir + crandom() * spread_x * v_right + crandom() * spread_y * v_up;
		
		TracerBullet (src, direction, damage, kick, speed);

    }
};

//================================================================================================================================

float STOP_EPSILON   = 0.1;
vector ClipVelocity(vector in, vector normal, float overbounce)
{
    float dot = dotproduct(in, normal);
    vector out = in + (normal * (-2 * dot));
    out = out * (overbounce - 1.0);
    
    if (dotproduct(out, out) < STOP_EPSILON * STOP_EPSILON)
        out = '0 0 0';
    
    return out;
}

static float vlensquared(vector v) =
{
	return v[0]^2 + v[1]^2 + v[2]^2;
}

float pitches[9] = { -80.0, -70.0, -60.0, -50.0, -40.0, -30.0, -20.0, -10.0, -5.0 };
// quake 2 rerelease
float M_CalculatePitchToFire(vector targ, vector start,__out vector aim_, float speed, float time_remaining, float mortar, float destroy_on_touch)
{
  
    float best_pitch = 0.0;
	// idk a quakec version of this
    float best_dist = 0;

    float sim_time = 0.1;
   	vector fwd, up, r;
    vector pitched_aim = vectoangles_(aim_);
    float grav = cvar("sv_gravity");	

    for (float i = 0; i < 9; i++)
    {
        if (mortar && pitches[i] >= -30.0)
            break;

        pitched_aim_x = pitches[i];
		
	  	AngleVectors(pitched_aim, fwd, r, up);

        vector vel = fwd * speed;
        vector org = start;

        float t = time_remaining;

        while (t > 0.0)
        {  
			vel += '0 0 -1' * grav * sim_time;

            vector end = org + (vel * sim_time);
			traceline(org, end, 0, self);

            org = trace_endpos;

            if (trace_fraction < 1)
            {
                if (pointcontents(org) == CONTENT_SKY)
                    break;

                org = org + trace_plane_normal;
                vel = ClipVelocity(vel, trace_plane_normal, 1.6);

                float dist = vlensquared(org - targ);

                if (trace_ent == self.enemy || (trace_ent.classname == "player") || 
				(trace_plane_normal_z >= 0.7 && dist < (128 * 128) && dist > best_dist))
                {
                  	best_pitch = pitches[i];
			//  bprint(ftos(best_pitch), "\n");
                    best_dist = dist;
                }

				if (destroy_on_touch)
                    break;
            }

            t -= sim_time;
        }
    }

    if (best_dist > 0)
    {	
        pitched_aim[0] = best_pitch;
	  	AngleVectors(pitched_aim, fwd, r, up);
        aim_ = fwd;
	
        return TRUE;
    } 

    return FALSE;
}

void() OgreGrenadeExplode =
{
	if (self.owner.classname == "monster_shambler" || self.owner.classname == "monster_shambler2")
		self.classname = "missile";
	
	self.dmg = 60;
	T_RadiusDamage (self, self.owner, self.dmg, self.dmg_rad + 40, world);
//	sound (self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);

rocketimpact  ();
	
	if (self.classname == "missile")
	{
		self.classname = "green";
		
	}
	BecomeExplosion ();
};

void() m_GrenadeExplode =
{
	if (self.owner.classname == "monster_shambler" || self.owner.classname == "monster_shambler2")
		self.classname = "missile";

	T_RadiusDamage (self, self.owner, self.dmg, self.dmg_rad + 40, world);
//	sound (self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);

rocketimpact  ();
	
	if (self.classname == "missile")
	{
		self.classname = "green";
		
	}
	BecomeExplosion ();
};

void() m_GrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage)
	{
		m_GrenadeExplode();
		return;
	}
	sound (self, CHAN_VOICE, "weapons/bounce.wav", 1, ATTN_NORM);	// bounce sound
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

void(vector org, vector dir, float damage, float timer, float right_adjust, float up_adjust, float speed) monster_FireGravityBall=
{
	local	entity missile;
	float grav = cvar("sv_gravity");
	
	self.effects = self.effects | EF_MUZZLEFLASH;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
		
// set missile speed	

	makevectors (dir);
	missile.velocity = dir * speed;

	if (up_adjust)
	{
		float gravityAdjustment = grav / 800;
		missile.velocity += v_up * up_adjust * gravityAdjustment ;
	}

	if (right_adjust)
		missile.velocity += v_right * right_adjust;

	missile.dmg = damage;
	missile.dmg_rad = damage;
	missile.aiflags |= IS_PROJECTILE;

	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = m_GrenadeTouch;

// set missile duration
	missile.nextthink = time + timer;
	missile.ltime = timer;
	missile.think = m_GrenadeExplode;

	setmodel (missile, "progs/muzzleflash.spr");
		
	if (self.classname == "monster_shambler" || self.classname == "monster_shambler2" || self.classname == "monster_boglord")
	{	
		missile.emiteffectnum = particleeffectnum ("TE_HK_FIREBALL");
		missile.traileffectnum = particleeffectnum ("EF_NADETRAIL2");
		missile.shake_interval = 0.6;
		missile.shake_time = 1;
	}	
	else
	{
		missile.emiteffectnum = particleeffectnum ("TE_IMP_FIREBALL");
		missile.traileffectnum = particleeffectnum ("EF_NADETRAIL");
		missile.shake_interval = 0.2;
		missile.shake_time = 1;
	}

	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, org);
};

static vector vectoangles_ (vector vec)
{
	float forward;
	float yaw, pitch;

	if (vec[1] == 0 && vec[0] == 0)
	{
		if (vec[2] > 0)
			return '-90 0 0';
		else
			return  '-270 0 0';
	}

	// PMM - fixed to correct for pitch of 0
	if (vec[0])
		yaw = (atan2(vec[1], vec[0]) * (180 / M_PI));
	else if (vec[1] > 0)
		yaw = 90;
	else
		yaw = 270;

	if (yaw < 0)
		yaw += 360;

	forward = sqrt(vec[0] * vec[0] + vec[1] * vec[1]);
	pitch = (atan2(vec[2], forward) * (180 / M_PI));

	if (pitch < 0)
		pitch += 360;

	vec_x = -pitch;
	vec_y = yaw;
	vec_z = 0;
	
	return vec;
}