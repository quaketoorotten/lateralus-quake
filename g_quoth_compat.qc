//=======================================================
//	g_quoth_compat.qc
//	
//	SERECKY APR-21-26: The only good Doom3 styled maps for Quake
//	are built for Quoth... So this file is here to make sure that
//	all Quoth ents. have their own equivalents here...
//
//	credz to quoth devs...
//=======================================================

void() misc_plasmabox_l =
{
	precache_model ("maps/b_explob.bsp");
	precache_sound ("weapons/r_exp3.wav");
	misc_explobox();
};

void() misc_plasmabox_s =
{
	precache_model2 ("maps/b_exbox2.bsp");
	precache_sound ("weapons/r_exp3.wav");
	misc_explobox2();
};

void() ambient_thrum =
{
	precache_sound ("ambience/thrum.wav");
	ambientsound (self.origin, "ambience/thrum.wav", 1, 1);
};

void() ambient_generalpurpose = 
{
	precache_sound(self.noise);
	
	if (!self.volume)
		self.volume = 1;

	if (!self.speed)
		self.speed = ATTN_STATIC;
		
	if (self.speed == 0)
		self.speed = ATTN_NONE;

	ambientsound(self.origin, self.noise, self.volume, self.speed);
};

/* Hipnotic sound entities */

void() play_sound_use =
   {
   if (self.spawnflags & 1)
      {
      if (self.state == 0)
         {
         self.state = 1;
         sound (self, self.impulse, self.noise, self.volume, self.speed);
         }
      else
         {
         self.state = 0;
         sound (self, self.impulse, "misc/null.wav", self.volume, self.speed);
         }
      }
   else
      {
      sound (self, self.impulse, self.noise, self.volume, self.speed);
      }
   };

void() PlaySoundThink =
   {
   local float t;
   t = self.wait * random();
   if (t < self.delay)
      t = self.delay;
   self.nextthink = time + t;
   play_sound_use();
   };


void() play_sound_triggered =
   {
   precache_sound (self.noise);
   precache_sound ("misc/null.wav");
   if (self.volume == 0)
      self.volume = 1;
   if (self.speed == 0)
      self.speed = 1;
   if (self.speed == -1)
      self.speed = 0;
   if (self.spawnflags & 1)
      if (self.impulse == 0)
         self.impulse = 7;
   self.use = play_sound_use;
   };
   

// originally a flying blob  - now a caco
void() monster_polyp =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	monster_wizard_cache ();

	spawn_wizard();
};

// originally a deadlier flying robot  - now a caco
void() monster_sentinel =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	monster_wizard_cache ();

	spawn_wizard();
};

// originally a flying robot  - now a lost soul
void() monster_bob =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	precache_model2 ("progs/tarbaby.md3");

	precache_sound2 ("blob/death1.wav");
	precache_sound2 ("blob/hit1.wav");
	precache_sound2 ("blob/land1.wav");
	precache_sound2 ("blob/sight1.wav");
	particleeffectnum("TE_LOST_FLAME");
	particleeffectnum("TE_LOST_SMOKE");

	spawn_soul();
};

// originally a cyborg ogre - now the tentacle armed dude
void() monster_edie =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	monster_puncturer_cache ();

	spawn_puncturer ();

};

// grunt types

// originally a grunt w/ a rocket - now a revenant
void() monster_army_rocket =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	monster_hell_knight_cache ();

	spawn_death_knight ();
};

// originally a flamethrower dude - now an imp
void() monster_pyro =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	monster_ogre_cache ();

	spawn_imp ();
};

// originally a grenade-launcher dude - now a maggot
void() monster_defender =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	precache_model("progs/soldier.md3");
	precache_model("progs/soldiermf.mdl");
	precache_model("progs/soldierdeath.md3");
	precache_model("progs/gib1.mdl");
	precache_model("progs/gib2.mdl");
	precache_model("progs/gib3.mdl");

	zsec_precache_sfx ();
	precache_model2 ("progs/infantry.md3");
	precache_model2 ("progs/infantrydeath.md3");

	precache_model("progs/infantrymf.mdl");
	precache_model2 ("progs/h_mega.mdl");
	precache_model2 ("progs/laser.mdl");

	
	if (random() > 0.6)
		spawn_zsec1 ();
	else
		spawn_infantry();
};

// originally a grenade-launcher dude - now a fatass
void() monster_eliminator =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/soldier.md3");
	precache_model("progs/soldiermf.mdl");
	precache_model("progs/soldierdeath.md3");
	precache_model("progs/gib1.mdl");
	precache_model("progs/gib2.mdl");
	precache_model("progs/gib3.mdl");

	zsec_precache_sfx ();
	precache_model2 ("progs/infantry.md3");
	precache_model2 ("progs/infantrydeath.md3");

	precache_model("progs/infantrymf.mdl");
	precache_model2 ("progs/h_mega.mdl");
	precache_model2 ("progs/laser.mdl");

	
	if (random() > 0.6)
		spawn_zsec1 ();
	else
		spawn_infantry();
};

// originally a drole - now pinky
void() monster_drole =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	monster_demon1_cache ();	
	spawn_demon ();
};

// CORPSES


void() corpse_crucified1 = { misc_evilmeat1(); }; // [ENTITY]
void() corpse_crucified2 = { misc_evilmeat1(); }; // [ENTITY]
void() corpse_impaled_back1 = { misc_corpse(); }; // [ENTITY]
void() corpse_impaled_back2 = { misc_corpse(); }; // [ENTITY]
void() corpse_impaled_back3 = { misc_corpse(); }; // [ENTITY]