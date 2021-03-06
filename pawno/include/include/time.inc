/*
*
*       -= LSR INCLUDE =-
*       Larceny Speed Radar
*
*       Autor: Larceny
*       Special Thanks to: Protioso ([VGS]Protioso_OC)
*       First    Release: 18, Setember, 2010 - V1.0.0
*   Fix      Release: 00, 00000000, 0000 - V1.1.0
*   Second   Release: 18, Setember, 2010 - V1.2.0
*       Third    Release: 19, Setember, 2010 - V1.3.0
*   Fix      Release: 00, 00000000, 0000 - V1.4.0
*   Fix      Release: 00, 00000000, 0000 - V1.5.0
*   Fix      Release: 00, 00000000, 0000 - V1.6.0
*   Fourth   Release: 20, Setember, 2010 - V1.7.0
*       Fifth    Release: 20, Setember, 2010 - V1.8.0
*   Sixth    Release: 22, October,  2010 - V1.9.0
*   Seven    Release: 27, December, 2010 - V2.0.0
*   Fix      Release: 29, December, 0000 - V2.1.0
*       Eight    Release: 01, January,  2010 - V2.1.1
*
*/
#include "a_samp"
 
#define MAX_Radar 100
#define LSR_TIME_CHECK 1500 // Time in miliseconds.
 
/*Function List -----------------------------------------------------------------------------||
 
native CreateRadar(Float:x, Float:y, Float:z, speedmax, radiation, pickup, activated, virtualword = -1);
native DestroyRadar(lrid);
native RadarExists(lrid);
native SetRadarPos(lrid, Float:x, Float:y, Float:z);
native SetRadarVirtualWorld(lrid, virtualworld);
native SetRadarActivate(lrid, toggle);
native SetRadarMaxSpeed(lrid, speed);
native SetRadarRadius(lrid, Float:radius);
native SetRadarPickup(lrid, pickupid);
native GetRadarPos(lrid, &Float:x, &Float:y, &Float:z);
native GetRadarVirtualWorld(lrid);
native LoadStaticRadarsFromFile(const filename[]);
native GetPlayerSpeed(playerid, bool:velo);
native GetVehicleSpeed(vehicleid);
native AttachRadarToPlayer(playerid, speedlimit);
native DettachRadarToPlayer(playerid);
native IsPlayerRadarAttached(playerid);
 
/------------------------------------------------------------------------------------------------------------||*/
 
enum lrdef
{
        LSR_VW,
        LSR_OID,
        Float:LSR_X,
        Float:LSR_Y,
        Float:LSR_Z,
        LSR_speedmax,
        LSR_radiation,
        LSR_pickup,
        LSR_activated
};
 
static  LSR_Timer, LSR_Total, LSR_Radar[MAX_Radar][lrdef];
 
#define LSR_CheckTimerAd() if(!LSR_Timer) LSR_Timer = SetTimer("CheckRadar", LSR_TIME_CHECK, 1)
#define LSR_CheckTimerRe() if(!LSR_Total){KillTimer(LSR_Timer); LSR_Timer = 0;}
 
forward CheckRadar();
forward HideRadar(playerid);
forward PlayerInPoint(Float:radi, playerid, Float:x, Float:y, Float:z);
forward OnPlayerEnterRadar(playerid, speed, radarid);
forward UseFlashRadar();
forward MoverPickup(lrid,Float:x,Float:y,Float:z);
 
new Text:Flash;
new UseFlash;
new RadarAttached[MAX_PLAYERS];
new RadarAttachedSpeed[MAX_PLAYERS];
 
stock CreateRadar(Float:x, Float:y, Float:z, speedmax, radiation, pickup, activated, virtualword = -1)
{
        new bid = LSR_ProcurarIDLivre();
        if(bid == -1)
        {
            printf("[LSP:] Radar limit was exceeded!(Max:%d) Increase the value or delete some...", MAX_Radar);
            return 0;
        }
        LSR_Radar[bid][LSR_OID] = CreatePickup(pickup,1,x,y,z+2,-1);
        LSR_Radar[bid][LSR_X] = x;
        LSR_Radar[bid][LSR_Y] = y;
        LSR_Radar[bid][LSR_Z] = z;
        LSR_Radar[bid][LSR_speedmax] = speedmax;
        LSR_Radar[bid][LSR_VW] = virtualword;
        LSR_Radar[bid][LSR_radiation] = radiation;
        LSR_Radar[bid][LSR_pickup] = pickup;
        LSR_Radar[bid][LSR_activated] = activated;
        LSR_CheckTimerAd();
        LSR_Total++;
        return bid;
}
 
stock DestroyRadar(lrid)
{
        if(!LSR_Radar[lrid][LSR_OID]) return 0;
        LSR_Total--;
        DestroyPickup(LSR_Radar[lrid][LSR_pickup]);
    LSR_Radar[lrid][LSR_OID] = 0;
    LSR_CheckTimerRe()
    return 1;
}
 
stock RadarExists(lrid) return (!LSR_Radar[lrid][LSR_OID]) ? 0 : 1;
 
stock SetRadarPos(lrid, Float:x, Float:y, Float:z)
{
        if(!LSR_Radar[lrid][LSR_OID]) return 0;
        LSR_Radar[lrid][LSR_X] = x;
        LSR_Radar[lrid][LSR_Y] = y;
        LSR_Radar[lrid][LSR_Z] = z;
        return MoverPickup(LSR_Radar[lrid][LSR_OID], x, y, z);
}
 
public MoverPickup(lrid,Float:x,Float:y,Float:z)
{
        if(LSR_Radar[lrid][LSR_OID])
        {
            DestroyPickup(LSR_Radar[lrid][LSR_OID]);
                LSR_Radar[lrid][LSR_X] = x;
                LSR_Radar[lrid][LSR_Y] = y;
                LSR_Radar[lrid][LSR_Z] = z;
                CreatePickup(LSR_Radar[lrid][LSR_pickup], 1, x, y, z, -1);
                return 1;
        }
        return 0;
}
 
stock SetRadarVirtualWorld(lrid, virtualworld)
{
        if(!LSR_Radar[lrid][LSR_OID]) return 0;
        LSR_Radar[lrid][LSR_VW] = virtualworld;
        DestroyPickup(LSR_Radar[lrid][LSR_OID]);
        new x = LSR_Radar[lrid][LSR_X];
        new y = LSR_Radar[lrid][LSR_Y];
        new z = LSR_Radar[lrid][LSR_Z];
        CreatePickup(LSR_Radar[lrid][LSR_pickup], 1, x, y, z, virtualworld);
        return 1;
}
 
stock SetRadarAtivate(lrid, toggle)
{
        if(!LSR_Radar[lrid][LSR_OID]) return 0;
        if(toggle == 1 || toggle == true){LSR_Radar[lrid][LSR_ativado] = 1;}
        if(toggle == 0 || toggle == false){LSR_Radar[lrid][LSR_ativado] = 0;}
        return MoverPickup(LSR_Radar[lrid][LSR_OID], x, y, z);
}
 
stock SetRadarMaxSpeed(lrid, speed)
{
        if(!LSR_Radar[lrid][LSR_OID]) return 0;
        return LSR_Radar[lrid][LSR_speedmax] = speed;
}
 
stock SetRadarRadius(lrid, Float:radius)
{
        if(!LSR_Radar[lrid][LSR_OID]) return 0;
        return LSR_Radar[lrid][LSR_radiation] = radius;
}
 
stock AttachRadarToPlayer(playerid, velocidade)
{
        RadarAttached[playerid] = 1;
        RadarAttachedSpeed[playerid] = velocidade;
        return 1;
}
 
stock DettachRadarToPlayer(playerid)
{
        RadarAttached[playerid] = 0;
        RadarAttachedSpeed[playerid] = 0;
        return 1;
}
 
stock IsPlayerRadarAttached(playerid)
{
        if(RadarAttached[playerid] == 1)return true;
        if(RadarAttached[playerid] == 0)return false;
        return 1;
}
 
stock GetPlayerSpeed(playerid, bool:velo)
{
    new Float:Vx,Float:Vy,Float:Vz,Float:rtn;
    if(IsPlayerInAnyVehicle(playerid)) GetVehicleVelocity(GetPlayerVehicleID(playerid),Vx,Vy,Vz); else GetPlayerVelocity(playerid,Vx,Vy,Vz);
    rtn = floatsqroot(floatabs(floatpower(Vx + Vy + Vz,2)));
    return velo?floatround(rtn * 100 * 1.61):floatround(rtn * 100);
}
 
stock GetVehicleSpeed(vehicleid)
{
    new Float:X, Float:Y, Float:Z;
    GetVehicleVelocity(vehicleid, X, Y, Z);
    return floatround(floatsqroot(X * X + Y * Y + Z * Z) * 180);
}
 
stock SetRadarPickup(lrid, pickupid)
{
        if(!LSR_Radar[lrid][LSR_OID]) return 0;
        LSR_Radar[lrid][LSR_pickup] = pickupid;
        return MoverPickup(lrid, LSR_Radar[lrid][LSR_X], LSR_Radar[lrid][LSR_Y], LSR_Radar[lrid][LSR_Z]+2);
}
 
stock GetRadarPos(lrid, &Float:x, &Float:y, &Float:z)
{
        if(!LSR_Radar[lrid][LSR_OID])
        {
            x = 0.0;
            y = 0.0;
            z = 0.0;
        }
        x = LSR_Radar[lrid][LSR_X];
        y = LSR_Radar[lrid][LSR_Y];
        z = LSR_Radar[lrid][LSR_Z];
}
 
stock GetRadarVirtualWorld(lrid)
{
        if(!LSR_Radar[lrid][LSR_OID]) return 0;
        return LSR_Radar[lrid][LSR_VW];
}
 
forward LSR_PlayerConnect(playerid);
public LSR_PlayerConnect(playerid)
{
        RadarAttached[playerid] = 0;
        RadarAttachedSpeed[playerid] = 0;
        return 1;
}
 
public PlayerInPoint(Float:radi, playerid, Float:x, Float:y, Float:z)
{
    if(IsPlayerConnected(playerid))
        {
                new Float:oldposx, Float:oldposy, Float:oldposz;
                new Float:tempposx, Float:tempposy, Float:tempposz;
                GetPlayerPos(playerid, oldposx, oldposy, oldposz);
                tempposx = (oldposx -x);
                tempposy = (oldposy -y);
                tempposz = (oldposz -z);
                if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
                {
                        return 1;
                }
        }
        return 0;
}
 
public CheckRadar()
{
        for(new i = 0; i < MAX_PLAYERS; i++)
        {
                for(new b = 1; b <= LSR_Total; b++)
                {
                        if(LSR_Radar[b][LSR_OID])
                        {
                                if(LSR_Radar[b][LSR_activated] == 1)
                                {
                                        if(LSR_Radar[b][LSR_VW] == -1 || GetPlayerVirtualWorld(i) == LSR_Radar[b][LSR_VW])
                                        {
                                                if(PlayerInPoint(LSR_Radar[b][LSR_radiation], i, LSR_Radar[b][LSR_X], LSR_Radar[b][LSR_Y], LSR_Radar[b][LSR_Z]))
                                                {
                                                        RadarForPlayer(i, LSR_Radar[b][LSR_speedmax], LSR_Radar[b][LSR_OID]);
                                                }
                                        }
                                }
                        }
                }
        }
}
 
stock LSR_ProcurarIDLivre()
{
        for(new b = 1; b < MAX_Radar; b++) if(!LSR_Radar[b][LSR_OID]) return b;
        return -1;
}
 
stock GetSpeed(playerid, bool:velo)
{
    new Float:Vx,Float:Vy,Float:Vz,Float:rtn;
    if(IsPlayerInAnyVehicle(playerid)) GetVehicleVelocity(GetPlayerVehicleID(playerid),Vx,Vy,Vz); else GetPlayerVelocity(playerid,Vx,Vy,Vz);
    rtn = floatsqroot(floatabs(floatpower(Vx + Vy + Vz,2)));
    return velo?floatround(rtn * 100 * 1.61):floatround(rtn * 100);
}
 
stock LoadStaticRadarsFromFile(const filename[])
{
        new File:file_ptr;
        new line[256];
        new var_from_line[64];
        new Float:SpawnX;
        new Float:SpawnY;
        new Float:SpawnZ;
        new SpeedMax;
    new Radiation, Pickup;
    new Ativado, VirtualWorld;
        new index;
        new radars_loaded;
 
        file_ptr = fopen(filename,filemode:io_read);
        if(!file_ptr) return 0;
 
        radars_loaded = 0;
 
        while(fread(file_ptr,line,256) > 0)
        {
            index = 0;
 
            // Read X, Y, Z, Rotation
                index = token_by_delim(line,var_from_line,',',index);
                if(index == (-1)) continue;
                SpawnX = floatstr(var_from_line);
 
                index = token_by_delim(line,var_from_line,',',index+1);
                if(index == (-1)) continue;
                SpawnY = floatstr(var_from_line);
 
                index = token_by_delim(line,var_from_line,',',index+1);
                if(index == (-1)) continue;
                SpawnZ = floatstr(var_from_line);
 
                // Read Speed Max
                index = token_by_delim(line,var_from_line,',',index+1);
                if(index == (-1)) continue;
                SpeedMax = strval(var_from_line);
 
                // Read Radiation, Pickup
                index = token_by_delim(line,var_from_line,',',index+1);
                if(index == (-1)) continue;
                Radiation = strval(var_from_line);
 
                index = token_by_delim(line,var_from_line,',',index+1);
                if(index == (-1)) continue;
                Pickup = strval(var_from_line);
 
                //Read Ativado, VirtualWorld
                index = token_by_delim(line,var_from_line,',',index+1);
                if(index == (-1)) continue;
                Ativado = strval(var_from_line);
 
                index = token_by_delim(line,var_from_line,';',index+1);
                VirtualWorld = strval(var_from_line);
 
                CreateRadar(SpawnX, SpawnY, SpawnZ, SpeedMax, Radiation, Pickup, Ativado, VirtualWorld);
                radars_loaded++;
        }
 
        fclose(file_ptr);
        printf("[LSR:] Loaded %d Radars from file: %s",radars_loaded,filename);
        return radars_loaded;
}
 
stock RadarForPlayer(playerid, speedlimit, radarid)
{
        new currentspeed = GetSpeed(playerid, true);
        if(currentspeed >= speedlimit)
        {
                if(UseFlash == 1){TextDrawShowForPlayer(playerid, Flash); SetTimerEx("HideRadar", 1000, 0, "d", playerid);}
                PlayerPlaySound(playerid,1132,0.0,0.0,0.0);
                OnPlayerEnterRadar(playerid, currentspeed, radarid);
        }
    return 1;
}
public HideRadar(playerid)
{
        TextDrawHideForPlayer(playerid, Flash);
        return 1;
}
 
public UseFlashRadar()
{
        UseFlash = 1;
        Flash = TextDrawCreate(635.000000, 432.000000, "__");
        TextDrawBackgroundColor(Flash, 255);
        TextDrawFont(Flash, 1);
        TextDrawLetterSize(Flash, 0.500000, -45.900001);
        TextDrawColor(Flash, -256);
        TextDrawSetOutline(Flash, 0);
        TextDrawSetProportional(Flash, 1);
        TextDrawSetShadow(Flash, 1);
        TextDrawUseBox(Flash, 1);
        TextDrawBoxColor(Flash, -86);
        TextDrawTextSize(Flash, 6.000000, 35.000000);
        return 1;
}