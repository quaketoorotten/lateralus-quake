/*
=====================================================================

player use weapons 

=====================================================================
*/

void()	player_run;

.entity pweaponmodel;
entity gunpmodel;

weapon_info_ammo a_empty = {};
weapon_info_generic w_empty = {};
weapon_info_frames wf_empty = {};

// weapon_info_frames foobar = { last_active, idle_first, idle_last, swap_first, swap_last, 
//				reload_first, reload_last, frame_ins_ammo, reloadloop_1st, reload_loop_last, mag_size, capacity, fire_func, sound_func}

weapon_info_frames getweaponframes[15] =
{	
	wf_empty,
	wf_fist,
	wf_pistol,
	wf_shotgun,
	wf_machinegun,
	wf_chaingun,
	wf_grenade,
	wf_plasmagun,
	wf_rocketlauncher,
	wf_bfg,
	wf_chainsaw,
	wf_doublebarrel, // where are you oh  i figured
	wf_grabber,
	wf_artifact,
	wf_empty
};

weapon_info_generic getweaponinfo[15] =
{	
	w_empty,
	w_fist,
	w_pistol,
	w_shotgun,
	w_machinegun,
	w_chaingun,
	w_grenade,
	w_plasmagun,
	w_rocketlauncher,
	w_bfg,
	w_chainsaw,
	w_doublebarrel,
	w_grabber,
	w_artifact,
	w_empty
};

weapon_info_ammo getweaponammo[15] =
{	
	a_empty,
	a_fist,
	a_pistol,
	a_shotgun,
	a_machinegun,
	a_chaingun,
	a_grenade,
	a_plasmagun,
	a_rocketlauncher,
	a_bfg,
	a_fist,
	a_doublebarrel, 
	a_fist,
	a_fist,
	a_empty
};

float getweaponbit[15] =
{	
	0,
	IT_FIST,
	IT_PISTOL,
	IT_SHOTGUN,
	IT_MACHINEGUN,
	IT_CHAINGUN,
	IT_GRENADE,
	IT_PLASMA_GUN,
	IT_ROCKET_LAUNCHER,
	IT_BFG,
	IT_CHAINSAW,
	IT_DOUBLEBARREL, 
	IT_GRABBER,
	IT_ARTIFACT,
	0
};

void(string weapon) player_get_gunmodel =
{
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
	weapon_info_generic wep = getweaponinfo[self.weaponid];
	weapon_info_ammo currammo = getweaponammo[self.weaponid];

	if (self.weaponid == self.oldweaponid || item == TRUE)
	{	
		currammo.assign_currentammo();	
		return;
	}
	
  	self.weapon = getweaponbit[self.weaponid];
	self.weaponmodel = wep.vmodel;
	currammo.assign_currentammo();

	player_get_gunmodel (wep.pmodel);
	
	self.newweaponid = 0;
	self.weaponframe = 0;
	self.weaponstate = WEAPON_ACTIVATE;
};


float() W_BestWeapon =
{
    local float it;

    it = self.items;

    if (self.waterlevel <= 1 && self.savedammo_cells2 >= 30 && (it & IT_BFG))
    {
        return 10;
    }
    else if (self.savedammo_cells >= 1 && (it & IT_PLASMA_GUN))
    {
        return 8;
    }
    else if (self.savedammo_nails2 >= 1 && (it & IT_CHAINGUN))
    {
        return 6;
    }
    else if (self.savedammo_shells >= 2 && (it & IT_SHOTGUN))
    {
        return 3;
    }
	  else if (self.savedammo_nails >= 1 && (it & IT_MACHINEGUN))
    {
        return 5;
    }
    else if (self.ammo_shells >= 2 && (it & IT_DOUBLEBARREL))
    {
        return 4;
    }
    else if (self.savedammo_shells2 >= 1 && (it & IT_PISTOL))
    {
        return 2;
    }
	
    return 1;
};


float(float w) RankForWeapon =
{
	if (w == 8)
		return 1;
	if (w == 10)
		return 2;
	if (w == 9)
		return 3;
	if (w == 3)
		return 4;
	if (w == 6)
		return 5;
	if (w == 7)
		return 6;
	if (w == 2)
		return 7;
	if (w == 5)
		return 8;
	return 11;
};

float() W_CheckNoAmmo =
{
	local float ammo_type = 0;
	weapon_info_generic wep = getweaponinfo [self.weaponid];
	weapon_info_ammo wep_ammo = getweaponammo [self.weaponid];	
	
    if (!wep_ammo.get_ammo() && !wep.condition())
    {
        return FALSE; // weapon doesn't need ammo
    }

    if (self.currentammo > 0)
    {
        return FALSE; // has at least one ammo
    }

	if (wep_ammo.get_ammo() > 0 && self.currentammo < 1 && cvar("g_autoreload") == 1)
	{		
		self.currentammo = 0;
		self.weaponstate = WEAPON_RELOAD;
		return TRUE; // just reload the gun
	}

	if (wep_ammo.get_ammo() <= 0)
	{
   	 	self.newweaponid = W_BestWeapon();
   	 	self.oldweaponid = self.weaponid;
   	 	self.weaponstate = WEAPON_DEACTIVATE;
	}

    // drop the weapon down
    return TRUE;
};

/*
============
W_ChangeWeapon
============
*/
void() W_ChangeWeapon =
{
    local float it, am, fl;

    float id = self.impulse;

	if (id == 13 && self.weaponid == 13)
		id = self.oldweaponid;

    if (id == 3 && self.weaponid == 3)
		id = 11;

    if (id == 3 && !(self.items & IT_SHOTGUN) && (self.items & IT_DOUBLEBARREL))
		id = 11;

	if (id == 1 && self.weaponid == 1)
		id = 10;

    weapon_info_generic wepinfo = getweaponinfo[id];

    it = self.items;
    am = wepinfo.condition();
    fl = getweaponbit[id];
	
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

	if (self.weaponid == id)
		return;
	
    self.newweaponid = id;
	self.oldweaponid = self.weaponid;
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
    local float it, am;

    it = self.items;
    self.impulse = 0;
	
	float id = self.weaponid;
	weapon_info_generic nextweapon = getweaponinfo[id];
	float nextweapon_bit = getweaponbit[id];	

    while(1)
    {		
	  	id++; 
	  	if (id >= MAX_WEAPONS) // reset
			id = 1; 
		//bprint (ftos(id), "\n");

	  	nextweapon = getweaponinfo[id];
	  	am = nextweapon.condition();  
		nextweapon_bit = getweaponbit[id];

        	if ((it & nextweapon_bit) && !am)
            	break;
    }
	
	self.newweaponid = id;	
	self.weaponstate = WEAPON_DEACTIVATE;
	self.oldweaponid = self.weaponid;
};

/*
============
CycleWeaponReverseCommand

Go to the prev weapon with ammo
============
*/
void() CycleWeaponReverseCommand =
{
    local float it, am;

    it = self.items;
    self.impulse = 0;
	
	float id = self.weaponid;
	weapon_info_generic nextweapon = getweaponinfo[id];
	float nextweapon_bit = getweaponbit[id];

    while(1)
    {		  
	  	id--;	  
	  	if (id <= 0) // reset
			id = MAX_WEAPONS - 1; 
	  
        	//bprint (ftos(id), "\n");
	  	nextweapon = getweaponinfo[id];
	  	am = nextweapon.condition();  
		nextweapon_bit = getweaponbit[id];

        if ((it & nextweapon_bit) && !am)
        	break;
    }

    self.newweaponid = id;	
	self.weaponstate = WEAPON_DEACTIVATE;
	self.oldweaponid = self.weaponid;

};

//============================================

/*
============
W_WeaponFrame

Called every frame so impulse events can be handled as well as possible
============
*/
.float grabber_thinker;

void() W_WeaponThink = 
{
	if (!self.weaponid)
		return;
	
	if (self.dspeed > time)
		return;

	if (self.grabber_thinker < time && self.weaponid == 12 && !self.grabbed_proj)
	{	
		if (grabber_grab_check() )
			self.hitmarker_time = time + 0.08;

		self.grabber_thinker = time + 0.1;
	}

	W_WeaponGeneric ();
};

float(float ammo) bfgcheckammo = 
{	
	if (29 < ammo && ammo < 60)
		return 30;
	if (59 < ammo && ammo < 90)
		return 60;
	if (89 < ammo && ammo < 120)
		return 90;
	if (ammo > 119)
		return 120;
	
	return 0;
}

static float FIRST = 0; static float LAST  = 1;

void() W_WeaponGeneric = 
{		
	if (!self.weaponmodel)
		return;

	weapon_info_frames wepname = getweaponframes[self.weaponid];

	//change_end = change_end + 1;
	local float ammo_type, cap = 0;

	if (self.weaponstate == WEAPON_ACTIVATE)
	{
		wepname.weaponsound ();
		self.weaponframe ++;
		self.attack_finished = TRUE;

		if (self.weaponframe == wepname.last_activation)
		{	
			self.weaponstate = WEAPON_IDLE;
			self.weaponframe = wepname.idle_frames[FIRST];
			self.attack_finished = 0;
		}
		
		self.dspeed = time + 0.02;
		return;
	}
	
	// WEAPON_SPIN_OUT_OF_AMMO removed
	
	if (self.weaponstate == WEAPON_DEACTIVATE)
	{	
		if (self.weaponframe < wepname.swap_frames[FIRST])
			self.weaponframe = wepname.swap_frames[FIRST];
		
		self.weaponframe ++;
		self.attack_finished = TRUE;
				
		if (self.weaponframe == wepname.swap_frames[LAST])
		{	
			if (random() <= 0.5)
				sound(self, CHAN_RELOAD, "weapons/wepchg1a.wav", 1, ATTN_NORM);
			else
				sound(self, CHAN_RELOAD, "weapons/wepchg1b.wav", 1, ATTN_NORM);
				
			self.attack_finished = FALSE;
			self.weaponid = self.newweaponid;	
			
			self.weaponstate = WEAPON_IDLE;
			W_SetCurrentAmmo(FALSE);
		}
		
		player_deactivate1();
		self.dspeed = time + 0.02;
		return;
	}
	
	if (self.weaponstate == WEAPON_USED)
		return;

	if (W_WeaponUse())
	{
		W_Attack(wepname.weaponfire);
		return;
	}
	
	if (self.weaponstate == WEAPON_RELOAD)
	{		
		weapon_info_ammo wepinfo = getweaponammo[self.weaponid];
		ammo_type = wepinfo.get_ammo();
		//local float tmp;
		float ammo_load = wepname.mag_size;
		cap = wepname.capacity;
		float truecap = cap;

		if (self.weaponid == 9) // bfg exclusive
		{	
			cap = bfgcheckammo(ammo_type);
			ammo_load = bfgcheckammo(ammo_type);
		}
		
		if ((self.currentammo >= cap || ammo_type < 1) && self.weaponframe >= wepname.reload_frames[LAST] && self.currentammo > 0)
		{
			self.weaponstate = WEAPON_IDLE;
			self.weaponframe = wepname.idle_frames[FIRST];
			return;		
		}

		if (self.weaponframe < wepname.reload_frames[FIRST] && (self.weaponframe >= wepname.idle_frames[FIRST] || self.weaponframe <= wepname.idle_frames[LAST]))
			self.weaponframe = wepname.reload_frames[FIRST];

		if (self.currentammo <= cap && self.weaponframe == wepname.reload_frames[2])
		{		
			if (ammo_type <= ammo_load && cap >= ammo_load)
				ammo_load = ammo_type;
			
			self.currentammo = self.currentammo + ammo_load;
			ammo_type -= ammo_load;

			if (self.currentammo > truecap)
			{	
				ammo_type += self.currentammo - cap;
				self.currentammo = self.currentammo - (self.currentammo - cap);
			}

			wepinfo.save_ammo (ammo_type);
		}

		if (self.currentammo < cap && ammo_type > 0 && self.weaponframe > wepname.reloadloop_frames[LAST] - 1 && self.weaponid != 9)
			self.weaponframe = wepname.reloadloop_frames[FIRST];
		
		self.weaponframe ++;
		wepname.weaponsound ();	

		if ( self.weaponframe < wepname.reloadloop_frames[LAST])
			self.attack_finished = TRUE;
		else
			self.attack_finished = FALSE;
		
		if (self.weaponid == 11)
			self.dspeed = time + 0.0325; // wtf
		else
			self.dspeed = time + 0.03; // wtf

		return;
	}	
	
	if (wepname.capacity != 0)
	{	
		weapon_info_ammo wepinfo2 = getweaponammo[self.weaponid];
		ammo_type = wepinfo2.get_ammo();
		if (self.currentammo < 1 && ammo_type <= 0)
		{	
			self.weaponstate = WEAPON_DEACTIVATE;
			self.newweaponid = W_BestWeapon();
			return;
		}
	}

	self.weaponframe ++;
	self.dspeed = time + 0.04;
	
	self.weaponstate = WEAPON_IDLE;
	self.attack_finished = FALSE;
		
	if (self.weaponframe == wepname.idle_frames[LAST])
		self.weaponframe = wepname.idle_frames[FIRST];

	ImpulseCommands();
};

void(void() fire) W_Attack =
{	
      makevectors(self.v_angle); // calculate forward angle for velocity
      self.show_hostile = time + 1; // wake monsters up
	
	//bprint(ftos(self.impulse), "\n");

      fire();

	//player_firegun ();
};

float () W_WeaponUse =
{		
	// WEAPON_SPIN_OUT_OF_AMMO removed

	if (self.weaponstate == WEAPON_ACTIVATE)
		return FALSE;

	if (self.weaponstate == WEAPON_DEACTIVATE)
		return FALSE;

	if (self.attack_finished)
		return FALSE;

	if (W_CheckNoAmmo ())
		return FALSE;

    // check for attack
    if (!self.button0)
		return FALSE;

	return TRUE;
};

void() W_WeaponReload = 
{	
	if (!self.button3)
		return;
	if (self.weaponstate == WEAPON_USED)
		return;
	if (self.weaponstate == WEAPON_RELOAD)
		return;

	weapon_info_ammo wepinfo = getweaponammo[self.weaponid];
	weapon_info_frames wepname = getweaponframes[self.weaponid];

	if (wepname.reload_frames[FIRST] <= 0)
		return;
	
	float ammo_type = wepinfo.get_ammo();
	
	float cap = wepname.capacity;

	if (self.weaponid == 9) // bfg exclusive
		cap = bfgcheckammo(ammo_type);
	
	if(ammo_type < 30 && self.weaponid == 9)
		return;
	if(self.currentammo == 120 && self.weaponid == 9)
		return;
	if(self.currentammo >= cap && self.weaponid != 9)
		return;
	if(ammo_type < 0)
		return;
	if(self.attack_state == AS_MISSILE)
		return;
	
	player_run();	
	self.weaponstate = WEAPON_RELOAD;
	self.dspeed = 0;	
}

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
	
    self.ammo_rockets = MAX_ROCKETS;
    self.ammo_nails = MAX_NAILS;
    self.ammo_shells = MAX_SHELLS;
    self.items = self.items |
                 IT_FIST |
                 IT_PISTOL |
                 IT_SHOTGUN |
                 IT_MACHINEGUN |
                 IT_CHAINGUN |
                 IT_GRENADE |
                 IT_ROCKET_LAUNCHER;

    self.ammo_cells = MAX_CELLS;
    self.items = self.items | 
			IT_PLASMA_GUN |
			IT_CHAINSAW |
			IT_DOUBLEBARREL |
			IT_BFG;

    self.impulse = 0;
	self.savedammo_rockets = RL_AMMO_CAP;
    self.savedammo_nails = MG_AMMO_CAP;
    self.savedammo_nails2 = CG_AMMO_CAP;

    self.savedammo_shells = SG_AMMO_CAP;
    self.savedammo_shells2 = PSTL_AMMO_CAP;
	self.savedammo_shellsDB = 2;
	self.savedammo_cells = PLSG_AMMO_CAP;
	self.savedammo_cells2 = BFG_AMMO_CAP;

    W_SetCurrentAmmo(TRUE);
};


void() CheatCommand2 =
{
    if (deathmatch || coop)
    {
        return;
    }
	
    self.items |= IT_GRABBER;

    self.impulse = 0;

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

    self.super_time = time;
    self.super_damage_finished = time + 30;
    self.powerups |= IT_QUAD;

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
    self.powerups |= IT_SUIT;
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
    self.powerups |= IT_INVISIBILITY;
    dprint("invis cheat\n");
};

void() PentaCheat =
{
    if (deathmatch || coop)
    {
        return;
    }

 //   self.invincible_time = 1;
 //   self.invincible_finished = time + 30;
    self.items |= IT_ARTIFACT;
    dprint("artifact cheat\n");
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
		case 29:
			CheatCommand();
			break;
		case 33:
			CheatCommand2();
			break;
		case 32:
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

void() WeaponChange =
{	
	if (self.super_damage_finished)
	{
		self.impulse = 0;
		return;
	}

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
		case 9:
		case 10:
		case 11:
		case 12:
		case 13:
			W_ChangeWeapon();
			break;
		case 30:
			CycleWeaponCommand();
			break;
		case 31:
			CycleWeaponReverseCommand ();
			break;
	//	case 67:
	//		WeaponReload ();
	//		break;
		default:
			return;	
	}	
		
	self.impulse = 0;
};
