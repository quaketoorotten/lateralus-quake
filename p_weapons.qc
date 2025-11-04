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
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_GUNSHOT);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
};

void(string mdl, vector org, vector dir) _casing =
{
	local entity casing;
	casing = spawn();

	setmodel(casing, mdl);
    	setsize(casing, '0 0 0', '0 0 0');
    	setorigin(casing, org);
	
	casing.movetype = MOVETYPE_BOUNCE;
   	casing.solid = SOLID_NOT;

	makevectors (self.v_angle);
	casing.velocity = v_right*-75 + v_up*(25 + random()*25);
	casing.angles = vectoangles(v_forward);
	casing.velocity += self.velocity;
	//casing.scale = 1.5;	

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
   	casing.solid = SOLID_NOT;

	casing.velocity = '0 0 10';
	casing.scale = 0.8;	

	casing.nextthink =  time + 10 + random()*5;
	casing.think = SUB_Remove;
	casing.avelocity = '0 600 600';
};


/*
================
W_FireShotgun
================
*/
void() W_FireShotgun =
{
    local vector dir;
	local vector offset, start;

	local float dmg = 18, kick = 8;

	if (deathmatch)
	{
		dmg = 12; 
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

    self.punchangle_x = -2;

	offset = setvector (0, 8, self.view_ofs[1] - 8);
	makevectors(self.v_angle);
	start = ProjectAim (self.origin, offset, v_forward, v_right);

    self.currentammo -= 1;
    dir = aim(self, 10000);

      SuperDamageSound();
	TE_GUNSMOKE (start + v_forward * 32 + '0 0 24');
    FireBullet (start,  dir, 0, 0, dmg, kick, TE_SPIKE);
	
	offset = setvector (14, 8, self.view_ofs[1] + 16);
	makevectors(self.v_angle);

	_casing ("progs/shell.mdl", ProjectAim (self.origin, offset, v_forward, v_right), aim(self, 10000));
};


/*
================
W_FireSuperShotgun
================
*/
void() W_FireSuperShotgun =
{
    local vector dir;
	local vector offset, start;

	local float dmg = 14, kick = 16;

	if (deathmatch)
	{
		dmg = 8; 
		kick = 4;
	}

	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_WEAPON, "weapons/shotgun/fire/sgfire_01.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_WEAPON, "weapons/shotgun/fire/sgfire_02.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_WEAPON, "weapons/shotgun/fire/sgfire_03.wav", 1, ATTN_NORM);

    self.punchangle_x = -4;

	offset = setvector (0, 8, self.view_ofs[1] - 8);
	makevectors(self.v_angle);
	start = ProjectAim (self.origin, offset, v_forward, v_right);

    self.currentammo -= 1;
    dir = aim(self, 10000);
	
      SuperDamageSound();
    FirePallets (SHOTGUN_PELLETS, start,  dir, SHOTGUN_HSPREAD, SHOTGUN_VSPREAD, dmg, kick, TE_SPIKE);
	TE_GUNSMOKE (start + v_forward * 32 + '0 0 24');
	TE_GUNSMOKE (start + v_forward * 32 + '0 0 24' + v_up * 2);
	TE_GUNSMOKE (start + v_forward * 32 + '0 0 24' + v_right * 2);
	TE_GUNSMOKE (start + v_forward * 32 + '0 0 24' + v_right * -2);

   // FirePallets (SSHOTGUN_PELLETS / 2, start,  dir, SSHOTGUN_HSPREAD*1.3, SHOTGUN_VSPREAD, dmg, kick, TE_GUNSHOT);
};

/*
================
W_FireMachineGun
================
*/
void() W_FireMachineGun =
{
      local vector dir;
	local vector offset, start;

	local float dmg = 13, kick = 2;

	if (deathmatch)
	{
		dmg = 8; 
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

	offset = setvector (0, 8, self.view_ofs[1] - 8);
	makevectors(self.v_angle);
	start = ProjectAim (self.origin, offset, v_forward, v_right);

    self.currentammo = self.currentammo - 1;
    dir = aim(self, 10000);
	
      SuperDamageSound();
		TE_GUNSMOKE (start + v_forward * 32 + '0 0 24');

    FireBullet (start,  dir, MACHINEGUN_HSPREAD, MACHINEGUN_VSPREAD, dmg, kick, TE_SPIKE);

		offset = setvector (12, 0, self.view_ofs[1] + 18);
	makevectors(self.v_angle);

	_casing ("progs/shell.mdl", ProjectAim (self.origin, offset, v_forward, v_right), aim(self, 10000));
};

/*
================
W_FireChaineGun
================
*/
void() W_FireChainGun =
{	

      local vector dir;
	local vector offset, start;

	local float dmg = 20, kick = 2, r, u;

	if (deathmatch)
	{
		dmg = 2; 
		kick = 0.5;
	}

  	 AutofireChainGunNoise ();

	self.punchangle = setvector (crandom() * 0.7, crandom() * 0.7, crandom() * 0.7);
	//bprint (vtos(self.punchangle));
	//bprint ("\n");

	makevectors(self.v_angle);
	
	r = 7 + crandom()*4;
	u = crandom()*4;
		
	offset = setvector (0, r, u + self.view_ofs[1] - 8);
	start = ProjectAim (self.origin, offset, v_forward, v_right);

    self.currentammo = self.savedammo_nails2 = self.savedammo_nails2 - 1;
    dir = aim(self, 10000);
	
	self.effects = self.effects | EF_MUZZLEFLASH;
	
      SuperDamageSound();
	TE_GUNSMOKE (start + v_forward * 32 + '0 0 24' + v_right * -2);

    FireBullet (start,  dir, CHAINGUN_HSPREAD, CHAINGUN_VSPREAD, dmg, kick, TE_SPIKE);

	offset = setvector (10, -2, self.view_ofs[1] + 16);
	makevectors(self.v_angle);

	_casing ("progs/shell.mdl", ProjectAim (self.origin, offset, v_forward, v_right), aim(self, 10000));
};

void() W_FireChainGunSpinning =
{		
	if (!self.button0)
		return;

	if (self.weaponframe >= 25 && self.weaponframe <= 32 && self.weaponframe % 3)
	{
		self.solid = SOLID_BBOX;
		W_FireChainGun ();
		self.solid = SOLID_SLIDEBOX;
	}
	

};

//=============================================================================

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

    damg = 170;
	
	pointparticles (particleeffectnum("TE_ROCKETIMPAC"), self.origin);
	pointparticles (particleeffectnum("TE_ROCKETIMPAC2"), self.origin);
	
    self.origin = self.origin - 16* normalize(self.velocity);

    if (other.takedamage)
    {
        T_Damage(other, self, self.origin, self.owner, damg, 50);
    }
   
    // don't do radius damage to the other, because all the damage
    // was done in the impact
    T_RadiusDamage(self, self.owner, 150, 175, other);
	
	self.owner.punchangle = setvector (crandom() * 1.2, crandom() * 1.2, crandom() * 1.2);

	
    //sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM)
    BecomeExplosion();
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

    self.punchangle_x = -2;

    missile = spawn();
    missile.owner = self;
    missile.movetype = MOVETYPE_FLY;
    missile.solid = SOLID_BBOX;
    missile.classname = "missile";

    // set missile speed

    offset = setvector (8, 8, self.view_ofs[1] + 8);
	makevectors(self.v_angle);
	start = ProjectAim (self.origin, offset, v_forward, v_right);

	TE_GUNSMOKE (start + v_forward * 32);
	TE_GUNSMOKE (start + v_forward * 32 + v_up * 2);
	TE_GUNSMOKE (start + v_forward * 32 + v_right * 2);
	TE_GUNSMOKE (start + v_forward * 32 + v_right * -2);

    missile.velocity = aim(self, 1000);
    missile.velocity = missile.velocity * 1500;
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

      SuperDamageSound();


};

//=============================================================================

void() GrenadeExplode =
{
    T_RadiusDamage(self, self.owner,self.dmg, 150, world);

		pointparticles (particleeffectnum("TE_ROCKETIMPAC"), self.origin);
	pointparticles (particleeffectnum("TE_ROCKETIMPAC2"), self.origin);

    BecomeExplosion();
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
	missile.traileffectnum = particleeffectnum ("EF_NADETRAIL");

    // set missile speed
    offset = setvector (8, 8, self.view_ofs[1] + 8);
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

	 SuperDamageSound();
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

    // set missile speed
    offset = setvector (8, 8, self.view_ofs[1] + 16);
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
	missile.dmg = 150;
		
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

	SuperDamageSound();
};


//=============================================================================

void(vector org) anchor =
{
	newmis = spawn();
	newmis.velocity = '0 0 0';
	newmis.origin = org;
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 0.2;
};

void() W_FireRail =
{
	local	vector  dir, start, offset;

	if (self.ammo_nails < 3)
		return;

	offset = setvector(8, 8, self.view_ofs[1] + 12);

	self.punchangle_x = -3;

	makevectors(self.v_angle);
	start = ProjectAim (self.origin, offset, v_forward, v_right);
	dir = aim(self,10000);
	
	 // sound(self, CHAN_WEAPON, "weapons/railgf1a.wav", 1, ATTN_NORM);

	self.currentammo = self.ammo_nails = self.ammo_nails - 3;
	
	anchor (start);
	fireRail (start, dir, newmis, self, 125, 200, TE_BEAM, 8192);
      SuperDamageSound();

};

void() W_FireHyper = 
{
	local vector dir, offset, start;

	offset = setvector(24, 8, self.view_ofs[1] + 12);

	makevectors(self.v_angle);
	start = ProjectAim (self.origin, offset, v_forward, v_right);

	self.punchangle_x = -1;
	
	self.effects = self.effects | EF_MUZZLEFLASH;
	
	dir = aim(self,10000);

	self.currentammo = self.currentammo - 1;

	local float r = rint(random() * 2);
	
	if (r == 2)
		    sound(self, CHAN_WEAPON, "weapons/plasma/2plasma_fire1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_WEAPON, "weapons/plasma/2plasma_fire3.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_WEAPON, "weapons/plasma/2plasma_fire6.wav", 1, ATTN_NORM);

	
	LaunchLaser (start, dir);
      SuperDamageSound();

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

	SuperDamageSound();
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
	local float		dmg = 20, kick = 5, crit = FALSE;
	// string punchnoise = ;
	
	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	local vector vel, dir;
	dir = source + v_forward*64;
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

		SpawnBlood (org, vel);

		T_Damage (trace_ent, self, trace_endpos, self, dmg , kick);
		sfx1 ();
	}
	else
	{	// hit wall
		sfx2 ();
		//stuffcmd (self, "vibrate tactile/player/axhit2.bnvib");
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SPIKE);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};

void() flash_update =
{		
	//bprint(ftos(self.owner.weaponframe),"\n");
	if (self.owner.weaponframe == 155 || self.owner.health < 1)
	{
		remove(self);
		return;
	}

       // Set Start Position
        local vector offset = setvector (8, 24, self.owner.view_ofs[1] + 8);
	  makevectors(self.owner.v_angle);
	  local vector start = ProjectAim (self.owner.origin, offset, v_forward, v_right);

        traceline (start , start + v_forward * 1024 , FALSE , self);

        // Set the Flashlight's position

        setorigin (self, trace_endpos+(v_forward * -5));

        // Repeat it in 0.02 seconds...
        self.nextthink = time + frametime;
};

void() flash_on =
{
        // Make a new entity to hold the Flashlight
        local entity myflash;

        // spawn flash
        myflash = spawn ();
        myflash.movetype = MOVETYPE_NONE;
        myflash.solid = SOLID_NOT;
        // this uses the s_bubble.spr, if you want it to be completly
        // invisible you need to create a one pixel trancparent spirit
        // and use it here...
        setmodel (myflash, "progs/muzzleflash.spr"); 
        setsize (myflash, '0 0 0', '0 0 0');

        // Wire Player And Flashlight Together
        myflash.owner = self;
        self.flash = myflash;
        
        // give the flash a Name And Make It Glow
        myflash.classname = "flash";
        myflash.traileffectnum = particleeffectnum ("EF_FLASHLIGHT");
        
        // Set Start Position
        local vector offset = setvector (8, 24, self.view_ofs[1] + 8);
	  makevectors(self.v_angle);
	  local vector start = ProjectAim (self.origin, offset, v_forward, v_right);

        traceline (start , start + v_forward * 1024 , FALSE , self);
        setorigin (myflash, trace_endpos);

        // Start Flashlight Update
        myflash.think = flash_update;
        myflash.nextthink = time + 0.02;
};

.float flash_flag; // On/off for the flashlight
.entity flash;   // flash entity

//==============================================================================================

/*PLAYER WEAPON USE
*/
//==============================================================================================

void() W_WeaponHandGr =
{
	self.weaponuse = player_flash;
	W_WeaponFrame (14, 65, 154, 160, 155, 0, 0, 0, 0, 0, 0, 0);
};

void() W_flashnoise =
{
	//bprint("cuh","\n");
	if (self.weaponframe == 13)
		flash_on ();
};

void() player_flashidle = 
{
	player_run ();
	self.attack_finished = 0; 
	self.weaponframe = 65;
	self.weaponstate = WEAPON_IDLE;

	return;
};

void() player_flashhitcheck = 
{
	switch(self.weaponframe)
	{
		case 18:
		case 44:
		self.solid = SOLID_BBOX;
		W_FireAxe (W_WeaponBlasterHit, W_WeaponBlasterHit);
		self.solid = SOLID_SLIDEBOX;
		break;

		default:
		break;
	}

	return;
};

void() player_flash2 = [self.frame , player_flash2 ]
{self.attack_finished = time + 20; self.weaponstate = WEAPON_USED; SUB_AnimateWeapon (39, 64, player_flashidle , 0.04, player_flashhitcheck );};
void() player_flash1 = [self.frame , player_flash1 ]
{self.attack_finished = time + 20; self.weaponstate = WEAPON_USED; SUB_AnimateWeapon (15, 38, player_flashidle , 0.04, player_flashhitcheck );};

void() player_flash = 
{	
	if (self.weaponstate == WEAPON_USED) 
		return;

	local float r = rint(random() * 6);
	
	switch(r)
	{
		case 1:
		player_flash2 ();
		break;

		default:
		player_flash1 ();
		break;
	}
};


void() W_WeaponBlaster = 
{	
	self.weaponuse = player_blast;
	W_WeaponFrame (11, 75, 120, 126, 121, 0, 0, 0, 0, 0, 0, 0);
};

void() W_WeaponBlasterNoise = 
{	
	if (self.weaponframe == 0)
		sound(self, CHAN_RELOAD, "weapons/fists/raise_fists_01.wav", 1, ATTN_NORM);
};

void() W_WeaponBlasterHit = 
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

void() player_blastidle = 
{
	player_run ();
	self.attack_finished = 0; 
	self.weaponframe = 75;
	self.weaponstate = WEAPON_IDLE;

	return;
};

void() player_blasthitcheck = 
{
	switch(self.weaponframe)
	{
		case 13:
		case 29:
		case 45:
		case 61:
		self.solid = SOLID_BBOX;
		W_FireAxe (W_WeaponBlasterHit, W_WeaponBlasterHit);
		self.solid = SOLID_SLIDEBOX;
		break;

		default:
		break;
	}

	return;
};

void() player_blast4 = [self.frame , player_blast4]
{self.attack_finished = time + 20; self.weaponstate = WEAPON_USED; SUB_AnimateWeapon (59, 74, player_blastidle, 0.04, player_blasthitcheck);};
void() player_blast3 = [self.frame , player_blast3]
{self.attack_finished = time + 20; self.weaponstate = WEAPON_USED; SUB_AnimateWeapon (43, 58, player_blastidle, 0.04, player_blasthitcheck);};
void() player_blast2 = [self.frame , player_blast2]
{self.attack_finished = time + 20; self.weaponstate = WEAPON_USED; SUB_AnimateWeapon (27, 42, player_blastidle, 0.04, player_blasthitcheck);};
void() player_blast1 = [self.frame , player_blast1]
{self.attack_finished = time + 20; self.weaponstate = WEAPON_USED; SUB_AnimateWeapon (12, 26, player_blastidle, 0.04, player_blasthitcheck);};

void() player_blast = 
{	
	if (self.weaponstate == WEAPON_USED) 
		return;

	local float r = rint(random() * 3);
	
	switch(r)
	{
		case 3:
		player_blast4 ();
		break;

		case 2:
		player_blast3 ();
		break;

		case 1:
		player_blast2 ();
		break;

		default:
		player_blast1 ();
		break;
	}
};

/*void(float start_fire, float idle_start, float idle_end, float change_end, 
	optional float change_start, optional float reload_start, optional float reload_loop_start, reload_insert
	 optional float reload_end_start, optional float reload_end_end, optional float ammo_load, optional float max_ammo_load, optional float ammo_type) */

void() W_WeaponGrenadeLaun = 
{	
	self.weaponuse = player_handgr;
	W_WeaponFrame (14, 155, 294, 300, 295, 0, 0, 0, 0, 0, 0, 0);
};

void() W_WeaponGrenadeLaunNoise = 
{	
	if (self.weaponframe == 0)
		sound(self, CHAN_RELOAD, "weapons/grenades/gren_use.wav", 1, ATTN_NORM);
};

void() player_handgr =[self.frame, player_handgr ]
{	
	self.attack_finished = time + 666;
	self.weaponstate = WEAPON_USED;

	if (self.weaponframe != 15 && self.weaponframe > 154)
	{
		sound(self, CHAN_WEAPON,"weapons/grenades/gren_throw_mix.wav", 1, ATTN_NORM);
		self.grenade_time = 0;
		self.weaponframe = 15;
	}

	if (self.weaponframe >= 154)
	{	
		player_run ();
		self.attack_finished = 0; 
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
			self.attack_finished = 0; 
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
	self.nextthink = time + 0.04;

	player_firegun ();
};

void() W_WeaponShotgun = 
{	
	self.weaponuse = player_shotg;
	W_WeaponFrame (14, 26, 85, 144, 139, 86, 100, 129, 132, 138, 16, 16);
};

void() W_WeaponPistolNoise =
{	
	//local float r = rint(random() * 2);

	if (self.weaponframe == 0)
		sound(self, CHAN_RELOAD, "weapons/pistol/pistol_use_01.wav", 1, ATTN_NORM);

	if (self.weaponframe == 86)
		sound(self, CHAN_RELOAD, "weapons/pistol/pistol_reload_01.wav", 1, ATTN_NORM);
};

void() player_shotg =[self.frame, player_shotg ]
{	
	self.attack_finished = time + 20;
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
			self.attack_finished = 0; 
			player_run ();
			self.weaponframe = 26;
			return;
		}
	}

	if (self.weaponframe != 15 && self.weaponframe > 25)
		self.weaponframe = 15;

	if (self.weaponframe == 21 && self.button0)
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
	self.nextthink = time + 0.04;
	player_firegun ();
};

/*void(float start_fire, float idle_start, float idle_end, float change_end, 
	optional float change_start, optional float reload_start, optional float reload_loop_start, reload_insert
	 optional float reload_end_start, optional float reload_end_end, optional float ammo_load, optional float max_ammo_load, optional float ammo_type) */

void() W_WeaponSShotgun = 
{	
	self.weaponuse = player_shotg2;
	W_WeaponFrame (14, 47, 118, 177, 172, 119, 126, 130, 150, 171, 1, 6);
};

void() W_WeaponShotgunNoise =
{	

	local float r = rint(random() * 2);

	if (self.weaponframe == 0)
		sound(self, CHAN_RELOAD, "weapons/shotgun/shotgun_use_01.wav", 1, ATTN_NORM);

	if (self.weaponframe == 9 || self.weaponframe == 165 || self.weaponframe == 33)
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

void() player_shotg2 =[self.frame, player_shotg2 ]
{	
	self.attack_finished = time + 20;
	self.weaponstate = WEAPON_USED;
 
	if (self.weaponframe != 15 && self.weaponframe > 46 )
		self.weaponframe = 15;

	if (self.weaponframe >= 46)
	{
		player_run ();
		self.attack_finished = 0; 
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

		_casing ("progs/shell2.mdl", ProjectAim (self.origin, offset, v_forward, v_right), aim(self, 10000));
	}

	self.weaponframe++;
	self.nextthink = time + 0.04;
	player_firegun ();
	self.weaponnoise ();
};

/*void(float start_fire, float idle_start, float idle_end, float change_end, 
	optional float change_start, optional float reload_start, optional float reload_loop_start, reload_insert
	 optional float reload_end_start, optional float reload_end_end, optional float ammo_load, optional float max_ammo_load, optional float ammo_type) */

void() W_WeaponMachineGun = 
{	
	self.weaponuse = player_machn;
	W_WeaponFrame (14, 19, 63, 129, 124, 64, 75, 107, 109, 123, 50, 50);
};

void() W_WeaponMachineGunNoise =
{
	if (self.weaponframe == 0)
		sound(self, CHAN_RELOAD, "weapons/machinegun/mg_use_01.wav", 1, ATTN_NORM);

	if (self.weaponframe == 64)
		sound(self, CHAN_RELOAD, "weapons/machinegun/mg_reload_01.wav", 1, ATTN_NORM);

	if (self.weaponframe == 85)
	{
		local vector offset = setvector (0, 0, self.view_ofs[1] + 4);
		makevectors(self.v_angle);

		_mag ("progs/shell4.mdl", ProjectAim (self.origin, offset, v_forward, v_right));
	}
};

void() player_machn = [self.frame, player_machn ]
{	
	self.attack_finished = time + 20; 
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
			self.attack_finished = 0; 
			player_run ();
			self.weaponframe = 19;
			return;
		}
	}

	if (self.weaponframe != 15 && self.weaponframe > 18)
		self.weaponframe = 15;

	if (self.weaponframe > 17 && self.button0)
		self.weaponframe = 15;

	if (self.weaponframe == 15)
	{
		self.solid = SOLID_BBOX;	
		W_FireMachineGun ();
		self.savedammo_nails = self.currentammo;
		self.effects = self.effects | EF_MUZZLEFLASH;
		self.solid = SOLID_SLIDEBOX;
      }
		
	self.weaponframe++;

	self.nextthink = time + 0.04;
	if (self.button0)
		self.nextthink = time + 0.035;	
	player_firegunloop ();
};

void() W_WeaponChainGun = 
{	
	self.weaponuse = player_chain;
	W_WeaponFrame (14, 45, 94, 150, 145, 95, 96, 102, 143, 144, 60, 60);
};

void() W_WeaponChainGunNoise =
{
	if (self.weaponframe == 0)
		sound(self, CHAN_RELOAD, "weapons/chaingun/cg_use_01.wav", 1, ATTN_NORM);

	if (self.weaponframe == 95)
		sound(self, CHAN_RELOAD, "weapons/chaingun/cg_reload_twist_01.wav", 1, ATTN_NORM);
};

void() player_chain = [self.frame, player_chain ]
{	
	self.attack_finished = time + 20; 
	self.weaponstate = WEAPON_USED;
	
	if (!self.button0 || (self.currentammo < 1))
	{	
		if (self.weaponframe < 25 || (self.weaponframe >= 25 && self.weaponframe <= 32))
		{
			sound(self, CHAN_RELOAD, "weapons/chaingun/cg_winddown_mix_01.wav", 1, ATTN_NORM);
			self.weaponframe = 33;
		}

		if ((self.weaponframe <= 44))
		{	
			self.weaponframe ++; 
			self.nextthink = time + 0.04;
			player_firegunloop ();
			return;
		}
		else
		{	
			sound(self, CHAN_RELOAD, "misc/null.wav", 1, ATTN_NORM);
			self.attack_finished = 0; 
			player_run ();
			self.weaponframe = 45;
			return;
		}
	}
	
	W_FireChainGunSpinning ();
	
	if (self.weaponframe != 15 && self.weaponframe > 44)
	{
		sound(self, CHAN_RELOAD, "weapons/chaingun/cg_windup_mix_01.wav", 1, ATTN_NORM);
		self.weaponframe = 15;
	}

	if (self.weaponframe > 31 && self.button0) // full-auto
	{
		sound(self, CHAN_RELOAD, "weapons/chaingun/cg_motor_loop_01.wav", 1, ATTN_NORM);
		self.weaponframe = 25;
	}

	self.weaponframe++;
	player_firegunloop ();
	self.nextthink = time + 0.04;
};

/*void(float start_fire, float idle_start, float idle_end, float change_end, 
	optional float change_start, optional float reload_start, optional float reload_loop_start, reload_insert
	 optional float reload_end_start, optional float reload_end_end, optional float ammo_load, optional float max_ammo_load, optional float ammo_type) */

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
	self.weaponuse = player_chainsaw;
	W_WeaponFrame (30, 68, 147, 153, 148, 0, 0, 0, 0, 0, 0, 0);

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

void() player_chainsaw = [self.frame, player_chainsaw ]
{	
	self.attack_finished = time + 20; 
	self.weaponstate = WEAPON_USED;
	
	if (self.weaponframe == 46)
		sound(self, CHAN_WEAPON, "weapons/chainsaw/stop_attack.wav", 1, ATTN_NORM);
	
	if (!self.button0)
	{	
		if (self.weaponframe != 45 && self.weaponframe < 45)
			self.weaponframe = 45;
			// bprint ("buh \n");
			// sound(self, CHAN_WEAPON, "weapons/chainsaw/stop_attack.wav", 1, ATTN_NORM);

		if ((self.weaponframe <= 67))
		{	
			self.weaponframe ++; 
			self.nextthink = time + 0.04;
			player_firegunloop ();
			return;
		}
		else
		{	
			self.attack_finished = 0; 
			player_run ();
			self.weaponframe = 68;
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
		self.solid = SOLID_SLIDEBOX;
	}

	self.weaponframe++;
	player_firegunloop ();
	self.nextthink = time + 0.04;
};

void() W_WeaponHyperBlas = 
{	
	self.weaponuse = player_hyperb;
	W_WeaponFrame (11, 27, 146, 213, 207, 147, 160, 190, 195, 206, 50, 50);
};


void() W_WeaponHyperBlasNoise =
{
	if (self.weaponframe == 147)
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


void() player_hyperb = [self.frame, player_hyperb ]
{	
	self.attack_finished = time + 20; 
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
			self.attack_finished = 0; 
			player_run ();
			self.weaponframe = 27;
			return;
		}
	}

	if (self.weaponframe != 12 && self.weaponframe > 26)
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
	self.nextthink = time + 0.04;
	player_firegunloop ();
};


/*void(float start_fire, float idle_start, float idle_end, float change_end, 
	optional float change_start, optional float reload_start, optional float reload_loop_start, reload_insert
	 optional float reload_end_start, optional float reload_end_end, optional float ammo_load, optional float max_ammo_load, optional float ammo_type) */

void() W_WeaponRocketLaun = 
{	
	self.weaponuse = player_rocket;
	W_WeaponFrame (14, 28, 110, 168, 161, 111, 120, 150, 155, 160, 5, 5);
};

void() W_WeaponRocketLaunNoise =
{	
	//local float r = rint(random() * 2);

	if (self.weaponframe == 0)
		sound(self, CHAN_RELOAD, "weapons/rocket/raise.wav", 1, ATTN_NORM);

	if (self.weaponframe == 111)
		sound(self, CHAN_RELOAD, "weapons/rocket/reload.wav", 1, ATTN_NORM);

	if (self.weaponframe == 134)
	{
		local vector offset = setvector (0, 8, self.view_ofs[1] + 4);
		makevectors(self.v_angle);

		_mag ("progs/shell5.mdl", ProjectAim (self.origin, offset, v_forward, v_right));
	}
};

void() player_rocket =[self.frame, player_rocket ]
{	
	self.attack_finished = time + 20;
	self.weaponstate = WEAPON_USED;

	if (self.weaponframe != 15 && self.weaponframe > 27)
		self.weaponframe = 15;

	if (self.weaponframe >= 27)
	{
		player_run ();
		self.attack_finished = time + 0.6; 
		self.weaponframe = 28;
		
		return;
	}

	//if (self.weaponframe == 6)
	//	sound(self, CHAN_RELOAD, "weapons/rocklr1b.wav", 1, ATTN_NORM);
	
	if (self.weaponframe == 15)
	{
		self.effects = self.effects | EF_MUZZLEFLASH;
		W_FireRocket();
		self.savedammo_rockets = self.currentammo;
	}	

	self.weaponframe++;
	
	player_firegun ();
	self.nextthink = time + 0.04;
};

/*void(float start_fire, float idle_start, float idle_end, float change_end, 
	optional float change_start, optional float reload_start, optional float reload_loop_start, reload_insert
	 optional float reload_end_start, optional float reload_end_end, optional float ammo_load, optional float max_ammo_load, optional float ammo_type) */

void() W_WeaponBFG = 
{	
	self.weaponuse = player_bfg;
	W_WeaponFrame (14, 182, 241, 308, 302, 242, 260, 280, 290, 301, 40, 40);
};

void(float level) W_FireBFG =
{
	local vector dir, offset, start; 
	local float dmg_rad, dmg, dmg_lsr;

	// self.currentammo  = self.ammo_cells = self.ammo_cells - 50;

	offset = setvector(24, 8, self.view_ofs[1] + 14);

	makevectors(self.v_angle);
	start = ProjectAim (self.origin, offset, v_forward, v_right);
	dir = aim(self,10000);

	self.punchangle_x = -8;
	
	dmg = 400 * level;
	dmg_lsr = 6 * level;
	dmg_rad = 400 * level;	

	launch_thunderball(dir,start,dmg,dmg_lsr,dmg_rad);
      SuperDamageSound();
};

void() W_WeaponBFGNoise =
{	
	//local float r = rint(random() * 2);

	if (self.weaponframe == 0)
		sound(self, CHAN_RELOAD, "weapons/bfg/bfg_raise.wav", 1, ATTN_NORM);

	if (self.weaponframe == 242)
		sound(self, CHAN_RELOAD, "weapons/bfg/bfg_reload.wav", 1, ATTN_NORM);

	if (self.weaponframe == 265)
	{
		local vector offset = setvector (0, -16, self.view_ofs[1] + 4);
		makevectors(self.v_angle);

		_mag ("progs/shell3.mdl", ProjectAim (self.origin, offset, v_forward, v_right));
	}
};

void() player_bfg = [self.frame, player_bfg ]
{	
	self.attack_finished = time + 999;
	local float level = 10;

	self.weaponstate = WEAPON_USED;

	if (self.weaponframe != 15 && self.weaponframe > 181)
	{
		sound(self, CHAN_WEAPON, "weapons/bfg/bfg_firebegin.wav", 1, ATTN_NORM);	
		self.weaponframe = 15;
	}

	if (self.weaponframe > 144 && self.button0 && self.weaponframe < 153)
	{
		// player_run ();
		W_FireGrenade2(0, 0, TRUE);
		self.weaponframe = 181;
		self.nextthink = time + 4; // don't overcharge it again dumbass
		return;
	}

	if (self.weaponframe >= 181)
	{
		player_run ();
		self.attack_finished = 0; 
		self.weaponframe = 182;
		
		return;
	}

	if (self.weaponframe <= 76 && self.weaponframe >= 56) 
		level = 20;

	else if (self.weaponframe <= 96 && self.weaponframe > 76)
		level = 30;
	
	else if (self.weaponframe <= 152 && self.weaponframe > 96)
		level = 40;
	
	if (self.savedammo_cells2 >= level)
		self.dmg_lsr = level;

	if (!self.button0 && self.weaponframe < 153)
		self.weaponframe = 153;

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
	{
		player_firegunloop ();
		self.nextthink = time + 0.02;
	}
	else
	{
		player_firegun ();
		self.nextthink = time + 0.04;
	}
};

//=============================================