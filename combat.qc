
void() T_MissileTouch;
void() info_player_start;
void(entity targ, entity attacker) ClientObituary;

void() monster_death_use;

//============================================================================

/*
============
CanDamage

Returns true if the inflictor can directly damage the target.  Used for
explosions and melee attacks.
============
*/
float(entity targ, entity inflictor) CanDamage =
{
// bmodels need special checking because their origin is 0,0,0
	if (targ.movetype == MOVETYPE_PUSH)
	{
		traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), TRUE, self);
		if (trace_fraction == 1)
			return TRUE;
		if (trace_ent == targ)
			return TRUE;
		return FALSE;
	}
	
	traceline(inflictor.origin, targ.origin, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	return FALSE;
};


/*
============
Killed
============
*/
void(entity targ, entity attacker) Killed =
{
	local entity oself;

	oself = self;
	self = targ;
	
// why the fuck wasn't this only for the player before
	if (self.health < -99 && (self.flags & FL_CLIENT))
		self.health = -99;		// don't let sbar look bad if a player

	if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE)
	{	// doors, triggers, etc
		self.th_die ();
		self = oself;
		return;
	}
	
	if (attacker.flags & FL_MONSTER)
		self.enemy = attacker;

	if(attacker.classname == "monster_medic") // if medic killed fuck, no fucks give
		self.owner = attacker;
	
// bump the monster counter
	if ((self.flags & FL_MONSTER) )
	{	
		if(!(self.flags & FL_RESURRECTED) && !(self.deadflag & DEAD_DEAD))
		{
			killed_monsters = killed_monsters + 1;
			WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
		}
	}
	
	if (!(self.deadflag & DEAD_DYING) && (self.flags & FL_CLIENT))
		ClientObituary(self, attacker);
	self.touch = SUB_Null;
	
	if (!(self.deadflag & DEAD_DEAD) && (self.flags & FL_MONSTER))
		monster_death_use();

	self.th_die ();
	
	self = oself;
};

float(entity attacker) dontattackthese =
{	
	if (attacker.classname == "player")
		return TRUE;

	if (self.attack_state == AS_STRAIGHT && attacker.classname != "player") return FALSE; // don't retaliate while running
	if (random() < 0.3) return FALSE; // evil

	if (attacker.classname == "monster_tank") return FALSE; 
	if (attacker.classname == "monster_commander")  return FALSE; 
	if (attacker.classname == "monster_medic") return FALSE; 
	if (attacker.classname == "monster_jorg") return FALSE; 
	if (attacker.classname == "monster_makron") return FALSE; 
	if (attacker.classname == "monster_supertank") return FALSE; 
	if (attacker.classname == "monster_boss2") return FALSE; 

	 return TRUE; 
};

/*
============
T_Damage

The damage is coming from inflictor, but get mad at attacker
This should be the only function that ever reduces health.
============
*/
void(entity targ, entity inflictor, vector inflictor_org, entity attacker, float damage, float kick) T_Damage=
{
	local	entity	oldself;
	local	float	save;
	local	float	take;

	if (!targ.takedamage)
		return;

	if (targ.classname == "gib")
	{
		if(kick)
		{
			local vector dir2 = targ.origin - inflictor_org;
			dir2 = normalize(dir2);

			targ.velocity = targ.velocity + dir2* (500.0 * kick / 100 );

			if(targ.flags & FL_ONGROUND)
				targ.velocity_z = targ.velocity_z + vlen(dir2 * (500.0 * kick / 100 ) );

			targ.flags = targ.flags - (targ.flags & FL_ONGROUND);
		}

		return;
	}	

// used by buttons and triggers to set activator for target firing
	damage_attacker = attacker;

// check for quad damage powerup on the attacker
	if (attacker.super_damage_finished > time)
	{
		damage = damage * 4;
		kick = kick * 4;
	}

// save damage based on the target's armor level

	save = ceil(targ.armortype*damage);
	if (save >= targ.armorvalue)
	{
		save = targ.armorvalue;
		targ.armortype = 0;	// lost all armor
		targ.items = targ.items - (targ.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
	}
	
	targ.armorvalue = targ.armorvalue - save;
	take = ceil(damage-save);

// add to the damage total for clients, which will be sent as a single
// message at the end of the frame
// FIXME: remove after combining shotgun blasts?
	if (targ.flags & FL_CLIENT)
	{
		targ.dmg_take = targ.dmg_take + take;
		targ.dmg_save = targ.dmg_save + save;
		targ.dmg_inflictor = inflictor;
	}

	// figure momentum add
	if (targ.mass == 0)
		kick = 0;

	else if ((targ.movetype != MOVETYPE_PUSH) && (targ.movetype != MOVETYPE_NONE) && (targ.movetype != MOVETYPE_BOUNCE))
	{
		if(kick && (checkbottom(targ)) && !(targ.flags & FL_LEAP) )
		{
			local vector dir = targ.origin - inflictor_org;
			dir = normalize(dir);

			if ((targ.flags & FL_CLIENT) && attacker == targ)
				targ.velocity = targ.velocity + dir* (1600.0 * kick / targ.mass );	
			else
				targ.velocity = targ.velocity + dir* (500.0 * kick / targ.mass );

			if((targ.flags & FL_MONSTER))
			{
				targ.flags = targ.flags - (targ.flags & FL_ONGROUND);
				targ.velocity_z = targ.velocity_z + vlen(dir* (100.0 * kick / targ.mass ) );
			}
		}
	}	
// check for godmode or invincibility
	if (targ.flags & FL_GODMODE)
		return;
	if (targ.invincible_finished >= time)
	{
		if (self.invincible_sound < time)
		{
			sound (targ, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM);
			self.invincible_sound = time + 2;
		}
		return;
	}

// team play damage avoidance
	if ( (teamplay == 1) && (targ.team > 0)&&(targ.team == attacker.team) )
		return;
		
// do the damage
	if((targ.classname == attacker.classname) 
		&& (targ.flags & FL_MONSTER) && skill >= 1 
		&& attacker != targ ) // enemies of same type don't damage eachother
		take = 0;
	
	if(take > 0) 
	{			
		targ.health = targ.health - take;
			
		if (targ.health <= 0)
		{		
			Killed (targ, attacker);
			return;
		}
	}

// react to the damage
	oldself = self;
	self = targ;

	if ( (self.flags & FL_MONSTER) && !(self.flags & FL_MEDIC) && dontattackthese(attacker)
		&& ( (attacker.flags & FL_MONSTER) || attacker.classname == "player") )
	{
		if (self != attacker && attacker != self.enemy 
			 && ((self.flags & (FL_FLY|FL_SWIM)) == (attacker.flags & (FL_FLY|FL_SWIM)))
			&& (!(self.enemy.flags & FL_MONSTER))) // dont infight while already INFIGHTINg
		{
			if ( (self.classname != attacker.classname) )
			{
				if (self.enemy.classname == "player")
					self.oldenemy = self.enemy;

				self.enemy = attacker;
				FoundTarget (self);
			}
				
		}

	}

	if (self.th_pain && take > 0)
	{
		self.th_pain (attacker, take);
		// nightmare mode monsters don't make pain noises often	
		if (skill == 3)
			self.pain_finished = time + 4 + random()*2;
		else if (skill == 2)
			self.pain_finished = time + 4;
	}

	self = oldself;
};

/*
============
T_RadiusDamage
============
*/
void(entity inflictor, entity attacker, float damage, float damage_rad, entity ignore) T_RadiusDamage =
{
	local	float 	points;
	local	entity	head;
	local	vector	org;

	head = findradius(inflictor.origin, damage_rad);
	
	while (head)
	{
		if (head != ignore)
		{
			if (head.takedamage)
			{
				org = head.origin + (head.mins + head.maxs)*0.5;
				points = 0.5*vlen (inflictor.origin - org);
				if (points < 0)
					points = 0;
				points = damage - points;
				if (head == attacker)
					points = points * 0.5;
				if (points > 0)
				{
					if (CanDamage (head, inflictor))
					{	// shambler takes half damage from all explosions
						if (head.classname == "monster_nazicultist")						
							T_Damage (head, inflictor, inflictor.origin, attacker, points*0.5, points*0.2);
						else
							T_Damage (head, inflictor, inflictor.origin, attacker, points, points*0.7);
					}
				}
			}
		}
		head = head.chain;
	}
};
