void() t_movetarget;
/*

.enemy
Will be world if not currently angry at anyone.

.movetarget
The next path spot to walk toward.  If .enemy, ignore .movetarget.
When an enemy is killed, the monster will try to return to it's path.

.huntt_ime
Set to time + something when the player is in sight, but movement straight for
him is blocked.  This causes the monster to use wall following code for
movement direction instead of sighting on the player.

.ideal_yaw
A yaw angle of the intended direction, which will be turned towards at up
to 45 deg / state.  If the enemy is in view and hunt_time is not active,
this will be the exact line towards the enemy.

.pausetime
A monster will leave it's stand state and head towards it's .movetarget when
time > .pausetime.

real_walkmove(angle, speed) primitive is all or nothing
*/


//
// globals
//

//
// when a monster becomes angry at a player, that monster will be used
// as the sight target the next frame so that monsters near that one
// will wake up even if they wouldn't have noticed the player
//
entity	sight_entity;
float	sight_entity_time;

float(float v) anglemod;

void(vector dest) ChooseTurn;

void() ai_face;

float RANGE_CLOSE = 1;

float	enemy_vis, enemy_infront, enemy_range;
float	enemy_yaw;

/*
==============================================================================

MOVETARGET CODE

The angle of the movetarget effects standing and bowing direction, but has no effect on movement, which allways heads to the next target.

targetname
must be present.  The name of this movetarget.

target
the next spot to move to.  If not present, stop here for good.

pausetime
The number of seconds to spend standing or bowing for path_stand or path_bow

==============================================================================
*/

/*QUAKED path_corner (0.5 0.3 0) (-8 -8 -8) (8 8 8)
Monsters will continue walking towards the next target corner.
*/
void() path_corner =
{	
	if (deathmatch)
	{
		remove (self);
		return;
	}

	if (!self.targetname)
		objerror ("monster_movetarget: no targetname");
		
	self.solid = SOLID_TRIGGER;
	self.touch = t_movetarget;
	setsize (self, '-8 -8 -8', '8 8 8');
};


/*
=============
t_movetarget

Something has bumped into a movetarget.  If it is a monster
moving towards it, change the next destination and continue.
==============
*/
void() t_movetarget =
{
local entity	temp;

	if (other.movetarget != self)
		return;
	
	if (other.enemy)
		return;		// fighting, not following a path

	temp = self;
	self = other; // self is now the one touching
	other = temp; // other is now the one calling the touch

//dprint ("t_movetarget\n");
	self.goalentity = self.movetarget = find (world, targetname, other.target);
	self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
	if (!self.movetarget)
	{
		self.pausetime = time + 999999;
		self.th_stand ();
		return;
	}
};

/*QUAKED point_combat (0.5 0.3 0) (-8 -8 -8) (8 8 8) Hold
Makes this the target of a monster and it will head here
when first activated before going after the activator.  If
hold is selected, it will stay here.

i included some comments from the rerelease source code

*/
void() point_combat_touch =
{
	local entity	temp;
	local float 	hold = FALSE;

	if (other.movetarget != self)
		return;
	
	if (self.spawnflags & 1)
		hold = TRUE;

	temp = self;
	self = other; // self is now the one touching
	other = temp; // other is now the one calling the touch

	if (other.target)
	{
		self.target = other.target;
		self.goalentity = other.movetarget = find(world, target, other.target);
		if (!self.goalentity)
		{
			dprint( self.classname, " at " , vtos(self.origin), "target ", self.target, " does not exist\n");
			self.movetarget = other;
		}
		other.target = __NULL__;
	}
	
	else if (hold && !(self.flags & (FL_SWIM|FL_FLY)))
	{		
		if (self.aiflags & AI_STAND_GROUND)
			return;

		self.pausetime = 99999999;
		self.th_stand ();
		self.aiflags |= (AI_STAND_GROUND | AI_THIRD_EYE);
		//self.nextthink = time;
	}

	if (self.movetarget == other)
	{	
		// [Paril-KEX] if we're holding, keep movetarget set; we will
		// use this to make sure we haven't moved too far from where
		// we want to "guard".
		
		if (!hold)
		{
			self.target = __NULL__;
			self.movetarget = __NULL__;
		}
		self.goalentity = self.enemy;
		self.aiflags &= ~AI_COMBAT_POINT;
	}
};

void() point_combat =
{
	if (deathmatch)
	{
		remove (self);
		return;
	}
	
	self.classname = "combat_point";
	self.solid = SOLID_TRIGGER;
	self.touch = point_combat_touch;
	setsize (self,' -8 -8 -16', '8 8 16');
};


//============================================================================

/*
=============
range

returns the range catagorization of an entity reletive to self
0	melee range, will become hostile even if back is turned
1	visibility and infront, or visibility and show hostile
2	infront and show hostile
3	only triggered by damage
=============
*/

float(entity targ) range =
{
local vector	spot1, spot2;
local float		r;	
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	
	r = vlen (spot1 - spot2);
	if (r < 100)
		return RANGE_MELEE;
	if (r < 300)
		return RANGE_CLOSE;
	if (r < 500)
		return RANGE_NEAR;
	if (r < 1000)
		return RANGE_MID;
	return RANGE_FAR;
};

/*
=============
visible

returns 1 if the entity is visible to self, even if not infront ()
=============
*/
float (entity targ) visible =
{
	local vector	spot1, spot2;
	
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline (spot1, spot2, TRUE, self);	// see through other monsters
	
	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_fraction == 1)
		return TRUE;
	return FALSE;
};


/*
=============
infront

returns 1 if the entity is in front (in sight) of self
=============
*/
float(entity targ) infront =
{
	local vector	vec;
	local float		dot;
	
	makevectors (self.angles);
	vec = normalize (targ.origin - self.origin);
	dot = vec * v_forward;
	
	if ( dot > 0.3)
	{
		return TRUE;
	}
	return FALSE;
};

//============================================================================

void(entity ent) HuntTarget =
{	
	local entity oself;
	oself = self;
	self = ent;	

	self.goalentity = self.enemy;

	if (!(self.flags & FL_DODGED))
		self.think = self.th_run;
	
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	self.nextthink = time + 0.1;

	SUB_AttackFinished (1);	// wait a while before first attack

	self = oself;
};

void(entity targ) FoundTarget =
{
	local entity oself;

	if (targ.enemy.classname == "player")
	{	// let other monsters see this monster for a while
		sight_entity = self;
		sight_entity_time = time;
	}
	
	targ.show_hostile = time + 1;		// wake up other monsters	
	targ.last_sighting = self.enemy.origin;
	targ.trail_time = time;

	oself = self;
	self = targ;

	if (!self.combattarget)
	{
		self.th_sight ();
		HuntTarget (self);

		self = oself;
		return;
	}
	
	self.goalentity = self.movetarget = find (world, targetname, self.combattarget);
	if (!self.movetarget)
	{
		self.goalentity = self.movetarget = self.enemy;
		HuntTarget (self);
		self.th_sight ();
		dprint (self.classname," at " ,vtos(self.origin)," combat target ", self.combattarget, " not found \n");
		return;
	}
	
// clear out our combattarget, these are a one shot deal
	self.combattarget = __NULL__;
	self.aiflags |= AI_COMBAT_POINT;

	// clear the targetname, that point is ours!
	self.movetarget.targetname = __NULL__;
	self.pausetime = 0;

	// run for it
	self.th_run ();	

	self = oself;
};

/*
===========
FindTarget

Self is currently not attacking anything, so try to find a target

Returns TRUE if an enemy was sighted

When a player fires a missile, the point of impact becomes a fakeplayer so
that monsters that see the impact will respond as if they had seen the
player.

To avoid spending too much time, only a single client (or fakeclient) is
checked each frame.  This means multi player games will have slightly
slower noticing monsters.
============
*/

float() FindTarget =
{
	local entity	client;
	local float		r;

	if (self.aiflags & AI_COMBAT_POINT)
		return FALSE;

	if (self.brainspeed > time)
		return FALSE;

	self.brainspeed = time + 0.1;

// if the first spawnflag bit is set, the monster will only wake up on
// really seeing the player, not another monster getting angry

// spawnflags & 3 is a big hack, because zombie crucified used the first
// spawn flag prior to the ambush flag, and I forgot about it, so the second
// spawn flag works as well
	if (sight_entity_time >= time - 0.1 && !(self.spawnflags & 3) )
	{
		client = sight_entity;
		if (client.enemy == self.enemy)
			return FALSE;
	}
	else
	{
		client = checkclient ();
		if (!client)
			return FALSE;	// current check entity isn't in PVS
	}

	if (client == self.enemy)
		return FALSE;

	if (client.flags & FL_NOTARGET)
		return FALSE;
	if (client.items & IT_INVISIBILITY)
		return FALSE;

	r = range (client);
	if (r == RANGE_FAR)
		return FALSE;
		
	if (!visible (client))
		return FALSE;

	if (r == RANGE_NEAR)
	{
		if (client.show_hostile < time && !infront (client))
			return FALSE;
	}

	else if (r == RANGE_MID)
	{
		if ( !infront (client))
			return FALSE;
	}
//
// got one
//
	self.enemy = client;
	if (self.enemy.classname != "player")
	{
		self.enemy = self.enemy.enemy;
		if (self.enemy.classname != "player")
		{
			self.enemy = world;
			return FALSE;
		}
	}
	
	FoundTarget (self);

	return TRUE;
};


//=============================================================================


void(float dist) ai_move =
{
	M_walkmove (self.angles_y, dist);
};

/*
=============
keeping compatability with old code because im too lazy to change them
=============
*/
void(float dist) ai_forward = 
{
	ai_move (dist);
};

void(float dist) ai_back = 
{
	ai_move (-dist);
};

void(float dist) ai_pain =
{
	ai_move (-dist);
};

void(float dist) ai_painforward = 
{
	ai_move (dist);
};

/*
=============
ai_walk

The monster is walking it's beat
=============
*/
void(float dist) ai_walk =
{
//	local vector		mtemp;
	
	movedist = dist;

	// check for noticing a player
	if (FindTarget ())
		return;
		
	self.nextthink = time + 0.04;	
	M_MoveToGoal (dist);
};


/*
=============
ai_stand

The monster is staying in one place for a while, with slight angle turns
=============
*/
void() ai_stand =
{	
	if (self.enemy && (self.aiflags & AI_THIRD_EYE))
	{	
		if (visible (self.enemy))
		{
			self.aiflags &= ~(AI_THIRD_EYE | AI_STAND_GROUND);
			self.th_run ();
		}
		return;
	}

	if (FindTarget ())
		return;
	
	if (time > self.pausetime)
	{
		self.th_walk ();
		return;
	}

	self.nextthink = time + 0.04;
	
// change angle slightly

};

/*
=============
ai_turn

don't move, but turn towards ideal_yaw
=============
*/
void() ai_turn =
{
	if (FindTarget ())
		return;
	
	ChangeYaw ();
};

//=============================================================================

/*
=============
ChooseTurn
=============
*/
void(vector dest3) ChooseTurn =
{
	local vector	dir, newdir;
	
	dir = self.origin - dest3;

	newdir_x = trace_plane_normal_y;
	newdir_y = 0 - trace_plane_normal_x;
	newdir_z = 0;
	
	if (dir * newdir > 0)
	{
		dir_x = 0 - trace_plane_normal_y;
		dir_y = trace_plane_normal_x;
	}
	else
	{
		dir_x = trace_plane_normal_y;
		dir_y = 0 - trace_plane_normal_x;
	}

	dir_z = 0;
	self.ideal_yaw = vectoyaw(dir);	
};

/*
============
FacingIdeal

============
*/
float() FacingIdeal =
{
	local	float	delta;
	
	delta = anglemod(self.angles_y - self.ideal_yaw);
	if (delta > 45 && delta < 315)
		return FALSE;
	return TRUE;
};


//=============================================================================


/*
=============
ai_run_melee

Turn and close until within an angle to launch a melee attack
=============
*/
void() ai_run_melee =
{
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();

	if (FacingIdeal())
	{
		self.th_melee ();
		self.attack_state = AS_STRAIGHT;
	}
};


/*
=============
ai_run_missile

Turn in place until within an angle to launch a missile attack
=============
*/
void() ai_run_missile =
{
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();
	if (FacingIdeal())
	{
		self.th_missile ();
		self.attack_state = AS_STRAIGHT;
	}
};

.float l;
/*
=============
ai_run_slide

Strafe sideways, but stay at aproximately the same range
=============
*/
void(float d, float timer = 0.1) ai_run_slide =
{
	local float	ofs;
	
	self.ideal_yaw = enemy_yaw;
	 self.nextthink = time + timer;

	if (!self.lefty)
		ChangeYaw ();

	if (self.lefty)
		ofs = 90;
	else
		ofs = -90;
	
	if (walkmove (self.ideal_yaw + ofs, d))
		return;
		
	self.lefty = 1 - self.lefty;
	
	M_walkmove (self.ideal_yaw - ofs, d);
};

/*
=============
ai_face

Stay facing the enemy
=============
*/
void() ai_face =
{
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();
};

/*
=============
ai_charge

The monster is in a melee attack, so get as close as possible to .enemy
=============
*/
float (entity targ) visible;
float(entity targ) infront;
float(entity targ) range;

void(float d) ai_charge =
{
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();
	M_walkmove (self.angles_y, d);		// done in C code...
};

void() ai_charge_side =
{
	local	vector	dtemp;
	local	float	heading;
	
// aim to the left of the enemy for a flyby

	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();

	makevectors (self.angles);
	dtemp = self.enemy.origin - 30*v_right;
	heading = vectoyaw(dtemp - self.origin);
	
	M_walkmove(heading, 20);
};


/*
=============
ai_melee

=============
*/
void() ai_melee =
{
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy)
		return;		// removed before stroke
		
	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 60)
		return;
		
	ldmg = (random() + random() + random()) * 3;
	T_Damage (self.enemy, self, self.origin, self, ldmg, 0);
};


void() ai_melee_side =
{
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy)
		return;		// removed before stroke
		
	ai_charge_side();
	
	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 60)
		return;
	if (!CanDamage (self.enemy, self))
		return;
	ldmg = (random() + random() + random()) * 3;
	T_Damage (self.enemy, self, self.origin, self, ldmg, 0);
};


//=============================================================================

void(float t) CheckForCharge =
{
// check for mad charge
if (!enemy_vis)
	return;
if (time < self.attack_finished)
	return;	
if ( fabs(self.origin_z - self.enemy.origin_z) > 20)
	return;		// too much height change
if ( vlen (self.origin - self.enemy.origin) < 80)
	return;		// use regular attack

// charge		
	SUB_AttackFinished (t);
	self.th_char ();

};

void(float t) CheckContinueCharge =
{
	if (time > self.attack_finished)
	{
		SUB_AttackFinished (t);
		self.th_run ();
		return;		// done charging
	}
};

// code rip from my other mod, deimos

float() CheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;

	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);
	
	if (trace_ent != targ)
		return FALSE;		// don't have a clear shot
			
	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (enemy_range == RANGE_MELEE)
	{	
		// don't always melee in easy mode
		if (skill == 0 && (rand()&3) )
			return FALSE;
		if (self.th_melee)
			self.attack_state = AS_MELEE;
		else 
			self.attack_state = AS_MISSILE;

		return TRUE;
	}
	
// missile attack
	
	if (!self.th_missile)
		return FALSE;
	
	if (self.flags & FL_DODGED)
		return FALSE;
		
	if (time < self.attack_finished)
		return FALSE;
		
	if (enemy_range == RANGE_FAR)
		return FALSE;
		
	if (enemy_range == RANGE_MELEE)
		chance = 0.2;
	else if (enemy_range == RANGE_CLOSE)
		chance = 0.15;
	else if (enemy_range == RANGE_NEAR)
		chance = 0.1;
	else if (enemy_range == RANGE_MID)
		chance = 0.06;
	else
		return FALSE;

	if (skill == 0)
		chance *= 0.5;
	if (skill >= 2)
		chance *= 1.5;

	if (random () < chance)
	{
		self.attack_state = AS_MISSILE;
		SUB_AttackFinished (1 + 2*random());
		return TRUE;
	}

	return FALSE;
};


float() CheckAnyAttack =
{
	if (!enemy_vis)
		return FALSE;
	if (self.th_checkatck)
		return self.th_checkatck();
	return CheckAttack ();
};

float() ai_checkattack =
{
	local float hesDeadJim = FALSE;
	
	if (self.aiflags & AI_COMBAT_POINT)
		return FALSE;

	if (self.flags & FL_DODGED)
		return FALSE;
	
// see if the enemy is dead
	if ((!self.enemy))
	{
		hesDeadJim = TRUE;
	}
	else if (self.flags & FL_MEDIC)
	{
		if (self.enemy.health > 0)
		{
			hesDeadJim = TRUE;
			self.flags &= ~FL_MEDIC;
		}
	}
	else
	{
		if (self.enemy.health <= 0)
			hesDeadJim = TRUE;
	}

	if (hesDeadJim)
	{
		self.enemy = world;
	// FIXME: look all around for other targets
		if (self.oldenemy && self.oldenemy.health > 0)
		{
			self.enemy = self.oldenemy;
			self.oldenemy = world;
			HuntTarget (self);
		}
		else
		{
			if (self.movetarget)
			{
				self.goalentity = self.movetarget;
				self.th_walk ();
			}
			else
			{
				// we need the pausetime otherwise the stand code
				// will just revert to walking with no target and
				// the monsters will wonder around aimlessly trying
				// to hunt the world entity
				self.pausetime = 100000000;
				self.th_stand();
			}
			return TRUE;
		}
	}

	self.show_hostile = time + 1;		// wake up other monsters

// check knowledge of enemy	
	enemy_vis = visible(self.enemy);
	if (enemy_vis)
	{
		self.last_sighting = self.enemy.origin;
		self.search_time = time + 5;
	}
	else if (self.movetarget.classname == "combat_point") // if enemy isn't there anymore go back to guarding
	{
		self.aiflags |= AI_COMBAT_POINT;
		self.goalentity = self.movetarget;
		self.aiflags &= ~AI_STAND_GROUND;
		return FALSE;
	}

// look for other coop players
	if (coop && self.search_time < time)
	{
		if (FindTarget ())
			return TRUE;
	}

	if (self.attack_state == AS_MISSILE)
	{
		ai_run_missile ();
		return TRUE;
	}
	if (self.attack_state == AS_MELEE)
	{
		ai_run_melee ();
		return TRUE;
	}

	return CheckAnyAttack();
};

//=============================================================================

/*
=============
ai_run

The monster has an enemy it is trying to kill
=============
*/
void(float dist) ai_run =
{		
	movedist = dist;
	local entity tempgoal, save, marker;
	local float left, right, dis1, dis2, center, new;
	local vector view, Ltarg, Rtarg;

	self.show_hostile = time + 1;		// wake up other monsters

	enemy_infront = infront(self.enemy);
	enemy_range = range(self.enemy);
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);

	self.nextthink = time + 0.04;

	if (self.aiflags & AI_COMBAT_POINT)
	{	
		M_MoveToGoal (dist);
		return;
	}

	if (ai_checkattack())
		return;		

	if (self.attack_state == AS_SLIDING)
	{	
		if ((self.aiflags & AI_LOST_SIGHT))
			self.attack_state = AS_STRAIGHT;
		else 
			ai_run_slide (movedist);
		return;
	}

//--------- q2 port kinda
	if (enemy_vis)
	{
		M_MoveToGoal (dist);
		self.aiflags &= ~AI_LOST_SIGHT;
		self.last_sighting = self.enemy.origin;
		return;
	}

	if ((self.search_time) && (time > (self.search_time + 20)))
	{	
		M_MoveToGoal (dist);
		self.search_time = 0;
		dprint("search timeout\n");
		return;
	}

	if (self.brainspeed > time)
	{
		M_MoveToGoal (dist);
		return;
	}

	self.brainspeed = time + 0.1;

	save = self.goalentity;
	tempgoal = spawn();
	self.goalentity = tempgoal;

	new = FALSE;
	
	if (!(self.aiflags & AI_LOST_SIGHT))
	{
		self.aiflags |= (AI_LOST_SIGHT | AI_PURSUIT_LAST_SEEN);
		self.aiflags &= ~(AI_PURSUE_NEXT | AI_PURSUE_TEMP);
		new = TRUE;
	}
	
	if (self.aiflags & AI_PURSUE_NEXT)
	{
		self.aiflags &= ~AI_PURSUE_NEXT;

		dprint("reached current goal: "); 
		dprint(vtos(self.origin)); dprint(" "); dprint(vtos(self.last_sighting)); 
		dprint(" "); dprint(ftos(vlen(self.origin - self.last_sighting))); dprint("\n");

		// give ourself more time since we got this far
		self.search_time = time + 5;

		if (self.aiflags & AI_PURSUE_TEMP)
		{
			self.aiflags &= ~AI_PURSUE_TEMP;
			self.saved_goal = self.last_sighting;
			marker = __NULL__;
			new = TRUE;
		}
		else if (self.aiflags & AI_PURSUIT_LAST_SEEN)
		{
			self.aiflags &= ~AI_PURSUIT_LAST_SEEN;
			marker = PlayerTrail_PickFirst ();
		}
		else
		{
			marker = PlayerTrail_PickNext ();
		}

		if (marker)
		{
			self.last_sighting = marker.origin;
			self.trail_time = marker.ltime;
			self.angles_y = self.ideal_yaw = marker.angles_y;

			dprint("heading is "); dprint(ftos(self.ideal_yaw)); dprint("\n");

			new = TRUE;
		}
	}
	
	if (vlen(self.origin - self.last_sighting) <= dist)
	{
		self.aiflags |= AI_PURSUE_NEXT;
		dist = vlen(self.origin - self.last_sighting);
	}
	
	self.goalentity.origin = self.last_sighting;
	
	if(new)
	{		
		tracebox(self.origin + '0 0 24', self.mins, self.maxs, self.goalentity.origin, TRUE, self);
	
		if(trace_fraction < 1)
		{	
			view = normalize(self.goalentity.origin - self.origin);
			dis1 = vlen(self.goalentity.origin - self.origin);
			center = trace_fraction;
			dis2 = dis1 * (center+1) / 2;
			self.angles_y = self.ideal_yaw = vectoyaw(view);
			makevectors(self.angles);

			local vector vec_forward = v_forward, vec_right = v_right;
		
			view = setvector(dis2, -16, 0);
			Ltarg = ProjectAim(self.origin + '0 0 24', view, vec_forward, vec_right);
			tracebox(self.origin, self.mins, self.maxs, Ltarg, FALSE, self);
			left = trace_fraction;

			view = setvector(dis2, 16, 0);
			Rtarg = ProjectAim(self.origin + '0 0 24', view, vec_forward, vec_right);
			tracebox(self.origin, self.mins, self.maxs, Rtarg, FALSE, self);
			right = trace_fraction;
		
			center = (dis1*center)/dis2;
			if (left >= center && left > right)
			{
				if (left < 1)
				{
					view = setvector(dis2 * left * 0.5, -16, 0);
					Ltarg = ProjectAim(self.origin, view, v_forward, v_right);
				}
				self.aiflags |= AI_PURSUE_TEMP;
				self.saved_goal = self.last_sighting;
				self.goalentity.origin = Ltarg;
				self.last_sighting = Ltarg;
				view = normalize(self.goalentity.origin - self.origin);
				self.angles_y = self.ideal_yaw = vectoyaw(view);
				dprint("turn left");
				dprint("\n");
				//line(self.origin, self.goalentity.origin);
			}
			else if (right >= center && right > left)
			{
				if (right < 1)
				{
					view = setvector(dis2 * right * 0.5, 16, 0);
					Rtarg = ProjectAim(self.origin, view, v_forward, v_right);
				}
				self.aiflags |= AI_PURSUE_TEMP;
				self.saved_goal = self.last_sighting;
				self.goalentity.origin = Rtarg;
				self.last_sighting = Rtarg;
				view = normalize(self.goalentity.origin - self.origin);
				self.angles_y = self.ideal_yaw = vectoyaw(view);
				dprint("turn right");
				dprint("\n");
				//line(self.origin, self.goalentity.origin);
			}
		}
		else
		{
			dprint("good path");
			dprint("\n");
			//line(self.origin, self.goalentity.origin);
		}
	}
		
// head straight in

	M_MoveToGoal (dist);		// done in C code...
	remove(tempgoal);
	self.goalentity = save;
}