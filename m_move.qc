/*
=============
SV_movestep 

Quake 2's version, i kept all of the comments while porting , no longer used

Called by monster program code.
The move will be adjusted for slopes and stairs, but if the move isn't
possible, no move is done, false is returned, and
pr_global_struct->trace_normal is set to the normal of the blocking wall
=============
*/
//FIXME since we need to test end position contents here, can we avoid doing
//it again later in catagorize position?

float (vector move, float relink) SV_movestep =
{
	float		dz;
	vector		oldorg, neworg, end;
	float			i;
	float		stepsize;
	vector		test;
	float			contents, fraction, allsolid, startsolid;

	vector	normal, endpos;

// try the move	
	oldorg = self.origin;
	neworg = self.origin + move;

// flying monsters don't step up
	if ( self.flags & (FL_SWIM | FL_FLY) )
	{
	// try one move with vertical motion, then one without
		for (i=0 ; i<2 ; i++)
		{
			neworg = self.origin + move;
			if (i == 0 && self.enemy)
			{
				if (!self.goalentity)
					self.goalentity = self.enemy;
				dz = self.origin[2] - self.goalentity.origin[2];
				if (self.goalentity.classname == "player")
				{
					if (dz > 40)
						neworg[2] -= 8;
					if (!((self.flags & FL_SWIM) && (self.waterlevel < 2)))
						if (dz < 30)
							neworg[2] += 8;
				}
				else
				{
					if (dz > 8)
						neworg[2] -= 8;
					else if (dz > 0)
						neworg[2] -= dz;
					else if (dz < -8)
						neworg[2] += 8;
					else
						neworg[2] += dz;
				}
			}
			//trace = gi.trace (self.s.origin, self.mins, self.maxs, neworg, ent, MASK_MONSTERSOLID);
			tracebox (self.origin, self.mins, self.maxs, neworg, FALSE, self);

			normal = trace_plane_normal; endpos = trace_endpos; fraction = trace_fraction;
			allsolid = trace_allsolid; startsolid = trace_startsolid;
	
			// fly monsters don't enter water voluntarily
			if (self.flags & FL_FLY)
			{
				if (!self.waterlevel)
				{
					test[0] = endpos[0];
					test[1] = endpos[1];
					test[2] = endpos[2] + self.mins[2] + 1;
					contents = pointcontents(test);
					if (contents == CONTENT_WATER)
						return FALSE;
				}
			}

			// swim monsters don't exit water voluntarily
			if (self.flags & FL_SWIM)
			{
				if (self.waterlevel < 2)
				{
					test[0] = endpos[0];
					test[1] = endpos[1];
					test[2] = endpos[2] + self.mins[2] + 1;
					contents = pointcontents(test);
					if (contents != CONTENT_WATER)
						return FALSE;
				}
			}

			if (fraction == 1)
			{
				self.origin = endpos;
				if (relink)
				{
					setorigin (self, self.origin);
					force_retouch = 2;
				}
				return TRUE;
			}
			
			if (!self.enemy)
				break;
		}
		
		return FALSE;
	}

// push down from a step height above the wished position
	//if (!(self.monsterinfo.aiflags & AI_NOSTEP))
		stepsize = 18;
	//else
	//	stepsize = 1;

	neworg[2] += stepsize;
	end = neworg;
	end[2] -= stepsize*2;

	//trace = gi.trace (neworg, self.mins, self.maxs, end, ent, MASK_MONSTERSOLID);
	tracebox (neworg, self.mins, self.maxs, end, FALSE, self);	

	normal = trace_plane_normal; endpos = trace_endpos; fraction = trace_fraction;
	allsolid = trace_allsolid; startsolid = trace_startsolid;

	if (allsolid)
		return FALSE;

	if (startsolid)
	{
		neworg[2] -= stepsize;
		//trace = gi.trace (neworg, self.mins, self.maxs, end, ent, MASK_MONSTERSOLID);

		tracebox (neworg, self.mins, self.maxs, end, FALSE, self);
		allsolid = trace_allsolid; startsolid = trace_startsolid;

		if (allsolid || startsolid)
			return FALSE;
	}


	// don't go in to water
	if (self.waterlevel == 0)
	{
		test[0] = endpos[0];
		test[1] = endpos[1];
		test[2] = endpos[2] + self.mins[2] + 1;	
		contents = pointcontents(test);

		if (contents == CONTENT_WATER)
			return FALSE;
	}

	if (fraction == 1)
	{
	// if monster had the ground pulled out, go ahead and fall
		if ( self.flags & FL_PARTIALGROUND )
		{
			self.origin += move;
			if (relink)
			{
				setorigin (self, self.origin);
				force_retouch = 2;
			}
			self.flags &= ~FL_ONGROUND;
			return TRUE;
		}
	
		return FALSE;		// walked off an edge
	}

// check point traces down for dangling corners
	self.origin = endpos;
	
	if (!checkbottom (self))
	{
		if ( self.flags & FL_PARTIALGROUND )
		{	// entity had floor mostly pulled out from underneath it
			// and is trying to correct
			if (relink)
			{
				setorigin (self, self.origin);
				force_retouch = 2;
			}
			return TRUE;
		}
		self.origin = oldorg;
		return FALSE;
	}

	if ( self.flags & FL_PARTIALGROUND )
	{
		self.flags &= ~FL_PARTIALGROUND;
	}
	self.flags |= FL_ONGROUND;

// the move is ok
	if (relink)
	{
		setorigin (self, self.origin);
		force_retouch = 2;
	}
	return TRUE;
};

/*
===============
TRUE_walkmove

quake 2's walkmove , no longer used
===============
*/
float (float yaw, float dist) TRUE_walkmove =
{
	vector	move;
	
	if (!(self.flags & FL_ONGROUND) && !(self.flags & (FL_FLY|FL_SWIM)))
		return FALSE;

	yaw = yaw*M_PI*2 / 360;
	
	move[0] = cos(yaw)*dist;
	move[1] = sin(yaw)*dist;
	move[2] = 0;

	return SV_movestep(move, TRUE);
}


//===================================

/*
ALKALINE*/ // used for BOSS monsters

//===================================

/*
======================
Bumpers

Fake collison, very heavy.

======================
*/
.entity nextbumper;

void() bumperThink = 
	{
	if (self.owner.nextbumper.classname != "bumper") {
		remove(self);
		return;
	}
	float wasonground = self.flags & FL_ONGROUND;
	vector neworigin;
	
	neworigin = self.owner.origin + self.view_ofs;

	if (wasonground && self.owner.flags & FL_ONGROUND) {
		neworigin_z = self.origin_z;
	}

	setorigin(self, neworigin);

	if (wasonground) {
		self.flags = self.flags | FL_ONGROUND;
		//droptofloor();
	}

	self.nextthink = time + 0.05;
};

void(vector ofs, float fly) SUB_AddBumper = {
	entity e, last;

	e = spawn();
	e.classname = "bumper";
	e.owner = self;
	e.movetype = MOVETYPE_STEP;
	//e.solid = SOLID_BBOX;
	e.flags = self.flags & (FL_FLY | FL_SWIM);
	if (fly) e.flags = e.flags | FL_FLY;
	e.view_ofs = ofs;
	e.think = bumperThink;
	e.nextthink = time + 0.05;

	setorigin(e, self.origin + ofs);

	last = self;

	while (last.nextbumper)
		last = last.nextbumper;

	last.nextbumper = e;
};

void() SUB_ClearBumpers = {
	entity e, eprev;

	e = self.nextbumper;

	while (e) {
		eprev = e;
		e = e.nextbumper;
		remove(eprev);
	}
	self.nextbumper = world;
};

/*
======================
StepDirection 

Turns to the movement direction, and walks the current distance if
facing it.

======================
*/
float(float yaw, float dist) M_walkmove = {

	if (!(self.nextbumper)) {

		self.oldorigin = self.origin;
		float ret;

		ret = walkmove(yaw, dist);// no longer uses q2's walkmove

		return ret;
		
	}

	entity oself, bp;
	float movefail;

		
	bp = self;

	while (bp) {
		bp.oldorigin = bp.origin;
		
		oself = self;
		self = bp;
		movefail = movefail | !walkmove(yaw, dist);// no longer uses q2's walkmove

		self = oself;
		
		bp = bp.nextbumper;
	}

	if (movefail) {
		bp = self;

		while (bp) {
			setorigin(bp, bp.oldorigin);
			bp = bp.nextbumper;
		}
		
		return FALSE;
	}
	return TRUE;
};

float(float yaw, float dist) SV_StepDirection = 
{
	local	float delta;

	self.ideal_yaw = yaw;
	ChangeYaw();

	delta = self.angles_y - self.ideal_yaw;

	if (delta > 45 && delta < 315) 
		// not turned far enough, so don't take the step
		return TRUE;
		
	if (M_walkmove(yaw, dist)) 
		return TRUE;
	
	return FALSE;
};

float DI_NODIR = -1;

void(entity enm, float dist) SV_NewChaseDir = 
{
	local float		deltax,deltay;
	local vector d;
	local float		tdir, olddir, turnaround;

	olddir = anglemod((self.ideal_yaw/45)*45);
	turnaround = anglemod(olddir - 180);

	deltax = enm.origin_x - self.origin_x;
	deltay = enm.origin_y - self.origin_y;

	if (deltax > 10)
		d_x = 0;
	else if (deltax < -10)
		d_x = 180;
	else
		d_x = DI_NODIR;

	if (deltay < -10)
		d_y = 270;
	else if (deltay > 10)
		d_y = 90;
	else
		d_y = DI_NODIR;

	// try direct route
	if (d_x != DI_NODIR && d_y != DI_NODIR) {
		if (d_x == 0)
			tdir = d_y == 90 ? 45 : 315;
		else
			tdir = d_y == 90 ? 135 : 215;

		if (tdir != turnaround && SV_StepDirection(tdir, dist))
			return;
	}

	// try other directions
	if (random() < 0.333 ||  fabs(deltay) > fabs(deltax)) {
		tdir = d_x;
		d_x = d_y;
		d_y = tdir;
	}

	if (d_x != DI_NODIR && d_x != turnaround && SV_StepDirection(d_x, dist))
		return;

	if (d_y != DI_NODIR && d_y != turnaround && SV_StepDirection(d_y, dist))
		return;

	/* there is no direct path to the player, so pick another direction */

	if (olddir != DI_NODIR && SV_StepDirection(olddir, dist))
		return;

	if (random() < 0.5) { /*randomly determine direction of search*/
		for (tdir = 0; tdir <= 315; tdir += 45)
			if (tdir != turnaround && SV_StepDirection(tdir, dist)) return;
	}
	else {
		for (tdir = 315 ; tdir >= 0 ; tdir -= 45)
			if (tdir != turnaround && SV_StepDirection(tdir, dist)) return;
	}

	if (turnaround != DI_NODIR && SV_StepDirection(turnaround, dist) )
		return;

	self.ideal_yaw = olddir;		// can't move

	// if a bridge was pulled out from underneath a monster, it may not have
	// a valid standing position at all

	if (!checkbottom(self))
		self.flags = self.flags | FL_PARTIALGROUND;

};

float(entity goal, float dist) SV_CloseEnough = 
{
	local float i;

	for (i = 0; i < 3; i++)
	{
		if (goal.absmin[i] > self.absmax[i] + dist)
			return FALSE;
		if (goal.absmax[i] < self.absmin[i] - dist)
			return FALSE;
	}
	return TRUE;
};

void(float dist) M_MoveToGoal = 
{
	local	entity		goal;

	goal = self.goalentity;

	if (!(self.flags & (FL_ONGROUND|FL_FLY|FL_SWIM)))
		return;

	// if the next step hits the enemy, return immediately
	if (self.enemy &&  SV_CloseEnough(self.enemy, dist)) // quake 1 used SV_CloseEnough(goal, dist)
		return;

	// bump around...
	if ((random() < 0.333) || !SV_StepDirection(self.ideal_yaw, dist)) {
		SV_NewChaseDir(goal, dist);
	}
};

