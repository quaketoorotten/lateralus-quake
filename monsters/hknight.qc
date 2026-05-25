/*  Copyright (C) 1996-1997  Id Software, Inc.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    See file, 'COPYING', for details.
*/
/*
==============================================================================

SHAMBLER

==============================================================================
*/

vector shammissile_org [] =
{
	'17.60 -34.32 47.96', // frame 0

'24.46 -34.32 47.96', // frame 1

'31.94 -32.39 48.47', // frame 2

'38.80 -29.17 48.99', // frame 3

'45.66 -24.66 50.03', // frame 4

'50.65 -19.51 51.58', // frame 5

'55.01 -14.35 54.16', // frame 6

'57.51 -9.84 56.75', // frame 7

'58.13 -5.98 58.30', // frame 8

'56.88 -4.05 58.82', // frame 9

'55.01 -4.69 58.30', // frame 10

'53.14 -7.91 57.79', // frame 11

'50.65 -11.13 57.27', // frame 12

'48.15 -15.00 57.27', // frame 13

'44.41 -20.79 58.30', // frame 14

'40.05 -27.88 60.37', // frame 15

'32.57 -35.61 63.99', // frame 16

'23.21 -41.41 67.10', // frame 17

'13.23 -43.98 69.17', // frame 18

'3.26 -45.27 69.68', // frame 19

'-5.47 -43.98 70.20', // frame 20

'-12.33 -42.70 69.68', // frame 21

'-18.57 -40.76 70.20', // frame 22

'-24.18 -39.47 71.23', // frame 23

'-29.79 -38.19 73.30', // frame 24

'-35.40 -37.54 75.89', // frame 25

'-40.39 -36.90 78.99', // frame 26

'-46.00 -38.19 82.62', // frame 27

'-49.75 -40.76 87.27', // frame 28

'-50.37 -46.56 93.48', // frame 29

'-35.40 -59.44 113.13', // frame 30

'9.49 -64.60 128.65', // frame 31

'64.37 -42.05 114.69', // frame 32

'86.82 -9.84 84.68', // frame 33

'83.08 17.86 58.82', // frame 34

'60.00 42.98 43.82', // frame 35

'28.82 54.57 43.82', // frame 36

'3.26 53.28 54.16', // frame 37

'-11.08 44.91 66.58', // frame 38

'-17.32 35.89 75.37', // frame 39

'-18.57 29.45 77.96', // frame 40

'-17.32 26.23 76.41', // frame 41

'-15.45 24.30 71.75', // frame 42

'-11.08 23.65 66.58', // frame 43

'-6.10 22.36 61.92', // frame 44

'-1.11 21.72 59.34', // frame 45

'3.26 20.43 59.34', // frame 46

'6.38 19.79 60.89', // frame 47

'8.25 19.79 63.48', // frame 48

'9.49 19.79 66.06', // frame 49

'11.99 19.14 67.61', // frame 50

'15.11 18.50 67.61', // frame 51

'18.85 17.21 66.58', // frame 52

'22.59 15.28 65.03', // frame 53

'26.33 12.70 62.44', // frame 54

'28.82 9.48 59.34', // frame 55

'30.69 5.62 56.23', // frame 56

'31.94 1.11 53.13', // frame 57

'32.57 -3.40 51.58', // frame 58

'31.94 -7.91 50.03', // frame 59

'31.32 -12.42 49.51', // frame 60

'30.07 -16.93 48.99', // frame 61

'28.82 -20.79 48.99', // frame 62

'26.33 -24.66 49.51', // frame 63

'23.84 -28.52 50.03', // frame 64

'17.60 -24.01 68.13', // frame 65

'16.35 -22.73 69.68', // frame 66

'13.86 -22.08 70.72', // frame 67

'11.36 -22.08 71.75', // frame 68

'8.87 -23.37 72.27', // frame 69

'7.00 -25.95 73.30', // frame 70

'3.26 -30.46 75.37', // frame 71

'-4.23 -35.61 78.48', // frame 72

'-14.20 -39.47 82.62', // frame 73

'-24.80 -40.12 87.79', // frame 74

'-33.53 -36.90 91.41', // frame 75

'-38.52 -34.32 91.41', // frame 76

'-34.16 -38.83 81.58', // frame 77

'-18.57 -44.63 64.51', // frame 78

'3.88 -45.27 54.16', // frame 79

'36.93 -41.41 55.20', // frame 80

'76.22 9.48 65.03', // frame 81

'18.85 44.27 69.68', // frame 82

'-10.46 32.67 82.62', // frame 83

'-12.96 31.38 81.06', // frame 84

'-12.96 30.74 77.44', // frame 85

'-11.71 30.09 73.82', // frame 86

'-9.21 30.09 70.72', // frame 87

'-6.72 30.74 69.68', // frame 88

'-4.23 32.03 69.68', // frame 89

'-1.11 32.67 69.68', // frame 90

'1.39 33.32 69.68', // frame 91

'4.50 33.96 68.65', // frame 92

'7.62 33.32 66.58', // frame 93

'10.74 32.67 63.99', // frame 94

'14.48 31.38 61.41', // frame 95

'18.22 30.09 58.30', // frame 96

'22.59 27.52 55.20', // frame 97

'28.20 24.30 52.10', // frame 98

'33.81 19.14 50.03', // frame 99

'39.42 12.06 48.99', // frame 100

'43.79 3.68 48.99', // frame 101

'46.91 -4.69 51.06', // frame 102

'48.78 -13.06 54.16', // frame 103

'48.15 -20.79 57.79', // frame 104

'46.28 -27.24 61.92', // frame 105

'43.17 -32.39 65.03', // frame 106

'39.42 -35.61 67.61', // frame 107

'33.81 -38.19 69.17', // frame 108

'28.20 -39.47 70.20', // frame 109

'21.96 -38.83 70.72', // frame 110

'16.98 -36.90 71.23', // frame 111

'13.23 -34.97 71.23', // frame 112

'30.69 -28.52 54.68', // frame 113

'31.94 -25.95 54.68', // frame 114

'31.32 -24.01 53.65', // frame 115

'28.82 -22.73 52.61', // frame 116

'25.71 -22.08 52.10', // frame 117

'23.84 -23.37 52.61', // frame 118

'21.96 -24.66 54.16', // frame 119

'21.96 -27.88 56.75', // frame 120

'21.96 -31.74 62.44', // frame 121

'20.72 -36.25 70.20', // frame 122

'16.35 -42.05 78.48', // frame 123

'7.62 -47.85 84.68', // frame 124

'-4.85 -51.71 87.79', // frame 125

'-18.57 -52.36 86.75', // frame 126

'-31.04 -49.78 83.65', // frame 127

'-41.02 -43.98 79.51', // frame 128

'-48.50 -36.90 75.37', // frame 129

'-54.11 -31.74 73.30', // frame 130

'-61.59 -28.52 73.30', // frame 131

'-53.49 -47.20 93.48', // frame 132

'3.26 -76.84 122.45', // frame 133

'74.35 -45.27 118.31', // frame 134

'95.55 6.91 98.13', // frame 135

'87.44 27.52 77.44', // frame 136

'64.99 35.89 61.92', // frame 137

'41.30 33.96 63.48', // frame 138

'31.32 28.81 69.68', // frame 139

'29.45 26.87 71.23', // frame 140

'30.07 25.59 71.23', // frame 141

'33.19 24.30 70.20', // frame 142

'38.80 21.08 69.17', // frame 143

'45.04 14.63 69.17', // frame 144

'49.40 4.33 70.20', // frame 145

'51.27 -6.62 70.72', // frame 146

'49.40 -16.28 70.72', // frame 147

'46.28 -22.73 68.65', // frame 148

'42.54 -25.95 65.03', // frame 149

'38.80 -27.24 60.89', // frame 150

'35.06 -27.88 57.27', // frame 151

'30.69 -28.52 54.68', // frame 152

'31.94 -25.95 54.68', // frame 153

'31.32 -24.01 53.65', // frame 154

'28.82 -22.73 52.61', // frame 155

'25.71 -22.08 52.10', // frame 156

'23.84 -23.37 52.61', // frame 157

'21.96 -24.66 54.16', // frame 158

'21.96 -27.88 56.75', // frame 159

'21.96 -31.74 62.44', // frame 160

'20.72 -36.25 70.20', // frame 161

'16.35 -42.05 78.48', // frame 162

'7.62 -47.85 84.68', // frame 163

'-4.85 -51.71 87.79', // frame 164

'-18.57 -52.36 86.75', // frame 165

'-31.04 -49.78 83.65', // frame 166

'-41.02 -43.98 79.51', // frame 167

'-48.50 -36.90 75.37', // frame 168

'-54.11 -31.74 73.30', // frame 169

'-61.59 -28.52 73.30', // frame 170

'-53.49 -47.20 93.48', // frame 171

'3.26 -76.84 122.45', // frame 172

'74.35 -45.27 118.31', // frame 173

'95.55 6.91 98.13', // frame 174

'87.44 27.52 77.44', // frame 175

'64.99 35.89 61.92', // frame 176

'41.30 33.96 63.48', // frame 177

'31.32 28.81 69.68', // frame 178

'29.45 26.87 71.23', // frame 179

'30.07 25.59 71.23', // frame 180

'33.19 24.30 70.20', // frame 181

'38.80 21.08 69.17', // frame 182

'45.04 14.63 69.17', // frame 183

'49.40 4.33 70.20', // frame 184

'51.27 -6.62 70.72', // frame 185

'49.40 -16.28 70.72', // frame 186

'46.28 -22.73 68.65', // frame 187

'42.54 -25.95 65.03', // frame 188

'38.80 -27.24 60.89', // frame 189

'35.06 -27.88 57.27', // frame 190

'30.69 -28.52 54.68', // frame 191
};


/*
============
ShamCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() ShamCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
//	local float		chance;

	targ = self.enemy;
	makevectors(self.angles);
	vector offset = setvector (16, 0, self.view_ofs[2]);
	vector start = ProjectAim(self.origin, offset, v_forward, v_right);
	
// see if any entities are in the way of the shot
	spot1 = start;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_ent != targ)
		return FALSE;		// don't have a clear shot

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_ent != targ)
	{
		return FALSE;	// don't have a clear shot
	}

	if (enemy_range == RANGE_MELEE)
	{
		if (CanDamage (self.enemy, self))
		{
			self.attack_state = AS_MELEE;
			return TRUE;
		}
	}

	if (time < self.attack_finished)
		return FALSE;
	
	if (!enemy_vis)
		return FALSE;
		
// missile attack
	if (enemy_range == RANGE_FAR)
		return FALSE;
		
	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (1 + 2*random());
	return TRUE;
};

static float(float rad)	inShamRange =
{	
	if (self.aiflags & AI_SCRIPTED_ACTION)
		return FALSE;

	local entity targ = self.enemy;
	local vector spot1 = self.origin + self.view_ofs;
	local vector spot2 = targ.origin + targ.view_ofs;

	if (vlen(spot1 - spot2) <= rad)
		return TRUE;
	
	return FALSE;
};

void() sham_stand1 = [ 0, sham_stand2 ] {ai_stand();};
void() sham_stand2 = [ self.frame, sham_stand2 ] 
{ 
	self.frame ++;
	if (self.frame >= 119) 
	{	
		if(random () < 0.2)
			hk_idle ();

		sham_stand1 ();
		return;
	}
	ai_stand ();
};

void() sham_walk1 = [ 120, sham_walk2 ] {ai_walk(3);};
void() sham_walk2 = [ self.frame, sham_walk2 ] 
{ 	
	self.frame ++;
	if (self.frame == 132 || self.frame == 150)
		hk_step ();

	if (self.frame >= 156) 
	{
		if(random () < 0.2)
			hk_idle ();

		sham_walk1 ();
		return;
	}
	ai_walk (3);
};

void() sham_run1 = [ 120, sham_run2 ] {ai_run(3);};
void() sham_run2 = [ self.frame, sham_run2 ] 
{ 
	self.frame ++;
	if (self.frame == 132 || self.frame == 150)
		hk_step ();
	
	if (self.frame >= 156) 
	{
		if(random () < 0.2)
			hk_idle ();

		sham_run1 ();
		return;
	}
	ai_run (3);
};


void() sham_bite1 = [ 157, sham_bite2 ] {ai_face(); self.nextthink = time + 0.03;};
void() sham_bite2 = [ self.frame, sham_bite2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;

	if (self.frame == 172)
		ShamBite ();
	
	if (self.frame >= 196) 
	{
		sham_run1 ();
		return;
	}

	if (self.frame <= 175 && self.frame > 163)
		ai_charge (10);
	
	if (self.frame > 175)
		ai_charge (-2);
};

void() sham_swingr1 = [ 262, sham_swingr2 ] {ai_face(); self.nextthink = time + 0.03;};
void() sham_swingr2 = [ self.frame, sham_swingr2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;

	if (self.frame == 278)
		ShamClaw (0);
	
	if (self.frame >= 309) 
	{
		sham_run1 ();
		return;
	}

	if (self.frame < 292 && self.frame > 272)
	{
		walkmove (self.ideal_yaw -90, 0.75);
		ai_charge (4);
	}
};

void() sham_swingl1 = [ 310, sham_swingl2 ] {ai_face(); self.nextthink = time + 0.03;};
void() sham_swingl2 = [ self.frame, sham_swingl2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;

	if (self.frame == 326)
		ShamClaw (0);
	
	if (self.frame >= 348) 
	{
		sham_run1 ();
		return;
	}

	if (self.frame < 327)
		ai_face ();
};

void() sham_smash1 = [ 408, sham_smash2 ] {ai_face(); self.nextthink = time + 0.03;};
void() sham_smash2 = [ self.frame, sham_smash2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;

	if (self.frame == 432)
		ShamSmash();
	
	if (self.frame >= 455) 
	{
		sham_run1 ();
		return;
	}
	
	if ((self.frame > 424 && self.frame < 427))
		ai_charge (5);

	if (self.frame > 427 && self.frame < 444)
		ai_forward (3);

	if (self.frame > 444)
		ai_forward (-2);
};


void(float side) ShamClaw =
{
	vector delta;
	float ldmg;

	if (!self.enemy)
		return;

	if (!CanDamage(self.enemy, self))
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 125)
	{
		hk_melee ();
		return;
	}
	
	makevectors(self.angles);
	ldmg = 10 + (random() + random() + random()) * 15;
	T_Damage(self.enemy, self, self.origin + v_forward*16, self, ldmg, 40);
	hk_chomp();

	if (side)
	{
		makevectors(self.angles);
		SpawnMeatSpray(self.origin + v_forward*16, side * v_right);
	}
};

void() ShamBite =
{
	vector delta;
	float ldmg;

	if (!self.enemy)
		return;

	if (!CanDamage(self.enemy, self))
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;

	makevectors(self.angles);
	ldmg = 20 + (random() + random() + random()) * 15;
	T_Damage(self.enemy, self, self.origin + v_forward*16, self, ldmg, 40);
	hk_chomp();
};



void() ShamSmash =
{
	vector delta;
	float ldmg;

	makevectors(self.angles);
	hk_step2();
	GroundShake (self, 0.7, 0.2);
	pointparticles (particleeffectnum("TE_SHOCK_DUST"), self.origin + v_forward * 64, '0 0 0', 2);
	explosion_wave (self.origin + v_forward * 64);
	if (!CanDamage(self.enemy, self))
		return;

	if (!self.enemy)
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 185)
		return;

	ldmg = 40 + (random() + random() + random()) * 15;
	T_Damage(self.enemy, self, self.origin + v_forward*16, self, ldmg, 40);
	//hk_chomp();
};

void() sham_melee =
{
	float chance;
	
	//bprint(ftos(self.pissed), "\n");
	hk_combat ();
	self.pissed += 0.33;
	
	if(self.pissed > 2)
	{	
		self.pissed = 0;
		sham_smash1 ();
		return;
	}
		
	if(self.pissed > 1)	
	{
		sham_bite1();
		return;
	}
	
	chance = random();
	if (chance >= 0.5)
		sham_swingr1();
	else
		sham_swingl1();
};

void(float dmg) ShamFireBall =
{
	
	local	vector	dir, org, offset, target;
	local entity en = self.enemy;
		
//	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
	
	self.effects = self.effects | EF_MUZZLEFLASH;

	makevectors(self.angles);

	offset = setvector (16, 0, self.view_ofs[2]);
	org = ProjectAim(self.origin, offset, v_forward, v_right);
	
	target = (en.origin + en.velocity*0.2);
	dir = target - org;
	local float dist = vlen(dir), pitch;

//PGM
	if((dist > 512) && (dir[2] < 64) && (dir[2] > -64))
	{
		dir[2] += (dist - 512);
	}

	dir = normalize (dir);
	pitch = dir[2];
	if(pitch > 0.4)
	{
		pitch = 0.4;
	}
	else if(pitch < -0.5)
		pitch = -0.5;

	dir = v_forward;
	dir = dir + pitch * v_up;
//PGM	
	if (M_CalculatePitchToFire (target, org, dir, 700, 1.5, 0, 0))
		monster_FireGravityBall (org, dir, dmg, 1.5,(crandom() * 10),0, 700);
	else
		monster_FireGravityBall (org, dir, dmg, 1.5,(crandom() * 10), 180 + (crandom() * 10), 700);
};

void() sham_magic1 = [ 197, sham_magic2 ] { spawn_fireball2 (197, 0, 33); ai_face(); self.nextthink = time + 0.025;};
void() sham_magic2 = [ self.frame, sham_magic2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.025;
	
	if (self.frame < 230)
		ai_face();

	if (self.frame == 230)
		ShamFireBall (160);
	
	if (self.frame >= 261) 
	{	
		if (inShamRange (125))
		{
			sham_melee ();
			return;
		}
		SUB_CheckRefire (sham_magic1);

		sham_run1 ();
		return;
	}

	if (self.frame < 245 && self.frame > 215)
		ai_charge (4);
};


void() sham_turret1 = [ 349, sham_turret2 ] { spawn_fireball2 (349, 152, 174); ai_face(); self.nextthink = time + 0.03;};
void() sham_turret2 = [ self.frame, sham_turret2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.03;
	
	if (self.frame < 371)
		ai_face();
	
	if (self.frame == 371)
		ShamFireBall (90);
	
	if (self.frame >= 388) 
	{	
		if (inShamRange (125))
		{
			sham_melee ();
			return;
		}
			
		sham_run1 ();
		return;
	}
};

void() sham_missile =
{	
	if(random() <= 0.5 && inShamRange (180))
	{	
		if (self.pissed)
			self.pissed -= 0.6;
		
		sham_smash1 ();
		return;
	}

	if (!inShamRange (300))
		sham_magic1 ();
	else
		sham_turret1 ();

	hk_combat ();
};
	

//============================================================================


void() sham_pain1 = [ 389, sham_pain2 ] {ai_charge(-10); self.nextthink = time + 0.035;};
void() sham_pain2 = [ self.frame, sham_pain2 ] 
{ 
	self.frame ++;
	self.nextthink = time + 0.035;
	
	if (self.frame >= 404) 
	{
		sham_run1 ();
		return;
	}

	if (self.frame < 397)
		ai_charge (1);
};

void(entity attacker, float damage) sham_pain =
{	
	if (self.pain_finished > time)
		return;

	self.pain_finished = time + 3;
	
	hk_pain ();

	if (self.health <= 0)
		return; // allready dying, don't go into pain frame

	if (random()*400 > damage)
		return; // didn't flinch

	sham_pain1 ();
};


//============================================================================

void() sham_death =
{	
	if (self.health < -300)
	{	
		self.deadflag = DEAD_DEAD;
		self.solid = SOLID_NOT;
		self.think = sham_gib1;
		self.nextthink = time + 0.035;
		return;
	}
	
	if((self.deadflag & DEAD_DEAD))
		return;

	hk_die ();

	local vector tmpangle;
	local float tempskin;
	tmpangle = self.angles;
	tempskin = self.skin;
	
	if (random() <= 0.5)
	{
		self.think = sham_die1;
		setmodel(self, "progs/shamblerdeath.md3");
	}
	else
	{
		self.think = sham_dieb1;
		setmodel(self, "progs/shamblerdeath2.md3");
	}
		
	setsize(self, '-32 -32 0', '32 32 88');

	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_CORPSE;
	self.nextthink = time + 0.035;

	self.angles = tmpangle;
	//self.skin = tempskin;
};

void() sham_die1 = [ 0, sham_die2 ] { self.nextthink = time + 0.035;};
void() sham_die2 = [ self.frame, sham_die2 ] 
{ 	
	self.nextthink = time + 0.035;

	if (self.frame < 10)
		ai_move (-4);
	self.frame ++;
	if (self.frame == 24)
	{	
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

void() sham_dieb1 = [ 0, sham_dieb2 ] { self.nextthink = time + 0.035;};
void() sham_dieb2 = [ self.frame, sham_dieb2 ] 
{ 	
	self.nextthink = time + 0.035;

	if (self.frame < 10)
		ai_move (-4);
	self.frame ++;
	if (self.frame == 29)
	{
		self.maxs_z = 12;
		self.nextthink = -1;
		return;
	}
};

static void(float dm) Shamblergib =
{	
	sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);

	for(float i = 0; i < 2; i++)
		ThrowGib ("progs/pork1.mdl");

	for(float i = 0; i < 2; i++)
		ThrowGib ("progs/pork2.mdl");

	for(float i = 0; i < 2; i++)
		ThrowGib ("progs/pork3.mdl");

	for(float i = 0; i < 2; i++)
		ThrowGib ("progs/pork4.mdl");

	for(float i = 0; i < 1; i++)
		ThrowGib ("progs/shambler_torsogib.md3");

	ThrowHead2 ("progs/brain.mdl");
	pointparticles (particleeffectnum("TE_BLOODSPRAY"), self.origin + '0 0 24', '0 0 0', 8);
}

void() sham_gib1 = [ self.frame, sham_gib2 ] 
{MonsterGib (self.health); self.skin = 2; self.alpha = 1; self.nextthink = time + 0.02;};

void() sham_gib2 = [ self.frame, sham_gib2 ] 
{ 	
	self.nextthink = time + 0.02;
	self.alpha -= 0.02;
	if (self.alpha <= 0)
	{
		remove(self);
		return;
	}
};

//============================================================================

static void() hk_chomp =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/hellknight/chomp1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/hellknight/chomp2.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/hellknight/chomp3.wav", 1, ATTN_NORM);	
};

static void() hk_melee =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/revenant/melee1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/revenant/melee2.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/revenant/melee3.wav", 1, ATTN_NORM);	
};

static void() hk_idle =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/hellknight/hk_chatter_01.wav", 1, ATTN_IDLE);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/hellknight/hk_chatter_02.wav", 1, ATTN_IDLE);
	else
		    sound(self, CHAN_VOICE, "monsters/hellknight/hk_chatter_03.wav", 1, ATTN_IDLE);
};

static void() hk_combat =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/hellknight/ncc_01.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/hellknight/ncc_02.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/hellknight/ncc_03.wav", 1, ATTN_NORM);
};
static void() hk_die =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/hellknight/die1.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/hellknight/die2.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/hellknight/die3.wav", 1, ATTN_NORM);
};

static void() hk_sight =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_WEAPON, "monsters/hellknight/sight1_1.wav", 1, ATTN_NONE);
	else if (r == 1)
		    sound(self, CHAN_WEAPON, "monsters/hellknight/sight2_1.wav", 1, ATTN_NONE);
	else
		    sound(self, CHAN_WEAPON, "monsters/hellknight/sight3_1.wav", 1, ATTN_NONE);
};

static void() hk_pain =
{
	local float r = rint(random() * 2);	

	if (r == 2)
		    sound(self, CHAN_VOICE, "monsters/hellknight/hk_pain_01.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_VOICE, "monsters/hellknight/hk_pain_02.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_VOICE, "monsters/hellknight/hk_pain_03.wav", 1, ATTN_NORM);	
};

static void() hk_step =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_BODY, "monsters/hellknight/Hell_Knight_FS_03.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_BODY, "monsters/hellknight/Hell_Knight_FS_05.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_BODY, "monsters/hellknight/Hell_Knight_FS_03.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_BODY, "monsters/hellknight/Hell_Knight_FS_05.wav", 1,  ATTN_NORM);

	GroundShake (self, 0.4, 0.2);
};

static void() hk_step2 =
{
	local float r = rint(random() * 3);	

	if (r == 3)
		    sound(self, CHAN_BODY, "monsters/hellknight/step1.wav", 1, ATTN_NORM);
	else if (r == 2)
		    sound(self, CHAN_BODY, "monsters/hellknight/step2.wav", 1, ATTN_NORM);
	else if (r == 1)
		    sound(self, CHAN_BODY, "monsters/hellknight/step3.wav", 1, ATTN_NORM);
	else
		    sound(self, CHAN_BODY, "monsters/hellknight/step4.wav", 1,  ATTN_NORM);

//	GroundShake (self, 0.4, 0.2);
};

/*QUAKED monster_nazicultist (1 0 0) (-32 -32 -24) (32 32 64) Ambush
*/
void() monster_shambler_cache =
{
	precache_model("progs/shambler.md3");
	precache_model("progs/shamblerdeath.md3");
	precache_model("progs/shamblerdeath2.md3");

	precache_model("progs/bolt.mdl");

	precache_sound("monsters/revenant/melee1.wav");
	precache_sound("monsters/revenant/melee2.wav");
	precache_sound("monsters/revenant/melee3.wav");

	precache_sound("monsters/hellknight/ncc_01.wav");
	precache_sound("monsters/hellknight/ncc_02.wav");
	precache_sound("monsters/hellknight/ncc_03.wav");
	precache_sound("monsters/hellknight/hk_chatter_01.wav");
	precache_sound("monsters/hellknight/hk_chatter_02.wav");
	precache_sound("monsters/hellknight/hk_chatter_03.wav");

	precache_sound("monsters/hellknight/sight1_1.wav");
	precache_sound("monsters/hellknight/sight2_1.wav");
	precache_sound("monsters/hellknight/sight3_1.wav");

	precache_sound("monsters/hellknight/fb_create_02.wav");

	precache_sound("monsters/hellknight/chomp1.wav");
	precache_sound("monsters/hellknight/chomp2.wav");
	precache_sound("monsters/hellknight/chomp3.wav");

	precache_sound("monsters/hellknight/hk_pain_01.wav");
	precache_sound("monsters/hellknight/hk_pain_02.wav");
	precache_sound("monsters/hellknight/hk_pain_03.wav");

	precache_sound("monsters/hellknight/die1.wav");
	precache_sound("monsters/hellknight/die2.wav");
	precache_sound("monsters/hellknight/die3.wav");

	precache_sound("monsters/hellknight/Hell_Knight_FS_05.wav");
	precache_sound("monsters/hellknight/Hell_Knight_FS_03.wav");

	precache_sound("monsters/hellknight/step1.wav");
	precache_sound("monsters/hellknight/step2.wav");
	precache_sound("monsters/hellknight/step3.wav");
	precache_sound("monsters/hellknight/step4.wav");
};

void() monster_shambler =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	monster_shambler_cache ();
	monster_necromancer_cache ();
	monster_salamander_cache ();
	
	if (random() <= 0.3 && world.model != "maps/e1m3.bsp" && world.model != "maps/e1m5.bsp")
		spawn_medic ();
	else 
	{
		if (random () > 0.3)
			spawn_shambler ();
		else
			spawn_salamander ();
	}
};

void() monster_shambler2 =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	monster_shambler_cache ();
	spawn_shambler ();
};

static void() fireball2_update_pos =
{	
	if (self.arraynumfire + (self.owner.frame - self.startfire) >= self.endfire || self.owner.think == sham_pain1 || self.owner.think == sham_pain2
		|| self.owner.health <= 0)
	{
		remove(self);
		return;
	}

	vector f, r, u;
	AngleVectors(self.owner.angles, f, r, u);
	vector org = ProjectAim(self.owner.origin, shammissile_org[self.arraynumfire + (self.owner.frame - self.startfire)] * 0.84, f, -1*r);	

	self.origin = org;
	
	self.think = fireball2_update_pos;
	self.nextthink = time;
};

static void(float start, float arrnum, float end) spawn_fireball2 =
{
	local entity e;

	makevectors(self.angles);
	vector org = ProjectAim(self.origin, shammissile_org[arrnum + (self.frame - start)] * 0.84, v_forward, -1*v_right);	
	
	e = spawn ();
	setmodel (e, "progs/muzzleflash.spr");
	
	setsize (e, '0 0 0', '0 0 0');
	//
	setorigin (e, self.origin);
	e.origin = org;

	e.emiteffectnum = particleeffectnum ("TE_HK_FIREBALL");
	e.traileffectnum = particleeffectnum ("EF_NADETRAIL2");
	
	e.startfire = start;
	e.endfire = end - 3;
	e.arraynumfire = arrnum;

	e.owner = self;
	e.think = fireball2_update_pos;
	e.nextthink = time;
	//e.ltime = removeframe;
	
	sound(self, CHAN_WEAPON, "monsters/hellknight/fb_create_02.wav", 1, ATTN_NORM);	
};


void() spawn_shambler =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/shambler.md3");

	setsize(self, '-32 -32 0', '32 32 88');
	self.health = 1500;
	self.max_health = 1500;
	self.mass = 1000;
	self.scale = 0.85;

	if (world.worldtype == 2)
		self.skin = 1;

	self.th_stand = sham_stand1;
	self.th_walk = sham_walk1;
	self.th_run = sham_run1;
	self.th_die = sham_death;
	self.th_melee = sham_melee;
	self.th_missile = sham_missile;
	self.th_pain = sham_pain;
	self.th_checkatck = ShamCheckAttack;
	self.th_spawn = spawn_shambler;
	self.th_sight = hk_sight;
	self.deathtype = "was stomped on by a Hell knight";
	self.pissed = 0;
	
	walkmonster_start();
}