/*
==============================================================================

MEDIC

==============================================================================
*/

$cd id1/models/medic_c
$origin 0 0 24
$base base		
$skin base

//=============================================================================

string reinforcements[] = 
{
	"monster_knight",	// 0
	"monster_knight",		// 1
	"monster_spectre",		// 2
	"monster_spectre",		// 3
	"monster_wizard",			// 4
	"monster_wizard",			// 5
	"monster_ogre"	// 6
};

void() reinforcements2[] = 
{
	spawn_maggot,	// 0
	spawn_maggot,		// 1
	spawn_spectre,		// 2
	spawn_spectre,		// 3
	spawn_wizard,			// 4
	spawn_wizard,			// 5
	spawn_imp	// 6
};

vector reinforcement_mins[] = 
{
	'-16 -16 0', // 0
	'-32 -32 0', // 1
	'-32 -32 0', // 2
	'-16 -16 0', // 3
	'-16 -16 0', // 4
	'-32 -32 0', // 5
	'-32 -32 0' // 6
};

vector reinforcement_maxs[] = 
{		
	'16 16 64', // 0
	'32 32 88', // 1
	'32 32 88', // 2
	'16 16 64', // 3
	'16 16 64', // 4
	'32 32 88', // 5
	'32 32 88'  // 6
};

vector reinforcement_position[] = 
{
	'160 0 0',
	'80 160 0',
	'80 -160 0',
	'0 160 0',
	'0 -160 0'
};

vector RarchHand [] =
{

    '-5.58 -27.36 44.35', // frame 0 172


    '-5.09 -27.70 44.35', // frame 1


    '-2.60 -29.06 45.52', // frame 2


    '-0.12 -31.11 47.48', // frame 3


    '1.86 -33.15 50.23', // frame 4


    '3.35 -35.54 54.15', // frame 5


    '3.35 -37.92 58.07', // frame 6


    '2.86 -39.97 61.60', // frame 7


    '1.37 -42.02 64.35', // frame 8


    '0.87 -42.70 65.92', // frame 9


    '0.37 -43.04 66.31', // frame 10


    '-0.12 -43.38 67.09', // frame 11


    '-0.62 -43.38 67.49', // frame 12


    '-1.11 -43.72 67.49', // frame 13


    '-2.11 -44.06 67.88', // frame 14


    '-2.60 -44.06 67.88', // frame 15


    '-3.60 -44.40 67.88', // frame 16


    '-4.59 -44.40 67.88', // frame 17


    '-5.09 -44.40 67.49', // frame 18


    '-6.08 -44.74 67.49', // frame 19


    '-6.58 -44.74 67.49', // frame 20


    '-7.07 -44.74 67.09', // frame 21


    '-7.07 -44.74 67.09', // frame 22


    '-7.57 -44.74 67.09', // frame 23


    '-7.57 -44.40 67.49', // frame 24


    '-7.07 -44.40 67.49', // frame 25


    '-6.58 -44.40 67.49', // frame 26


    '-6.08 -44.06 67.88', // frame 27


    '-5.58 -43.72 67.88', // frame 28


    '-5.09 -43.72 68.27', // frame 29


    '-4.09 -43.38 68.27', // frame 30


    '-3.60 -43.04 68.66', // frame 31


    '-2.60 -42.70 68.66', // frame 32


    '-2.11 -42.70 68.66', // frame 33


    '-1.61 -42.36 68.66', // frame 34


    '-1.11 -42.02 68.27', // frame 35


    '-1.11 -41.67 67.49', // frame 36


    '-0.62 -41.33 67.09', // frame 37


    '-0.12 -41.33 65.92', // frame 38


    '0.37 -40.99 65.13', // frame 39


    '0.87 -40.65 63.96', // frame 40


    '1.86 -39.63 62.00', // frame 41


    '2.86 -38.27 59.25', // frame 42


    '3.35 -36.22 56.11', // frame 43


    '3.35 -34.17 52.19', // frame 44


    '1.86 -32.13 49.05', // frame 45


    '-0.12 -30.42 46.70', // frame 46 221


    '-3.10 -28.72 45.13', // frame 47  222


    '-5.09 -27.70 44.35', // frame 48


    '-5.58 -27.36 44.35', // frame 49


    '-5.58 -27.36 44.35', // frame 50


    '-1.61 -26.67 43.95', // frame 51


    '-2.60 -25.65 42.38', // frame 52


    '-3.10 -23.95 40.42', // frame 53


    '0.87 -21.90 40.42', // frame 54


    '18.25 -16.79 49.44', // frame 55


    '52.01 -13.04 54.94', // frame 56


    '71.86 -8.26 54.15', // frame 57


    '75.83 -8.26 54.54', // frame 58


    '78.81 -8.60 54.94', // frame 59


    '80.30 -8.60 54.94', // frame 60


    '81.30 -8.60 55.33', // frame 61


    '81.30 -8.60 55.33', // frame 62


    '80.30 -8.60 55.33', // frame 63


    '79.31 -8.60 55.72', // frame 64


    '77.32 -8.60 56.11', // frame 65


    '75.34 -8.26 56.50', // frame 66


    '73.35 -7.92 56.90', // frame 67


    '69.38 -8.26 56.50', // frame 68


    '62.43 -10.65 54.54', // frame 69


    '52.50 -14.74 51.80', // frame 70


    '40.59 -19.17 49.84', // frame 71


    '24.20 -24.29 47.88', // frame 72


    '4.35 -27.36 45.13', // frame 73 246


    '-5.58 -27.36 44.35', // frame 74 247


    '-5.58 -27.36 44.35', // frame 75


    '4.35 -29.06 41.99', // frame 76


    '17.25 -27.70 34.15', // frame 77


    '27.68 -23.95 25.52', // frame 78


    '32.64 -21.56 21.20', // frame 79


    '33.14 -21.56 21.20', // frame 80


    '32.64 -22.24 26.70', // frame 81


    '32.15 -21.90 39.25', // frame 82


    '28.67 -21.22 56.11', // frame 83


    '19.74 -21.56 73.37', // frame 84


    '-2.11 -24.29 88.27', // frame 85


    '-23.95 -25.99 91.80', // frame 86


    '-30.90 -27.01 91.02', // frame 87


    '-34.38 -27.70 89.84', // frame 88


    '-36.86 -28.04 88.67', // frame 89


    '-38.84 -28.38 87.49', // frame 90


    '-40.33 -28.72 86.31', // frame 91


    '-41.33 -29.06 85.53', // frame 92


    '-41.82 -29.06 85.14', // frame 93


    '-42.32 -29.06 85.14', // frame 94


    '-42.82 -29.06 85.14', // frame 95


    '-42.82 -29.06 85.53', // frame 96


    '-42.32 -28.72 85.92', // frame 97


    '-41.82 -28.72 86.71', // frame 98


    '-41.33 -28.38 87.10', // frame 99


    '-40.33 -28.04 87.88', // frame 100


    '-38.84 -27.70 88.67', // frame 101


    '-37.85 -27.70 89.45', // frame 102


    '-36.36 -27.36 89.84', // frame 103


    '-34.38 -27.36 90.24', // frame 104


    '-32.89 -27.01 90.24', // frame 105


    '-28.42 -27.36 91.02', // frame 106


    '-19.48 -27.70 92.20', // frame 107


    '-9.55 -28.72 92.20', // frame 108


    '-0.62 -30.08 90.63', // frame 109


    '5.84 -31.45 86.71', // frame 110


    '8.81 -32.13 78.47', // frame 111


    '8.32 -32.13 66.70', // frame 112


    '3.35 -30.42 54.54', // frame 113


    '-2.60 -28.38 46.70', // frame 114


    '-5.58 -27.36 44.35', // frame 115


    '-5.58 -27.36 44.35', // frame 116
};


vector LarchHand[] = {
	
    '9.81 23.10 35.72', // frame 0 172


    '10.30 23.44 36.11', // frame 1


    '12.29 24.47 38.07', // frame 2


    '14.28 26.17 41.60', // frame 3


    '15.76 28.56 46.70', // frame 4


    '15.76 30.94 52.58', // frame 5


    '14.28 33.33 58.07', // frame 6


    '12.29 35.04 62.39', // frame 7


    '10.30 36.40 65.13', // frame 8


    '9.31 37.08 66.70', // frame 9


    '9.31 37.08 67.09', // frame 10


    '8.81 37.42 67.88', // frame 11


    '8.81 37.76 68.27', // frame 12


    '8.32 37.76 68.66', // frame 13


    '8.81 37.76 68.66', // frame 14


    '8.81 37.76 69.06', // frame 15


    '9.31 37.76 69.06', // frame 16


    '9.31 37.76 69.06', // frame 17


    '9.81 37.76 68.66', // frame 18


    '10.30 37.76 68.66', // frame 19


    '10.30 37.42 68.66', // frame 20


    '10.80 37.42 68.66', // frame 21


    '10.80 37.42 68.66', // frame 22


    '10.80 37.76 68.66', // frame 23


    '10.80 37.76 68.66', // frame 24


    '10.80 38.10 68.66', // frame 25


    '10.30 38.10 69.06', // frame 26


    '9.81 38.44 69.45', // frame 27


    '9.81 38.79 69.45', // frame 28


    '9.31 39.13 69.84', // frame 29


    '8.81 39.47 69.84', // frame 30


    '8.32 39.47 69.84', // frame 31


    '8.32 39.81 69.84', // frame 32


    '7.82 39.81 69.84', // frame 33


    '7.82 39.81 69.45', // frame 34


    '8.32 39.81 69.06', // frame 35


    '8.32 39.81 68.66', // frame 36


    '8.32 39.81 67.88', // frame 37


    '8.81 39.47 67.09', // frame 38


    '8.81 39.47 66.31', // frame 39


    '9.31 39.13 65.13', // frame 40


    '10.30 38.44 63.56', // frame 41


    '12.29 37.08 60.82', // frame 42


    '14.28 35.04 56.50', // frame 43


    '15.76 32.31 51.01', // frame 44


    '15.76 29.58 45.52', // frame 45


    '14.28 26.85 40.82', // frame 46 221


    '12.29 24.81 37.68', // frame 47 222


    '10.30 23.78 36.11', // frame 48


    '9.81 23.10 35.72', // frame 49


    '8.81 21.06 36.50', // frame 50


    '9.81 21.06 35.72', // frame 51


    '6.83 23.10 34.15', // frame 52


    '3.35 24.13 32.97', // frame 53


    '4.84 22.76 34.54', // frame 54


    '21.72 4.01 50.23', // frame 55


    '53.00 3.33 60.43', // frame 56


    '72.36 7.76 60.03', // frame 57


    '76.33 7.76 60.43', // frame 58


    '79.31 8.10 60.82', // frame 59


    '81.30 8.10 61.21', // frame 60


    '81.79 8.10 61.21', // frame 61


    '81.79 8.10 61.60', // frame 62


    '80.80 8.10 61.60', // frame 63


    '79.31 8.44 62.00', // frame 64


    '77.32 8.44 62.00', // frame 65


    '74.84 8.44 62.39', // frame 66


    '72.36 8.44 62.78', // frame 67


    '68.39 8.44 61.60', // frame 68


    '61.93 7.76 58.07', // frame 69


    '53.49 6.74 53.37', // frame 70


    '44.56 5.72 48.66', // frame 71


    '31.15 8.44 43.17', // frame 72


    '16.26 16.28 37.68', // frame 73


    '8.81 21.06 36.50', // frame 74 246


    '8.81 21.06 36.50', // frame 75 247


    '9.31 21.40 32.97', // frame 76


    '13.28 23.44 29.05', // frame 77


    '19.24 26.51 26.70', // frame 78


    '24.70 27.88 24.34', // frame 79


    '29.17 27.53 23.56', // frame 80


    '32.15 25.83 24.73', // frame 81


    '34.63 22.76 29.05', // frame 82


    '35.62 19.35 37.29', // frame 83


    '32.15 17.65 48.27', // frame 84


    '21.72 21.06 63.17', // frame 85


    '1.86 26.85 80.43', // frame 86


    '-17.50 28.56 88.27', // frame 87


    '-26.93 29.92 89.84', // frame 88


    '-30.40 29.92 89.45', // frame 89


    '-32.89 29.58 89.06', // frame 90


    '-35.37 29.58 88.67', // frame 91


    '-36.86 29.58 88.27', // frame 92


    '-38.35 29.24 88.27', // frame 93


    '-38.84 29.24 88.27', // frame 94


    '-39.34 28.90 88.67', // frame 95


    '-39.34 28.90 89.06', // frame 96


    '-38.84 28.56 89.45', // frame 97


    '-38.35 28.56 90.24', // frame 98


    '-37.36 28.22 90.63', // frame 99


    '-35.87 27.88 91.41', // frame 100


    '-34.38 27.88 92.20', // frame 101


    '-32.39 27.53 92.59', // frame 102


    '-30.40 27.19 92.98', // frame 103


    '-28.42 26.85 92.98', // frame 104


    '-26.43 26.85 92.98', // frame 105


    '-21.97 26.17 93.37', // frame 106


    '-14.02 24.47 95.33', // frame 107


    '-5.09 21.74 96.51', // frame 108


    '3.85 19.35 96.12', // frame 109


    '11.30 18.33 93.37', // frame 110


    '16.76 19.01 85.14', // frame 111


    '20.23 21.40 69.84', // frame 112


    '16.76 21.40 51.01', // frame 113


    '11.30 20.72 40.03', // frame 114


    '8.81 21.06 36.50', // frame 115


    '8.81 21.06 36.50', // frame 116
};

void() medic_determine_spawn =
{
	local vector		f, r, offset, startpoint, spawnpoint, u;
	float	lucky;
	local float		summonStr;
	local float			count;
	local float			inc;
	local float			num_summoned; // should be 1, 3, or 5
	local float			num_success = 0;
	local float			find_result = 0;

	summonStr = 3;

	// bell curve - 0 = 67%, 1 = 93%, 2 = 99% -- too steep
	// this ends up with
	// -3 = 5%
	// -2 = 10%
	// -1 = 15%
	// 0  = 40%
	// +1 = 15%
	// +2 = 10%
	// +3 = 5%
	if (lucky < 0.05)
		summonStr -= 3;
	else if (lucky < 0.15)
		summonStr -= 2;
	else if (lucky < 0.3)
		summonStr -= 1;
	else if (lucky > 0.95)
		summonStr += 3;
	else if (lucky > 0.85)
		summonStr += 2;
	else if (lucky > 0.7)
		summonStr += 1;

	if (summonStr < 0)
		summonStr = 0;

	//FIXME - need to remember this, might as well use this int that isn't used for monsters
	self.pissed = summonStr;

	AngleVectors (self.angles, f, r, u);

// this yields either 1, 3, or 5
	if (summonStr)
		num_summoned = (summonStr - 1) + (summonStr % 2);
	else
		num_summoned = 1;

	for (count = 0; count < num_summoned; count++)
	{
		inc = count + (count%2); // 0, 2, 2, 4, 4
	
		offset = reinforcement_position[count];
		startpoint = ProjectAim (self.origin, offset, f, r);

		count ++;
		// a little off the ground
		startpoint[2] += 10;	

		spawnpoint = FindSpawnPoint (startpoint, reinforcement_mins[summonStr-inc], reinforcement_maxs[summonStr-inc], spawnpoint, 64);

		if (CheckGroundSpawnPoint(spawnpoint, 
			reinforcement_mins[summonStr-inc], reinforcement_maxs[summonStr-inc], 
			256, -1))
		{
			num_success++;
			// we found a spot, we're done here
			count = num_summoned;
		}		
	}

	if (num_success == 0)
	{	
		count = 0;
		for (count = 0; count < num_summoned; count ++)
		{	
			inc = count + (count%2); // 0, 2, 2, 4, 4
			offset = reinforcement_position[count];
			
			// check behind
			offset[0] *= -1.0;
			offset[1] *= -1.0;
			startpoint = ProjectAim (self.origin, offset, f, r);

			// a little off the ground
			startpoint[2] += 10;

			spawnpoint = FindSpawnPoint (startpoint, reinforcement_mins[summonStr-inc], reinforcement_maxs[summonStr-inc], spawnpoint, 64);

			if (CheckGroundSpawnPoint(spawnpoint, 
				reinforcement_mins[summonStr-inc], reinforcement_maxs[summonStr-inc], 
				256, -1))
			{
				num_success++;
				// we found a spot, we're done here
				count = num_summoned;
			}

			if (num_success)
			{
				//self->monsterinfo.aiflags |= AI_MANUAL_STEERING;
				self.ideal_yaw = anglemod(self.angles[1]) + 180;
				if (self.ideal_yaw > 360.0)
				self.ideal_yaw -= 360.0;
//				self.pissed *= -1;
			}
		}
	}
};

static void(vector o) SpawnPentagram =
{
	local entity e2 = spawn ();
	setorigin(e2, o);
	setmodel (e2, "progs/muzzleflash.spr");
	setsize (e2, '-32 -32 0', '32 32 88');
	
	SUB_KillBox (e2);	

	e2.solid = SOLID_NOT;
	e2.emiteffectnum = (particleeffectnum("TE_ARCHVILEFLAME"));
	//pointparticles (particleeffectnum("EF_SUMMONLIGHT"), o);
	e2.think = SUB_Remove;
	e2.nextthink = time + 0.8;
};	

void() medic_spawngrows  =
{
	vector	f, r, offset, startpoint, spawnpoint, u;
	local float		summonStr;
	local float		count;
	local float		inc;
	local float		num_summoned; // should be 1, 3, or 5
	local float		num_success = 0;
	local float		behind = FALSE;

	summonStr = self.pissed;

	AngleVectors (self.angles, f, r, u);

	if (summonStr)
		num_summoned = (summonStr - 1) + (summonStr % 2);
	else
		num_summoned = 1;

	for (count = 0; count < num_summoned; count ++)
	{
		inc = count + (count%2); // 0, 2, 2, 4, 4
		offset = reinforcement_position[count];
		startpoint = ProjectAim (self.origin, offset, f, r);

		// a little off the ground
		//startpoint[2] += 4;
		spawnpoint = FindSpawnPoint (startpoint, reinforcement_mins[summonStr-inc], reinforcement_maxs[summonStr-inc], spawnpoint, 64);

		if (CheckGroundSpawnPoint(spawnpoint, 
			reinforcement_mins[summonStr-inc], reinforcement_maxs[summonStr-inc], 
			256, -1))
		{
			num_success++;
			SpawnPentagram  (spawnpoint +' 0 0 10');		// normal size
			SpawnPentagram  (spawnpoint +' 0 0 10');	
		}
	}
};

.float goons;

void() medic_finish_spawn =
{
	local entity ent;
	local vector	f, r, offset, startpoint, spawnpoint, u;
	local float		summonStr;
	local float		count;
	local float		inc;
	local float		num_summoned; // should be 1, 3, or 5
	local float		behind = FALSE;

	//FIXME - better place to store this info?
	if (self.pissed < 0)
	{
		behind = TRUE;
		self.pissed *= -1;
	}
	summonStr = self.pissed;

	AngleVectors (self.angles, f, r, u);

	if (summonStr)
		num_summoned = (summonStr - 1) + (summonStr % 2);
	else
		num_summoned = 1;

	for (count  = 0; count < num_summoned; count ++)
	{	
		inc = count + (count%2); // 0, 2, 2, 4, 4
		offset = reinforcement_position[count];
		startpoint = ProjectAim (self.origin, offset, f, r);

		// a little off the ground
		startpoint[2] += 10;

		ent = world;
		
		spawnpoint = FindSpawnPoint (startpoint, reinforcement_mins[summonStr-inc], reinforcement_maxs[summonStr-inc], spawnpoint, 64);

		if (CheckSpawnPointQ2 (spawnpoint, reinforcement_mins[summonStr-inc], reinforcement_maxs[summonStr-inc]))
			ent = CreateGroundMonster (spawnpoint, self.angles,
				reinforcement_mins[summonStr-inc], reinforcement_maxs[summonStr-inc],
				reinforcements[summonStr-inc], reinforcements2[summonStr-inc], 256);

		if (ent == world)
			continue;

		SUB_KillBox (ent);

		self.goons ++;
		ent.goonmaster = self;
	
		if ((self.enemy) && (self.enemy.health > 0))
		{	
			ent.enemy = self.enemy;
		}
		else
		{
			ent.enemy = world;
		}

	}
};


//=============================================================================

/*
===========
MedicCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() MedicCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;

	targ = self.enemy; // i am a very smart dumbass

	// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_ent != targ)
		return FALSE;	// don't have a clear shot

	if (enemy_range == RANGE_MELEE)
	{	
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	
	if (!enemy_vis)
		return FALSE;

	if (time < self.attack_finished)
		return FALSE;
			
// missile attack
	
	if (enemy_range == RANGE_FAR)
		return FALSE;
	else if (enemy_range == RANGE_MELEE)
		chance = 0.9;
	else if (enemy_range == RANGE_CLOSE)
		chance = 0.6;
	else if (enemy_range == RANGE_NEAR)
		chance = 0.3;
	else if (enemy_range == RANGE_MID)
		chance = 1.5;
	else
		chance = 0;

	if (random () < chance)
	{
		self.attack_state = AS_MISSILE;
		SUB_AttackFinished (1 + random()*2);
		return TRUE;
	}

	return FALSE;
};

void(entity e) checkOccupation =
{	
	SUB_KillBox (e); // telefrag whatever is standing over it

	entity oself = self;
	self = e;

	if(!M_walkmove(0,0) && self.health > 0) // if in wall or something is standing at its location
	{
		T_Damage (self, self, self.origin, self, 99999, 0);
	}

	self = oself;
}; 

void() FlameTouch =
{	
	if (!other.takedamage)
		return;
	if (other == self.owner)
		return;
	if (other != self.enemy)
		return;
	if (other.dmgtime > time)
		return;

	T_Damage (other, self, self.origin, self, self.dmg, 0);
	other.dmgtime = time + 0.08;
};

void() _FlameTouch =
{	
	//T_Damage (other, self, self.origin, self.owner, self.dmg, 15);
	if (other.solid != SOLID_BSP)
		return;
	
	pointparticles (particleeffectnum("TE_BURNT"), self.origin);
	self.touch = FlameTouch;
};

void() _FlameTouch2 =
{	
	FlameTouch ();
	
//	pointparticles (particleeffectnum("TE_BURNT"), self.origin);
//	self.touch = FlameTouch;
};

void(vector org, float damage, vector min, vector max, float timer) SpawnFlame =
{
	local entity e;
	
	e = spawn();
	setorigin(e, org);
	e.origin[2] -= 16;

	setmodel (e, "progs/muzzleflash.spr");
	setsize (e, min, max);
	e.solid = SOLID_TRIGGER;
	e.movetype = MOVETYPE_FLY;
//	e.traileffectnum = (particleeffectnum("TE_ARCHVILEFLAME2"));
	e.emiteffectnum = (particleeffectnum("TE_ARCHVILEFLAME"));
	e.touch = _FlameTouch2 ;
	e.enemy = self.enemy;
	e.owner = self;
	e.deathtype = "fire";
	e.nextthink = time + timer;
	
	vector org2 = e.origin;
	org[2] = e.origin[2];
	pointparticles (particleeffectnum("TE_BURNT"), org2);
	e.think = SUB_Remove;
	e.dmg = damage;

	medic_fire(e);
};

void(vector org, float damage, vector min, vector max, float timer) SpawnFlameWall =
{
	local entity e2, e;
	
	e = spawn();
	setorigin(e, org);
	e.origin[2] = self.origin[2];

	setmodel (e, "progs/muzzleflash.spr");
	setsize (e, min, max);
	e.solid = SOLID_TRIGGER;
	e.movetype = MOVETYPE_TOSS;
	e.emiteffectnum = (particleeffectnum("TE_ARCHVILEFLAME"));
	e.traileffectnum = (particleeffectnum("EF_ARCHVILEFLAME_LIGHT"));
	e2 = spawn();
	setorigin(e2, org);
	e2.origin[2] = self.origin[2];

	setmodel (e2, "progs/muzzleflash.spr");
	setsize (e2, min, max);
	e2.solid = SOLID_NOT;
	e2.movetype = MOVETYPE_NONE;
	e2.emiteffectnum = (particleeffectnum("TE_ARCHVILEFLAME"));
	e2.nextthink = time + timer;
	e2.think = SUB_Remove;

	e.touch = _FlameTouch ;
	e.enemy = self.enemy;
	e.owner = self;
	e.deathtype = "fire";
	e.nextthink = time + timer;
	e.think = SUB_Remove;
	e.dmg = damage;

	medic_fire(e);
};

void() FlameWall =
{
	SpawnFlameWall (self.origin, 12, '-16 -16 0', '16 16 64', 0.35);
	remove(self);
};

void(float num, vector org) FlameSpot =
{
	entity e;
	e = spawn();
	e.origin = org;
	e.angles = self.angles;
	e.think = FlameWall;
	e.enemy = self.enemy;
	e.nextthink = time + num;
};

static void() ogre_miss =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/imp/melee/miss_01.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/imp/melee/miss_02.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/imp/melee/miss_03.wav", 1, ATTN_NORM);
};

void() medic_Melee =
{
	float ldmg;
	vector delta;

	delta = self.enemy.origin - self.origin;

	ogre_miss ();

	if (vlen(delta) > 100)
		return;
	if (!CanDamage(self.enemy, self))
		return;

	//pinky_hit ();
	ldmg = 32 + 5*random();
	T_Damage(self.enemy, self, self.origin + v_forward*16, self, ldmg, 15);

	makevectors(self.angles);
	SpawnMeatSpray(self.origin + v_forward*16, 8 * v_right);
};


//=============================================================================

void() medic_stand1 = [ 0, medic_stand2 ] { ai_stand();};
void() medic_stand2 = [ self.frame, medic_stand2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 73) 
	{	
		if (random() < 0.2)
			medic_idle ();
		medic_stand1 ();
		return;
	}
	ai_stand ();
};

void() medic_walk1 = [ 144, medic_walk2 ] { ai_walk(4);};
void() medic_walk2 = [ self.frame, medic_walk2 ] 
{ 
	self.frame ++;
	if (self.frame >= 171) 
	{	
		if (random() < 0.2)
			medic_idle ();

		medic_walk1 ();
		return;
	}
	ai_walk (4);
};

void() medic_run1 = [ 144, medic_run2 ] { ai_run(4);};
void() medic_run2 = [ self.frame, medic_run2 ] 
{ 
	self.frame ++;
	if (self.frame >= 171) 
	{
		if (random() < 0.2)
			medic_idle ();

		medic_run1 ();
		return;
	}
	ai_run (4);
};

void() medic_run6	=[	107,		medic_run1	] {ai_run(35); };


void() medic_meleea1 = [ 74, medic_meleea2 ] {self.nextthink = time + 0.03;};
void() medic_meleea2 = [ self.frame, medic_meleea2 ] 
{ 
	self.frame ++;

	if (self.frame == 85)
		medic_Melee ();	

	if (self.frame < 82)
		ai_face ();
	else if (self.frame < 85)
		ai_charge (5);
	else if (self.frame > 85 && self.frame < 88)
		ai_charge (12);
	else if (self.frame > 88)
		ai_charge (-1);

	if (self.frame >= 107) 
	{
		//if (random() < 0.2)
		//	pinky_idle ();
		
		medic_run1 ();
		return;
	}
	self.nextthink = time + 0.03;
};

void() medic_meleeb1 = [ 109, medic_meleeb2 ] {self.nextthink = time + 0.03;};
void() medic_meleeb2 = [ self.frame, medic_meleeb2 ] 
{ 
	self.frame ++;

	if (self.frame == 122)
		medic_Melee ();	

	if (self.frame < 116)
		ai_face ();
	else if (self.frame < 122)
		ai_charge (12);
	else if (self.frame > 122 && self.frame < 131)
		ai_charge (-1);
	else if (self.frame > 131 && self.frame < 139)
		ai_charge (1.5);

	if (self.frame >= 143) 
	{
		//if (random() < 0.2)
		//	pinky_idle ();
		
		medic_run1 ();
		return;
	}
	self.nextthink = time + 0.03;
};

void() archvile_flameRHAND_org = 
{		
	if (self.arraynumfire + (self.owner.frame - self.startfire)  >= self.endfire || self.owner.think == medic_pain1 || self.owner.think == medic_pain2
		|| self.owner.health <= 0)
	{
		remove(self);
		return;
	}

	vector org;
		
	vector f, r, u;
	AngleVectors(self.owner.angles, f, r, u);

	//bprint (ftos(47 + (self.owner.frame - 222)), "\n");
	org = ProjectAim(self.owner.origin, RarchHand[self.arraynumfire + (self.owner.frame - self.startfire)] * 0.84, f, -1*r);

	self.origin = org;
	self.think = archvile_flameRHAND_org;
	self.nextthink = time ;
};

void() archvile_flameLHAND_org = 
{		
	if (self.arraynumfire + (self.owner.frame - self.startfire) >= self.endfire || self.owner.think == medic_pain1 || self.owner.think == medic_pain2
		|| self.owner.health <= 0)
	{
		remove(self);
		return;
	}

	vector org;
		
	vector f, r, u;
	AngleVectors(self.owner.angles, f, r, u);

	//bprint (ftos(self.arraynumfire + (self.owner.frame - self.startfire)), "\n");
	org = ProjectAim(self.owner.origin, LarchHand[self.arraynumfire + (self.owner.frame - self.startfire)] * 0.84, f, -1*r);

	self.origin = org;
	self.think = archvile_flameLHAND_org;
	self.nextthink = time ;
};

.float startfire;
.float endfire;
.float arraynumfire;

void(float start, float arraynum, float end) archvile_flameLHAND = 
{	
	vector org;
		
	entity e = spawn();	

	makevectors(self.angles);
	org = ProjectAim(self.origin, LarchHand[arraynum + (self.frame - start)] * 0.84, v_forward, -1*v_right);	
	
	e.origin = org;
	e.startfire = start;
	e.endfire = end - 3;
	e.arraynumfire = arraynum;
	e.owner = self;
	setmodel (e, "progs/muzzleflash.spr");
	setsize (e, VEC_ORIGIN, VEC_ORIGIN);
	e.emiteffectnum = (particleeffectnum("TE_ARCHVILEFLAME_HAND"));
	e.traileffectnum = (particleeffectnum("EF_ARCHVILEFLAME_HAND_LIGHT"));

	e.think = archvile_flameLHAND_org;
	e.nextthink = time;
};


void(float start, float arraynum, float end) archvile_flameRHAND = 
{	
	vector org;
		
	entity e = spawn();	

	makevectors(self.angles);
	org = ProjectAim(self.origin, RarchHand[arraynum + (self.frame - start)] * 0.84, v_forward, -1*v_right);	
	
	e.origin = org;
	e.startfire = start;
	e.endfire = end - 3;
	e.arraynumfire = arraynum;
	e.owner = self;
	setmodel (e, "progs/muzzleflash.spr");
	setsize (e, VEC_ORIGIN, VEC_ORIGIN);
	e.emiteffectnum = (particleeffectnum("TE_ARCHVILEFLAME_HAND"));
	e.traileffectnum = (particleeffectnum("EF_ARCHVILEFLAME_HAND_LIGHT"));
	e.think = archvile_flameRHAND_org;
	e.nextthink = time;
};

void() medic_summon1 = [ 172, medic_summon2 ]
 {
	archvile_flameRHAND (172, 0, 46);
	archvile_flameLHAND (172, 0, 46);  self.nextthink = time + 0.03;};
void() medic_summon2 = [ self.frame, medic_summon2 ] 
{ 
	self.frame ++;
	
	if (self.frame == 181)
	{	
		sound(self, CHAN_WEAPON, "monsters/archvile/resurrection.wav", 1, ATTN_NORM);
		medic_determine_spawn ();
		medic_spawngrows ();
	}

	if (self.frame == 182)
		medic_finish_spawn ();	

	if (self.frame >= 221) 
	{
		//if (random() < 0.2)
		//	pinky_idle ();
		
		self.flags &= ~FL_MEDIC;
		medic_run1 ();
		return;
	}
	self.nextthink = time + 0.03;
};

static void() SetTargetOnFire =
{		
	vector f,r,u;
	vector ang = self.enemy.angles;
	if(self.enemy.flags & FL_CLIENT)
		ang = self.enemy.v_angle;
	
	AngleVectors(ang,f,r,u);
		if (visible(self.enemy))
			SpawnFlame (self.enemy.origin - self.enemy.velocity * 0.16 + f * 32, 24, '-16 -16 0', '16 16 64', 0.6);
}

void() medic_burna1 = [ 247, medic_burna2 ] 
{ 	
	archvile_flameRHAND (247, 74, 116);
	archvile_flameLHAND (247, 74, 116); 
	ai_face (); 
	self.nextthink = time + 0.035;
};
void() medic_burna2 = [ self.frame, medic_burna2 ] 
{ 
	self.frame ++;
	ai_face ();
	
	if (self.frame >= 266 && self.frame < 275)
	{		
		SetTargetOnFire();
	}

	if (self.frame >= 288) 
	{
		//if (random() < 0.2)
		//	pinky_idle ();

		medic_run1 ();
		return;
	}
	self.nextthink = time + 0.035;
};
 // 47 -> 73

void() medic_wallofflame =
{	
	traceline (self.origin, self.enemy.origin, TRUE, self); // see thru mons
	float n = vlen(self.origin - trace_endpos);
	n = ceil(n / 32);

	//bprint(ftos(n),"\n");

	local vector f, r, u;
	float num = 64;
	float timer = 0.001;
	
	AngleVectors(self.angles, f, r, u);
	
	for (float i = 0; i < n; i++)
	{	
		//num = 64;
	//	timer =
		FlameSpot (timer, self.origin + f * num);
		num = num + 32;
		timer += 0.03;
	}
};		

void() medic_burnb1 = [ 222, medic_burnb2 ] 
{ 
	archvile_flameLHAND (222, 47, 73); 
	archvile_flameRHAND (222, 47, 73); 
	ai_face (); 
	self.nextthink = time + 0.035;
};
void() medic_burnb2 = [ self.frame, medic_burnb2 ] 
{ 
	self.frame ++;

	if (self.frame < 232 )
	{
		//self.pos1 = self.enemy.origin;
		ai_face ();
	}
	if (self.frame == 233)
	{
		medic_wallofflame();
	}
	
	if (self.frame >= 246) 
	{
		//if (random() < 0.2)
		//	pinky_idle ();

		medic_run1 ();
		return;
	}
	self.nextthink = time + 0.035;
};

void() medic_attack = 
{	
//	bprint (ftos(vlen(self.enemy.origin - self.origin)), "\n");
//	if ((self.goons >= 0 || random() > 0.4))

	if ((self.goons >= self.maxgoons || random() > 0.6 || vlen(self.enemy.origin - self.origin) < 160) && self.goons > 0)
//	if ((self.goons >= 0 || random() > 0.4))
	{	
		if ( random() > 0.5 && fabs(self.origin_z - self.enemy.origin_z) < 30)
			medic_burnb1 ();
		else
			medic_burna1 ();
			
		medic_sight ();
		return;
	}
	
	sound(self, CHAN_VOICE, "monsters/archvile/cin_sight.wav", 1, ATTN_NORM);
	self.flags |= FL_MEDIC;
	medic_summon1();

	SUB_AttackFinished (1 + 2*random());
};

void() medic_melee = 
{	
	if (random() < 0.5)
		medic_meleea1();
	else
		medic_meleeb1();
};

void() medic_pain1 = [ 288, medic_pain2 ] {self.nextthink = time + 0.03;};
void() medic_pain2 = [ self.frame, medic_pain2 ] 
{ 	
	self.frame ++;
	if (self.frame >= 302) 
	{	
		//if (random() < 0.2)
		//	pinky_idle ();
		medic_run1 ();
		return;
	}
	self.nextthink = time + 0.03;
};

float halfamedic = 150;

void(entity attacker, float damage)	medic_pain =
{
	local float	r;
	r = random();
		
	if (self.flags & FL_MEDIC) 
		return;

	// don't make multiple pain sounds right after each other
	if (self.pain_finished > time)
		return;

	if (self.flags & FL_DODGED)
		return;
	if (skill == 3)
		return;	
	self.pain_finished = time + 3;	
	
	arch_pain();
	medic_pain1();	
};

void() medic_die =
{	
	if (self.health < -600)
	{	
		self.deadflag = DEAD_DEAD;
		self.solid = SOLID_NOT;
		self.think = medic_gib1;
		self.nextthink = time + 0.035;
		return;
	}
	
	if((self.deadflag & DEAD_DEAD))
		return;

	local vector tmpangle;
	local float tempskin;
	tmpangle = self.angles;
	tempskin = self.skin;

	medic_death ();
	
	setmodel(self, "progs/necromancerdie.md3");
	setsize(self, '-32 -32 0', '32 32 88');

	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_CORPSE;
	self.think = medic_die1;
	self.nextthink = time + 0.035;

	self.angles = tmpangle;
	//self.skin = tempskin;
};

void() medic_die1 = [ 0, medic_die2 ] { self.nextthink = time + 0.035;};
void() medic_die2 = [ self.frame, medic_die2 ] 
{ 	
	self.nextthink = time + 0.035;

	self.frame ++;
	if (self.frame < 8)
		ai_move (-4);
	
	if (self.frame == 20)
	{	
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() medic_gib1 = [ self.frame, medic_gib2 ] 
{MonsterGib (self.health); self.skin = 1; self.alpha = 1; self.nextthink = time + 0.02;};

void() medic_gib2 = [ self.frame, medic_gib2 ] 
{ 	
	self.nextthink = time + 0.02;
	self.alpha -= 0.02;
	if (self.alpha <= 0)
	{
		remove(self);
		return;
	}
};

/*QUAKED monster_medic (1 0 0) (-32 -32 -24) (32 32 64) Ambush

*/
void() spawn_medic;

static void() medic_sight =
{
	local float r = rint(random() * 5);	

	if (r == 5)
		    sound(self, CHAN_VOICE, "monsters/archvile/sight2_1.wav", 1, ATTN_NORM);
	else if (r == 4)
		    sound(self, CHAN_VOICE, "monsters/archvile/sight2_2.wav", 1, ATTN_NORM);
	else if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/archvile/sight2_3.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/archvile/sight11.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/archvile/sight12.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/archvile/sight13.wav", 1, ATTN_NORM);
};

static void(entity en) medic_fire =
{
	local float r = rint(random() * 4);	

	if (r == 4)
		    sound(en, CHAN_VOICE, "monsters/archvile/fire_01.wav", 0.6, ATTN_IDLE);
	else if (r == 3)
		    sound(en, CHAN_VOICE, "monsters/archvile/fire_02.wav", 0.6, ATTN_IDLE);
	else if (r == 2)
		    sound(en, CHAN_VOICE, "monsters/archvile/fire_03.wav", 0.6, ATTN_IDLE);
	else if (r == 1)
		    sound(en, CHAN_VOICE, "monsters/archvile/fire_04.wav", 0.6, ATTN_IDLE);
	else
		    sound(en, CHAN_VOICE, "monsters/archvile/fire_05.wav", 0.6, ATTN_IDLE);
};

static void() medic_idle =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/archvile/breath1.wav", 1, ATTN_IDLE);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/archvile/breath2.wav", 1, ATTN_IDLE);
	else
		    sound(self, CHAN_VOICE, "monsters/archvile/breath3.wav", 1, ATTN_IDLE);
};

static void() medic_death =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/archvile/die1.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/archvile/die2.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/archvile/die3.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/archvile/die4.wav", 1, ATTN_NORM);
};

static void() arch_pain =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_VOICE, "monsters/archvile/pain1.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/archvile/pain2.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/archvile/pain3.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/archvile/pain4.wav", 1, ATTN_NORM);
};



void() monster_necromancer_cache =
{
	precache_model ("progs/necromancer.md3");
	precache_model ("progs/necromancerdie.md3");

	precache_sound ("monsters/archvile/sight2_1.wav");
	precache_sound ("monsters/archvile/sight2_2.wav");
	precache_sound ("monsters/archvile/sight2_3.wav");
	precache_sound ("monsters/archvile/sight11.wav");
	precache_sound ("monsters/archvile/sight12.wav");
	precache_sound ("monsters/archvile/sight13.wav");

	precache_sound ("monsters/archvile/pain1.wav");
	precache_sound ("monsters/archvile/pain2.wav");
	precache_sound ("monsters/archvile/pain3.wav");
	precache_sound ("monsters/archvile/pain4.wav");

	precache_sound ("monsters/archvile/die1.wav");
	precache_sound ("monsters/archvile/die2.wav");
	precache_sound ("monsters/archvile/die3.wav");
	precache_sound ("monsters/archvile/die4.wav");

	precache_sound ("monsters/archvile/breath1.wav");
	precache_sound ("monsters/archvile/breath2.wav");
	precache_sound ("monsters/archvile/breath3.wav");

	precache_sound ("monsters/archvile/resurrection.wav");
	precache_sound ("monsters/archvile/cin_sight.wav");

	precache_sound("monsters/imp/melee/miss_01.wav");
	precache_sound("monsters/imp/melee/miss_02.wav");
	precache_sound("monsters/imp/melee/miss_03.wav");

	precache_sound ("monsters/archvile/fire_01.wav");
	precache_sound ("monsters/archvile/fire_02.wav");
	precache_sound ("monsters/archvile/fire_03.wav");
	precache_sound ("monsters/archvile/fire_04.wav");
	precache_sound ("monsters/archvile/fire_05.wav");

	monster_ogre_cache ();
	monster_knight_cache ();
	monster_spectre_cache ();
	monster_wizard_cache ();
}

void() monster_medic =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	monster_necromancer_cache ();

	spawn_medic();
};

.float maxgoons;

void() spawn_medic =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/necromancer.md3");
	
	setsize (self, '-32 -32 0', '32 32 88');
	self.health = 900;
	self.max_health = 900; // it was too mean
	self.mass = 400;
	self.skin = 0;
	self.scale = 0.87;

	self.th_stand = medic_stand1;
	self.th_walk = medic_walk1;
	self.th_run = medic_run1;
	self.th_die = medic_die;
	//self.th_dodge = medic_duck;
	self.th_missile = medic_attack;
	self.th_pain = medic_pain;
	self.th_spawn = spawn_medic;
	self.th_checkatck = MedicCheckAttack;
	self.th_melee = medic_melee;
	self.th_sight = medic_sight;
	self.pissed = 0;
	self.deathtype = "turned into charcoal";
	
	if (skill == 0)
		self.maxgoons = 1;
	if (skill == 1)
		self.maxgoons = 3;
	if (skill == 2)
		self.maxgoons = 3;
	if (skill == 3)
		self.maxgoons = 5;

	walkmonster_start();
};
