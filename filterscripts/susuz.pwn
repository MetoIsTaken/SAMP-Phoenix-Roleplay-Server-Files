#define FILTERSCRIPT

#include <a_samp>
#include <Progress>
#include <dini>
#include <zcmd>

#undef MAX_PLAYERS
#define MAX_PLAYERS 1000 // slot sayýsý

#if defined FILTERSCRIPT

#define COLOR_BLUE				0x0000BBAA
#define COLOR_LIGHTBLUE			0x33CCFFAA

new Bar:susuzluk[MAX_PLAYERS] = {INVALID_BAR_ID, ...};
new InsideMainMenu[MAX_PLAYERS];
new ActiveChatbox[MAX_PLAYERS];
new InsideTut[MAX_PLAYERS];
forward ProgressBar();
forward update();

stock SendClientMessageEx(playerid, color, string[])
{
	if(InsideMainMenu[playerid] == 1 || InsideTut[playerid] == 1 || ActiveChatbox[playerid] == 0)
		return 0;

	else SendClientMessage(playerid, color, string);
	return 1;
}

enum pInfo
{
	pCash,
};

enum PlayerStats
{
	Susuz
};
new PInfo[MAX_PLAYERS][PlayerStats];

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Susuzluk Sistemi Yukleniyor...");
	print("--------------------------------------\n");
	SetTimer("ProgressBar", 180000, 1);
	SetTimer("update", 5000, 1);

	for(new playerid; playerid < MAX_PLAYERS; playerid++)
    {
        new Float:health;
		GetPlayerHealth(playerid, health);
        new susuzlukTime = SetPlayerHealth(playerid, health-10);
		if(GetProgressBarValue(susuzluk[playerid]) <= 1)
		{
	    	SetTimer("susuzlukTime", 30000, 1);
	    	SendClientMessageEx(playerid, COLOR_BLUE, "Susamaya baþladýn.");
	    	SendClientMessageEx(playerid, COLOR_BLUE, "Susamaya devam edersen canýn azalacak !");
		}
		if(GetProgressBarValue(susuzluk[playerid]) <= 0)
		{
		    SetProgressBarValue(susuzluk[playerid], 0);
		}
		if(GetProgressBarValue(susuzluk[playerid]) > 0)
		{
		    KillTimer(susuzlukTime);
		}
	}

   	print("\n--------------------------------------");
	print(" Susuzluk Sistemi Yuklendi.. Metehan Bayaz");
	print("--------------------------------------\n");

	return 1;
}

public ProgressBar()
{
    for(new playerid; playerid < MAX_PLAYERS; playerid++)
    {
		SetProgressBarValue(susuzluk[playerid], GetProgressBarValue(susuzluk[playerid])-2);
	}
	return 1;
}

stock IsAt247(playerid)
{
 	if(IsPlayerConnected(playerid))
	{
		if(IsPlayerInRangeOfPoint(playerid, 100.0, -30.875, -88.9609, 1004.53))
		{
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 10.0, -2654.2300,1526.3693,907.1797))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 50.0, 890.66, 1429.08, -82.34))
		{
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 50.0, -29.2035, -185.1285, 1003.5469))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 50.0, 2.0450,-29.0116,1003.5494))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 50.0, -28.1463,-89.9533,1003.5469))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 50.0, -22.0699,-138.6297,1003.5469))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 50.0, -22.0699,-138.6297,1003.5469))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 50.0, -30.9772,-29.0228,1003.5573))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 50.0, -23.4488,-55.6319,1003.5469))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 50, 372.3520, -131.6510, 1001.4922))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 50, 365.7158, -9.8873, 1001.8516))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 20, 366.0248, -73.3478, 1001.5078))
		{
		    return 1;
		}
		else if((IsPlayerInRangeOfPoint(playerid,130.0,470.430297, -2414.415527, 10.790462) && GetPlayerInterior(playerid) == 18))
		{ // Saints Mall
		    return 1;
		}
 	}
	return 0;
}

public update()
{
	for(new playerid; playerid < MAX_PLAYERS; playerid++)
	{
	    UpdateProgressBar(susuzluk[playerid], playerid);
	}
	return 1;
}

#endif

public OnPlayerConnect(playerid)
{
	PInfo[playerid][Susuz] = 100;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
 	new file[256],n[MAX_PLAYER_NAME];
    GetPlayerName(playerid,n,MAX_PLAYER_NAME);
    format(file,sizeof(file),"Susuz/%s.txt",n);
    PInfo[playerid][Susuz] = floatround(GetProgressBarValue(susuzluk[playerid]));
    if(dini_Exists(file))
    {
        dini_IntSet(file,"Susuz",floatround(GetProgressBarValue(susuzluk[playerid])));
        return 1;
    }
	return 1;
}

public OnPlayerSpawn(playerid)
{
    new file[256],n[MAX_PLAYER_NAME];
    GetPlayerName(playerid,n,MAX_PLAYER_NAME);
    format(file,sizeof(file),"Susuz/%s.txt",n);
    if(!dini_Exists(file))
    {
        dini_Create(file);
    	dini_IntSet(file,"Susuz",100);
	}
	susuzluk[playerid] = CreateProgressBar(548.00, 6.00, 57.50, 3.20, COLOR_LIGHTBLUE, 100.0);
	ShowProgressBarForPlayer(playerid, susuzluk[playerid]);
	SetProgressBarValue(susuzluk[playerid], dini_Int(file,"Susuz"));
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	SetProgressBarValue(susuzluk[playerid], 100);
	return 1;
}


CMD:sbarkapa(playerid,params[]) {
	HideProgressBarForPlayer(playerid, susuzluk[playerid]);
	DestroyProgressBar(susuzluk[playerid]);
}
CMD:sbarac(playerid,params[]) {
	ShowProgressBarForPlayer(playerid, susuzluk[playerid]);
}
CMD:icecekal(playerid,params[])
{
	if(isnull(params))
	{
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "Kullaným: /icecekal su");
	}
	if(strcmp(params,"su",true) == 0)
	{
 		if(IsAt247(playerid))
		{
			GivePlayerMoney(playerid, -1);
	    	SetProgressBarValue(susuzluk[playerid], GetProgressBarValue(susuzluk[playerid])+10);
			return SendClientMessage(playerid, COLOR_BLUE, "Suyu baþarýyla içtin");
		}
		else return SendClientMessage(playerid, COLOR_BLUE, "Herhangi bir Burger,Pizza veya 7/24 de olmalýsýn!");
	}

	return 1;
}
