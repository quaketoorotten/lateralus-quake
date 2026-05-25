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

float sweaponid;
float marker_time;

float STAT_MARKERTIME = 34;
float STAT_WEAPONID = 33;

// items. FIXME: you should share these with your ssqc...
float	IT_FIST				= 1<<0;
float	IT_PISTOL				= 1<<1;
float	IT_SHOTGUN				= 1<<2;
float	IT_MACHINEGUN			= 1<<3;
float	IT_CHAINGUN				= 1<<4;
float	IT_GRENADE				= 1<<5;
float	IT_PLASMA_GUN			= 1<<6;
float	IT_ROCKET_LAUNCHER		= 1<<7;
float	IT_BFG				= 1<<8;
float	IT_CHAINSAW				= 1<<9;
float	IT_DOUBLEBARREL			= 1<<10;
float	IT_GRABBER				= 1<<11;
float	IT_ARTIFACT				= 1<<12;

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

static string ammotypes[4] = {
	"gfx/stat4_0",
	"gfx/stat4_1",
	"gfx/stat4_2",
	"gfx/stat4_3"
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
float painfinishtime;//tracks when we took damage, for flinching.


//registers the various pics so they're ready as needed.
void() Hud_Init
{
	float i;
	precache_pic("gfx/crosshair", TRUE);
	precache_pic("gfx/crosshair1", TRUE);
	precache_pic("gfx/infotab_glass", TRUE);
	precache_pic("gfx/infotab_border", TRUE);
	precache_pic("gfx/sbar", TRUE);
	precache_pic("gfx/stat1", TRUE);
	precache_pic("gfx/stat2_a", TRUE);
	precache_pic("gfx/stat2_h", TRUE);
	precache_pic("gfx/stat2_h1", TRUE);
	precache_pic("gfx/stat3", TRUE);
	precache_pic("gfx/stat4", TRUE);
	precache_pic("gfx/stat4_0", TRUE);
	precache_pic("gfx/stat4_1", TRUE);
	precache_pic("gfx/stat4_2", TRUE);
	precache_pic("gfx/stat4_3", TRUE);
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

static void(float type, vector pos) Hud_DrawAmmoCount =
{
	string s;
	float value;
	float len;
	float c;
	value = getstatf(STAT_SHELLS+type);

	if (value>999)
		value = 999;
	
	//print(ftos(value));
	s = ftos(floor(value));
	len = strlen(s);

	pos_x += 5 * (3-len);
	while(len>0)
	{
		len--;
		c = str2chr(s, len);
		drawcharacter(pos+len * '8 0 0', (18-'0') + c, '8 8 0', '1 1 1', 1, 0);
	}
};

static void(vector pos, float value) Hud_DrawNums =
{
	string s;
	float len;
	float c;
	//value = getstatf(STAT_AMMO);
	if (value < 0)
		value = 0;	//hrm
	if (value>999)
		value = 999;
	
	//print(ftos(value));
	s = ftos(floor(value));
	len = strlen(s);
	
	pos_x += 5 * (3-len);
	while(len>0)
	{
		len--;
		c = str2chr(s, len);
		drawcharacter(pos+len * '8 0 0',(18-'0') + c, '8 8 0', '1 1 1', 1, 0);
	}
};

static void(vector pos, float value) Hud_DrawNumsBlue =
{
	string s;
	float len;
	float c;
	//value = getstatf(STAT_AMMO);
	if (value < 0)
		value = 0;	//hrm
	if (value>999)
		value = 999;
	
	//print(ftos(value));
	s = ftos(floor(value));
	len = strlen(s);
	
	pos_x += 5 * (3-len);
	while(len>0)
	{
		len--;
		c = str2chr(s, len);
		drawcharacter(pos+len * '8 0 0',(146-'0') + c, '8 8 0', '1 1 1', 1, 0);
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
		
	drawpic(sbar, "gfx/infotab_glass", '150 105 0', '1 1 1', 0.5, 0);
	drawpic(sbar, "gfx/infotab_border", '150 105 0', '1 1 1',1, 0);

	s = strcat("Monsters:", FormatFloat(getstatf(STAT_KILLEDMONSTERS), 3, " "), "/", FormatFloat(getstatf(STAT_TOTALMONSTERS), 3, " "));
	drawstring(sbar + '8 16', s, '8 8 0', '1 1 1', 1, 0);
	s = strcat("Secrets :", FormatFloat(getstatf(STAT_FOUNDSECRETS), 3, " "), "/", FormatFloat(getstatf(STAT_TOTALSECRETS), 3, " "));
	drawstring(sbar + '8 24', s, '8 8 0', '1 1 1', 1, 0);

	nmins = floor(time/60);
	nsecs = floor(time - nmins*60);
	s = strcat("Time :", FormatFloat(nmins, 3, " "), ":", FormatFloat(nsecs, 2, "0"));
	drawstring(sbar + '8 32', s, '8 8 0', '1 1 1', 1, 0);
	
	drawstring(sbar + '8 40', "Weapons:", '8 8 0', '1 1 1', 1, 0);
	drawstring(sbar + '8 48', "1                ", '8 8 0', '1 1 1', 1, 0);

	if (sitems & IT_PISTOL) // there gotta be a better way right ?
		drawstring(sbar + '8 48', "  2              ", '8 8 0', '1 1 1', 1, 0);
	if (sitems & IT_SHOTGUN)
		drawstring(sbar + '8 48', "    3            ", '8 8 0', '1 1 1', 1, 0);
	if (sitems & IT_MACHINEGUN)
		drawstring(sbar + '8 48', "      4          ", '8 8 0', '1 1 1', 1, 0);
	if (sitems & IT_CHAINGUN)
		drawstring(sbar + '8 48', "        5        ", '8 8 0', '1 1 1', 1, 0);
	if (sitems & IT_GRENADE)
		drawstring(sbar + '8 48', "          6      ", '8 8 0', '1 1 1', 1, 0);
	if (sitems & IT_PLASMA_GUN)
		drawstring(sbar + '8 48', "            7    ", '8 8 0', '1 1 1', 1, 0);
	if (sitems & IT_ROCKET_LAUNCHER)
		drawstring(sbar + '8 48', "              8  ", '8 8 0', '1 1 1', 1, 0);
	if (sitems & IT_BFG)
		drawstring(sbar + '8 48', "                9", '8 8 0', '1 1 1', 1, 0);
	
	if (sitems & IT_CHAINSAW)
		drawstring(sbar + '8 56', "1", '8 8 0', '1 1 1', 1, 0);
	if (sitems & IT_DOUBLEBARREL)
		drawstring(sbar + '8 56', "    3", '8 8 0', '1 1 1', 1, 0);
	if (sitems & IT_GRABBER)
		drawstring(sbar + '8 56', "  F  ", '8 8 0', '1 1 1', 1, 0);

	drawstring(sbar + '8 64',"keys:", '8 8 0', '1 1 1', 1, 0);
	if (sitems & IT_KEY1)
		drawstring(sbar + '8 64',"      S", '8 8 0', '1 1 1', 1, 0);
	if (sitems & IT_KEY2)
	{	
		if (sitems & IT_KEY1)
			sbar_x += 16;
		drawstring(sbar + '8 64',"      G", '8 8 0', '1 1 1', 1, 0);
	}

	float num = sweaponid - 1;
	if (sweapon == 1<<num )
	{	
		sbar_x = sbar_x + sweaponid*16 - 21;
		if (num < 9)
			drawstring(sbar + '8 48', "\s[]", '8 8 0', '1 1 1', 1, 1);
		else if (num == 9)
		{	
			sbar_x = pos_x - 4;
			drawstring(sbar + '8 56', "\s[]", '8 8 0', '1 1 1', 1, 1);	
		}
		else if (num == 10)
		{	
			sbar_x = pos_x;
			sbar_x = sbar_x + 3*16 - 21;
			drawstring(sbar + '8 56', "\s[]", '8 8 0', '1 1 1', 1, 1);
		}
		else if (num == 11)
		{	
			sbar_x = pos_x;
			sbar_x = sbar_x + 2*16 - 21;
			drawstring(sbar + '8 56', "\s[]", '8 8 0', '1 1 1', 1, 1);
		}
	}
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

static float Return_AmmoType ()
{
	if (sweapon == IT_PISTOL || sweapon == IT_SHOTGUN || sweapon == IT_DOUBLEBARREL)
		return 0;
	if (sweapon == IT_MACHINEGUN || sweapon == IT_CHAINGUN)
		return 1;
	if (sweapon == IT_ROCKET_LAUNCHER || sweapon == IT_GRENADE)
		return 2;
	if (sweapon == IT_BFG || sweapon == IT_PLASMA_GUN)
		return 3;

	return 0;
}

static void Hud_DrawSBar(vector virtsize)
{	
	vector pos, picsize;
	picsize_x = 166;
	picsize_y = 35;
	picsize_z = 0;

	pos = [0, virtsize_y-(picsize_y)];
	if (autocvar(cl_sbar, 1))
		drawpic(pos, "gfx/stat1", '166 35 0', '1 1 1', 0.6, 0);
	
	vector healthsize = '0 10 0';
	vector armorsize = '0 12 0';
	float selfhealth = shealth;
	float selfhealth2 = 0;
	
	if (shealth > 100)
	{
		selfhealth = 100;
		selfhealth2 = shealth - selfhealth;
	}
	
	float helth = 0 + (87  * (selfhealth/100));
	healthsize_x = helth;
	drawpic(pos+[70, 6, 0], "gfx/stat2_h", healthsize, '1 1 1', autocvar(scr_sbaralpha, 0.75), 0);

	float helth_mega = 0 + (87  * (selfhealth2/100));
	healthsize_x = helth_mega;
	drawpic(pos+[70, 6, 0], "gfx/stat2_h1", healthsize, '1 1 1', autocvar(scr_sbaralpha, 0.75), 0);
	
	if(shealth > 150)
		Hud_DrawNumsBlue ( pos+[128, 6, 0], shealth);
	else
		Hud_DrawNums( pos+[128, 6, 0], shealth);

	float armo = 0 + (99  * (getstatf(STAT_ARMOR)/200));
	armorsize_x = armo;
	drawpic(pos+[63, 21, 0], "gfx/stat2_a", armorsize, '1 1 1', autocvar(scr_sbaralpha, 0.75), 0);

	Hud_DrawNums( pos+[136, 24, 0], getstatf(STAT_ARMOR));

	if (autocvar(cl_sbar, 1))
		drawpic(pos, "gfx/stat3", '166 35 0', '1 1 1', autocvar(scr_sbaralpha, 0.75), 0);

	float weapontype = Return_AmmoType();
//	string ammotype = "gfx/stat4_";
	
	if (sweapon != IT_FIST && sweapon != IT_CHAINSAW && sweapon != IT_GRABBER && sweapon != IT_ARTIFACT)
	{	
		drawpic(pos, "gfx/stat4", '166 35 0', '1 1 1', 1, 0);

		if (sweapon != IT_GRENADE)
			Hud_DrawNums( pos+[22, 10, 0], getstatf(STAT_AMMO));
		else
			Hud_DrawAmmoCount(weapontype, pos+[22, 10, 0]);

		Hud_DrawAmmoCount(weapontype, pos+[14, 21, 0]);
		
		drawpic(pos, ammotypes[weapontype], '166 35 0', '1 1 1', 1, 0);
	}

	pos_y = virtsize_y/2-6;
	pos_x = virtsize_x/2-6;

	if (cvar("crosshair"))
		drawpic(pos, "gfx/crosshair", '16 16 0', '1 1 1', 0.67, 0);

	if (marker_time > time)
	{
		pos_y = virtsize_y/2-3;
		pos_x = virtsize_x/2-3;

		if (cvar("crosshair"))
			drawpic(pos, "gfx/crosshair1", '10 10 0', '255 1 1', 1, 0);
	}
};

float numclientseats;


void Hud_Draw(vector virtsize, float scoreboard)
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
	sweaponid = getstatf( STAT_WEAPONID);
	shealth = getstatf(STAT_HEALTH);
	marker_time = getstatf(STAT_MARKERTIME);
	//note that ssqc can provide custom stats, eg: clientstat(STAT_USER+n, EV_FLOAT, items3); can then be read by us with float items3 = getstatf(STAT_USER+n);
	
	if (shealth <= 0)
		return;

	float spowerups = getstatbits(37, 0, 23);
	if (spowerups & IT_QUAD)
		drawfill('0 0 0', virtsize, '1 0 0', 0.3);

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
		{	
			pos_x = (virtsize_x-150);
			pos_y = pos_y - 235;
			Hud_CoopScores_SBar(pos);
		}
		Hud_DrawSBar(virtsize);
		
		pos_x = virtsize_x - strlen(world.message)*8;
		pos_y = virtsize_y - 8;
		drawstring(pos, world.message, '8 8 0', '1 1 1', 1, 0);
	}
};