
#define FILTERSCRIPT

#include <a_samp>
#include <Progress>
#include <dini>
#include <zcmd>

#if defined FILTERSCRIPT

#define COLOR_BLUE				0x0000BBAA
#define COLOR_LIGHTBLUE			0x33CCFFAA

new Bar:hungry[MAX_PLAYERS] = {INVALID_BAR_ID, ...};
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
	Hunger
};
new PInfo[MAX_PLAYERS][PlayerStats];

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Aclik Sistemi Yukleniyor...");
	print("--------------------------------------\n");
	SetTimer("ProgressBar", 180000, 1);
	SetTimer("update", 5000, 1);

	for(new playerid; playerid < MAX_PLAYERS; playerid++)
    {
        new Float:health;
		GetPlayerHealth(playerid, health);
        new HungryTime = SetPlayerHealth(playerid, health-5);
		if(GetProgressBarValue(hungry[playerid]) <= 1)
		{
	    	SetTimer("HungryTime", 30000, 1);
	    	SendClientMessageEx(playerid, COLOR_BLUE, "Acýkmaya baþladýn.");
	    	SendClientMessageEx(playerid, COLOR_BLUE, "Acýkmaya devam edersen canýn azalacak !");
		}
		if(GetProgressBarValue(hungry[playerid]) <= 0)
		{
		    SetProgressBarValue(hungry[playerid], 0);
		}
		if(GetProgressBarValue(hungry[playerid]) > 0)
		{
		    KillTimer(HungryTime);
		}
	}

   	print("\n--------------------------------------");
	print(" AÃ§lÄ±k Sistemi YÃ¼klendi.. Metehan Bayaz");
	print("--------------------------------------\n");

	return 1;
}

public ProgressBar()
{
    for(new playerid; playerid < MAX_PLAYERS; playerid++)
    {
		SetProgressBarValue(hungry[playerid], GetProgressBarValue(hungry[playerid])-2);
	}
	return 1;
}

public update()
{
	for(new playerid; playerid < MAX_PLAYERS; playerid++)
	{
	    UpdateProgressBar(hungry[playerid], playerid);
	}
	return 1;
}

#endif

public OnPlayerConnect(playerid)
{
	PInfo[playerid][Hunger] = 100;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
 	new file[256],n[MAX_PLAYER_NAME];
    GetPlayerName(playerid,n,MAX_PLAYER_NAME);
    format(file,sizeof(file),"Stats/%s.txt",n);
    PInfo[playerid][Hunger] = floatround(GetProgressBarValue(hungry[playerid]));
    if(dini_Exists(file))
    {
        dini_IntSet(file,"Hunger",floatround(GetProgressBarValue(hungry[playerid])));
        return 1;
    }
	return 1;
}

public OnPlayerSpawn(playerid)
{
    new file[256],n[MAX_PLAYER_NAME];
    GetPlayerName(playerid,n,MAX_PLAYER_NAME);
    format(file,sizeof(file),"Stats/%s.txt",n);
    if(!dini_Exists(file))
    {
        dini_Create(file);
    	dini_IntSet(file,"Hunger",100);
	}
	hungry[playerid] = CreateProgressBar(548.00, 26.00, 57.50, 3.20, 0xFF8000FF, 100.0);
	ShowProgressBarForPlayer(playerid, hungry[playerid]);
	SetProgressBarValue(hungry[playerid], dini_Int(file,"Hunger"));
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	SetProgressBarValue(hungry[playerid], 100);
	return 1;
}
CMD:abarkapa(playerid,params[]) {
	HideProgressBarForPlayer(playerid, hungry[playerid]);
	DestroyProgressBar(hungry[playerid]);
}
CMD:abarac(playerid,params[]) {
	ShowProgressBarForPlayer(playerid, hungry[playerid]);
}

CMD:yemekal(playerid,params[])
{
	if(isnull(params))
	{
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "Kullaným: /yemekal [burger/pizza/tavuk]");
	}
	if(strcmp(params,"burger",true) == 0)
	{
		if(IsPlayerInRangeOfPoint(playerid, 20, 366.0248, -73.3478, 1001.5078))
		{
			GivePlayerMoney(playerid, -25);
	    	SetProgressBarValue(hungry[playerid], GetProgressBarValue(hungry[playerid])+10);
			return SendClientMessage(playerid, COLOR_BLUE, "Burger yediðin için teþekkürler!");
		}
		else return SendClientMessage(playerid, COLOR_BLUE, "Burger mekanýnda olmalýsýn !");
	}
	if(strcmp(params,"pizza",true) == 0)
	{
		if(IsPlayerInRangeOfPoint(playerid, 50, 372.3520, -131.6510, 1001.4922))
		{
			GivePlayerMoney(playerid, -35);
	    	SetProgressBarValue(hungry[playerid], GetProgressBarValue(hungry[playerid])+15);
			return SendClientMessage(playerid, COLOR_BLUE, "Pizza yediðin için teþekkürler!");
		}
		else return SendClientMessage(playerid, COLOR_BLUE, "Pizzacý mekanýnda olmalýsýn !");
	}
	if(strcmp(params,"tavuk",true) == 0)
	{
		if(IsPlayerInRangeOfPoint(playerid, 50, 365.7158, -9.8873, 1001.8516))
		{
			GivePlayerMoney(playerid, -10);
	    	SetProgressBarValue(hungry[playerid], GetProgressBarValue(hungry[playerid])+5);
			return SendClientMessage(playerid, COLOR_BLUE, "Tavuk yediðin için teþekkürler!");
		}
		else return SendClientMessage(playerid, COLOR_BLUE, "Tavukçu mekanýnda olmalýsýn !");
	}
	return 1;
}
