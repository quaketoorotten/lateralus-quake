// CSQC entry points all conveniently in one file

void(vector virtsize, float showscores) CSQC_DrawScores =
{
	if (intermission || showscores || getstatf(STAT_HEALTH) <= 0)
		if (deathmatch)
			return Hud_DeathmatchScoreboard('0 0 0', virtsize);
	if (intermission)
		Hud_Intermission('0 0 0', virtsize);
};

float(float save, float take, vector dir) CSQC_Parse_Damage =
{
	if (numclientseats <= 1)
		painfinishtime = time + 0.2;
	return FALSE;	//let the engine handle any red tints etc
};

void(vector virtsize, float showscores) CSQC_DrawHud =
{
	Hud_Draw(virtsize, showscores);
};

float draw_scoreboard;

void(float vwidth, float vheight, float notmenu) CSQC_UpdateView =
{
	clearscene();

	//setviewprop(VF_DRAWENGINESBAR, 1);
	//setviewprop(VF_DRAWCROSSHAIR, 1);

	V_CalcRefDef();
	
	addentities(MASK_ENGINE);
	renderscene();
		
	if (intermission)
		return;
	
	local vector ssize;
	ssize_x = vwidth; ssize_y = vheight; ssize_z = 0;

	CSQC_DrawHud (ssize, draw_scoreboard);
};

float(string str) CSQC_ConsoleCommand =
{
	tokenize( str );
	switch ( argv(0) ) 
	{
		case "+showscores":
		{
			draw_scoreboard = TRUE;
			return TRUE;
			break;
		}
		case "-showscores":
		{
			draw_scoreboard = FALSE;
			return TRUE;
			break;
		}
		default:
		{
			return FALSE;
			break;
		}
	}
    return TRUE;
};

void(float apilevel, string enginename, float engineversion) CSQC_Init =
{
	Hud_Init();
	V_Init();
};

void() CSQC_Input_Frame =
{
	getinputstate(clientcommandframe - 1);
	old_movevalues = input_movevalues;
	old_buttons = input_buttons;
	
	getinputstate(clientcommandframe);
	
	cur_movevalues = input_movevalues;
	cur_buttons = input_buttons;
}
