#include <a_samp>

#undef MAX_PLAYERS
#define MAX_PLAYERS 100 // slot sayýsý
#define ARALIK 0 // 250 ms - saniyede 4 kere günceller

new Text: speedoBacka;
new Text: speedoBack;
new Text: modelTD[MAX_PLAYERS];
new Text: isimTD[MAX_PLAYERS];
new Text: hizTD[MAX_PLAYERS];
new Text: hasarTD[MAX_PLAYERS];
new SpeedoGuncelle[MAX_PLAYERS];

new VehicleFriendlyNames[212][] = {
	{"Landstalker"},{"Bravura"},{"Buffalo"},{"Linerunner"},{"Perrenial"},{"Sentinel"},
 	{"Dumper"},{"Firetruck"},{"Trashmaster"},{"Stretch"},{"Manana"},{"Infernus"},{"Voodoo"},
  	{"Pony"},{"Mule"},{"Cheetah"},{"Ambulance"},{"Leviathan"},{"Moonbeam"},{"Esperanto"},{"Taxi"},
   	{"Washington"},{"Bobcat"},{"Mr. Whoopee"},{"BF. Injection"},{"Hunter"},{"Premier"},{"Enforcer"},
   	{"Securicar"},{"Banshee"},{"Predator"},{"Bus"},{"Rhino"},{"Barracks"},{"Hotknife"},{"Article Trailer"},
    {"Previon"},{"Coach"},{"Cabbie"},{"Stallion"},{"Rumpo"},{"RC Bandit"},{"Romero"},{"Packer"},{"Monster"},
    {"Admiral"},{"Squalo"},{"Seasparrow"},{"Pizzaboy"},{"Tram"},{"Article Trailer 2"},{"Turismo"},{"Speeder"},
    {"Reefer"},{"Tropic"},{"Flatbed"},{"Yankee"},{"Caddy"},{"Solair"},{"Berkley's RC Van"},{"Skimmer"},
    {"PCJ-600"},{"Faggio"},{"Freeway"},{"RC Baron"},{"RC Raider"},{"Glendale"},{"Oceanic"},{"Sanchez"},
    {"Sparrow"},{"Patriot"},{"Quad"},{"Coastguard"},{"Dinghy"},{"Hermes"},{"Sabre"},{"Rustler"},{"ZR-350"},
    {"Walton"},{"Regina"},{"Comet"},{"BMX"},{"Burrito"},{"Camper"},{"Marquis"},{"Baggage"},{"Dozer"},
    {"Maverick"},{"News Chopper"},{"Rancher"},{"FBI Rancher"},{"Virgo"},{"Greenwood"},{"Jetmax"},{"Hotring"},
    {"Sandking"},{"Blista Compact"},{"Police Maverick"},{"Boxville"},{"Benson"},{"Mesa"},{"RC Goblin"},
    {"Hotring Racer A"},{"Hotring Racer B"},{"Bloodring Banger"},{"Rancher"},{"Super GT"},{"Elegant"},
    {"Journey"},{"Bike"},{"Mountain Bike"},{"Beagle"},{"Cropdust"},{"Stunt"},{"Tanker"},{"Roadtrain"},
    {"Nebula"},{"Majestic"},{"Buccaneer"},{"Shamal"},{"Hydra"},{"FCR-900"},{"NRG-500"},{"HPV1000"},
    {"Cement Truck"},{"Tow Truck"},{"Fortune"},{"Cadrona"},{"FBI Truck"},{"Willard"},{"Forklift"},
    {"Tractor"},{"Combine"},{"Feltzer"},{"Remington"},{"Slamvan"},{"Blade"},{"Freight"},{"Streak"},
    {"Vortex"},{"Vincent"},{"Bullet"},{"Clover"},{"Sadler"},{"Firetruck LA"},{"Hustler"},{"Intruder"},
    {"Primo"},{"Cargobob"},{"Tampa"},{"Sunrise"},{"Merit"},{"Utility"},{"Nevada"},{"Yosemite"},{"Windsor"},
    {"Monster A"},{"Monster B"},{"Uranus"},{"Jester"},{"Sultan"},{"Stratum"},{"Elegy"},{"Raindance"},
    {"RC Tiger"},{"Flash"},{"Tahoma"},{"Savanna"},{"Bandito"},{"Freight Flat"},{"Streak Carriage"},
    {"Kart"},{"Mower"},{"Dunerider"},{"Sweeper"},{"Broadway"},{"Tornado"},{"AT-400"},{"DFT-30"},{"Huntley"},
    {"Stafford"},{"BF-400"},{"Newsvan"},{"Tug"},{"Article Trailer 3"},{"Emperor"},{"Wayfarer"},{"Euros"},{"Mobile Hotdog"},
    {"Club"},{"Freight Carriage"},{"Trailer 3"},{"Andromada"},{"Dodo"},{"RC Cam"},{"Launch"},{"Police Car (LSPD)"},
    {"Police Car (SFPD)"},{"Police Car (LVPD)"},{"Police Ranger"},{"Picador"},{"S.W.A.T Van"},{"Alpha"},
    {"Phoenix"},{"Glendale"},{"Sadler"},{"Luggage Trailer A"},{"Luggage Trailer B"},{"Stair Trailer"},
    {"Boxville"},{"Farm Plow"},{"Utility Trailer"}
};

stock GetVehicleSpeed(vehicleid)
{
	new Float:Pos[3],Float:ARRAY ;
	GetVehicleVelocity(vehicleid, Pos[0], Pos[1], Pos[2]);
	ARRAY = floatsqroot(Pos[0]*Pos[0] + Pos[1]*Pos[1] + Pos[2]*Pos[2])*200;
	return floatround(ARRAY,floatround_round);
}

public OnFilterScriptInit()
{
	
    speedoBacka = TextDrawCreate(0.000000, 0.000000, "");
	TextDrawBackgroundColor(speedoBacka, 255);
	TextDrawFont(speedoBacka, 0);
	TextDrawLetterSize(speedoBacka, 0.600000, 0.000000);
	TextDrawColor(speedoBacka, -1);
	TextDrawSetOutline(speedoBacka, 0);
	TextDrawSetProportional(speedoBacka, 0);
	TextDrawSetShadow(speedoBacka, 0);
	TextDrawUseBox(speedoBacka, 0);
	TextDrawBoxColor(speedoBacka, 0);
	TextDrawTextSize(speedoBacka, 0.000000, 0.000000);
	TextDrawSetSelectable(speedoBacka, 0);
	
    speedoBack = TextDrawCreate(500.000000, 400.000000, "_");
	TextDrawBackgroundColor(speedoBack, 255);
	TextDrawFont(speedoBack, 1);
	TextDrawLetterSize(speedoBack, 0.600000, 1.899999);
	TextDrawColor(speedoBack, -1);
	TextDrawSetOutline(speedoBack, 0);
	TextDrawSetProportional(speedoBack, 1);
	TextDrawSetShadow(speedoBack, 1);
	TextDrawUseBox(speedoBack, 1);
	TextDrawBoxColor(speedoBack, 85);
	TextDrawTextSize(speedoBack, 170.000000, 32.000000);
	TextDrawSetSelectable(speedoBack, 0);

	return 1;
}

public OnFilterScriptExit()
{
	TextDrawDestroy(speedoBacka);
	TextDrawDestroy(speedoBack);
	return 1;
}

public OnPlayerConnect(playerid)
{
    modelTD[playerid] = TextDrawCreate(154.000000, 375.000000, "_");
	TextDrawBackgroundColor(modelTD[playerid], 0);
	TextDrawFont(modelTD[playerid], 5);
	TextDrawLetterSize(modelTD[playerid], -0.000000, -0.000000);
	TextDrawColor(modelTD[playerid], -1);
	TextDrawSetOutline(modelTD[playerid], 0);
	TextDrawSetProportional(modelTD[playerid], 1);
	TextDrawSetShadow(modelTD[playerid], 1);
	TextDrawUseBox(modelTD[playerid], 1);
	TextDrawBoxColor(modelTD[playerid], 0);
	TextDrawTextSize(modelTD[playerid], 60.000000, 63.000000);
	TextDrawSetPreviewModel(modelTD[playerid], 400);
	TextDrawSetPreviewRot(modelTD[playerid], -10.000000, 0.000000, 50.000000, 1.000000);
	TextDrawSetSelectable(modelTD[playerid], 0);
	
	isimTD[playerid] = TextDrawCreate(212.000000, 403.000000, "_");
	TextDrawBackgroundColor(isimTD[playerid], 255);
	TextDrawFont(isimTD[playerid], 1);
	TextDrawLetterSize(isimTD[playerid], 0.260000, 1.000000);
	TextDrawColor(isimTD[playerid], 6737151);
	TextDrawSetOutline(isimTD[playerid], 1);
	TextDrawSetProportional(isimTD[playerid], 1);
	TextDrawSetSelectable(isimTD[playerid], 0);
	
	hizTD[playerid] = TextDrawCreate(258.000000, 403.000000, "Hiz: ~w~0");
	TextDrawBackgroundColor(hizTD[playerid], 255);
	TextDrawFont(hizTD[playerid], 1);
	TextDrawLetterSize(hizTD[playerid], 0.260000, 1.000000);
	TextDrawColor(hizTD[playerid], 6737151);
	TextDrawSetOutline(hizTD[playerid], 1);
	TextDrawSetProportional(hizTD[playerid], 1);
	TextDrawSetSelectable(hizTD[playerid], 0);
	
	hasarTD[playerid] = TextDrawCreate(308.000000, 403.000000, "Hasar: ~r~500");
	TextDrawBackgroundColor(hasarTD[playerid], 255);
	TextDrawFont(hasarTD[playerid], 1);
	TextDrawLetterSize(hasarTD[playerid], 0.260000, 1.000000);
	TextDrawColor(hasarTD[playerid], 6737151);
	TextDrawSetOutline(hasarTD[playerid], 1);
	TextDrawSetProportional(hasarTD[playerid], 1);
	TextDrawSetSelectable(hasarTD[playerid], 0);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	TextDrawDestroy(modelTD[playerid]);
	TextDrawDestroy(isimTD[playerid]);
	TextDrawDestroy(hizTD[playerid]);
	TextDrawDestroy(hasarTD[playerid]);
	KillTimer(SpeedoGuncelle[playerid]);
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER) {
	    TextDrawShowForPlayer(playerid, speedoBacka);
	    TextDrawShowForPlayer(playerid, speedoBack);
	    TextDrawSetPreviewModel(modelTD[playerid], GetVehicleModel(GetPlayerVehicleID(playerid)));
	    TextDrawShowForPlayer(playerid, modelTD[playerid]);
	    
	    new string[64];
	    format(string, sizeof(string), VehicleFriendlyNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400]);
	    TextDrawSetString(isimTD[playerid], string);
	    TextDrawShowForPlayer(playerid, isimTD[playerid]);
	    
	    TextDrawSetString(hizTD[playerid], "Hiz: ~w~0");
	    TextDrawShowForPlayer(playerid, hizTD[playerid]);
	    
	    TextDrawSetString(hasarTD[playerid], "Hasar: ~r~0");
	    TextDrawShowForPlayer(playerid, hasarTD[playerid]);
	    
	    SpeedoGuncelle[playerid] = SetTimerEx("TextleriGuncelle", ARALIK, true, "i", playerid);
	}
	
	if(oldstate == PLAYER_STATE_DRIVER) {
	    TextDrawHideForPlayer(playerid, speedoBacka);
	    TextDrawHideForPlayer(playerid, speedoBack);
	    TextDrawHideForPlayer(playerid, modelTD[playerid]);
	    TextDrawHideForPlayer(playerid, isimTD[playerid]);
	    TextDrawHideForPlayer(playerid, hizTD[playerid]);
	    TextDrawHideForPlayer(playerid, hasarTD[playerid]);
	    KillTimer(SpeedoGuncelle[playerid]);
	}
	return 1;
}

forward public TextleriGuncelle(playerid);
public TextleriGuncelle(playerid) {
	new id = GetPlayerVehicleID(playerid), Float: hp, string[64];
	format(string, sizeof(string), "Hiz: ~w~%d", GetVehicleSpeed(id));
	TextDrawSetString(hizTD[playerid], string);
	
 	floatround(GetVehicleHealth(GetPlayerVehicleID(playerid), hp));
   	format(string, sizeof(string), "Hasar: ~r~%d", floatround(1000-hp));
	TextDrawSetString(hasarTD[playerid], string);
	return 1;
}
