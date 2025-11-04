
void() SUB_Null = {};

void() SUB_Remove = {remove(self);};


/*
QuakeEd only writes a single float for angles (bad idea), so up and down are
just constant angles.
*/
void() SetMovedir =
{
	if (self.angles == '0 -1 0')
		self.movedir = '0 0 1';
	else if (self.angles == '0 -2 0')
		self.movedir = '0 0 -1';
	else
	{
		makevectors (self.angles);
		self.movedir = v_forward;
	}
	
	self.angles = '0 0 0';
};

/*
================
InitTrigger
================
*/
void() InitTrigger =
{
// trigger angles are used for one-way touches.  An angle of 0 is assumed
// to mean no restrictions, so use a yaw of 360 instead.
	if (self.angles != '0 0 0')
		SetMovedir ();
	self.solid = SOLID_TRIGGER;
	setmodel (self, self.model);	// set size and link into world
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
};

/*
=============
SUB_CalcMove

calculate self.velocity and self.nextthink to reach dest from
self.origin traveling at speed
===============
*/
void(entity ent, vector tdest, float tspeed, void() func) SUB_CalcMoveEnt =
{
local entity	stemp;
	stemp = self;
	self = ent;

	SUB_CalcMove (tdest, tspeed, func);
	self = stemp;
};

void(vector tdest, float tspeed, void() func) SUB_CalcMove =
{
local vector	vdestdelta;
local float		len, traveltime;

	if (!tspeed)
		objerror("No speed is defined!");

	self.think1 = func;
	self.finaldest = tdest;
	self.think = SUB_CalcMoveDone;

	if (tdest == self.origin)
	{
		self.velocity = '0 0 0';
		self.nextthink = self.ltime + 0.1;
		return;
	}
		
// set destdelta to the vector needed to move
	vdestdelta = tdest - self.origin;
	
// calculate length of vector
	len = vlen (vdestdelta);
	
// divide by speed to get time to reach dest
	traveltime = len / tspeed;

	if (traveltime < 0.1)
	{
		self.velocity = '0 0 0';
		self.nextthink = self.ltime + 0.1;
		return;
	}
	
// set nextthink to trigger a think when dest is reached
	self.nextthink = self.ltime + traveltime;

// scale the destdelta vector by the time spent traveling to get velocity
	self.velocity = vdestdelta * (1/traveltime);	// qcc won't take vec/float	
};

/*
============
After moving, set origin to exact final destination
============
*/
void()  SUB_CalcMoveDone =
{
	setorigin(self, self.finaldest);
	self.velocity = '0 0 0';
	self.nextthink = -1;
	if (self.think1)
		self.think1();
};


/*
=============
SUB_CalcAngleMove

calculate self.avelocity and self.nextthink to reach destangle from
self.angles rotating 

The calling function should make sure self.think is valid
===============
*/
void(entity ent, vector destangle, float tspeed, void() func) SUB_CalcAngleMoveEnt =
{
local entity		stemp;
	stemp = self;
	self = ent;
	SUB_CalcAngleMove (destangle, tspeed, func);
	self = stemp;
};

void(vector destangle, float tspeed, void() func) SUB_CalcAngleMove =
{
local vector	destdelta;
local float		len, traveltime;

	if (!tspeed)
		objerror("No speed is defined!");
		
// set destdelta to the vector needed to move
	destdelta = destangle - self.angles;
	
// calculate length of vector
	len = vlen (destdelta);
	
// divide by speed to get time to reach dest
	traveltime = len / tspeed;

// set nextthink to trigger a think when dest is reached
	self.nextthink = self.ltime + traveltime;

// scale the destdelta vector by the time spent traveling to get velocity
	self.avelocity = destdelta * (1 / traveltime);
	
	self.think1 = func;
	self.finalangle = destangle;
	self.think = SUB_CalcAngleMoveDone;
};

/*
============
After rotating, set angle to exact final angle
============
*/
void() SUB_CalcAngleMoveDone =
{
	self.angles = self.finalangle;
	self.avelocity = '0 0 0';
	self.nextthink = -1;
	if (self.think1)
		self.think1();
};

//=========================
//
// SUB_NormalizeAngles
//
//=========================

vector ( vector ang ) SUB_NormalizeAngles =
   {
   while( ang_x > 360 )
      {
      ang_x = ang_x - 360;
      }
   while( ang_x < 0 )
      {
      ang_x = ang_x + 360;
      }

   while( ang_y > 360 )
      {
      ang_y = ang_y - 360;
      }
   while( ang_y < 0 )
      {
      ang_y = ang_y + 360;
      }

   while( ang_z > 360 )
      {
      ang_z = ang_z - 360;
      }
   while( ang_z < 0 )
      {
      ang_z = ang_z + 360;
      }

   return ang;
   };

//=============================================================================

void() DelayThink =
{
	activator = self.enemy;
	SUB_UseTargets ();
	remove(self);
};

/*
==============================
SUB_UseTargets

the global "activator" should be set to the entity that initiated the firing.

If self.delay is set, a DelayedUse entity will be created that will actually
do the SUB_UseTargets after that many seconds have passed.

Centerprints any self.message to the activator.

Removes all entities with a targetname that match self.killtarget,
and removes them, so some events can remove other triggers.

Search for (string)targetname in all entities that
match (string)self.target and call their .use function

==============================
*/
void() SUB_UseTargets =
{
	local entity t, stemp, otemp, act;

//
// check for a delay
//
	if (self.delay)
	{
	// create a temp object to fire at a later time
		t = spawn();
		t.classname = "DelayedUse";
		t.nextthink = time + self.delay;
		t.think = DelayThink;
		t.enemy = activator;
		t.message = self.message;
		t.killtarget = self.killtarget;
		t.target = self.target;
		return;
	}
	
	
//
// print the message
//
	if (activator.classname == "player" && self.message != "")
	{
		centerprint (activator, self.message);
		if (!self.noise)
			sound (activator, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
	}

//
// kill the killtagets
//
	if (self.killtarget != "" && self.killtarget != " ")
	{
		t = world;
		do
		{
			t = find (t, targetname, self.killtarget);
			if (!t)
				return;
			if((t.classname == "func_explosive") && (t.targetname == self.killtarget)) // make breakables blow up not disapear
				T_Damage (t, activator, activator.origin, activator, t.health, 0);
			else
				remove (t);
		} while ( 1 );
	}
	
//
// fire targets
//
	if (self.target != "" && self.target != " ")
	{
		act = activator;
		t = world;
		do
		{
			t = find (t, targetname, self.target);
			if (!t)
			{
				return;
			}
			stemp = self;
			otemp = other;
			self = t;
			other = stemp;
			if (self.use != SUB_Null)
			{
				if (self.use)
					self.use ();
			}
			self = stemp;
			other = otemp;
			activator = act;
		} while ( 1 );
	}
	

};

//============================================================

float(entity e) SUB_KillBox =
{	
	local float oldsolid = e.solid;

	e.solid = SOLID_BBOX;
	while(1)
	{
		tracebox (e.origin, e.mins, e.maxs, e.origin, FALSE, self);
		if(!trace_ent)
			break;
		
		if(trace_ent.deadflag)
			return FALSE;		

		T_Damage (trace_ent, e, e.origin, e, trace_ent.health + 10000, 0);
		
		if (trace_ent.solid)
			return FALSE;
	}
	
	e.solid = oldsolid;
	return TRUE;
};

void(float start, float end, void() thinker, float speed, void() extra_thinker) SUB_AnimateWeapon =
{		
	if (self.weaponframe != start && self.weaponframe > end + 1)
		self.weaponframe = start;

	if (self.weaponframe >= end)
	{
		self.think = thinker;
		self.nextthink = time + speed;
		return;
	}
	
	self.weaponframe++;
	// self.think = self.think2;
	self.nextthink = time + speed;

	extra_thinker();
	player_firegun ();
};

void(float start, float end, void() thinker, float speed, void() extra_thinker) SUB_Animate =
{		
	if (self.frame >= end)
	{
		thinker ();
		extra_thinker();
		return;
	}
	
	self.frame++;
	self.nextthink = time + speed;

	extra_thinker();
};

		
void(float normal) SUB_AttackFinished =
{	
	self.cnt = 0;
	self.attack_finished = time + normal;
};

void(entity ent, float normal) SUB_AttackFinished_notself =
{	
	ent.cnt = 0;
	ent.attack_finished = time + normal;
};

float (entity targ) visible;

void (void() thinkst) SUB_CheckRefire =
{	
	if (skill < 2)
		return;
	if (self.cnt == 1)
		return;
	if (!visible (self.enemy))
		return;
	self.cnt = 1;
	self.think = thinkst;
};

float (float thinkst) SUB_CheckRefireFrame =
{	
	//if (skill < 2)
	//	return FALSE;
	if (self.cnt == 1)
		return FALSE;
	if (!visible (self.enemy))
		return FALSE;
	self.cnt = 1;
	self.frame = thinkst;
	return TRUE;
};


float (float accel, vector dis, float discap) CalcVelocity = 
{
	local float lendis;	
	local float vel;
	
	lendis = vlen(dis) - discap;

	vel = 2*accel*lendis;
	vel = floor(sqrt(vel));
	return vel;
};

vector (vector a, vector b, vector forward, vector right) ProjectAim =
{
	local vector spit;
	spit = a + forward * b[0] + right * b[1];
	spit_z = spit_z + b[2];
	
	return spit;
};

vector (float x, float y, float z) setvector = 
{
	local vector v;
	v_x = x;
	v_y = y;
	v_z = z;
	return v;
};

float rand() =
{
	return random()*32767;
};

void(vector start, vector pos) line = 
{
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LIGHTNING2);

	WriteEntity(MSG_BROADCAST, self);

	WriteCoord(MSG_BROADCAST, start_x);
	WriteCoord(MSG_BROADCAST, start_y);
	WriteCoord(MSG_BROADCAST, start_z);
	WriteCoord(MSG_BROADCAST, pos_x);
	WriteCoord(MSG_BROADCAST, pos_y);
	WriteCoord(MSG_BROADCAST, pos_z);
}

