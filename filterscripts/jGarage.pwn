/*
	CMD:garagehelp(playerid,params[])
	{
		SendClientMessage(playerid, COLOR_ORANGE, "Garaj komutlarý:");
		if(!IsPlayerAdmin(playerid))
		{
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "/ggir | /gcik | /garajkilit | /garajal | /garajsat");
		}
		else
		{
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "/golustur | /gsil | /gtip | /ggir | /gcik | /garajkilit | /garajal | /garajsat");
		}
		return 1;
	}
*/

//=== INCLUDES ===//
#include <a_samp> //Credits to the SA-MP Team
#include <streamer> //Credits to Incognito
#include <sscanf2> //Credits to Y_Less



//====================-- SCRIPT CONFIGURATION --=====================================//
#define COMMAND_SYS 1 //Set to '1' for zcmd, change to '2' for strcmp
#define SAVING_SYS 2//Change this to the number of the saving system you want.

/*
    Number      System
        1         y_ini (y_ini include by Y_Less needed)
        2         Dini (Dini include by Dracoblue needed)
        3         MySQL R6 !unthreaded! (MySQL plugin/include by BlueG needed, R6, unthreaded queries)
		4         SQLite (sampdb include by the SA-MP Team needed)
*/

//-- SYSTEMATIC CONFIGURATION --//
#define MAX_OWNED_GARAGES 2 //Set this to the max. number of garages that a player should be able to own
#define AUTOSAVE true //Set to false if you don't want the script to autosave
#define AUTOSAVE_INTERVAL 10 //Set this to the amount of <~!~> MINUTES <~!~> you want the autosave function to be called (if enabled)
#define MAX_GARAGES 100 //Max garages to be created in the server

//-- PICKUPS AND TEXTLABELS --//
#define GARAGE_OWNED_PICKUP 1272 //Change this to the pickup model you prefer. Default: White arrow (diamond)
#define GARAGE_FREE_PICKUP 1273 //Change this to the pickup model you prefer. Default: Green house
#define GARAGE_OWNED_TEXT "Sahibi: %s\nKilit Durumu: %s" //This text will appear at all owned garages
#define GARAGE_FREE_TEXT "SATILIK GARAJ!\n Price: %d\n\nSatýn Almak Ýçin /Garajal" //This text will appear at all garages that are for sale
#define DD 200.0 //The streamdistance for the textlabels
#define 					GivePlayerCash(%0,%1) 				PlayerInfo[%0][pCash] += (%1)

//-- COLORS --//
#define TXTCOLOR 0xF9C50FFF //The textcolor for the textlabels
#define COLOR_USAGE 0xBB4D4DFF //The textcolor for the 'command usage' message
#define COLOR_SUCCESS 0x00AE00FF //The textcolor for the 'command sucessfull' message
#define COLOR_ERROR 0xFF0000FF //The textcolor for the 'error' message
#define COLOR_ORANGE 0xFFA500FF //The color orange
#define COLOR_LIGHTBLUE 0xADD8E6FF //The color light blue

////-- MySQL database/connection info. Only needed when using saving system number 3, MySQL. You can ignore this otherwise --////
#define HOST "localhost"
#define USER "root"
#define PASS ""
#define DataB "SAMP"
//


//System defines, no need to change stuff here, unless your includes are located elsewhere. Change with care.

#if SAVING_SYS == 1
	#include <YSI\y_ini> //Credits to Y_Less
#endif
#if SAVING_SYS == 2
	#include <Dini> //Credits to Dracoblue
#endif
#if SAVING_SYS == 3
	#include <a_mysql> //Credits to BlueG
#endif
#if SAVING_SYS == 4
	#include <a_sampdb> //Credits to the SA-MP Team
#endif
#if COMMAND_SYS == 1
    #include <zcmd> //Credits to Zeex
#endif

//For my reference, no need to change
#define SCRIPT_VERSION "V1.1"
//


//=== ENUMS ===//
enum garageInfo{

	Owner[24], //Holds the name of the owner
	Owned, //Holds the owned value (1 if owned, 0 if for sale)
	Locked, //The locked status of the garage (0 unlocked, 1 locked)
	Price, //The price of the garage
	Float:PosX, //The outside X position of the garage
	Float:PosY, //The outside Y position of the garage
	Float:PosZ, //The outside Z position of the garage
	Interior, //The internal interior number of the garage
 	UID //Unique ID, keeps a unique ID of the garages so the virtualworld doesn't mix up when deleting and reloading garages
}
enum pInfo
{
	pKey[129],
	pLevel,
	pAdmin,
	pAdminName[32],
	pBanAppealer,
	pGangMod,
	pDonator,
	pBanned,
	pPermaBanned,
	pDisabled,
	pIP[16],
	pReg,
	pID,
 	pTut,
	pSex,
	pAge,
	pSkin,
	Float:pPos_x,
	Float:pPos_y,
	Float:pPos_z,
	Float:pPos_r,
	pConnectTime,
	pRespect,
	pNumber,
	pWarns,
	pGang,
	pFaction,
	pLeader,
	pRank,
	pJob,
	pJob2,
	gPupgrade,
	Float:pSarmor,
	pCash,
	pBank,
	pInsurance,
	pCrimes,
	pArrested,
	pWantedLevel,
	Float:pHealth,
	Float:pArmor,
	pPot,
	pCrack,
	pPackages,
	pCrates,
	pRadio,
	pRadioFreq,
	pPhoneBook,
	pDice,
	pCDPlayer,
	pMats,
	pRope,
	pCigar,
	pSprunk,
	pSpraycan,
	pHouse,
	pHouse2,
	pRenting,
	pInt,
	pVW,
	pJailed,
	pJailTime,
	pGuns[12],
	pAGuns[12],
	pPayCheck,
	pPayReady,
	pHospital,
	pDetSkill,
	pLawSkill,
	pSexSkill,
	pDrugsSkill,
	pSmugSkill,
	pArmsSkill,
	pMechSkill,
	pFishSkill,
	pBoxSkill,
	pTruckSkill,
	pCarSkill,
	//pCraftSkill,
	pLawyerTime,
	pLawyerFreeTime,
	pDrugsTime,
	pMechTime,
	pSexTime,
	pCarTime,
	pFishes,
	pBiggestFish,
	pLockCar, // non-saved
	pWeedObject,
	Float: pWeedPos[3],
	pWeedVW,
	pWeedInt,
	pWeedGrowth,
	pWSeeds,
	pWins,
	pLoses,
	pFightStyle,
	pScrewdriver,
	pSmslog,
	pWristwatch,
	pTire,
	pFirstaid,
	pRccam,
	pReceiver,
	pGPS,
	pSweep,
	pSweepLeft,
	pBugged,
	pVehicleKeys,
	pVehicleKeysFrom,
	pDuty,
	pCarLic,
	pFlyLic,
	pBoatLic,
	pFishLic,
	pGunLic,
	pDivision,
	pLiveBanned,
	pTicketTime,
	pHeadValue,
	pContractBy[32],
	pContractDetail[64],
	pC4,
	pC4Get,
	pC4Used,
	pBombs,
	pCHits,
	pFHits,
	pPrisonedBy[MAX_PLAYER_NAME],
	pPrisonReason[128],
	pAcceptReport,
	pTrashReport,
	pAccent,
	pNMute,
	pNMuteTotal,
	pADMute,
	pADMuteTotal,
	pRMuted,
	pRMutedTotal,
	pRMutedTime,
	pSpeedo,
	pGCMuted,
	pGCMutedTime,
	pCallsAccepted,
	pHelper,
	pPatientsDelivered,
	pTriageTime,
	pMarried,
	pMarriedTo[MAX_PLAYER_NAME],
	pKillLog0[128],
	pKillLog1[128],
	pKillLog2[128],
	pKillLog3[128],
	pKillLog4[128],
	pKillLog5[128],
	pKillLog6[128],
	pKillLog7[128],
	pKillLog8[128],
	pKillLog9[128],
	pFlag[128],
	pReferredBy[MAX_PLAYER_NAME],
	pRefTokens,
	pRefTokensOffline,
	pWalkStyle,
	pGate1,
	pGate2,
	pGate3,
	pBlindfold,
	pGas,
	pBiz,
    pVBiz,
	pEmlak,
	pmka,
	eDuzenliyor,
}

//=== NEWS ===//
new PlayerInfo[MAX_PLAYERS + 1][pInfo];
new gInfo[MAX_GARAGES][garageInfo]; //This is used to access variable from our enumerator
new garageCount; //This will hold the total of loaded garages
new Float:GarageInteriors[][] = //This array holds the coordinates, facing angle and interior ID of the garages.
{
	{616.4642, -124.4003, 997.5993, 90.0, 3.0}, // Small garage
    {617.0011, -74.6962, 997.8426, 90.0, 2.0}, // Medium garage
    {606.4268, -9.9375, 1000.7485, 270.0, 1.0} //Big garage

};
new Text3D:garageLabel[MAX_GARAGES]; //Will hold the garage label
new garagePickup[MAX_GARAGES]; //Will hold the garage pickup
new lastGarage[MAX_PLAYERS]; //Will hold the last garage ID the player went in to
#if SAVING_SYS == 4 //To prevent 'variable not used' warnings and such
	new DB:Garages;
#endif
//=== PUBLICS ===//

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	printf(" MGaraj %s by Metehan yükleniyor..",SCRIPT_VERSION);
	print("                  ---                 \n");
	printf("    Garaj Kaydetme Þekli %d      ",SAVING_SYS);
	print("\n--------------------------------------");
	DoConnect(); //Connects the script to a database (if needed, automatically detected)
	Load_Garages(); //Loads all garages
	return 1;
}

public OnFilterScriptExit()
{
	Save_Garages();
	Remove_PickupsAndLabels();
	return 1;
}
forward Save_Garages();
public Save_Garages() //Saves all the garages, changed to a public because of the autosave timer
{
	#if SAVING_SYS == 1

	    for(new i=0; i < garageCount+1; i++)
		{
		    if(strcmp(gInfo[i][Owner],"REMOVED")) //If the garage is not deleted, save it.
			{
			    new path[64];
			    format(path,sizeof(path),"jgarage/y_ini/%d.ini",i);
		     	new INI:gfile = INI_Open(path);
		     	INI_WriteString(gfile, "Owner", gInfo[i][Owner]);
			    INI_WriteInt(gfile, "Owned", gInfo[i][Owned]);
		        INI_WriteInt(gfile, "Locked", gInfo[i][Locked]);
		        INI_WriteInt(gfile, "Price", gInfo[i][Price]);
		        INI_WriteFloat(gfile, "PosX", gInfo[i][PosX]);
		        INI_WriteFloat(gfile, "PosY", gInfo[i][PosY]);
		        INI_WriteFloat(gfile, "PosZ", gInfo[i][PosZ]);
		        INI_WriteInt(gfile,"Interior", gInfo[i][Interior]);
		        INI_WriteInt(gfile, "UID", gInfo[i][UID]);
				INI_Close(gfile);
			}
	    }

	#endif

	#if SAVING_SYS == 2

	    new path[64];
		for(new i=0; i < garageCount+1; i++)
		{
		    if(strcmp(gInfo[i][Owner],"REMOVED")) //If the garage is not deleted, save it.
			{
			    format(path,sizeof(path),"jgarage/dini/%d.ini",i); //Format the path with the filenumber
			    if(dini_Exists(path)) //If the file exists, save the data
			    {
			        dini_Set(path,"Owner",gInfo[i][Owner]);
					dini_IntSet(path,"Owned",gInfo[i][Owned]);
					dini_IntSet(path,"Locked",gInfo[i][Locked]);
					dini_IntSet(path,"Price",gInfo[i][Price]);
					dini_FloatSet(path,"PosX",gInfo[i][PosX]);
					dini_FloatSet(path,"PosY",gInfo[i][PosY]);
					dini_FloatSet(path,"PosZ",gInfo[i][PosZ]);
					dini_IntSet(path,"Interior",gInfo[i][Interior]);
					dini_IntSet(path,"UID",gInfo[i][UID]);
				}
			}
		}

	#endif

	#if SAVING_SYS == 3

		for(new i=0; i < garageCount+1; i++)
		{
			new sql[256];
			format(sql,sizeof(sql),"UPDATE `garages` SET \
			`Owner`='%s',\
			`Owned`='%d',\
			`Locked`='%d',\
			`Price`='%d',\
			`PosX`='%f',\
			`PosY`='%f',\
			`PosZ`='%f',\
			`Interior`='%d',\
			`UID`='%d'\
			WHERE `UID`='%d'",
			gInfo[i][Owner],
			gInfo[i][Owned],
			gInfo[i][Locked],
			gInfo[i][Price],
			gInfo[i][PosX],
			gInfo[i][PosY],
			gInfo[i][PosZ],
	        gInfo[i][Interior],
			gInfo[i][UID],
			gInfo[i][UID]);
			mysql_query(sql);
		}
	#endif

	#if SAVING_SYS == 4

 		for(new i=0; i < garageCount+1; i++)
		{
	    	new sql[256];
			format(sql,sizeof(sql),"UPDATE `garages` SET \
			`Owner`='%s',\
			`Owned`='%d',\
			`Locked`='%d',\
			`Price`='%d',\
			`PosX`='%f',\
			`PosY`='%f',\
			`PosZ`='%f',\
			`Interior`='%d',\
			`UID`='%d'\
			WHERE `UID`='%d'",
			gInfo[i][Owner],
			gInfo[i][Owned],
			gInfo[i][Locked],
			gInfo[i][Price],
			gInfo[i][PosX],
			gInfo[i][PosY],
			gInfo[i][PosZ],
	        gInfo[i][Interior],
			gInfo[i][UID],
			gInfo[i][UID]);
	    	db_free_result(db_query(Garages, sql));
		}
    #endif

}
//=== STOCKS ===//
stock DoConnect()
{
    #if SAVING_SYS == 3
		mysql_debug(1);
		mysql_connect(HOST,USER,DataB,PASS);
	#endif

	#if SAVING_SYS == 4
        Garages = db_open("jgarage/garages.db");
	#endif
}
stock CreateGarage(gid)
{
    #if SAVING_SYS == 1
		Save_Garage(gid); //y_ini creates the file automatically, so we'll just call the save function here.
	#endif
	#if SAVING_SYS == 2
	    new path[64];
		format(path,sizeof(path),"jgarage/dini/%d.ini",gid); //Format the path with the filenumber
		dini_Create(path);
	#endif
	#if SAVING_SYS == 3
	    new sql[128];
		format(sql,sizeof(sql),"INSERT INTO `garages` (UID) VALUES ('%d')",gid); //Insert the UID into the SQL database, and save the data based on the UID
		mysql_query(sql);
	#endif
	#if SAVING_SYS == 4
	  	new sql[128];
		format(sql,sizeof(sql),"INSERT INTO `garages` (UID) VALUES ('%d')",gid); //Insert the UID into the SQL database, and save the data based on the UID
        db_free_result(db_query(Garages,sql));
	#endif

}

stock RemoveGarage(gid)
{
    #if SAVING_SYS == 1
        new path[64];
		format(path,sizeof(path),"jgarage/y_ini/%d.ini",gInfo[gid][UID]); //Format the path with the filenumber
		if(fexist(path)) fremove(path);
	#endif
	#if SAVING_SYS == 2
	   	new path[64];
		format(path,sizeof(path),"jgarage/dini/%d.ini",gInfo[gid][UID]); //Format the path with the filenumber
		dini_Remove(path);
	#endif
	#if SAVING_SYS == 3
	    new sql[128];
		format(sql,sizeof(sql),"DELETE FROM `garages` WHERE `UID`='%d'",gInfo[gid][UID]); //Format the removal query
		mysql_query(sql);
	#endif
	#if SAVING_SYS == 4
        new sql[128];
		format(sql,sizeof(sql),"DELETE FROM `garages` WHERE `UID`='%d'",gInfo[gid][UID]); //Format the removal query
		db_query(Garages,sql);
	#endif

}
stock CheckGarageAmount(playerid)
{
	new pName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
	new found = 0;
	for(new i=0; i < MAX_GARAGES; i++)
	{
	    if(!strcmp(gInfo[i][Owner],pName)) //If the player owns garage 'i', continue
	    {
	        found++;
	    }
	}
	if(found == MAX_OWNED_GARAGES) //If the player owns the max. amount of garages
	{
	    new out[128];
		format(out, 128,"Hata: Zaten %d tane garaj almýþsýn!",MAX_OWNED_GARAGES);
		SendClientMessage(playerid, COLOR_ERROR,out);
		return 1;
	}
	return 0;
}

stock Load_Garages() //Loads all garages
{
	garageCount = 1; //Make a debug garage
	#if SAVING_SYS == 1

		new path[64];
	    for(new i=1; i < MAX_GARAGES; i++) //Loop trough all garage slots
		{
		    	format(path, sizeof(path), "jgarage/y_ini/%d.ini",i);
		        INI_ParseFile(path, "YINI_LoadGarageData", .bExtra = true, .extra = garageCount);
				if(fexist(path)) //To prevent unneeded action
				{
					//printf("DEBUG: %s %d %d %d %f %f %f %d %d",gInfo[garageCount][Owner],gInfo[garageCount][Owned],gInfo[garageCount][Locked],gInfo[garageCount][Price],gInfo[garageCount][PosX],gInfo[garageCount][PosY],gInfo[garageCount][PosZ],gInfo[garageCount][Interior],gInfo[garageCount][UID]);
					UpdateGarageInfo(garageCount);
		        	garageCount++;
		        }

		}
	#endif

	#if SAVING_SYS == 2


		new path[64];
		for(new i=1; i < MAX_GARAGES; i++) //Loop trough all garage slots
		{
		    format(path,sizeof(path),"jgarage/dini/%d.ini",i); //Format the path with the filenumber
		    if(dini_Exists(path)) //If the file exists, load the data
		    {
		        format(gInfo[i][Owner],24,"%s",dini_Get(path,"Owner"));
		        gInfo[i][Owned] = dini_Int(path,"Owned");
		        gInfo[i][Locked] = dini_Int(path,"Locked");
		        gInfo[i][Price] = dini_Int(path,"Price");
			    gInfo[i][PosX] = dini_Float(path,"PosX");
			    gInfo[i][PosY] = dini_Float(path,"PosY");
			    gInfo[i][PosZ] = dini_Float(path,"PosZ");
			    gInfo[i][Interior] = dini_Int(path,"Interior");
			    gInfo[i][UID] = dini_Int(path,"UID");
			    //printf("DEBUG: %s %d %d %d %f %f %f %d %d",gInfo[i][Owner],gInfo[i][Owned],gInfo[i][Locked],gInfo[i][Price],gInfo[i][PosX],gInfo[i][PosY],gInfo[i][PosZ],gInfo[i][Interior],gInfo[i][UID]);
			    UpdateGarageInfo(i);
			    garageCount++;
			}
		}

	#endif


	#if SAVING_SYS == 3

		new sql[128] = "SELECT * FROM `garages`";
		new i;
		mysql_query(sql);
		mysql_store_result();
		while(mysql_fetch_row(sql))
		{

		 	sscanf(sql, "e<p<|>s[24]dddfffdd>", gInfo[i]);
		 	//printf("DEBUG: %s %d %d %d %f %f %f %d %d",gInfo[i][Owner],gInfo[i][Owned],gInfo[i][Locked],gInfo[i][Price],gInfo[i][PosX],gInfo[i][PosY],gInfo[i][PosZ],gInfo[i][Interior],gInfo[i][UID]);
			UpdateGarageInfo(i);
			garageCount++;
			i++;

		}
		mysql_free_result();

	#endif

	#if SAVING_SYS == 4

		new DBResult: Result;
        new Query[128] = "SELECT * FROM `garages`";
		Result = db_query(Garages, Query);
		new amnt = db_num_rows(Result);

        for(new i=1; i < amnt; i++)
    	{

	            db_get_field_assoc(Result,"Owner", Query, sizeof(Query));
	            format(gInfo[i][Owner],MAX_PLAYER_NAME,"%s",Query);
	            db_get_field_assoc(Result,"Owned", Query, sizeof(Query));
	            gInfo[i][Owned] = strval(Query);
	            db_get_field_assoc(Result,"Locked", Query, sizeof(Query));
	            gInfo[i][Locked] = strval(Query);
	            db_get_field_assoc(Result,"Price", Query, sizeof(Query));
	            gInfo[i][Price] = strval(Query);
	            db_get_field_assoc(Result,"PosX", Query, sizeof(Query));
	            gInfo[i][PosX] = floatstr(Query);
	            db_get_field_assoc(Result,"PosY", Query, sizeof(Query));
				gInfo[i][PosY] = floatstr(Query);
	            db_get_field_assoc(Result,"PosZ", Query, sizeof(Query));
				gInfo[i][PosZ] = floatstr(Query);
				db_get_field_assoc(Result,"Interior", Query, sizeof(Query));
				gInfo[i][Interior] = strval(Query);
				db_get_field_assoc(Result,"UID", Query, sizeof(Query));
				gInfo[i][UID] = strval(Query);
	            //printf("DEBUG: %s %d %d %d %f %f %f %d %d",gInfo[i][Owner],gInfo[i][Owned],gInfo[i][Locked],gInfo[i][Price],gInfo[i][PosX],gInfo[i][PosY],gInfo[i][PosZ],gInfo[i][Interior],gInfo[i][UID]);
                UpdateGarageInfo(i);
				garageCount++;
	            db_next_row(Result);
       	}
        db_free_result(Result);

	#endif
	printf("[jGarage]: Loaded %d garages.",garageCount-1); //The debug garage isn't a real garage, so we take 1 away
	garageCount++; //To prevent overwriting/not detecting of garages

	#if AUTOSAVE == true
		SetTimer("Save_Garages",AUTOSAVE_INTERVAL*1000,true); //Start the autosave timer if enabled
	#endif
}
#if SAVING_SYS == 1

	forward YINI_LoadGarageData(garageID, name[], value[]);
	public YINI_LoadGarageData(garageID, name[], value[])
	{

	    INI_String("Owner",gInfo[garageID][Owner], MAX_PLAYER_NAME);
	    INI_Int("Owned", gInfo[garageID][Owned]);
	    INI_Int("Locked", gInfo[garageID][Locked]);
	    INI_Int("Price", gInfo[garageID][Price]);
	    INI_Float("PosX",  gInfo[garageID][PosX]);
	    INI_Float("PosY",  gInfo[garageID][PosY]);
	    INI_Float("PosZ",  gInfo[garageID][PosZ]);
        INI_Int("Interior", gInfo[garageID][Interior]);
		INI_Int("UID", gInfo[garageID][UID]);
	    return 1;
	}

#endif

stock Save_Garage(gid) //Saves a specific garage
{
    #if SAVING_SYS == 1

	    new path[64];
	    format(path,sizeof(path),"jgarage/y_ini/%d.ini",gid);
     	new INI:gfile = INI_Open(path);
     	INI_WriteString(gfile, "Owner", gInfo[gid][Owner]);
	    INI_WriteInt(gfile, "Owned", gInfo[gid][Owned]);
        INI_WriteInt(gfile, "Locked", gInfo[gid][Locked]);
        INI_WriteInt(gfile, "Price", gInfo[gid][Price]);
        INI_WriteFloat(gfile, "PosX", gInfo[gid][PosX]);
        INI_WriteFloat(gfile, "PosY", gInfo[gid][PosY]);
        INI_WriteFloat(gfile, "PosZ", gInfo[gid][PosZ]);
        INI_WriteInt(gfile,"Interior", gInfo[gid][Interior]);
        INI_WriteInt(gfile, "UID", gInfo[gid][UID]);
		INI_Close(gfile);

	#endif

    #if SAVING_SYS == 2

	    new path[64];
		format(path,sizeof(path),"jgarage/dini/%d.ini",gid); //Format the path with the filenumber
		if(dini_Exists(path)) //If the file exists, save the data
	    {
	        dini_Set(path,"Owner",gInfo[gid][Owner]);
			dini_IntSet(path,"Owned",gInfo[gid][Owned]);
			dini_IntSet(path,"Locked",gInfo[gid][Locked]);
			dini_IntSet(path,"Price",gInfo[gid][Price]);
			dini_FloatSet(path,"PosX",gInfo[gid][PosX]);
			dini_FloatSet(path,"PosY",gInfo[gid][PosY]);
			dini_FloatSet(path,"PosZ",gInfo[gid][PosZ]);
			dini_IntSet(path,"Interior",gInfo[gid][Interior]);
			dini_IntSet(path,"UID",gInfo[gid][UID]);
		}
 	#endif

 	#if SAVING_SYS == 3

		new sql[256];
		format(sql,sizeof(sql),"UPDATE `garages` SET \
		`Owner`='%s',\
		`Owned`='%d',\
		`Locked`='%d',\
		`Price`='%d',\
		`PosX`='%f',\
		`PosY`='%f',\
		`PosZ`='%f',\
		`Interior`='%d',\
		`UID`='%d'\
		WHERE `UID`='%d'",
		gInfo[gid][Owner],
		gInfo[gid][Owned],
		gInfo[gid][Locked],
		gInfo[gid][Price],
		gInfo[gid][PosX],
		gInfo[gid][PosY],
		gInfo[gid][PosZ],
		gInfo[gid][Interior],
		gInfo[gid][UID],
		gInfo[gid][UID]);
		mysql_query(sql);

	#endif

	#if SAVING_SYS == 4

		new sql[256];
		format(sql,sizeof(sql),"UPDATE `garages` SET \
		`Owner`='%s',\
		`Owned`='%d',\
		`Locked`='%d',\
		`Price`='%d',\
		`PosX`='%f',\
		`PosY`='%f',\
		`PosZ`='%f',\
		`Interior`='%d',\
		`UID`='%d'\
		WHERE `UID`='%d'",
		gInfo[gid][Owner],
		gInfo[gid][Owned],
		gInfo[gid][Locked],
		gInfo[gid][Price],
		gInfo[gid][PosX],
		gInfo[gid][PosY],
		gInfo[gid][PosZ],
        gInfo[gid][Interior],
		gInfo[gid][UID],
		gInfo[gid][UID]);
    	db_free_result(db_query(Garages, sql));

	#endif
}
stock UpdateGarageInfo(gid) //Updates/creates the garage text and label
{
	//Get rid of the old label and pickup (if existing)
	DestroyDynamic3DTextLabel(garageLabel[gid]);
	DestroyDynamicPickup(garagePickup[gid]);

	//Re-create them with the correct data
	new ltext[128];
	if(gInfo[gid][Owned] == 1) //If the garage is owned
	{
	    format(ltext,128,GARAGE_OWNED_TEXT,gInfo[gid][Owner],GetLockedStatus(gInfo[gid][Locked]));
	    garageLabel[gid] = CreateDynamic3DTextLabel(ltext, TXTCOLOR, gInfo[gid][PosX],gInfo[gid][PosY],gInfo[gid][PosZ]+0.1,DD);
	    garagePickup[gid] = CreateDynamicPickup(GARAGE_OWNED_PICKUP,1,gInfo[gid][PosX],gInfo[gid][PosY],gInfo[gid][PosZ]+0.2);
	}
	if(gInfo[gid][Owned] == 0)
	{
	    format(ltext,128,GARAGE_FREE_TEXT,gInfo[gid][Price]);
	    garageLabel[gid] = CreateDynamic3DTextLabel(ltext, TXTCOLOR, gInfo[gid][PosX],gInfo[gid][PosY],gInfo[gid][PosZ]+0.1,DD);
	    garagePickup[gid] = CreateDynamicPickup(GARAGE_FREE_PICKUP,1,gInfo[gid][PosX],gInfo[gid][PosY],gInfo[gid][PosZ]);
	}
}
stock GetLockedStatus(value) //Returns 'Locked' or 'Unlocked' according to the value given
{
	new out[64];
	if(value == 1)
	{
	    out = "Kilitli";
	}
	else
	{
	    out = "Kilidi Açýk";
	}
	return out;
}
stock GetPlayerNameEx(playerid)
{
	new pName[24];
	GetPlayerName(playerid,pName,24);
	return pName;
}
stock Remove_PickupsAndLabels()
{
	for(new i=0; i < garageCount+1; i++)
	{
	    DestroyDynamic3DTextLabel(garageLabel[i]);
	    DestroyDynamicPickup(garagePickup[i]);
	}
}
stock DeductGarageMoney(gid)
{
	if(gInfo[gid][Price] > 100)
    {
		gInfo[gid][Price]-= random(101);
	}
	if(gInfo[gid][Price] < 100) //If the garage has reached it's lowest possible value, 'reset' it to 1200 to prevent price in minus
	{
        gInfo[gid][Price] = 1200;
	}
}
//=== COMMANDS ===//

#if COMMAND_SYS == 1
/*
	CMD:garagehelp(playerid,params[])
	{
		SendClientMessage(playerid, COLOR_ORANGE, "Garaj komutlarý:");
		if(!IsPlayerAdmin(playerid))
		{
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "/ggir | /gcik | /garajkilit | /garajal | /garajsat");
		}
		else
		{
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "/golustur | /gsil | /gtip | /ggir | /gcik | /garajkilit | /garajal | /garajsat");
		}
		return 1;
	}*/
	CMD:gtip(playerid,params[])
	{
	    if(!IsPlayerAdmin(playerid)) return 0;
	    SendClientMessage(playerid, COLOR_ORANGE, "jGarage info - Garage types");
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "Type 0: Small garage");
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "Type 1: Medium garage");
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "Type 2: Big garage");
		return 1;
	}
	CMD:golustur(playerid,params[])
	{
		if(!IsPlayerAdmin(playerid)) return 0;
		if(garageCount == MAX_GARAGES) return SendClientMessage(playerid, COLOR_USAGE, "Garaj oluþturma sýnýrýna ulaþtýnýz.");
		new price, type;
		if(sscanf(params,"dd",price, type)) return SendClientMessage(playerid, COLOR_USAGE, "Usage: /golustur <fiyat> <tip>  || Use /garagetypes for a list of garage types.");
		new Float:X, Float:Y, Float:Z;
		GetPlayerPos(playerid, X,Y,Z);
		format(gInfo[garageCount][Owner],24,"the State");
		gInfo[garageCount][Owned] = 0;
		gInfo[garageCount][Price] = price;
		gInfo[garageCount][Interior] = type;
		gInfo[garageCount][UID] = garageCount;
		gInfo[garageCount][PosX] = X;
		gInfo[garageCount][PosY] = Y;
		gInfo[garageCount][PosZ] = Z;
		gInfo[garageCount][Locked] = 1;
		CreateGarage(garageCount);
		Save_Garage(garageCount);
		UpdateGarageInfo(garageCount);
		garageCount++;
		SendClientMessage(playerid,COLOR_SUCCESS,"Garaj oluþturuldu!");
		return 1;
	}
	CMD:gsil(playerid,params[])
	{
	    if(!IsPlayerAdmin(playerid)) return 0;
	    for(new i=0; i < garageCount+1; i++)
		{
		    if(IsPlayerInRangeOfPoint(playerid, 3.0, gInfo[i][PosX], gInfo[i][PosY], gInfo[i][PosZ]))
		    {
				RemoveGarage(i);
			    format(gInfo[i][Owner],24,"REMOVED");
				gInfo[i][Owned] = -999;
				gInfo[i][Price] = -999;
				gInfo[i][Interior] = -999;
				gInfo[i][UID] = -999;
				gInfo[i][PosX] = -999;
				gInfo[i][PosY] = -999;
				gInfo[i][PosZ] = -999;
				gInfo[i][Locked] = -999;
				DestroyDynamic3DTextLabel(garageLabel[i]);
		    	DestroyDynamicPickup(garagePickup[i]);
				SendClientMessage(playerid, COLOR_SUCCESS, "Bu Garajý Sildin.");
				return 1;
			}
		}
		SendClientMessage(playerid, COLOR_ERROR,"Hata: Yakýnýnda Garaj yok.");
		return 1;
	}
	CMD:ggir(playerid,params[])
	{
		for(new i=0; i < garageCount+1; i++)
		{
		    if(IsPlayerInRangeOfPoint(playerid, 3.0, gInfo[i][PosX], gInfo[i][PosY], gInfo[i][PosZ]))
		    {

		        if(gInfo[i][Locked] == 1 && strcmp(GetPlayerNameEx(playerid),gInfo[i][Owner])) return SendClientMessage(playerid,COLOR_ERROR,"Hata: Bu garaj kilitli durumda !");
		        new gtype = gInfo[i][Interior];
		       	if(!IsPlayerInAnyVehicle(playerid))
				{
					SetPlayerVirtualWorld(playerid,gInfo[i][UID]);
					SetPlayerInterior(playerid,floatround(GarageInteriors[gtype][4]));
					SetPlayerPos(playerid,GarageInteriors[gtype][0],GarageInteriors[gtype][1],GarageInteriors[gtype][2]);
					lastGarage[playerid] = i;
				}
				else
				{
					new vid = GetPlayerVehicleID(playerid);
				    LinkVehicleToInterior(vid,floatround(GarageInteriors[gtype][4]));
				    SetVehicleVirtualWorld(vid,gInfo[i][UID]);
	                SetPlayerVirtualWorld(playerid,gInfo[i][UID]);
					SetPlayerInterior(playerid,floatround(GarageInteriors[gtype][4]));
					SetVehiclePos(vid,GarageInteriors[gtype][0],GarageInteriors[gtype][1],GarageInteriors[gtype][2]);
					lastGarage[playerid] = i;
				}
				return 1;

			}
		}
		SendClientMessage(playerid,COLOR_ERROR,"Hata: Herhangi bir garajýn yanýnda deðilsin. ");
		return 1;
	}
	CMD:gcik(playerid,params[])
	{
		if(lastGarage[playerid] >= 0)
	 	{
		    new lg = lastGarage[playerid];
		    if(!IsPlayerInAnyVehicle(playerid))
		    {
		    	SetPlayerPos(playerid,gInfo[lg][PosX],gInfo[lg][PosY],gInfo[lg][PosZ]);
		    	SetPlayerInterior(playerid,0);
		    	SetPlayerVirtualWorld(playerid,0);
			}
			else
			{
			    new vid = GetPlayerVehicleID(playerid);
				LinkVehicleToInterior(vid,0);
				SetVehicleVirtualWorld(vid,0);
				SetVehiclePos(vid,gInfo[lg][PosX],gInfo[lg][PosY],gInfo[lg][PosZ]);
			    SetPlayerVirtualWorld(playerid,0);
			    SetPlayerInterior(playerid,0);
			}
			lastGarage[playerid] = -999;
		}
		else return SendClientMessage(playerid,COLOR_ERROR,"Hata: Herhangi bir garajýn yanýnda deðilsin. ");
		return 1;
	}

	CMD:garajal(playerid, params[])
	{
	    for(new i=0; i < garageCount+1; i++)
		{
	  		if(IsPlayerInRangeOfPoint(playerid, 3.0, gInfo[i][PosX], gInfo[i][PosY], gInfo[i][PosZ]))
	  		{
				if(gInfo[i][Owned] == 1) return SendClientMessage(playerid, COLOR_ERROR,"Hata: Bu garaj zaten alýnmýþ !");
				if(CheckGarageAmount(playerid) == 1) return 1; //Check if the player owns the max amount of garages
				if(GetPlayerMoney(playerid) < gInfo[i][Price]) return SendClientMessage(playerid,COLOR_ERROR,"Hata: Garajý alacak paran yok");
				GivePlayerCash(playerid,-gInfo[i][Price]);
				DeductGarageMoney(i); //Take some money off of the original price
				format(gInfo[i][Owner],24,"%s",GetPlayerNameEx(playerid));
				gInfo[i][Owned] = 1;
				Save_Garage(i);
				UpdateGarageInfo(i);
				SendClientMessage(playerid,COLOR_SUCCESS,"Bu garajý baþarýyla satýn aldýn.");
				return 1;
	  		}
		}
		SendClientMessage(playerid,COLOR_ERROR,"Hata: Herhangi bir garajýn yanýnda deðilsin. ");
		return 1;
	}
	CMD:garajkilit(playerid,params[])
	{
		for(new i=0; i < garageCount+1; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, gInfo[i][PosX], gInfo[i][PosY], gInfo[i][PosZ]))
	  		{
				if(strcmp(gInfo[i][Owner],GetPlayerNameEx(playerid))) return SendClientMessage(playerid,COLOR_ERROR,"Hata: Bu garaj sana ait deðil.");
				if(gInfo[i][Locked] == 1)
				{
				    gInfo[i][Locked] = 0;
				    UpdateGarageInfo(i);
				    Save_Garage(i);
	                SendClientMessage(playerid,COLOR_SUCCESS,"Garajýnýn kilidini açtýn.");
				    return 1;
				}
				else
				{
				    gInfo[i][Locked] = 1;
				    UpdateGarageInfo(i);
	                Save_Garage(i);
	                SendClientMessage(playerid,COLOR_SUCCESS,"Garajýný kilitledin.");
				    return 1;
				}
		 	}
		}
		SendClientMessage(playerid,COLOR_ERROR,"Hata: Herhangi bir garajýn yanýnda deðilsin. ");
		return 1;
	}
	CMD:garajsat(playerid,params[])
	{
		for(new i=0; i < garageCount+1; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, gInfo[i][PosX], gInfo[i][PosY], gInfo[i][PosZ]))
	    	{
				if(strcmp(gInfo[i][Owner],GetPlayerNameEx(playerid))) return SendClientMessage(playerid,COLOR_ERROR,"Hata: Bu garaj sana ait deðil.");
				GivePlayerCash(playerid,gInfo[i][Price]-random(500));
				gInfo[i][Owned] = 0;
				format(gInfo[i][Owner],24,"the State");
				gInfo[i][Locked] = 1;
				UpdateGarageInfo(i);
				Save_Garage(i);
				SendClientMessage(playerid, COLOR_SUCCESS,"Garajýný baþarýyla sattýn.");
			   	return 1;
			  }
		}
		SendClientMessage(playerid, COLOR_ERROR,"Hata: Herhangi bir garajýn yanýnda deðilsin. ");
		return 1;
	}
#endif

#if COMMAND_SYS == 2

    public OnPlayerCommandText(playerid, cmdtext[])
	{
		if(strcmp("/garagehelp", cmdtext, true, 11) == 0)
		{
			SendClientMessage(playerid, COLOR_ORANGE, "jGarage commands:");
			if(!IsPlayerAdmin(playerid))
			{
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "/genter | /gexit | /lockgarage | /buygarage | /sellgarage");
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "/creategarage | /removegarage | /garagetypes | /genter | /gexit | /lockgarage | /buygarage | /sellgarage");
			}
			return 1;
		}
		if(strcmp("/garagetypes", cmdtext, true, 12) == 0)
		{
		    if(!IsPlayerAdmin(playerid)) return 0;
		    SendClientMessage(playerid, COLOR_ORANGE, "jGarage info - Garage types");
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Type 0: Small garage");
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Type 1: Medium garage");
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Type 2: Big garage");
			return 1;
		}
		if(strcmp("/creategarage", cmdtext, true, 13) == 0)
		{
			if(!IsPlayerAdmin(playerid)) return 0;
			if(garageCount == MAX_GARAGES) return SendClientMessage(playerid, COLOR_USAGE, "The max. amount of garages is reached. Increase the limit in the jGarage filterscript.");
			new price, type;
			if(sscanf(cmdtext[14],"dd",price, type)) return SendClientMessage(playerid, COLOR_USAGE, "Usage: /creategarage <price> <type>  || Use /garagetypes for a list of garage types.");
			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(playerid, X,Y,Z);
			format(gInfo[garageCount][Owner],24,"the State");
			gInfo[garageCount][Owned] = 0;
			gInfo[garageCount][Price] = price;
			gInfo[garageCount][Interior] = type;
			gInfo[garageCount][UID] = garageCount;
			gInfo[garageCount][PosX] = X;
			gInfo[garageCount][PosY] = Y;
			gInfo[garageCount][PosZ] = Z;
			gInfo[garageCount][Locked] = 1;
			CreateGarage(garageCount);
			Save_Garage(garageCount);
			UpdateGarageInfo(garageCount);
			garageCount++;
			SendClientMessage(playerid,COLOR_SUCCESS,"Garage created!");
			return 1;
		}
		if(strcmp("/removegarage", cmdtext, true, 13) == 0)
		{
		    if(!IsPlayerAdmin(playerid)) return 0;
		    for(new i=0; i < garageCount+1; i++)
			{
			    if(IsPlayerInRangeOfPoint(playerid, 3.0, gInfo[i][PosX], gInfo[i][PosY], gInfo[i][PosZ]))
			    {
			        format(gInfo[i][Owner],24,"REMOVED");
					gInfo[i][Owned] = -999;
					gInfo[i][Price] = -999;
					gInfo[i][Interior] = -999;
					gInfo[i][UID] = -999;
					gInfo[i][PosX] = -999;
					gInfo[i][PosY] = -999;
					gInfo[i][PosZ] = -999;
					gInfo[i][Locked] = -999;
					DestroyDynamic3DTextLabel(garageLabel[i]);
			    	DestroyDynamicPickup(garagePickup[i]);
     				RemoveGarage(i);
					SendClientMessage(playerid, COLOR_SUCCESS, "You have removed this garage.");
					return 1;
				}
			}
			SendClientMessage(playerid, COLOR_ERROR,"Hata: You're not near any garage.");
			return 1;
		}
		if(strcmp("/genter", cmdtext, true, 7) == 0)
		{
			for(new i=0; i < garageCount+1; i++)
			{
			    if(IsPlayerInRangeOfPoint(playerid, 3.0, gInfo[i][PosX], gInfo[i][PosY], gInfo[i][PosZ]))
			    {

			        if(gInfo[i][Locked] == 1 && strcmp(GetPlayerNameEx(playerid),gInfo[i][Owner])) return SendClientMessage(playerid,COLOR_ERROR,"Hata: You're not the owner of this garage. It's locked, you can't enter.");
			        new gtype = gInfo[i][Interior];
			       	if(!IsPlayerInAnyVehicle(playerid))
					{
						SetPlayerVirtualWorld(playerid,gInfo[i][UID]);
						SetPlayerInterior(playerid,floatround(GarageInteriors[gtype][4]));
						SetPlayerPos(playerid,GarageInteriors[gtype][0],GarageInteriors[gtype][1],GarageInteriors[gtype][2]);
						lastGarage[playerid] = i;
					}
					else
					{
						new vid = GetPlayerVehicleID(playerid);
					    LinkVehicleToInterior(vid,floatround(GarageInteriors[gtype][4]));
					    SetVehicleVirtualWorld(vid,gInfo[i][UID]);
		                SetPlayerVirtualWorld(playerid,gInfo[i][UID]);
						SetPlayerInterior(playerid,floatround(GarageInteriors[gtype][4]));
						SetVehiclePos(vid,GarageInteriors[gtype][0],GarageInteriors[gtype][1],GarageInteriors[gtype][2]);
						lastGarage[playerid] = i;
					}
					return 1;

				}
			}
			SendClientMessage(playerid,COLOR_ERROR,"Hata: You're not near any garage. ");
			return 1;
		}
		if(strcmp("/gexit", cmdtext, true, 6) == 0)
		{
			if(lastGarage[playerid] >= 0)
		 	{
			    new lg = lastGarage[playerid];
			    if(!IsPlayerInAnyVehicle(playerid))
			    {
			    	SetPlayerPos(playerid,gInfo[lg][PosX],gInfo[lg][PosY],gInfo[lg][PosZ]);
			    	SetPlayerInterior(playerid,0);
			    	SetPlayerVirtualWorld(playerid,0);
				}
				else
				{
				    new vid = GetPlayerVehicleID(playerid);
					LinkVehicleToInterior(vid,0);
					SetVehicleVirtualWorld(vid,0);
					SetVehiclePos(vid,gInfo[lg][PosX],gInfo[lg][PosY],gInfo[lg][PosZ]);
				    SetPlayerVirtualWorld(playerid,0);
				    SetPlayerInterior(playerid,0);
				}
				lastGarage[playerid] = -999;
			}
			else return SendClientMessage(playerid,COLOR_ERROR,"Hata: You're not in any garage.");
			return 1;
		}

		if(strcmp("/buygarage", cmdtext, true, 10) == 0)
		{
		    for(new i=0; i < garageCount+1; i++)
			{
		  		if(IsPlayerInRangeOfPoint(playerid, 3.0, gInfo[i][PosX], gInfo[i][PosY], gInfo[i][PosZ]))
		  		{
					if(gInfo[i][Owned] == 1) return SendClientMessage(playerid, COLOR_ERROR,"Hata: This garage is already owned.");
					if(GetPlayerMoney(playerid) < gInfo[i][Price]) return SendClientMessage(playerid,COLOR_ERROR,"Hata: You don't have enough money to buy this garage.");
					GivePlayerCash(playerid,-gInfo[i][Price]);
					DeductGarageMoney(i); //Take some money off of the original price
					format(gInfo[i][Owner],24,"%s",GetPlayerNameEx(playerid));
					gInfo[i][Owned] = 1;
					Save_Garage(i);
					UpdateGarageInfo(i);
					SendClientMessage(playerid,COLOR_SUCCESS,"You have successfully bought this garage.");
					return 1;
		  		}
			}
			SendClientMessage(playerid,COLOR_ERROR,"Hata: You're not near any garage.");
			return 1;
		}
		if(strcmp("/lockgarage", cmdtext, true, 10) == 0)
		{
			for(new i=0; i < garageCount+1; i++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 3.0, gInfo[i][PosX], gInfo[i][PosY], gInfo[i][PosZ]))
		  		{
					if(strcmp(gInfo[i][Owner],GetPlayerNameEx(playerid))) return SendClientMessage(playerid,COLOR_ERROR,"Hata: You're not the owner of this garage.");
					if(gInfo[i][Locked] == 1)
					{
					    gInfo[i][Locked] = 0;
					    UpdateGarageInfo(i);
					    Save_Garage(i);
		                SendClientMessage(playerid,COLOR_SUCCESS,"You have unlocked your garage.");
					    return 1;
					}
					else
					{
					    gInfo[i][Locked] = 1;
					    UpdateGarageInfo(i);
		                Save_Garage(i);
		                SendClientMessage(playerid,COLOR_SUCCESS,"You have locked your garage.");
					    return 1;
					}
			 	}
			}
			SendClientMessage(playerid,COLOR_ERROR,"Hata: You're not near any garage.");
			return 1;
		}
		if(strcmp("/sellgarage", cmdtext, true, 11) == 0)
		{
			for(new i=0; i < garageCount+1; i++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 3.0, gInfo[i][PosX], gInfo[i][PosY], gInfo[i][PosZ]))
		    	{
					if(strcmp(gInfo[i][Owner],GetPlayerNameEx(playerid))) return SendClientMessage(playerid,COLOR_ERROR,"Hata: You're not the owner of this garage.");
					GivePlayerCash(playerid,gInfo[i][Price]-random(500));
					gInfo[i][Owned] = 0;
					format(gInfo[i][Owner],24,"the State");
					gInfo[i][Locked] = 1;
					UpdateGarageInfo(i);
					Save_Garage(i);
					SendClientMessage(playerid, COLOR_SUCCESS,"You have successfully sold your garage.");
				   	return 1;
				  }
			}
			SendClientMessage(playerid, COLOR_ERROR,"You're not near any garage.");
			return 1;
		}
		return 0;
	}
#endif

