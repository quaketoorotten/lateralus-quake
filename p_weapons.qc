///============================

/* PLAYER WEAPONS SHIT!!!!

uhhhh

*/
///============================


//==============================================================================================

/*PLAYER WEAPON USE
*/
//==============================================================================================


void(vector org) TE_GUNSMOKE =
{	
	org += self.velocity * 0.04;
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_GUNSHOT);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
};

void(string mdl, vector org, vector dir, vector vel) _casing =
{
	local entity casing;
	casing = spawn();

	setmodel(casing, mdl);
    	setsize(casing, '0 0 0', '0 0 0');
    	setorigin(casing, org);
	
	casing.movetype = MOVETYPE_BOUNCE;
   	casing.solid = SOLID_TRIGGER;

	//makevectors (self.v_angle);
	casing.velocity = vel;
	casing.angles = vectoangles(aim(self,10000));

	casing.nextthink =  time + 10 + random()*5;
	casing.think = SUB_Remove;
};

void(string mdl, vector org) _mag =
{
	local entity casing;
	casing = spawn();

	setmodel(casing, mdl);
    	setsize(casing, '0 0 0', '0 0 0');
    	setorigin(casing, org);
	
	casing.movetype = MOVETYPE_BOUNCE;
   	casing.solid = SOLID_TRIGGER;

	casing.velocity = '0 0 10';
	casing.scale = 0.8;	

	casing.nextthink =  time + 10 + random()*5;
	casing.think = SUB_Remove;
	casing.avelocity = '0 600 600';
};

float() BFGNoAmmo = 
{	
	if (self.savedammo_cells2 > 29)	
          	return FALSE;

	if (self.ammo_cells > 30)
		return FALSE;

	return TRUE;
};


float() AmmoLessCheck = 
{	
	return FALSE;
};

/*
================
W_FireShotgun
================
*/
float() PistolNoAmmo = 
{	
	if (self.savedammo_shells2 > 0)	
        return FALSE;

	if (self.ammo_shells > 0)
		return FALSE;

	return TRUE;
};

void() W_FireShotgun =
{
    local vector dir;
	local vector offset, start;

	local float dmg = 18, kick = 8;

	if (deathmatch)
	{
		dmg = 8; 
		kick = 0.5;
	}
	

    local float r = rint(random() * 2);

	if (self.weaponframe == 15)
	{
		if (r==2)
			sound(self, CHAN_WEAPON, "weapons/pistol/pistol_shot_02a.wav", 1, ATTN_NORM);
		else if (r==1)
			sound(self, CHAN_WEAPON, "weapons/pistol/pistol_shot_03a.wav", 1, ATTN_NORM);
		else
			sound(self, CHAN_WEAPON, "weapons/pistol/pistol_shot_04a.wav", 1, ATTN_NORM);
	}

	self.punchangle = setvector (-2, crandom() * 0.2, crandom() * 0.2);

	offset = setvector (0, 8, self.view_ofs[2] - 8);
	makevectors(self.v_angle);
	start = ProjectAim (self.origin, offset, v_forward, v_right);

    self.currentammo -= 1;
    dir = aim(self, 10000);

	TE_GUNSMOKE (start + v_forward * 32 + '0 0 4');
    FireBullet (start,  dir, 0, 0, dmg, kick, TE_SPIKE);
	
	offset = setvector (14, 8, self.view_ofs[1] + 16);
	makevectors(self.v_angle);

	_casing ("progs/shell.mdl", ProjectAim (self.origin, offset, v_forward, v_right), aim(self, 10000), self.velocity + v_right*-75 + v_up*(25 + random()*50));
};


/*
================
W_FireSuperShotgun
================
*/
float() ShotgunNoAmmo = 
{	
	if (self.savedammo_shells > 0)	
        return FALSE;

	if (self.ammo_shells > 0)
		return FALSE;

	return TRUE;
};

void() W_FireSuperShotgun =
{
    local vector dir;
	local vector offset, start;

	local float dmg = 14, kick = 5;

	if (deathmatch)
	{
		dmg = 8; 
		kick = 4;
	}

	local float r = rint(random() * 4);	

	if (r == 4)
		    sound(self, CHAN_WEAPON, "weapons/shotgun/fire/sgfire_01.wav", 1, ATTN_NORM);
	else if (r == 3)
		    sound(self, CHAN_WEAPON, "weapons/shotgun/fire/sgfire_02.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_WEAPON, "weapons/shotgun/fire/sgfire_03.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_WEAPON, "weapons/shotgun/fire/sgfire_04.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_WEAPON, "weapons/shotgun/fire/sgfire_05.wav", 1, ATTN_NORM);

  	self.punchangle = setvector (-4, crandom() * 0.3, crandom() * 0.3);

	offset = setvector (0, 4, self.view_ofs[2] - 8);
	makevectors(self.v_angle);
	start = ProjectAim (self.origin, offset, v_forward, v_right);

    self.currentammo -= 1;
    dir = aim(self, 10000);
	
    FirePallets (SHOTGUN_PELLETS, start,  dir, SHOTGUN_HSPREAD, SHOTGUN_VSPREAD, dmg, kick, TE_SPIKE);
	
	offset = setvector (0, 6, self.view_ofs[2] - 2);
	makevectors(self.v_angle);
	start = ProjectAim (self.origin, offset, v_forward, v_right);
	
	TE_GUNSMOKE (start + v_forward * 32);
	TE_GUNSMOKE (start + v_forward * 32 + v_up * 2);
	TE_GUNSMOKE (start + v_forward * 32 + v_right * 2);
	TE_GUNSMOKE (start + v_forward * 32 + v_right * -2);

   // FirePallets (SSHOTGUN_PELLETS / 2, start,  dir, SSHOTGUN_HSPREAD*1.3, SHOTGUN_VSPREAD, dmg, kick, TE_GUNSHOT);
};

float() DoubleBarrelNoAmmo = 
{	
	if (self.savedammo_shellsDB > 0)	
        return FALSE;

	if (self.ammo_shells > 1)
		return FALSE;

	return TRUE;
};

void() W_FireDoubleBarrel =
{
    local vector dir;
	local vector offset, start;

	local float dmg = 14, kick = 5;

	if (deathmatch)
	{
		dmg = 8; 
		kick = 4;
	}

	sound(self, CHAN_WEAPON, "weapons/ssg/fire_04.wav", 1, ATTN_NORM);

  	self.punchangle = setvector (-6, crandom() * 0.3, crandom() * 0.3);

	offset = setvector (0, 4, self.view_ofs[2] - 8);
	makevectors(self.v_angle);
	start = ProjectAim (self.origin, offset, v_forward, v_right);

    self.currentammo -= 2;
    dir = aim(self, 10000);
	
    FirePallets (SHOTGUN_PELLETS, start,  dir, SHOTGUN_HSPREAD*2, SHOTGUN_VSPREAD*1.3, dmg, kick, TE_SPIKE);
	FirePallets (SHOTGUN_PELLETS, start,  dir, SHOTGUN_HSPREAD*2, SHOTGUN_VSPREAD*1.3, dmg, kick, TE_SPIKE);

	offset = setvector (0, 6, self.view_ofs[2] - 2);
	makevectors(self.v_angle);
	start = ProjectAim (self.origin, offset, v_forward, v_right);
	
	TE_GUNSMOKE (start + v_forward * 32);
	TE_GUNSMOKE (start + v_forward * 32 + v_up * 2);
	TE_GUNSMOKE (start + v_forward * 32 + v_right * 2);
	TE_GUNSMOKE (start + v_forward * 32 + v_right * -2);

   // FirePallets (SSHOTGUN_PELLETS / 2, start,  dir, SSHOTGUN_HSPREAD*1.3, SHOTGUN_VSPREAD, dmg, kick, TE_GUNSHOT);
};


/*
================
W_FireMachineGun
================
*/
float() MachineGunNoAmmo = 
{	
	if (self.savedammo_nails > 0)	
          	return FALSE;

	if (self.ammo_nails > 0)
		return FALSE;

	return TRUE;
};

void() W_FireMachineGun =
{
    local vector dir;
	local vector offset, start;

	local float dmg = 14, kick = 2;

	if (deathmatch)
	{
		dmg = 6; 
		kick = 0.5;
	}

    AutofireMachineNoise ();

	local float r = rint(random() * 2);

	if(r == 2)
		sound(self, CHAN_RELOAD, "weapons/machinegun/mg_mech_03.wav", 1, ATTN_NORM);
	else	if(r == 1)
		sound(self, CHAN_RELOAD, "weapons/machinegun/mg_mech_02.wav", 1, ATTN_NORM);
	else
		sound(self, CHAN_RELOAD, "weapons/machinegun/mg_mech_01.wav", 1, ATTN_NORM);

	self.punchangle = setvector (crandom() * 0.7, crandom() * 0.7, crandom() * 0.7);

	offset = setvector (0, 4, self.view_ofs[2] - 8);
	makevectors(self.v_angle);
	start = ProjectAim (self.origin, offset, v_forward, v_right);

    self.currentammo -= 1;
    dir = aim(self, 10000);
	
		TE_GUNSMOKE (start + v_forward * 32 + '0 0 4');

    FireBullet (start,  dir, MACHINEGUN_HSPREAD, MACHINEGUN_VSPREAD, dmg, kick, TE_SPIKE);

		offset = setvector (12, 0, self.view_ofs[1] + 18);
	makevectors(self.v_angle);

	_casing ("progs/shell.mdl", ProjectAim (self.origin, offset, v_forward, v_right), aim(self, 10000), self.velocity + v_right*-75 + v_up*(25 + random()*50));
};

/*
================
W_FireChaineGun
================
*/
float() ChainGunNoAmmo = 
{	
	if (self.savedammo_nails2 > 0)	
		return FALSE;

	if (self.ammo_nails > 0)
		return FALSE;

	return TRUE;
};

void() W_FireChainGun =
{	

      local vector dir;
	local vector offset, start;

	local float dmg = 16, kick = 4, r, u;

	if (self.currentammo < 1)
		return;

	if (deathmatch)
	{
		dmg = 4; 
		kick = 12;
	}

	self.punchangle = setvector (crandom() * 0.8, crandom() * 0.8, crandom() * 0.8);
	//bprint ("check");
	//bprint ("\n");

	makevectors(self.v_angle);
	
	r = 3 + crandom()*4;
	u = crandom()*4;
		
	offset = setvector (0, r, u + self.view_ofs[2] - 8);
	start = ProjectAim (self.origin, offset, v_forward, v_right);

    self.currentammo -= 1;
    dir = aim(self, 10000);
	
	self.effects = self.effects | EF_MUZZLEFLASH;
	
	TE_GUNSMOKE (start + v_forward * 32  + '0 0 4');

    FireBullet (start,  dir, CHAINGUN_HSPREAD, CHAINGUN_VSPREAD, dmg, kick, TE_SPIKE);

	offset = setvector (10, -2, self.view_ofs[1] + 16);
	makevectors(self.v_angle);

	_casing ("progs/shell.mdl", ProjectAim (self.origin, offset, v_forward, v_right), aim(self, 10000),self.velocity + v_right*-75 + v_up*(25 + random()*50));
};

void() W_FireChainGunSpinning =
{		
	if (!self.button0)
		return;
	
	local float shots = 0;

	if (self.weaponframe >= 27 && self.weaponframe <= 30 && self.button0)
		shots = 2;
	
	if (self.weaponframe >= 30 && self.weaponframe <= 35 && self.button0)
		shots = 3;

	if (shots < 1)
		return;

	AutofireMachineNoise ();

	self.solid = SOLID_BBOX;
	
	for (float i = 0; i < shots; i++)
		W_FireChainGun ();
	
	self.solid = SOLID_SLIDEBOX;
};

//=============================================================================

void() rocketimpact =
{
	pointparticles (particleeffectnum("TE_ROCKETIMPAC"), self.origin);
	pointparticles (particleeffectnum("TE_ROCKETIMPAC2"), self.origin);
}

void() T_MissileTouch =
{
    local float damg;

    if (other == self.owner)
    {
        return; // don't explode on owner
    }

    if (pointcontents(self.origin) == CONTENT_SKY)
    {
        remove(self);
        return;
    }

    damg = 165 + random()*20;
	
	rocketimpact  ();
	
	 T_RadiusDamage(self, self.owner, 180, 175, other);
	
    self.origin = self.origin - 32* normalize(self.velocity);

    if (other.takedamage)
    {
        T_Damage(other, self, self.origin, self.owner, damg, 50);

	for(float i = 0; i<6;i++)
		SpawnBlood (self.origin, '0 0 0', 20);
    }
	self.owner.punchangle = setvector (crandom() * 1.2, crandom() * 1.2, crandom() * 1.2);

	
    //sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM)
    BecomeExplosionPlayer();
};


/*
================
W_FireRocket
================
*/

void() rocketThink = 
{	
	if (time > self.ltime)
		remove(self);

	makevectors(self.angles);
	particle (self.origin + normalize(v_forward * -20), '0 0 -24', 234, 2);
	self.think = rocketThink;
	self.nextthink = time + 0.01;
};



void() W_FireRocket =
{
    local entity missile;
	local vector offset, start;

    self.currentammo -= 1;

   	RocketNoise ();

    self.punchangle = setvector (crandom() * 1.2, crandom() * 1.2, crandom() * 1.2);

    missile = spawn();
    missile.owner = self;
    missile.movetype = MOVETYPE_FLY;
    missile.solid = SOLID_BBOX;
    missile.classname = "missile";
	missile.shake_interval = 0.5;
	missile.shake_time = 1;

    // set missile speed

    offset = setvector (0, 8, self.view_ofs[1] + 8);
	makevectors(self.v_angle);
	start = ProjectAim (self.origin, offset, v_forward, v_right);

	TE_GUNSMOKE (start + v_forward * 32);
	TE_GUNSMOKE (start + v_forward * 32 + v_up * 2);
	TE_GUNSMOKE (start + v_forward * 32 + v_right * 2);
	TE_GUNSMOKE (start + v_forward * 32 + v_right * -2);

    missile.velocity = aim(self, 1000);
    missile.velocity = missile.velocity * 800;
    missile.angles = vectoangles(missile.velocity);

    missile.touch = T_MissileTouch;
	missile.traileffectnum = particleeffectnum ("EF_ROCKETTRAIL");

    // set missile duration
    // missile.ltime = time + 5;
    missile.think = SUB_Remove;
    missile.nextthink = time + 5;

    setmodel(missile, "progs/missile.mdl");
    setsize(missile, '0 0 0', '0 0 0');
    setorigin(missile, start );
	CheckDodge(start, aim(self, 10000), 1000);

	// sound(missile, CHAN_BODY, "weapons/rockfly.wav", 1, ATTN_IDLE);
};

//=============================================================================

void() GrenadeExplode =
{
    T_RadiusDamage(self, self.owner, self.dmg, 180, world);
	
	rocketimpact  ();
	
	self.origin_z += 16;
    BecomeExplosionPlayer();
};


void() GrenadeTouch =
{
    if (other == self.owner)
    {
        return; // don't explode on owner
    }

    if (other.takedamage)
    {
        GrenadeExplode();
        return;
    }

    sound(self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM); // bounce sound

    if (self.velocity == '0 0 0')
    {
        self.avelocity = '0 0 0';
    }

	local vector	normal_angles, end, plane;
	local float 	time_left = time;

	if (other.solid != SOLID_BSP)
		return;
	
	end = self.origin + time_left*self.velocity;
	traceline(self.origin, end, FALSE, self); // guessing how q2 returns *cplane_t plane

	if (trace_plane_normal)
	{	
		plane = trace_plane_normal;

		normal_angles = vectoangles (plane);
		makevectors (normal_angles);
		self.angles = vectoangles (v_right);
	}
};


/*
================
W_FireGrenade
================
*/
void() W_FireGrenade =
{
    local entity missile;
	local vector start, offset;

    self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;

//    sound(self, CHAN_WEAPON, "weapons/grenlf1a.wav", 1, ATTN_NORM);

    self.punchangle_x = -2;

    missile = spawn();
    missile.owner = self;
    missile.movetype = MOVETYPE_BOUNCE;
    missile.solid = SOLID_BBOX;
    missile.classname = "grenade";	
	missile.shake_interval = 0.4;
	missile.shake_time = 1;
	missile.traileffectnum = particleeffectnum ("EF_NADETRAIL");

    // set missile speed
    offset = setvector (0, 8, self.view_ofs[1] + 8);
	makevectors(self.v_angle);
	start = ProjectAim (self.origin, offset, v_forward, v_right);
	
	local vector dir = aim(self,10000);
	makevectors (dir);

	missile.velocity = dir * 600;
	missile.velocity += (200 + crandom() * 10)* v_up;
	missile.velocity += (crandom() * 10) * v_right; 

    missile.avelocity = '300 300 300';

    missile.angles = vectoangles(missile.velocity);

    missile.touch = GrenadeTouch;

    // set missile duration
    missile.nextthink = time + 2.5;
    missile.think = GrenadeExplode;
	missile.dmg = 120;

    setmodel(missile, "progs/grenade.mdl");
    setsize(missile, '0 0 0', '0 0 0');
    setorigin(missile, start);
	CheckDodge(missile.origin, aim(self, 10000), 600);
};

void(float speed, float timer, float bool) W_FireGrenade2 =
{
    local entity missile;
	local vector start, offset;

   self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;

    missile = spawn();
    missile.owner = self;
    missile.movetype = MOVETYPE_BOUNCE;
    missile.solid = SOLID_BBOX;
    missile.classname = "grenade";
	missile.shake_interval = 0.5;
	missile.shake_time = 1;

    // set missile speed
    offset = setvector (0, 8, self.view_ofs[1] + 16);
	makevectors(self.v_angle);
	start = ProjectAim (self.origin, offset, v_forward, v_right);

	local vector dir = aim(self,10000);
	makevectors (dir);

	missile.velocity = dir * speed;
	missile.velocity += (speed / 3 + crandom() * 10)* v_up;
	missile.velocity += (crandom() * 10) * v_right; 
	missile.traileffectnum = particleeffectnum ("EF_NADETRAIL");

	//bprint (vtos(missile.velocity), "\n");

	 
    missile.avelocity = '300 300 300';
	missile.dmg = 165;
		
	if (bool)
		missile.dmg = 400;

    missile.angles = vectoangles(missile.velocity);

    missile.touch = GrenadeTouch;

    // set missile duration
    missile.nextthink = time + timer;
    missile.think = GrenadeExplode;
	//missile.modelflags = MF_GRENADE;

    setmodel(missile, "progs/grenade.mdl");
    setsize(missile, '-1 -1 -1', '1 1 1');
    setorigin(missile, start);
};

float() RocketLauncherNoAmmo = 
{	
	if (self.savedammo_rockets > 0)	
        return FALSE;
	if (self.ammo_rockets > 0)
		return FALSE;

	return TRUE;
};

float() GrenadeNoAmmo = 
{	
	if (self.ammo_rockets > 0)
		return FALSE;

	return TRUE;
};
//=============================================================================

float() PlasmaNoAmmo = 
{	
	if (self.savedammo_cells > 0)	
        return FALSE;

	if (self.ammo_cells > 0)
		return FALSE;

	return TRUE;
};

void() W_FireHyper = 
{
	local vector dir, offset, start;

	offset = setvector(0, 8, self.view_ofs[1] + 12);

	makevectors(self.v_angle);
	start = ProjectAim (self.origin, offset, v_forward, v_right);
	
	self.effects = self.effects | EF_MUZZLEFLASH;

	self.punchangle = setvector (crandom() * 0.7, crandom() * 0.7, crandom() * 0.7);
	
	dir = aim(self,10000);

	self.currentammo -= 1;

	local float r = rint(random() * 2);
	
	if (r == 2)
		    sound(self, CHAN_WEAPON, "weapons/plasma/2plasma_fire1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_WEAPON, "weapons/plasma/2plasma_fire3.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_WEAPON, "weapons/plasma/2plasma_fire6.wav", 1, ATTN_NORM);
	
	makevectors(self.v_angle);
	LaunchLaser (start, dir, v_right * (crandom() * 15), v_up * (crandom() * 15));

	if (self.flags & FL_CLIENT)
		CheckDodge(start, dir, 3000);
};


void() W_FireDisint = 
{
	local vector dir, offset, start;

	offset = setvector(24, 8, self.view_ofs[1] + 14);

	makevectors(self.v_angle);
	start = ProjectAim (self.origin, offset, v_forward, v_right);
	dir = aim(self,10000);
	
//	launch_blackhole(dir, start, 45, 160);
	self.currentammo = self.ammo_cells = self.ammo_cells - 15;

	if (self.flags & FL_CLIENT)
		CheckDodge(start, dir, 3000);
};

/*
================
W_FireAxe
================
*/

void(void() sfx1, void() sfx2) W_FireAxe =
{
	local	vector	source;
	local	vector	org;
	local float		spew = 15;
	local float		dmg = 25, kick = 5, crit = FALSE;
	// string punchnoise = ;
	
	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	local vector vel, dir;
	float dist = 48;

	if (self.powerups & IT_QUAD)
		dist = 64;

	dir = source + v_forward*dist;
	traceline (source, dir, 0, self);

	if (trace_fraction == 1.0)
		return;
	
	org = trace_endpos;

	vel = normalize(dir + v_up*crandom() + v_right*crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = 1;

		SpawnBlood (org, vel, kick);

		T_Damage (trace_ent, self, trace_endpos, self, dmg , kick);
		sfx1 ();
	}
	else
	{	// hit wall
		sfx2 ();
		//stuffcmd (self, "vibrate tactile/player/axhit2.bnvib");

	}
};

//==============================================================================================

/*PLAYER WEAPON FIRES
*/
//==============================================================================================

/*
============
Fists
============
*/

void() W_WeaponFistNoise = 
{	
	if (self.weaponframe == 0)
		sound(self, CHAN_RELOAD, "weapons/fists/raise_fists_01.wav", 1, ATTN_NORM);
};

void() W_WeaponFistHit = 
{
	local float r = rint(random() * 3);
	
		switch(r)
		{
			case 3:
			sound (self, CHAN_WEAPON, "weapons/fists/default_punch_04.wav", 1, ATTN_NORM);
			break;

			case 2:
			sound (self, CHAN_WEAPON, "weapons/fists/default_punch_03.wav", 1, ATTN_NORM);
			break;

			case 1:
			sound (self, CHAN_WEAPON, "weapons/fists/default_punch_02.wav", 1, ATTN_NORM);
			break;

			default:
			sound (self, CHAN_WEAPON, "weapons/fists/default_punch_01.wav", 1, ATTN_NORM);
			break;
		}
}

void() player_fistidle = 
{
	player_run ();
	self.weaponframe = 75;
	self.weaponstate = WEAPON_IDLE;

	return;
};

void() player_fisthitcheck = 
{
	switch(self.weaponframe)
	{
		case 13:
		case 29:
		case 45:
		case 61:
		self.solid = SOLID_BBOX;
		W_FireAxe (W_WeaponFistHit, W_WeaponFistHit);
		self.solid = SOLID_SLIDEBOX;
		break;

		default:
		break;
	}

	return;
};

void() player_fist4 = [self.frame, player_fist4]
{	
	self.weaponstate = WEAPON_USED; 
	SUB_AnimateWeapon (59, 74, player_fistidle , 0.03, player_fisthitcheck);
};
void() player_fist3 = [self.frame, player_fist3]
{	
	self.frame++;
	self.weaponstate = WEAPON_USED; 
	SUB_AnimateWeapon (43, 58, player_fistidle , 0.03, player_fisthitcheck);
};
void() player_fist2 = [self.frame, player_fist2]
{	
	self.frame++;
	self.weaponstate = WEAPON_USED; 
	SUB_AnimateWeapon (27, 42, player_fistidle , 0.03, player_fisthitcheck);
};
void() player_fist1 = [self.frame, player_fist1]
{	
	self.weaponstate = WEAPON_USED; 
	SUB_AnimateWeapon (12, 26, player_fistidle , 0.03, player_fisthitcheck);
};

void() player_punch = 
{	
	if (self.weaponstate == WEAPON_USED) 
		return;

	local float r = rint(random() * 3);
	
	switch(r)
	{
		case 3:
		player_fist4 ();
		break;

		case 2:
		player_fist3 ();
		break;

		case 1:
		player_fist2 ();
		break;

		default:
		player_fist1 ();
		break;
	}
};

float() get_noammo = {return 0;};
void(float a) save_noammo = {return 0;};

weapon_info_frames wf_fist = {11, '75 120 0', '121 126 0', '0 0 0', '0 0 0', NO_AMMO, NO_AMMO, player_punch, W_WeaponFistNoise  };
weapon_info_generic w_fist = { "progs/v_blast.md3", "", AmmoLessCheck};
weapon_info_ammo a_fist = {SUB_Assign_NoAmmo, get_noammo ,save_noammo};

/*
============
Hand Grenades
============
*/

void() W_WeaponGrenadeLaunNoise = 
{	
	if (self.weaponframe == 0)
		sound(self, CHAN_RELOAD, "weapons/grenades/gren_use.wav", 1, ATTN_NORM);
};

void() player_handgr = [self.frame, player_handgr]
{	
	self.weaponstate = WEAPON_USED;
	self.attack_finished = TRUE;
	if (self.weaponframe != 15 && self.weaponframe > 154)
	{
		sound(self, CHAN_WEAPON,"weapons/grenades/gren_throw_mix.wav", 1, ATTN_NORM);
		self.grenade_time = 0;
		self.weaponframe = 15;
	}

	if (self.weaponframe >= 154)
	{	
		player_run ();
		self.weaponframe = 155;
		self.weaponstate = WEAPON_IDLE;
		return;
	}

	if (self.button0 && self.weaponframe < 126)
	{	
		if (!self.grenade_time)
			self.grenade_time = time + GRENADE_TIMER + 0.2;	
		
		if (self.weaponframe >= 125)
		{
			W_FireGrenade2(0, 0, FALSE);
			player_run ();    
			self.weaponframe = 155;
			self.weaponstate = WEAPON_IDLE;
			return;
		}
		
		self.weaponframe++;
		self.nextthink = time + 0.04;
		return;
	}

	if (!self.button0 && self.weaponframe < 126 && self.weaponframe > 33)
		self.weaponframe = 126;

	if (self.weaponframe == 135)
	{
		local float speed, timer;

		timer = self.grenade_time - time;
		speed = GRENADE_MINSPEED + (GRENADE_TIMER - timer) * ((GRENADE_MAXSPEED - GRENADE_MINSPEED) / GRENADE_TIMER);
	
     	W_FireGrenade2(speed, timer,  FALSE);

		// bprint (ftos(speed), "\n");

		self.grenade_time = 0;
		sound(self, CHAN_WEAPON, "misc/null.wav", 1, ATTN_NORM);

      }

	self.weaponframe++;
	self.nextthink = time + 0.03;

	if (self.weaponframe > 126)
		self.nextthink = time + 0.02;
};

float() get_rockets = {return self.ammo_rockets;};
void(float ammotype) save_grenades = 
{
	self.ammo_rockets = ammotype;
	self.currentammo = self.ammo_rockets;
}

weapon_info_frames wf_grenade = {14, '155 294 0', '295 300 0', '0 0 0', '0 0 0', NO_AMMO, NO_AMMO, player_handgr, W_WeaponGrenadeLaunNoise };
weapon_info_generic w_grenade = { "progs/v_launch.md3", "progs/male/w_glauncher.mdl", GrenadeNoAmmo};
weapon_info_ammo a_grenade = {SUB_Assign_Rockets, get_rockets, save_grenades };

/*
============
Pistol
============
*/

void() W_WeaponPistolNoise =
{	
	//local float r = rint(random() * 2);

	if (self.weaponframe == 0)
		sound(self, CHAN_RELOAD, "weapons/pistol/pistol_use_01.wav", 1, ATTN_NORM);

	if (self.weaponframe == 87)
	{	
		local vector offset = setvector (0, 0, self.view_ofs[1] + 4);
		makevectors(self.v_angle);

		_mag ("progs/shell6.mdl", ProjectAim (self.origin, offset, v_forward, v_right));
		sound(self, CHAN_RELOAD, "weapons/pistol/pistol_reload_01.wav", 1, ATTN_NORM);
	}
};

void() player_pistol =[self.frame, player_pistol ]
{	
	self.weaponstate = WEAPON_USED;

	if (!self.button0 || self.currentammo < 1)
	{	
		if ((self.weaponframe <= 25))
		{	
			self.weaponframe ++; 
			self.nextthink = time + 0.04;
			return;
		}
		else
		{	
			self.weaponstate = WEAPON_IDLE;
			player_run ();
			self.weaponframe = 26;
			return;
		}
	}

	if (self.weaponframe != 15 && self.weaponframe > 25)
		self.weaponframe = 15;

	if (self.weaponframe == 15)
	{
		 self.solid = SOLID_BBOX;
     	  	 W_FireShotgun();
		self.savedammo_shells2 = self.currentammo;
		self.effects = self.effects | EF_MUZZLEFLASH;
		 self.solid = SOLID_SLIDEBOX;
      }

	self.weaponframe++;
	self.nextthink = time + 0.02;

	if (self.weaponframe < 18)
		self.nextthink = time + 0.015;
};

float() getshells = {return self.ammo_shells;};
void(float a) save_pistolammo = 
{
	self.ammo_shells = a;
	self.savedammo_shells2 = self.currentammo;
};

weapon_info_frames wf_pistol = {14, '26 85 0', '139 144 0', '86 138 100', '129 137 0', PSTL_AMMO_CAP, PSTL_AMMO_CAP, player_pistol,  W_WeaponPistolNoise };
weapon_info_generic w_pistol = { "progs/v_shotg.md3", "progs/male/w_shotgun.mdl", PistolNoAmmo};
weapon_info_ammo a_pistol = {SUB_Assign_Saved_Shells2, getshells, save_pistolammo};

/*
============
Shotgun
============
*/
void() W_WeaponShotgunNoise =
{	

	local float r = rint(random() * 2);

	if (self.weaponframe == 0)
		sound(self, CHAN_RELOAD, "weapons/shotgun/shotgun_use_01.wav", 1, ATTN_NORM);

	if (self.weaponframe == 9 || self.weaponframe == 165 || self.weaponframe == 29)
		sound(self, CHAN_RELOAD, "weapons/shotgun/shotgun_cock_01.wav", 1, ATTN_NORM);

	if (self.weaponframe == 135)
	{
		if (r == 2)
			sound(self, CHAN_RELOAD, "weapons/shotgun/reload/sgreload_addshell_01.wav", 1, ATTN_NORM);
		else if (r == 1)
			sound(self, CHAN_RELOAD, "weapons/shotgun/reload/sgreload_addshell_02.wav", 1, ATTN_NORM);
		else
			sound(self, CHAN_RELOAD, "weapons/shotgun/reload/sgreload_addshell_03.wav", 1, ATTN_NORM);
	}

	if (self.weaponframe == 127)
	{
		if (r==2)
			sound(self, CHAN_RELOAD, "weapons/shotgun/reload/sgreload_start_01.wav", 1, ATTN_NORM);
		else if (r==1)
			sound(self, CHAN_RELOAD, "weapons/shotgun/reload/sgreload_start_02.wav", 1, ATTN_NORM);
		else
			sound(self, CHAN_RELOAD, "weapons/shotgun/reload/sgreload_start_03.wav", 1, ATTN_NORM);
	}
};

void() W_WeaponShotgun2Noise =
{	

	local float r = rint(random() * 2);

	if (self.weaponframe == 0 || self.weaponframe == 178)
		sound(self, CHAN_RELOAD, "weapons/ssg/click_01.wav", 1, ATTN_NORM);

	if (self.weaponframe == 140)
		sound(self, CHAN_RELOAD, "weapons/ssg/clack_01.wav", 1, ATTN_NORM);

	if (self.weaponframe == 158 || self.weaponframe == 164)
	{
		if (r == 2)
			sound(self, CHAN_RELOAD, "weapons/ssg/insert_01.wav", 1, ATTN_NORM);
		else if (r == 1)
			sound(self, CHAN_RELOAD, "weapons/ssg/insert_02.wav", 1, ATTN_NORM);
		else
			sound(self, CHAN_RELOAD, "weapons/ssg/insert_03.wav", 1, ATTN_NORM);
	}
};

void() player_shotg = [self.frame, player_shotg]
{
	self.weaponstate = WEAPON_USED;
 
	if (self.weaponframe != 15 && self.weaponframe > 46)
		self.weaponframe = 15;	 

	if (self.weaponframe >= 46 )
	{	
		player_run ();
		self.weaponstate = WEAPON_IDLE;
		self.weaponframe = 47;
		return;
	}

	if (self.weaponframe == 15)
	{
		 self.solid = SOLID_BBOX;
     	  	 W_FireSuperShotgun();
		self.savedammo_shells = self.currentammo;
		self.effects = self.effects | EF_MUZZLEFLASH;
		 self.solid = SOLID_SLIDEBOX;
      }

	if (self.weaponframe == 33)
	{	
		local vector offset;
		offset = setvector (24, 4, self.view_ofs[1] + 16);
		makevectors(self.v_angle);

		_casing ("progs/shell2.mdl", ProjectAim (self.origin, offset, v_forward, v_right), aim(self, 10000),self.velocity + v_right*-75 + v_up*(25 + random()*25));
	}

	self.weaponframe++;

	self.nextthink = time + 0.038;

	 W_WeaponShotgunNoise ();
};


void() player_doublebarrel = [self.frame, player_doublebarrel]
{	
	self.weaponstate = WEAPON_USED;
	
	if (self.weaponframe != 15 && self.weaponframe > 29)
		self.weaponframe = 15;	 

	if (self.weaponframe >= 29)
	{	
		player_run ();
		self.weaponstate = WEAPON_IDLE;
		self.weaponframe = 30;
		return;
	}

	if (self.weaponframe == 15)
	{
		 self.solid = SOLID_BBOX;
     	  	 W_FireDoubleBarrel();
		self.savedammo_shellsDB = self.currentammo;
		self.effects = self.effects | EF_MUZZLEFLASH;
		 self.solid = SOLID_SLIDEBOX;
      }

/*	if (self.weaponframe == 33)
	{	
		local vector offset;
		offset = setvector (24, 4, self.view_ofs[1] + 16);
		makevectors(self.v_angle);

		//_casing ("progs/shell2.mdl", ProjectAim (self.origin, offset, v_forward, v_right), aim(self, 10000),self.velocity + v_right*-75 + v_up*(25 + random()*25));
	}*/

	self.weaponframe++;

	self.nextthink = time + 0.04;

	// W_WeaponShotgunNoise ();
};

void(float a) save_sgammo = 
{
	self.ammo_shells = a;
	self.savedammo_shells = self.currentammo;
};

void(float a) save_DBammo = 
{
	self.ammo_shells = a;
	self.savedammo_shellsDB = self.currentammo;
};

weapon_info_frames wf_shotgun = {14, '47 118 0', '172 177 0', '119 171 139', '126 152 0', SG_AMMO_LOAD, SG_AMMO_CAP, player_shotg,  W_WeaponShotgunNoise};
weapon_info_generic w_shotgun = {"progs/v_shotg2.md3", "progs/male/w_sshotgun.mdl", ShotgunNoAmmo};
weapon_info_ammo a_shotgun = {SUB_Assign_Saved_Shells1, getshells, save_sgammo};

weapon_info_frames wf_doublebarrel = {14, '30 130 0', '182 188 0', '131 181 166', '180 181 0', 2, 2, player_doublebarrel, W_WeaponShotgun2Noise};
weapon_info_generic w_doublebarrel = { "progs/v_shotg3.md3", "progs/male/w_sshotgun.mdl", DoubleBarrelNoAmmo };
weapon_info_ammo a_doublebarrel    = {SUB_Assign_Saved_ShellsDB, getshells, save_DBammo};

/*
============
Machinegun
============
*/

void() W_WeaponMachineGunNoise =
{
	if (self.weaponframe == 0)
		sound(self, CHAN_RELOAD, "weapons/machinegun/mg_use_01.wav", 1, ATTN_NORM);

	if (self.weaponframe == 66)
		sound(self, CHAN_RELOAD, "weapons/machinegun/mg_reload_01.wav", 1, ATTN_NORM);

	if (self.weaponframe == 85)
	{
		local vector offset = setvector (0, 0, self.view_ofs[1] + 4);
		makevectors(self.v_angle);

		_mag ("progs/shell4.mdl", ProjectAim (self.origin, offset, v_forward, v_right));
	}
};

void() player_machn = [self.frame, player_machn]
{	
	self.weaponstate = WEAPON_USED;
	
	if (!self.button0 || self.currentammo < 1)
	{	
		if ((self.weaponframe <= 18))
		{	
			self.weaponframe ++; 
			self.nextthink = time + 0.04;
			return;
		}
		else
		{	
			self.weaponstate = WEAPON_IDLE;
			player_run ();
			self.weaponframe = 19;
			return;
		}
	}

	if (self.weaponframe != 15 && self.weaponframe > 18)
		self.weaponframe = 15;
	
	if (self.weaponframe > 18 && self.button0)
		self.weaponframe = 15;

	if (self.weaponframe == 15)
	{
		self.solid = SOLID_BBOX;	
		W_FireMachineGun ();
		//W_FireMachineGun ();
		self.savedammo_nails = self.currentammo;
		self.effects = self.effects | EF_MUZZLEFLASH;
		self.solid = SOLID_SLIDEBOX;
      }
		
	self.weaponframe++;	
	self.nextthink = time + 0.04;
	if (self.button0)
		self.nextthink = time + 0.02;	
};

float() getnails = {return self.ammo_nails;};

void(float a) save_mgammo = 
{
	self.ammo_nails = a;
	self.savedammo_nails = self.currentammo;
};

void(float a) save_cgammo = 
{
	self.ammo_nails = a;
	self.savedammo_nails2 = self.currentammo;
};

weapon_info_frames wf_machinegun = {14, '19 63 0', '124 129 0', '64 123 75', '64 123 0', MG_AMMO_CAP, MG_AMMO_CAP, player_machn,  W_WeaponMachineGunNoise};
weapon_info_generic w_machinegun = { "progs/v_machn.md3", "progs/male/w_machinegun.mdl", MachineGunNoAmmo};
weapon_info_ammo a_machinegun = {SUB_Assign_Saved_Nails1, getnails, save_mgammo};

/*
============
Chaingun
============
*/

void() W_WeaponChainGunNoise =
{
	if (self.weaponframe == 0)
		sound(self, CHAN_RELOAD, "weapons/chaingun/cg_use_01.wav", 1, ATTN_NORM);

	if (self.weaponframe == 103)
		sound(self, CHAN_RELOAD, "weapons/chaingun/cg_reload_twist_01.wav", 1, ATTN_NORM);
};

void() player_chain = [self.frame, player_chain]
{	
	self.weaponstate = WEAPON_USED;
	
	if (!self.button0 || (self.currentammo < 1))
	{	
		if (self.weaponframe < 27)
		{
			sound(self, CHAN_RELOAD, "weapons/chaingun/cg_winddown_mix_01.wav", 1, ATTN_NORM);
			self.weaponframe = 39;
		}

		if (self.weaponframe >= 27 && self.weaponframe <= 36)
		{
			sound(self, CHAN_RELOAD, "weapons/chaingun/cg_winddown_mix_01.wav", 1, ATTN_NORM);
			self.weaponframe = 36;
		}		

		if ((self.weaponframe <= 50))
		{	
			self.weaponframe ++; 
			self.nextthink = time + 0.04;
			return;
		}
		else
		{	
			sound(self, CHAN_RELOAD, "misc/null.wav", 1, ATTN_NORM);
			self.weaponstate = WEAPON_IDLE; 
			player_run ();
			self.weaponframe = 52;
			return;
		}
	}
	
	if (self.button0)
		W_FireChainGunSpinning ();

	self.savedammo_nails2 = self.currentammo;
	
	if (self.weaponframe != 15 && self.weaponframe > 44)
		self.weaponframe = 15;

	if (self.weaponframe == 15)
		sound(self, CHAN_RELOAD, "weapons/chaingun/cg_windup_mix_01.wav", 1, ATTN_NORM);

	if (self.weaponframe > 35 && self.button0) // full-auto
	{	
		sound(self, CHAN_RELOAD, "weapons/chaingun/cg_motor_loop_01.wav", 1, ATTN_NORM);
		self.weaponframe = 30;
	}

	self.weaponframe++;

	self.nextthink = time + 0.042;
	if (self.weaponframe > 29 && self.button0)
		self.nextthink = time + 0.03;	
};

weapon_info_frames wf_chaingun = {14, '52 101 0', '152 157 0', '102 151 110', '104 151 0', CG_AMMO_CAP, CG_AMMO_CAP, player_chain, W_WeaponChainGunNoise};
weapon_info_generic w_chaingun = { "progs/v_chain.md3", "progs/male/w_chaingun.mdl", ChainGunNoAmmo};
weapon_info_ammo a_chaingun = {SUB_Assign_Saved_Nails2, getnails, save_cgammo};

/*
============
PLASMAgun
============
*/

void() W_WeaponPlasmaNoise =
{
	if (self.weaponframe == 149)
		sound(self, CHAN_RELOAD, "weapons/plasmagun/plasma_reload_01.wav", 1, ATTN_NORM);

	if (self.weaponframe == 0)
		sound(self, CHAN_RELOAD, "weapons/plasmagun/plasma_use_01.wav", 1, ATTN_NORM);

	if (self.weaponframe == 166)
	{
		local vector offset = setvector (0, 0, self.view_ofs[1] + 4);
		makevectors(self.v_angle);

		_mag ("progs/shell3.mdl", ProjectAim (self.origin, offset, v_forward, v_right));
	}
};


void() player_plas = [self.frame, player_plas ]
{	
	self.weaponstate = WEAPON_USED;
	
	if (!self.button0 || self.currentammo < 1)
	{	
		if ((self.weaponframe <= 26))
		{	
			self.weaponframe ++; 
			self.nextthink = time + 0.04;
			return;
		}
		else
		{	
			self.weaponstate = WEAPON_IDLE;
			self.weaponframe = 27;
			player_run();
			return;
		}
	}

	if (self.weaponframe != 12 && self.weaponframe > 15)
		self.weaponframe = 12;

	if (self.weaponframe == 15 && self.button0)
		self.weaponframe = 12;

	if (self.weaponframe == 12)
	{
		//self.solid = SOLID_BBOX;	
		W_FireHyper ();
		self.savedammo_cells = self.currentammo;
		self.effects = self.effects | EF_MUZZLEFLASH;
		//self.solid = SOLID_SLIDEBOX;
      }
		
	self.weaponframe++;
	self.nextthink = time + 0.0325;
};

float() getcells = {return self.ammo_cells;};

void(float a) save_pgammo = 
{
	self.ammo_cells = a;
	self.savedammo_cells = self.currentammo;
};

void(float a) save_bfgammo = 
{
	self.ammo_cells = a;
	self.savedammo_cells2 = self.currentammo;
};

weapon_info_frames wf_plasmagun = {11, '27 146 0', '207 213 0', '147 206 195', '160 206 0', PLSG_AMMO_CAP, PLSG_AMMO_CAP, player_plas, W_WeaponPlasmaNoise};
weapon_info_generic w_plasmagun = { "progs/v_hyperb.md3", "progs/male/w_hyperblaster.mdl", PlasmaNoAmmo};
weapon_info_ammo a_plasmagun = {SUB_Assign_Saved_Cells1, getcells, save_pgammo};

/*
============
Rocket Laucnher
============
*/
void() W_WeaponRocketLaunNoise =
{	
	//local float r = rint(random() * 2);

	if (self.weaponframe == 0)
		sound(self, CHAN_RELOAD, "weapons/rocket/raise.wav", 1, ATTN_NORM);

	if (self.weaponframe == 113)
		sound(self, CHAN_RELOAD, "weapons/rocket/reload.wav", 1, ATTN_NORM);

	if (self.weaponframe == 134)
	{
		local vector offset = setvector (0, 8, self.view_ofs[1] + 4);
		makevectors(self.v_angle);

		_mag ("progs/shell5.mdl", ProjectAim (self.origin, offset, v_forward, v_right));
	}
};

void() player_rocket = [self.frame, player_rocket]
{	
	self.weaponstate = WEAPON_USED;

	if (self.weaponframe != 15 && self.weaponframe > 27)	
		self.weaponframe = 15;
	
	if (self.weaponframe >= 27)
	{
		self.weaponstate = WEAPON_IDLE;
		self.weaponframe = 28;
		player_run();
		return;
	}
	
	if (self.weaponframe == 15)
	{
		self.effects = self.effects | EF_MUZZLEFLASH;
		W_FireRocket();
		self.savedammo_rockets = self.currentammo;
	}	

	self.weaponframe++;
	self.nextthink = time + 0.04;
};

void(float a) save_rlammo = 
{
	self.ammo_rockets = a;
	self.savedammo_rockets = self.currentammo;
};

weapon_info_frames wf_rocketlauncher = {14, '28 110 0', '161 168 0', '110 160 120', '155 160 0', RL_AMMO_CAP, RL_AMMO_CAP, player_rocket, W_WeaponRocketLaunNoise};
weapon_info_generic w_rocketlauncher = { "progs/v_rocket.md3", "progs/male/w_rlauncher.mdl", RocketLauncherNoAmmo};
weapon_info_ammo a_rocketlauncher = {SUB_Assign_Saved_Rockets, get_rockets, save_rlammo};

/*
============
big fucking gun
============
*/

void(float level) W_FireBFG =
{
	local vector dir, offset, start; 
	local float dmg_rad, dmg, dmg_lsr;

	// bprint (ftos(level / 3), "\n");
	
	// self.currentammo  = self.ammo_cells = self.ammo_cells - 50;

	offset = setvector(32, 8, self.view_ofs[1] + 14);

	makevectors(self.v_angle);
	start = ProjectAim (self.origin, offset, v_forward, v_right);
	dir = aim(self,10000);

	self.punchangle = setvector (-12, crandom() * 0.7, crandom() * 0.7);
	
	dmg = 400 * (level / 3);
	dmg_lsr = 15; // unaffected
	dmg_rad = 400 * (level / 3);	

	launch_thunderball(dir,start,dmg,dmg_lsr,dmg_rad);
};

void() W_WeaponBFGNoise =
{	
	//local float r = rint(random() * 2);

	if (self.weaponframe == 0)
		sound(self, CHAN_RELOAD, "weapons/bfg/bfg_raise.wav", 1, ATTN_NORM);

	if (self.weaponframe == 244)
		sound(self, CHAN_RELOAD, "weapons/bfg/bfg_reload.wav", 1, ATTN_NORM);

	if (self.weaponframe == 265)
	{
		local vector offset = setvector (0, -16, self.view_ofs[1] + 4);
		makevectors(self.v_angle);

		_mag ("progs/shell3.mdl", ProjectAim (self.origin, offset, v_forward, v_right));
	}
};

void() player_bfg = [self.frame, player_bfg]
{	
	local float level = 30;

	self.weaponstate = WEAPON_USED;

	if (self.weaponframe != 15 && self.weaponframe > 181)
	{
		sound(self, CHAN_WEAPON, "weapons/bfg/bfg_firebegin.wav", 1, ATTN_NORM);	
		self.weaponframe = 15;
	}

	if (self.weaponframe > 144 && self.button0 && self.weaponframe < 153)
	{
		W_FireGrenade2(0, 0, TRUE);
		self.weaponframe = 181;
		return;
	}

	if (self.weaponframe >= 181)
	{
		self.weaponstate = WEAPON_IDLE;
		self.weaponframe = 182;
		player_run ();
		return;
	}

	if (self.weaponframe <= 76 && self.weaponframe >= 56) 
		level = 60;

	else if (self.weaponframe <= 112 && self.weaponframe > 76)
		level = 90;
	
	else if (self.weaponframe <= 152 && self.weaponframe > 112)
		level = 120;
	
	if (self.savedammo_cells2 >= level)
		self.dmg_lsr = level;

	if (!self.button0 && self.weaponframe < 153)
		self.weaponframe = 153;

	if (self.weaponframe < 153)
		self.punchangle = setvector (crandom() * 0.2, crandom() * 0.2, crandom() * 0.2);	

	if (self.weaponframe == 153)
	{
		self.effects = self.effects | EF_MUZZLEFLASH;
	//bprint (ftos(level * 0.1), "\n");
		W_FireBFG(level * 0.1);
		sound(self, CHAN_WEAPON, "weapons/bfg/bfg_fire.wav", 1, ATTN_NORM);

		self.savedammo_cells2 = self.savedammo_cells2 - self.dmg_lsr;
		self.currentammo = self.savedammo_cells2;
	}
	
	self.weaponframe++;
	if (self.weaponframe < 153)
		self.nextthink = time + 0.018;
	else
		self.nextthink = time + 0.04;
};

weapon_info_frames wf_bfg = {14, '182 241 0', '302 308 0', '242 301 280', '280 301 0', BFG_AMMO_CAP, BFG_AMMO_CAP, player_bfg, W_WeaponBFGNoise};
weapon_info_generic w_bfg = { "progs/v_bfg.md3", "progs/male/w_bfg.mdl", BFGNoAmmo};
weapon_info_ammo a_bfg = {SUB_Assign_Saved_Cells2, getcells, save_bfgammo};

/*
============
Chainsaw
============
*/

void() W_WeaponChainsawHitMeat = 
{
	local float r = rint(random() * 3);
	
		switch(r)
		{
			case 3:
			sound (self, CHAN_BODY, "weapons/chainsaw/hit_04.wav", 1, ATTN_NORM);
			break;

			case 2:
			sound (self, CHAN_BODY, "weapons/chainsaw/hit_03.wav", 1, ATTN_NORM);
			break;

			case 1:
			sound (self, CHAN_BODY, "weapons/chainsaw/hit_02.wav", 1, ATTN_NORM);
			break;

			default:
			sound (self, CHAN_BODY, "weapons/chainsaw/hit_01.wav", 1, ATTN_NORM);
			break;
		}
}

void() W_WeaponChainsawHitWall = 
{
	local float r = rint(random() * 3);
	
		switch(r)
		{
			case 3:
			sound (self, CHAN_BODY, "weapons/chainsaw/hit_metal_04.wav", 1, ATTN_NORM);
			break;

			case 2:
			sound (self, CHAN_BODY, "weapons/chainsaw/hit_metal_03.wav", 1, ATTN_NORM);
			break;

			case 1:
			sound (self, CHAN_BODY, "weapons/chainsaw/hit_metal_02.wav", 1, ATTN_NORM);
			break;

			default:
			sound (self, CHAN_BODY, "weapons/chainsaw/hit_metal_01.wav", 1, ATTN_NORM);
			break;
		}
}

void() W_WeaponChainsaw = 
{	
	//self.weaponuse = player_chainsaw;
	//W_WeaponFrame (30, 68, 147, 153, 148, NO_AMMO, NO_AMMO, NO_AMMO, NO_AMMO, NO_AMMO, NO_AMMO, NO_AMMO);

	if (self.dspeed < time)
		return;
	
	makevectors(self.v_angle);
	local vector offset = setvector (0, 8, self.view_ofs[1] - 8);
	TE_GUNSMOKE (ProjectAim (self.origin, offset, v_forward, v_right) + v_forward * 32);
};

void() W_WeaponChainsawNoise =
{
	if (self.weaponframe == 0)
		sound(self, CHAN_RELOAD, "weapons/chainsaw/pull.wav", 1, ATTN_NORM);

	if (self.weaponframe == 10)
		sound(self, CHAN_RELOAD, "weapons/chainsaw/pull_zip.wav", 1, ATTN_NORM);

	if (self.weaponframe == 16)
		sound(self, CHAN_RELOAD, "weapons/chainsaw/idle.wav", 1, ATTN_NORM);

	if (self.weaponframe == 147)
		sound(self, CHAN_RELOAD, "weapons/chainsaw/put_away.wav", 1, ATTN_NORM);
};

void() player_chainsaw = [self.frame, player_chainsaw]
{	
	self.weaponstate = WEAPON_USED;
	
	if (self.weaponframe == 46)
		sound(self, CHAN_WEAPON, "weapons/chainsaw/stop_attack.wav", 1, ATTN_NORM);
	
	if (!self.button0)
	{	
		if (self.weaponframe != 45 && self.weaponframe < 45)
		{
			self.weaponframe = 45;
			// bprint ("buh \n");
			// sound(self, CHAN_WEAPON, "weapons/chainsaw/stop_attack.wav", 1, ATTN_NORM);
		}

		if ((self.weaponframe <= 67))
		{	
			self.weaponframe ++; 
			self.nextthink = time + 0.04;
			return;
		}
		else
		{	
			self.weaponstate = WEAPON_IDLE;
			self.weaponframe = 68;
			player_run();
			return;
		}
	}
		
	if (self.weaponframe != 31 && self.weaponframe > 67)
	{
		sound(self, CHAN_WEAPON, "weapons/chainsaw/start_attack.wav", 1, ATTN_NORM);
		self.weaponframe = 31;
	}

	if (self.weaponframe > 45 && self.button0 && self.weaponframe < 47) // full-auto
		self.weaponframe = 35;

	if (self.weaponframe == 35)
		sound(self, CHAN_WEAPON, "weapons/chainsaw/attack.wav", 1, ATTN_NORM);

	if (self.weaponframe > 34 && self.weaponframe < 46)
	{
		self.solid = SOLID_BBOX;
		W_FireAxe (W_WeaponChainsawHitMeat, W_WeaponChainsawHitWall);
	//	W_FireAxe (W_WeaponChainsawHitMeat, W_WeaponChainsawHitWall);
		self.solid = SOLID_SLIDEBOX;
	}

	self.weaponframe++;
	self.nextthink = time + 0.04;
};

weapon_info_frames wf_chainsaw = {30, '68 147 0', '148 153 0', '0 0 0', '0 0 0', NO_AMMO, NO_AMMO, player_chainsaw, W_WeaponChainsawNoise};
weapon_info_generic w_chainsaw = { "progs/v_rail.md3", "progs/male/w_railgun.mdl", AmmoLessCheck};

//=============================================

/*
============
Grabber
============
*/
.entity grabbed_proj;

void() W_WeaponGrabberNoise = {};

void(float vel) grabberfire =
{	
	local vector dir = aim(self,1000);

	//	self.grabbed_proj.owner = __NULL__;
	if (self.grabbed_proj.flags & FL_ITEM)
	{	
		self.grabbed_proj.velocity = dir * -400;
		self.grabbed_proj.movetype = MOVETYPE_TOSS;
		self.grabbed_proj.touch = self.grabbed_proj.use;

	//	self.grabbed_proj.think = SUB_Remove;
		self.grabbed_proj.nextthink = -1;
		self.grabbed_proj = __NULL__;
		return;
	}

	if (vel != 2000)
	{	
		self.grabbed_proj.movetype = MOVETYPE_TOSS;
	}

	self.grabbed_proj.flags &= ~FL_ONGROUND;
	self.grabbed_proj.velocity = dir * vel;
	self.grabbed_proj.angles = vectoangles(dir);

	self.grabbed_proj.think = SUB_Remove;
	self.grabbed_proj.nextthink = time + 6;
	self.grabbed_proj.dmg *= 3;

	if (self.grabbed_proj.classname == "grenade")
	{
		self.grabbed_proj.use = m_GrenadeExplode;
	//	self.grabbed_proj.nextthink = time + (self.grabbed_proj.ltime / 2);
	}

	if (self.grabbed_proj.classname == "explo_box")
	{
		self.grabbed_proj.use = barrel_explode;
		self.grabbed_proj.solid = SOLID_BBOX;
		self.grabbed_proj.dmg /= 3;
	//	self.grabbed_proj.nextthink = time + (self.grabbed_proj.ltime / 2);
	}

	if (self.grabbed_proj.classname == "homing_missile")
		self.dmg *= 8;
	
	self.grabbed_proj.touch = self.grabbed_proj.use;
	
	self.grabbed_proj.aiflags &= ~IS_PROJECTILE; // so that it cant be picked up
	self.grabbed_proj = __NULL__;
}

void() NeutralizeProj =
{	
	if (self.owner.health <= 0)
	{
		remove(self);
		return;
	}
//	AngleVectors (self.owner.v_angle, f, r, u);

//	traceline (self, self.origin)
	makevectors (self.owner.v_angle);
	self.origin = self.owner.origin + self.owner.view_ofs + aim(self.owner,1000) * 64 + v_right * 12;

	self.nextthink = time;
	self.think = NeutralizeProj;
}

void() NeutralizeMonster =
{	
	if (self.owner.health <= 0)
	{
		remove(self);
		return;
	}

//	AngleVectors (self.owner.v_angle, f, r, u);

//	traceline (self, self.origin)
	makevectors (self.owner.v_angle);
	self.origin = self.owner.origin + self.owner.view_ofs + aim(self.owner,1000) * 64;

	self.owner.grabbed_proj = __NULL__;

	self.velocity = '0 0 200';
	self.movetype = MOVETYPE_TOSS;

	Killed (self, self);

	//self.nextthink = -1;
	//self.think = NeutralizeMonster;
}

void() NeutralizeItem =
{	
	if (self.owner.health <= 0)
	{
		remove(self);
		return;
	}
	
//	AngleVectors (self.owner.v_angle, f, r, u);

//	traceline (self, self.origin)
//	vector o = self.mins + self.maxs;
//	o *= 0.5;
	makevectors (self.owner.v_angle);
	self.origin = self.owner.origin + self.owner.view_ofs + aim(self.owner,1000) * 64;

	self.nextthink = time;
	self.think = NeutralizeItem;
}

float(entity targ) infront_grabber =
{
	local vector	vec;
	local float		dot;
	
	makevectors (self.v_angle);
	vec = normalize (targ.origin - (self.origin + self.view_ofs));
	dot = vec * aim(self,100000);
	
//	bprint(ftos(dot), "\n");
	if ( dot > 0.98)
	{
		return TRUE;
	}
	return FALSE;
};

float() grabber_grab_check = 
{	
	entity ent, best;
	vector src = self.origin + self.view_ofs;
	vector end = src + (350 * aim(self,10000));
	traceline (self.origin + self.view_ofs, end, 2, self );

	if (trace_ent)
	{	
		if (trace_ent.classname == "explo_box")
			return TRUE;
		
		if (trace_ent.flags & FL_MONSTER && trace_ent.classname == "monster_grabbable")
			return TRUE;
	}
	
	for (ent = findradius(self.origin, 350); ent; ent = ent.chain)
	{	
		if (best)
			return TRUE;

		if ((ent.flags & FL_MONSTER))
			continue;

		if ((ent.flags & FL_CLIENT))
			continue;

		if (ent == world)
			break;

		if (!CanDamage(ent, self))
			continue;

		if ((ent.flags & FL_ITEM)) // special
		{	
			if (!infront_grabber(ent))
				continue;

			if (!CanDamage(ent, self))
				continue;

			best = ent;
		}

		if (!(ent.aiflags & IS_PROJECTILE))
			continue;

		if (!infront_grabber(ent))
			continue;

		best = ent;
	//	self.grabbed = TRUE;
	}
	return FALSE;
}

float() grabber_grab = 
{
	//local vector org;
	local entity ent, best;

	vector src = self.origin + self.view_ofs;
	vector end = src + (350 * aim(self,10000));
	traceline (self.origin + self.view_ofs, end, 2, self );
	if (trace_ent)
	{	
		if (trace_ent.classname == "explo_box")
		{	
			best = trace_ent;
			self.grabbed_proj = best;
			best.owner = self;
			best.nextthink = time;

			best.solid = SOLID_NOT;
			best.touch = SUB_Null;
			best.movetype = MOVETYPE_FLY;

			best.flags &= ~FL_ONGROUND;
			best.think = NeutralizeProj;
			
			return TRUE;
		}
		if (trace_ent.flags & FL_MONSTER && trace_ent.classname == "monster_grabbable")
		{	
			best = trace_ent;
			self.grabbed_proj = best;
			best.owner = self;
			best.nextthink = time;

			best.use = best.touch;
			best.touch = SUB_Null;
			best.movetype = MOVETYPE_FLY;

			best.flags &= ~FL_ONGROUND;
			best.think = NeutralizeMonster;
			
			return TRUE;
		}
	}

	for (ent = findradius(self.origin, 350); ent; ent = ent.chain)
	{	
		if (best)
			return TRUE;

		if ((ent.flags & FL_MONSTER))
			continue;

		if ((ent.flags & FL_CLIENT))
			continue;

		if (ent == world)
			break;

		if ((ent.flags & FL_ITEM)) // special
		{	
			if (!infront_grabber(ent))
				continue;

			best = ent;

			self.grabbed_proj = best;
			best.owner = self;
			best.nextthink = time;

			best.use = best.touch;
			best.touch = SUB_Null;

			best.movetype = MOVETYPE_FLY;
			best.think = NeutralizeItem;
			best.flags &= ~FL_ONGROUND;
		}

		if (!(ent.aiflags & IS_PROJECTILE))
			continue;

		if (!infront_grabber(ent))
			continue;

		best = ent;

		self.grabbed_proj = best;
		best.owner = self;
		best.nextthink = time;

		best.use = best.touch;
		best.touch = SUB_Null;

		best.flags &= ~FL_ONGROUND;
		best.think = NeutralizeProj;
	//	self.grabbed = TRUE;
	}
	return FALSE;
}

.float grabbed;
void() player_grab = [self.frame, player_grab]
{	
	self.weaponstate = WEAPON_USED;
//	bprint (ftos(self.weaponframe),"\n");

	if (self.weaponframe != 13 && self.weaponframe > 131)
	{	
		if (!grabber_grab())
		{	
			//bprint("eeeek", "\n");
			self.weaponframe = 118;
			//self.grabbed = FALSE;
		}
		else
		{
			//bprint("true", "\n");
	//	self.grabbed = FALSE;
			self.weaponframe = 13;
		}
	}
	
	if (self.weaponframe >= 131 || ((self.weaponframe >= 117) && self.grabbed))
	{
		self.grabbed = FALSE;
		self.weaponstate = WEAPON_IDLE;
		self.weaponframe = 132;
		player_run();
		return;
	}
	
	if (!self.button0)
	{	
		if (self.grabbed_proj)
		{	
			self.grabbed = TRUE;
			if (self.weaponframe != 96 && self.weaponframe < 96)
			{	
				//bprint ("fire", "\n");
				self.weaponframe = 96;
				grabberfire (2000);
			}
		}
		else 
		{
			if (self.weaponframe != 118 && self.weaponframe < 118 && !self.grabbed)
				self.weaponframe = 118;
		//	self.grabbed = FALSE;
		}

		if ((self.weaponframe <= 117))
		{	
			self.weaponframe ++; 
			self.nextthink = time + 0.04;
			return;
		}

		if ((self.weaponframe > 117) && (self.weaponframe <= 126))
		{	
			self.weaponframe ++; 
			self.nextthink = time + 0.03;
			return;
		}
	}

	if (self.weaponframe > 58 && self.button0 && self.weaponframe < 96) // can't keep it holding longer
	{
		//bprint ("fire", "\n");
		self.weaponframe = 32;
	//	grabberfire (200);
	//	self.nextthink = time + 1.2;
	}

	if (self.weaponframe > 20 && !self.grabbed_proj && self.weaponframe < 117) // full-auto
		self.weaponframe = 118;

	self.weaponframe++;
	self.nextthink = time + 0.04;
};

weapon_info_frames wf_grabber = {12, '132 192 0', '193 198 0', '0 0 0', '0 0 0', NO_AMMO, NO_AMMO, player_grab, W_WeaponGrabberNoise};
weapon_info_generic w_grabber = { "progs/v_grav.md3", "progs/male/w_railgun.mdl", AmmoLessCheck};

//=============================================

/*
============
artifact
============
*/

entity() ArtifactAim =
{
	local	vector	source;

	source = self.origin + '0 0 16';
	local vector dir;

	dir = source + aim(self,10000)*8192;
	traceline (source, dir, FALSE, self);

	if (trace_fraction == 1.0)
		return world;

	if (trace_ent.flags & FL_MONSTER && trace_ent.takedamage && trace_ent.health > 0)
		return trace_ent;
	
	return world;	
}


static float (float diff) get_diff =
{
	if ( diff > 180 ) 
		diff = 180;
	else if ( diff < -180 ) 
		diff = -180;
	return diff;
}

void() Artifact_Home = // im just gonna reuse this
{
	vector	dir, seekPos;
	vector  dirAng, nose;
	float frac;
	vector diff;
	float i = 0;

	nose = self.origin;
	seekPos = self.enemy.origin + (self.enemy.mins + self.enemy.maxs)*0.5;

	dir = seekPos - nose;

	if (vlen (nose - seekPos) < 16)
		self.movetype = MOVETYPE_FLY;

	dirAng = vectoangles(normalize(dir));
	dirAng [0] = -dirAng[0]; // im not sure why 

	if ( self.ltime < time ) 
	{
		self.rndAng[ 0 ] = 15 * crandom();
		self.rndAng[ 1 ] = 15 * crandom();
		self.rndAng[ 2 ] = 15 * crandom();
		self.ltime = time + 1.25;
	}

	// make it more accurate as it gets closer
	frac = vlen(dir) / 256;
	if ( frac > 1) 
		frac = 1;

	diff = dirAng - self.movedir + self.rndAng * frac;
	diff = Normalize180(diff);

	diff[0] = get_diff(diff[0]);
	diff[1] = get_diff(diff[1]);
	diff[2] = get_diff(diff[2]);

	self.movedir += diff;

	vector fwd;
	AngleVectors(self.movedir, fwd);

	self.velocity = fwd * 600;

	self.nextthink = time;
	self.think = Artifact_Home;	
};

static void(vector o, vector vel, float p) spawnbloodspray =
{	
	for(float i = 0; i<8;i++)
		SpawnBlood (o, vel * (crandom()*1800), p);
}

void() Artifact_touch =
{   
	entity damaged = self.enemy;
	entity own = self.owner;
	vector oldorg = self.origin;

	if (other != self.enemy)
		return;

	if (self.dmgtime > time)
		return;

	if (!own.artifact_healfinished && own.health < 125 && !own.megahealth_finished)
	{		
		float heal = 100;
		if (damaged.health > 1000)
			heal = 125;

		own.artifact_healfinished = 1;
		own.healamount = heal;
		own.artifact_healtime = time;
	}
	
	sound(self, CHAN_VOICE, "misc/null.wav", 1, ATTN_NORM);
	sound(self, CHAN_BODY, "weapons/soulcube/soulcube_shred.wav", 1, ATTN_NORM);

	//sound(own, CHAN_FIVE, "weapons/soulcube/recharge.wav", 1, ATTN_NONE);
	pointparticles (particleeffectnum("TE_GORESPRAY"), damaged.origin + '0 0 24', '0 0 200', 6);

	spawnbloodspray  (damaged.origin + '0 0 24', normalize(oldorg - damaged.origin), 1000);

	self.dmgtime = time + 0.2;

	if (self.dmg >= self.count)
	{	
		T_Damage (damaged, own, oldorg, own, 100, 0);

		if (damaged.health <= 0 && damaged.health < 1000) // ensure gib
		{	
			T_Damage (damaged, own, oldorg, own, 9999, 0); 
			remove(self);
			return;
		}

		self.count += 100;
	}
	else
	{	
		remove(self);
	}
};

void(vector org, vector vec) LaunchArtifact =
{
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_NOCLIP;
	newmis.solid = SOLID_BBOX;
	newmis.effects = EF_DIMLIGHT;
	newmis.dmgtime = 0;
	newmis.classname = "artifact";
	newmis.scale = 1.3;
	newmis.count = 0;
	newmis.dmg = 1000;
	newmis.dmgtime = 0;

	setmodel (newmis, "progs/artifact_mis.md3");
	setsize (newmis, '-16 -16 -16', '16 16 16');		

	setorigin (newmis, org);

	newmis.velocity = normalize(vec) * 1800;
	newmis.movedir = vectoangles(newmis.velocity);
	newmis.avelocity = '300 300 300';

	newmis.nextthink = time + 0.2;
	newmis.think = Artifact_Home;
	newmis.enemy = self.enemy;
	self.enemy = world;
	newmis.touch = Artifact_touch;
	sound(newmis, CHAN_VOICE, "weapons/soulcube/fly_loop_01.wav", 1, ATTN_NORM);
};

.float animatereverse;

void() player_useartifact =[self.frame, player_useartifact ]
{	
	self.weaponstate = WEAPON_USED;

	if (self.weaponframe != 20 && self.weaponframe > 131)
	{	
		self.weaponframe = 20;
		self.enemy = ArtifactAim();
	}

	if (!self.enemy && self.weaponframe == 26)
		self.animatereverse = TRUE;
	
	if (self.animatereverse)
	{	
		if (self.weaponframe == 20)
		{		
			self.animatereverse = FALSE;
			self.weaponstate = WEAPON_IDLE;
			self.weaponframe = 132;
			player_run();
			return;
		}

		self.weaponframe--;
		self.nextthink = time + 0.03;
		return;
	}

	if (self.weaponframe == 44)
	{	
		LaunchArtifact (self.origin, aim(self,10000));
		self.items &= ~IT_ARTIFACT;
		self.weaponid = self.oldweaponid;
		self.oldweaponid = 0;
		player_run();
		W_SetCurrentAmmo (FALSE);
		return;
    }

	self.weaponframe++;
	self.nextthink = time + 0.03;

	W_WeaponArtifactNoise ();
};

void() W_WeaponArtifactNoise =
{
	if (self.weaponframe == 0)
	{
		if (random() <= 0.5)
			sound(self, CHAN_RELOAD, "weapons/soulcube/raise_01.wav", 1, ATTN_NORM);
		else	
			sound(self, CHAN_RELOAD, "weapons/soulcube/raise_02.wav", 1, ATTN_NORM);
	}
		
	if (self.weaponframe == 221)
		sound(self, CHAN_RELOAD, "weapons/soulcube/putaway_01.wav", 1, ATTN_NORM);

	if (self.weaponframe == 27)
	{
		if (random() <= 0.5)
			sound(self, CHAN_RELOAD, "weapons/soulcube/fly_start_03.wav", 1, ATTN_NORM);
		else	
			sound(self, CHAN_RELOAD, "weapons/soulcube/fly_start_02.wav", 1, ATTN_NORM);
	}
};

weapon_info_frames wf_artifact = {19, '132 220 0', '221 226 0', '0 0 0', '0 0 0', NO_AMMO, NO_AMMO, player_useartifact, W_WeaponArtifactNoise};
weapon_info_generic w_artifact = { "progs/v_artifact.md3", "progs/male/w_railgun.mdl", AmmoLessCheck};