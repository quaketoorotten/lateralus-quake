//	This file implements NQ, QW, and N64-style huds in csqc. Its meant to be complete, while not otherwise being that different.
//	The hud layout+items used are specific to vanilla Quake. For the mission packs, you should use the appropriate alternative huds.
//	
//	The entry points are at the bottom of the file.
//	You can just add this file (and fteextensions.qc or qsextensions.qc) into any mod and then just adapt it as desired.
//
//	Note that it doesn't understand viewsizes all that well, but no worse than eg scr_sbaralpha<1 in QS (its default). (this keeps the api spec simpler.)
//	the 'simple csqc' api means that this file (and api defs) is all you need for a hud, and can be directly embedded into a regular nq progs.dat, if needed.
//
//	I have made attempts to avoid copying the engine code, however I will not be held liable if there's any GPL contagion.
//	There is otherwise no license for the code in this file.


/*autocvars:
	cl_sbar: alternative layouts (sorry for this complication, but mneh).
		0: QuakeWorld style hud
		1: Vanilla style hud
		2: n64-style hud
		3: n64-style with meshes instead of models, where supported.
	cl_hudswap: QW/n64 ammo+weapons are on the
		0: right
		1: left
	scr_sbaralpha: opacity of backgroundy elements
*/

// items. FIXME: you should share these with your ssqc...
float	IT_AXE				= 1<<12;
float	IT_SHOTGUN				= 1<<0;
float	IT_SUPER_SHOTGUN			= 1<<1;
float	IT_NAILGUN				= 1<<2;
float	IT_SUPER_NAILGUN			= 1<<3;
float	IT_GRENADE_LAUNCHER		= 1<<4;
float	IT_ROCKET_LAUNCHER		= 1<<5;
float	IT_LIGHTNING			= 1<<6;
float	IT_BFG				= 1<<7;
float	IT_CHAINSAW				= 1<<8;
float	IT_DOUBLEBARREL			= 1<<9;

float	IT_ARMOR1				= 1<<13;
float	IT_ARMOR2				= 1<<14;
float	IT_ARMOR3				= 1<<15;
//float	IT_SUPERHEALTH			= 1<<16;

float	IT_KEY1					= 1<<17;
float	IT_KEY2					= 1<<18;
float	IT_INVISIBILITY			= 1<<19;
float	IT_INVULNERABILITY		= 1<<20;
float	IT_SUIT					= 1<<21;
float	IT_QUAD					= 1<<22;

float IT2_RUNE1					= 1<<5;
float IT2_RUNE2					= 1<<6;
float IT2_RUNE3					= 1<<7;
float IT2_RUNE4					= 1<<8;


//wad image names in array form, for easier access.
static string number[10] = {
	"gfx/num_0",
	"gfx/num_1",
	"gfx/num_2",
	"gfx/num_3",
	"gfx/num_4",
	"gfx/num_5",
	"gfx/num_6",
	"gfx/num_7",
	"gfx/num_8",
	"gfx/num_9"
};

static string hudnumber[10] = {
	"gfx/hud_n0",
	"gfx/hud_n1",
	"gfx/hud_n2",
	"gfx/hud_n3",
	"gfx/hud_n4",
	"gfx/hud_n5",
	"gfx/hud_n6",
	"gfx/hud_n7",
	"gfx/hud_n8",
	"gfx/hud_n9"
};
static string anumber[10] = {
	"gfx/anum_0",
	"gfx/anum_1",
	"gfx/anum_2",
	"gfx/anum_3",
	"gfx/anum_4",
	"gfx/anum_5",
	"gfx/anum_6",
	"gfx/anum_7",
	"gfx/anum_8",
	"gfx/anum_9"
};
static string weaponnames[] = {
	"shotgun",
	"sshotgun",
	"nailgun",
	"snailgun",
	"rlaunch",
	"srlaunch",
	"lightng",
#define WEAPONICONS 7
#define LIGHTNING_WIDTH 48
};
static string facetab[] = {
	"gfx/face5", "gfx/face4", "gfx/face3", "gfx/face2", "gfx/face1",
	"gfx/face_p5", "gfx/face_p4", "gfx/face_p3", "gfx/face_p2", "gfx/face_p1",
	"gfx/face_inv2", "gfx/face_quad", "gfx/face_invis", "gfx/face_invul2"
};



//copies of stats, for easier access
static float sitems;		//copy of .items
static float sitems2;		//copy of .items2 (or serverflags)
static float sweapon;		//copy of .weapon
static float shealth;		//copy of .health

//Note: these are not tracked for splitscreen, which limits them to one player. We're lazy and just don't update them.
static float flashtime[WEAPONICONS];	//tracks the time that various items were obtained, so we can flash stuff accordingly.
static float painfinishtime;//tracks when we took damage, for flinching.


//registers the various pics so they're ready as needed.
static void() Hud_Init
{
	float i;
	precache_pic("gfx/sbar", TRUE);
	precache_pic("gfx/ibar", TRUE);
	for (i = 0; i < 10; i++)
	{
		precache_pic(number[i], TRUE);
		precache_pic(anumber[i], TRUE);
	}

	precache_pic("gfx/sb_armor1", TRUE);
	precache_pic("gfx/sb_armor2", TRUE);
	precache_pic("gfx/sb_armor3", TRUE);
	precache_pic("gfx/disc", TRUE);

	precache_pic("gfx/sb_shells", TRUE);
	precache_pic("gfx/sb_nails", TRUE);
	precache_pic("gfx/sb_rocket", TRUE);
	precache_pic("gfx/sb_cells", TRUE);

	precache_pic("gfx/sb_key1", TRUE);
	precache_pic("gfx/sb_key2", TRUE);
	precache_pic("gfx/sb_invis", TRUE);
	precache_pic("gfx/sb_invuln", TRUE);
	precache_pic("gfx/sb_suit", TRUE);
	precache_pic("gfx/sb_quad", TRUE);
	
	precache_pic("gfx/sb_sigil1", TRUE);
	precache_pic("gfx/sb_sigil2", TRUE);
	precache_pic("gfx/sb_sigil3", TRUE);
	precache_pic("gfx/sb_sigil4", TRUE);

	for (i = 0; i < weaponnames.length; i++)
	{
		precache_pic(strcat("gfx/inv_", weaponnames[i]), TRUE);
		precache_pic(strcat("gfx/inv2_", weaponnames[i]), TRUE);
		precache_pic(strcat("gfx/inva1_", weaponnames[i]), TRUE);
		precache_pic(strcat("gfx/inva2_", weaponnames[i]), TRUE);
		precache_pic(strcat("gfx/inva3_", weaponnames[i]), TRUE);
		precache_pic(strcat("gfx/inva4_", weaponnames[i]), TRUE);
		precache_pic(strcat("gfx/inva5_", weaponnames[i]), TRUE);
	}
	for (i = 0; i < facetab.length; i++)
		precache_pic(facetab[i], TRUE);
};

static void(vector pos, float value, float threshhold) Hud_DrawLargeValue =
{
	float c;
	float len;
	string s;
	if (value < 0)
		value = 0;	//hrm
	if (value>999)
		value = 999;

	s = ftos(floor(value));
	len = strlen(s);

	pos_x += 24 * (3-len);
	

	if (value <= threshhold)
	{	//use alternate (red) numbers

		while(len>0)
		{
			len--;
			c = str2chr(s, len);

			drawpic(pos+len * '24 0 0', anumber[c-'0'], '24 24 0', '1 1 1', 1, 0);
		}
	}
	else
	{	//use normal numbers

		while(len>0)
		{
			len--;
			c = str2chr(s, len);

			drawpic(pos+len * '24 0 0', number[c-'0'], '24 24 0', '1 1 1', 1, 0);
		}
	}
};

static void(vector pos, float value, float threshhold) Hud2_DrawLargeValue =
{
	float c;
	float len;
	string s;
	if (value < 0)
		value = 0;	//hrm
	if (value>999)
		value = 999;

	s = ftos(floor(value));
	len = strlen(s);

	pos_x += 10 * (4-len);
	
	//use normal numbers

		while(len>0)
		{
			len--;
			c = str2chr(s, len);

			drawpic(pos+len * '14 0 0', hudnumber[c-'0'], '12 12 0', '1 1 1', 1, 0);
		}
};

static void(float type, vector pos, float drawback) Hud_DrawAmmoCount =
{
	string s;
	float value;
	float len;
	float c;
	value = getstatf(STAT_SHELLS+type);
	if (value < 0)
		value = 0;	//hrm
	if (value>999)
		value = 999;

	s = ftos(floor(value));
	len = strlen(s);

	pos_x += 5 * (3-len);
	while(len>0)
	{
		len--;
		c = str2chr(s, len);
		drawcharacter(pos+len * '5 0 0', (18-'0') + c, '8 8 0', '1 1 1', 1, 0);
	}
};

static void(float num, vector pos) Hud_DrawWeapon =
{
	string prefix;
	float flash = (time - flashtime[num])*10;
	if (flash >= 10)
	{
		if (sweapon == (1<<num))
			prefix = "gfx/inv2_";
		else
			prefix = "gfx/inv_";
	}
	else
	{
		static string tab[] = {"gfx/inva1_","gfx/inva2_","gfx/inva3_","gfx/inva4_","gfx/inva5_"};
		if (flash >= 5)
			flash -= 5;
		prefix = tab[flash];
	}

	drawpic(pos, strcat(prefix, weaponnames[num]), '24 16 0', '1 1 1', 1, 0);
};
static void(float num, float lflashtime, float iscurrent, vector pos, float drawwidth, float imgwidth) Hud_DrawWeaponEx =
{
	string prefix;
	float flash = (time - lflashtime)*10;
	if (flash >= 10)
	{
		if (iscurrent)
			prefix = "gfx/inv2_";
		else
			prefix = "gfx/inv_";
	}
	else
	{
		static string tab[] = {"gfx/inva1_","gfx/inva2_","gfx/inva3_","gfx/inva4_","gfx/inva5_"};
		if (flash >= 5)
			flash -= 5;
		prefix = tab[flash];
	}
	drawsubpic(pos, [drawwidth, 16], strcat(prefix, weaponnames[num]), '0 0 0', [drawwidth/imgwidth, 1], '1 1 1', 1, 0);
};

static string(float f, float chars, string lead) FormatFloat
{
	string s = ftos(f);
	if (f < 10 && chars >= 3)
		s = strcat(lead, lead, s);
	else if (f < 10 && chars == 2)
		s = strcat(lead, s);
	else if (f < 100 && chars >= 3)
		s = strcat(lead, s);
	return s;
};

static void(vector pos) Hud_CoopScores_SBar =
{
	string s;
	float nsecs;
	float nmins;
	vector sbar = pos;
	drawpic(sbar, "gfx/scorebar", '320 24 0', '1 1 1', autocvar(scr_sbaralpha, 0.75), 0);

	s = strcat("Monsters:", FormatFloat(getstatf(STAT_KILLEDMONSTERS), 3, " "), "/", FormatFloat(getstatf(STAT_TOTALMONSTERS), 3, " "));
	drawstring(sbar + '8 4', s, '8 8 0', '1 1 1', 1, 0);
	s = strcat("Secrets :", FormatFloat(getstatf(STAT_FOUNDSECRETS), 3, " "), "/", FormatFloat(getstatf(STAT_TOTALSECRETS), 3, " "));
	drawstring(sbar + '8 12', s, '8 8 0', '1 1 1', 1, 0);

	nmins = floor(time/60);
	nsecs = floor(time - nmins*60);
	s = strcat("Time :", FormatFloat(nmins, 3, " "), ":", FormatFloat(nsecs, 2, "0"));
	drawstring(sbar + '184 4', s, '8 8 0', '1 1 1', 1, 0);

	drawstring(sbar + '232 12' - strlen(world.message)*'4 0', world.message, '8 8 0', '1 1 1', 1, 0);
};

static void Hud_PicOrModel(vector topleft, string pic, string showmodel, float showskin, float speed)
{
	vector sz = '24 24';
#ifdef DP_QC_RENDER_SCENE	//requires fteextensions.qc instead of qsextensions.qc
	if (autocvar(cl_sbar, 1) >= 3)
	if (checkextension("DP_QC_RENDER_SCENE"))
	{
		//reset view props and wipe entity lists
		clearscene();

		//set up the various view details, set up the renderer to be a little larger than the intended size... it avoids harsh cuts.
		setviewprop(VF_MIN, topleft - sz);
		setviewprop(VF_SIZE, sz * 3);
		setviewprop(VF_DRAWENGINESBAR, FALSE);
		setviewprop(VF_DRAWCROSSHAIR, FALSE);
		setviewprop(VF_DRAWWORLD, FALSE);
		setviewprop(VF_AFOV, 30);	//a small fov reduces perspective distortions without making it look like its isometric.
		setviewprop(VF_ANGLES, '15 0 0');	//angle downwards slightly
		makevectors('15 0 0');
		setviewprop(VF_ORIGIN, v_forward*-256);	//and move the camera away so that we can position the model at the center without needing to worry about the tilt.

		//spawn a (reusable) entity for our scene
		static entity hudpicent;
		if (!hudpicent)
			hudpicent = spawn();
		precache_model(showmodel);
		setmodel(hudpicent, showmodel);
		hudpicent.angles_y = cltime*speed;
		hudpicent.skin = showskin;
		makevectors(hudpicent.angles);
		//make sure its centered
		vector org = (hudpicent.maxs+hudpicent.mins)*0.5;
		setorigin(hudpicent, - v_forward*org_x + v_right*org_y - v_up*org_z);
		//and now copy it into the scene
		addentity(hudpicent);

		//and ask the engine to actually draw that single-entity scene. Think of this as a drawpic call.
		renderscene();

		return;
	}
#endif
	drawpic(topleft, pic, '24 24 0', '1 1 1', 1, 0);
};

static void Hud_DrawFace(vector pos)
{
	string face;
	if (sitems & IT_INVISIBILITY)
	{	//invis can go first, because its the most obvious image difference.
		if (sitems & IT_INVULNERABILITY)
			face = facetab[10];	//special double-powerup image!
		else
			face = facetab[12];
	}
	else if (sitems & IT_QUAD)
		face = facetab[11];
	else if (sitems & IT_INVULNERABILITY)
		face = facetab[13];
	else
	{
		float frame = shealth/20;
		if (frame < 0)
			frame = 0;
		else if (frame > 4)
			frame = 4;
		if (painfinishtime > time)
			frame += 5;	//pain.
		face = facetab[frame];
	}
	
	if (shealth > 100)
		drawpic(pos +' -2 -6 0', face, '24 24 0', '1 1 1', 1, 0);
	else if (shealth > 50)
		drawpic(pos+' -2 -6 0', face, '24 24 0', '1 1 1', 1, 0);
	else
		drawpic(pos+' -2 -6 0', face, '24 24 0', '1 1 1', 1, 0);
};


static void Hud_DrawSBar(vector pos, vector virtsize)
{	
	if (autocvar(cl_sbar, 1))
		drawpic(pos + '0 -24 0', "gfx/sbar1", '321 48 0', '1 1 1', autocvar(scr_sbaralpha, 0.75), 0);
	
//	Hud_DrawAmmoCount(0, pos + '294 -6', FALSE);
//	Hud_DrawAmmoCount(1, pos + '294 0', FALSE);
//	Hud_DrawAmmoCount(2, pos + '294 6', FALSE);
//	Hud_DrawAmmoCount(3, pos + '294 12', FALSE);

	if (sweapon == IT_DOUBLEBARREL)		Hud2_DrawLargeValue(pos+'254 -1 0', getstatf(STAT_SHELLS), -1);
	if (sweapon == IT_AXE)				Hud2_DrawLargeValue(pos+'248 -1 0', 0, -1);
	if (sweapon == IT_SHOTGUN)			Hud2_DrawLargeValue(pos+'254 -1 0', getstatf(STAT_SHELLS), -1);
	if (sweapon == IT_SUPER_SHOTGUN)		Hud2_DrawLargeValue(pos+'254 -1 0', getstatf(STAT_SHELLS), -1);
	if (sweapon == IT_NAILGUN)			Hud2_DrawLargeValue(pos+'254 -1 0', getstatf(STAT_NAILS), -1);
	if (sweapon == IT_SUPER_NAILGUN)		Hud2_DrawLargeValue(pos+'254 -1 0', getstatf(STAT_NAILS), -1);
	if (sweapon == IT_GRENADE_LAUNCHER)		Hud2_DrawLargeValue(pos+'252 -1 0', getstatf(STAT_ROCKETS), -1);
	if (sweapon == IT_ROCKET_LAUNCHER)		Hud2_DrawLargeValue(pos+'254 -1 0', getstatf(STAT_CELLS), -1);
	if (sweapon == IT_LIGHTNING)			Hud2_DrawLargeValue(pos+'252 -1 0', getstatf(STAT_ROCKETS), -1);
	if (sweapon == IT_CHAINSAW)			Hud2_DrawLargeValue(pos+'248 -1 0', 0, -1);
	if (sweapon == IT_BFG)				Hud2_DrawLargeValue(pos+'254 -1 0', getstatf(STAT_CELLS), -1);
		
	if (sitems & IT_INVULNERABILITY)
	{
		//drawpic(pos, "gfx/disc", '24 24 0', '1 1 1', 1, 0);
		Hud2_DrawLargeValue(pos+'180 -1 0', 999, -1);
	}
	else
	{
		Hud2_DrawLargeValue(pos+'180 -1 0', getstatf(STAT_ARMOR), -1);
	}
	//getstatf(STAT_ARMOR)

	Hud_DrawFace(pos+'150 0 0');
	Hud2_DrawLargeValue(pos+'48 -1 0', shealth, -1);
	
	if (getstatf(STAT_AMMO) > 99)
		Hud2_DrawLargeValue(pos+'-3 -1 0', getstatf(STAT_AMMO), -1);
	else if (getstatf(STAT_AMMO) > 9)
		Hud2_DrawLargeValue(pos+'-5 -1 0', getstatf(STAT_AMMO), -1);
	else
		Hud2_DrawLargeValue(pos+'-5 -1 0', getstatf(STAT_AMMO), -1);
	
	if (sitems & IT_KEY1)
		drawpic(pos+'236 -9 0', "gfx/sb_key1", '16 16 0', '1 1 1', 1, 0);
	if (sitems & IT_KEY2)
		drawpic(pos+'236 1 0', "gfx/sb_key2", '16 16 0', '1 1 1', 1, 0);
};

static void Hud_DrawIBar(vector pos, vector br)
{
	
	//standard nq sbar
	//	drawpic(pos + '0 9 0', "gfx/ibar", '320 9 0', '1 1 1', autocvar(scr_sbaralpha, 0.75), 0);
	

	if (sitems & IT_KEY1)
		drawpic(pos+'192 8 0', "gfx/sb_key1", '16 16 0', '1 1 1', 1, 0);
	if (sitems & IT_KEY2)
		drawpic(pos+'208 8 0', "gfx/sb_key2", '16 16 0', '1 1 1', 1, 0);
	if (sitems & IT_INVISIBILITY)
		drawpic(pos+'224 8 0', "gfx/sb_invis", '16 16 0', '1 1 1', 1, 0);
	if (sitems & IT_INVULNERABILITY)
		drawpic(pos+'240 8 0', "gfx/sb_invuln", '16 16 0', '1 1 1', 1, 0);
	if (sitems & IT_SUIT)
		drawpic(pos+'256 8 0', "gfx/sb_suit", '16 16 0', '1 1 1', 1, 0);
	if (sitems & IT_QUAD)
		drawpic(pos+'272 8 0', "gfx/sb_quad", '16 16 0', '1 1 1', 1, 0);

	if (sitems2 & IT2_RUNE1)
		drawpic(pos+'288 8 0', "gfx/sb_sigil1", '8 16 0', '1 1 1', 1, 0);
	if (sitems2 & IT2_RUNE2)
		drawpic(pos+'296 8 0', "gfx/sb_sigil2", '8 16 0', '1 1 1', 1, 0);
	if (sitems2 & IT2_RUNE3)
		drawpic(pos+'304 8 0', "gfx/sb_sigil3", '8 16 0', '1 1 1', 1, 0);
	if (sitems2 & IT2_RUNE4)
		drawpic(pos+'312 8 0', "gfx/sb_sigil4", '8 16 0', '1 1 1', 1, 0);

	if (deathmatch)
	{	//should probably show team scores, but this mimics vanilla
		pos_x += 194;
		for (float i = -1; i >= -4; i--)
		{
			string frags = getplayerkeyvalue(i, "frags");
			if not (frags)
				break;
			vector top = stov(getplayerkeyvalue(i, "topcolor_rgb"));
			vector bot = stov(getplayerkeyvalue(i, "bottomcolor_rgb"));
			drawfill(pos+[0,1], [28,3], top, 0.75, 0);
			drawfill(pos+[0,4], [28,4], bot, 0.75, 0);
			drawstring(pos+[2,0], strpad(-3, frags), [8,8], [1,1,1],1,0);
			if (player_localentnum == stof(getplayerkeyvalue(i, "viewentity")))
			{
				drawcharacter(pos+[-4,0], 0xe010, [8,8], [1,1,1],1, 0);
				drawcharacter(pos+[24,0], 0xe011, [8,8], [1,1,1],1, 0);
			}
			pos_x += 8*4;
		}
	}
};

float numclientseats;
static void Hud_Draw(vector virtsize, float scoreboard)
{
	vector pos;
	float oitems = sitems;
	float oitems2 = sitems2;
	float ohealth = shealth;

	pos_x = (virtsize_x-320)/2;
	pos_y = virtsize_y;

	sitems = getstatbits(STAT_ITEMS, 0, 23);	//note that we could use getstati to read the items stat, but it'd degrade when then cast to a float, and QSS+DP don't support ints, so we have to use two floats. 
	sitems2 = getstatbits(STAT_ITEMS, 23, 9);
	sweapon = getstatf(STAT_ACTIVEWEAPON);
	shealth = getstatf(STAT_HEALTH);
	//note that ssqc can provide custom stats, eg: clientstat(STAT_USER+n, EV_FLOAT, items3); can then be read by us with float items3 = getstatf(STAT_USER+n);
	
	if (shealth <= 0)
		scoreboard = TRUE;

	if (numclientseats <= 1)
	{	//note that we only track one player's stats. with splitscreen we need to stop looking for changes otherwise we'd see them all the time.
		if (ohealth && sitems != oitems)
		{
			for (float f = 0; f < 7; f++)
			{
				if ((sitems & (1<<f)) && !(oitems & (1<<f)))
					flashtime[f] = time;
			}
		}
	}

	if (autocvar(viewsize, 100) < 120)
	{
		if (scoreboard)
			Hud_CoopScores_SBar(pos - '0 24 0');
		else
			Hud_DrawSBar(pos - '0 24 0', virtsize);

		//if (autocvar(viewsize, 100) < 110)
		//	Hud_DrawIBar(pos - '0 48 0', virtsize);
	}
};

//lame entry point, just so that we know when damage was taken
float(float save, float take, vector dir) CSQC_Parse_Damage =
{
	if (numclientseats <= 1)
		painfinishtime = time + 0.2;
	return FALSE;	//let the engine handle any red tints etc
};

//Hud entry point!
//showscores is set if +scores is held (check health yourself).
void(vector virtsize, float showscores) CSQC_DrawHud =
{
	Hud_Draw(virtsize, showscores);
};

void(float apilevel, string enginename, float engineversion) CSQC_Init =
{
	Hud_Init();
};