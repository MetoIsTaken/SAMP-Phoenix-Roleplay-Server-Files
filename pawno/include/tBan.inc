/*
	tBan - Süreli Ban Sistemi
	Yapýmcý: Trollface
	
	native tBan_Banla(playerid, sebep[], gun);
	native tBan_BanKaldir(isim[]);
	native OyuncuBanlandi(playerid, sebep[], gun);
	native OyuncuBaniAcildi(playerid);
*/

#include	<YSI\y_ini>

#undef		MAX_PLAYERS
#define 	MAX_PLAYERS		(24)

enum tban_enum 
{
	tb_Isim[MAX_PLAYER_NAME],
	tb_Sebep[32],
	tb_Sure
};

new tBanEnum[MAX_PLAYERS][tban_enum];

stock tban_date(timestamp, _form=0) // http://forum.sa-mp.com/showthread.php?t=330861
{
    /*
        ~ convert a Timestamp to a Date.
        ~ 10.07.2009

        date( 1247182451 )  will print >> 09.07.2009-23:34:11
        date( 1247182451, 1) will print >> 09/07/2009, 23:34:11
        date( 1247182451, 2) will print >> July 09, 2009, 23:34:11
        date( 1247182451, 3) will print >> 9 Jul 2009, 23:34
    */
    new year=1970, day=0, month=0, hour=0, mins=0, sec=0;

    new days_of_month[12] = { 31,28,31,30,31,30,31,31,30,31,30,31 };
    new names_of_month[12][10] = {"January","February","March","April","May","June","July","August","September","October","November","December"};
    new returnstring[32];

    while(timestamp>31622400){
        timestamp -= 31536000;
        if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) ) timestamp -= 86400;
        year++;
    }

    if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) )
        days_of_month[1] = 29;
    else
        days_of_month[1] = 28;


    while(timestamp>86400){
        timestamp -= 86400, day++;
        if(day==days_of_month[month]) day=0, month++;
    }

    while(timestamp>60){
        timestamp -= 60, mins++;
        if( mins == 60) mins=0, hour++;
    }

    sec=timestamp;

    switch( _form ){
        case 1: format(returnstring, 31, "%02d/%02d/%d %02d:%02d:%02d", day+1, month+1, year, hour, mins, sec);
        case 2: format(returnstring, 31, "%s %02d, %d, %02d:%02d:%02d", names_of_month[month],day+1,year, hour, mins, sec);
        case 3: format(returnstring, 31, "%d %c%c%c %d, %02d:%02d", day+1,names_of_month[month][0],names_of_month[month][1],names_of_month[month][2], year,hour,mins);

        default: format(returnstring, 31, "%02d.%02d.%d-%02d:%02d:%02d", day+1, month+1, year, hour, mins, sec);
    }

    return returnstring;
}

stock tBan_Banla(playerid, sebep[], gun)
{
	new tban_dosya[64], acilis = gettime()+(gun*86400);
	format(tban_dosya, sizeof(tban_dosya), "tBan/ban_%s.ban", tBanEnum[playerid][tb_Isim]);
	
	format(tBanEnum[playerid][tb_Sebep], 32, "%s", sebep);
	tBanEnum[playerid][tb_Sure] = acilis;
	
	new INI: Banla = INI_Open(tban_dosya);
	INI_WriteString(Banla, "Sebep", sebep);
	INI_WriteInt(Banla, "Sure", acilis);
	INI_Close(Banla);
	
	CallLocalFunction("OyuncuBanlandi", "isi", playerid, sebep, gun);

	new string[256];
	format(string, sizeof(string), "Sunucudan uzaklaþtýrýldýnýz.\n\nSebep: %s\nAçýlma Tarihi: %s\n\nEðer cezanýz haksýzsa, yönetimle iletiþime geçin.",
	tBanEnum[playerid][tb_Sebep], tban_date(tBanEnum[playerid][tb_Sure]));
	ShowPlayerDialog(playerid, 32700, DIALOG_STYLE_MSGBOX, "tBan", string, "Kapat", "");

	SetTimerEx("tBan_Kick", 100, false, "i", playerid);
	return 1;
}

stock tBan_BanKaldir(isim[])
{
	new tban_dosya[64];
	format(tban_dosya, sizeof(tban_dosya), "tBan/ban_%s.ban", isim);
	if(!fexist(tban_dosya)) return 0;
	fremove(tban_dosya);
	return 1;
}

forward public tBan_Yukle(playerid, name[], value[]);
public tBan_Yukle(playerid, name[], value[])
{
	INI_String("Sebep", tBanEnum[playerid][tb_Sebep], 32);
	INI_Int("Sure", tBanEnum[playerid][tb_Sure]);
	return 1;
}

forward public tBan_Kick(playerid);
public tBan_Kick(playerid)
{
	if(IsPlayerConnected(playerid)) Kick(playerid);
	return 1;
}

public OnPlayerConnect(playerid)
{
	new tban_dosya[64];
	GetPlayerName(playerid, tBanEnum[playerid][tb_Isim], MAX_PLAYER_NAME);
	
	format(tban_dosya, sizeof(tban_dosya), "tBan/ban_%s.ban", tBanEnum[playerid][tb_Isim]);
	if(fexist(tban_dosya)) {
		INI_ParseFile(tban_dosya, "tBan_Yukle", .bExtra = true, .extra = playerid);
		
		if(tBanEnum[playerid][tb_Sure] > gettime()) {
			new string[256];
			format(string, sizeof(string), "Sunucudan uzaklaþtýrýldýnýz.\n\nSebep: %s\nAçýlma Tarihi: %s\n\nEðer cezanýz haksýzsa, yönetimle iletiþime geçin.",
			tBanEnum[playerid][tb_Sebep], tban_date(tBanEnum[playerid][tb_Sure]));
			ShowPlayerDialog(playerid, 32700, DIALOG_STYLE_MSGBOX, "tBan", string, "Kapat", "");
			SetTimerEx("tBan_Kick", 100, false, "i", playerid);
		}else{
			CallLocalFunction("OyuncuBaniAcildi", "i", playerid);
			fremove(tban_dosya);
		}
	}
	
	if (funcidx("Ban_OnPlayerConnect") != -1)
    {
        return CallLocalFunction("Ban_OnPlayerConnect", "i", playerid);
    }
	return 1;
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Ban_OnPlayerConnect

forward Ban_OnPlayerConnect(playerid);
forward OyuncuBanlandi(playerid, sebep[], gun);
forward OyuncuBaniAcildi(playerid);
