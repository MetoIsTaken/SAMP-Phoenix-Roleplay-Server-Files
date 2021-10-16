#if defined _mweather_included
  #endinput
#endif
 
#define _mweather_included
#pragma library mweather
#pragma tabsize 0

#define WEATHER_UNKNOWN                         0
#define WEATHER_SUNNY                           1
#define WEATHER_MOSTLY_SUNNY        2
#define WEATHER_PARTLY_CLOUDY           3
#define WEATHER_MOSTLY_CLOUDY           4
#define WEATHER_CLOUDY              5
#define WEATHER_LIGHT_RAIN          6
#define WEATHER_SHOWERS             7
#define WEATHER_RAIN                8
#define WEATHER_LIGHT_THUNDERSTORM  9
#define WEATHER_THUNDERSTORM        10
#define WEATHER_MIST                11
#define WEATHER_SNOWRAIN            12
#define WEATHER_LIGHT_SNOW          13
 
#include <a_http>
 
// Callbacks
forward OnPlayerWeatherZoneChange(playerid, oldzone, newzone);
forward OnWeatherZoneMoved(zoneid);
forward OnRealWeatherUpdate(observerid, oldstate, newstate);
 
enum EnumRealWeather {
        bool:ValidWeather,
        UpdateTimer,
        WUrl[192],
        LastWState
}
 
enum EnumWeatherZone {
        bool:ValidWeatherZone,
        Float:W_midx,
        Float:W_midy,
        Float:W_midz,
        Float:W_length,
        Float:W_width,
        Float:W_height,
        Float:W_xt,
        Float:W_yt,
        Float:W_zt,
        Float:W_movespeed,
        W_WeatherID,
        bool:W_observer,
        W_timer
}
 
new RealWeather[16][EnumRealWeather];
new WeatherZones[16][EnumWeatherZone];
 
new GlobalWeather = -1;
new PlayerWeather[MAX_PLAYERS];
new GlobalNormalWeather = -1;
new PlayerNormalWeather[MAX_PLAYERS];
new PlayerZone[MAX_PLAYERS];
 
MWeather_OnGameModeInit()
{
        for(new i = 0; i < MAX_PLAYERS; i ++)
        {
            PlayerWeather[i] = -1;
            PlayerNormalWeather[i] = -1;
            PlayerZone[i] = -1;
        }
}
 
// -----------------------------------------------------------------------------
// -------------------------- Weather zones ------------------------------------
 
stock AddWeatherZone(Float:x, Float:y, Float:z, Float:length, Float:width, Float:height, weatherid, bool:observer)
{
    new wid = GetFreeWeatherZone();
        if(wid == -1) return -1;
        if(W_observer && !RealWeather[weatherid][ValidWeather]) return -1;
        WeatherZones[wid][W_midx] = x;
        WeatherZones[wid][W_midy] = y;
        WeatherZones[wid][W_midz] = z;
        WeatherZones[wid][W_length] = length;
        WeatherZones[wid][W_width] = width;
        WeatherZones[wid][W_height] = height;
        WeatherZones[wid][W_WeatherID] = weatherid;
        WeatherZones[wid][W_observer] = observer;
        WeatherZones[wid][W_timer] = SetTimerEx("WeatherZoneUpdater", 2000, 1, "i", wid);
    WeatherZones[wid][ValidWeatherZone] = true;
        return wid;
}
 
stock MoveWeatherZone(zoneid, Float:tox, Float:toy, Float:toz, Float:speed)
{
        if(!WeatherZones[zoneid][ValidWeatherZone]) return 0;
        WeatherZones[zoneid][W_xt] = tox;
    WeatherZones[zoneid][W_yt] = toy;
    WeatherZones[zoneid][W_zt] = toz;
    WeatherZones[zoneid][W_movespeed] = speed;
    return 1;
}
stock StopWeatherZone(zoneid)
{
    if(!WeatherZones[zoneid][ValidWeatherZone]) return 0;
    WeatherZones[zoneid][W_movespeed] = 0.0;
    return 1;
}
 
 
// -----------------------------------------------------------------------------
// --------------------------- RealWeather -------------------------------------
 
stock AddWeatherObserver(url[], updatetime)
{
        new wid = GetFreeRealWeather();
        if(wid == -1) return -1;
        format(RealWeather[wid][WUrl], 192, "www.mauzen.net/utils/a.php?URL=%s", url);
        RealWeather[wid][UpdateTimer] = SetTimerEx("WeatherUpdater", updatetime, 1, "i", wid);
        RealWeather[wid][LastWState] = WEATHER_UNKNOWN;
        RealWeather[wid][ValidWeather] = true;
        WeatherUpdater(wid);
        return wid;
}
stock RemoveWeatherObserver(observerid)
{
        if(!RealWeather[observerid][ValidWeather]) return false;
        RealWeather[observerid][ValidWeather] = false;
        KillTimer(RealWeather[observerid][UpdateTimer]);
        return true;
}
 
// -----------------------------------------------------------------------------
// ------------------------- Sets and Gets -------------------------------------
 
stock SetRealWeatherEx(observerid)
{
    if(!RealWeather[observerid][ValidWeather]) return;
        GlobalWeather = observerid;
        GlobalNormalWeather = -1;
        UpdateWeather();
}
stock GetRealWeatherEx()
{
        return GlobalWeather;
}
stock SetWeatherEx(weatherid)
{
        GlobalNormalWeather = weatherid;
        GlobalWeather = -1;
        UpdateWeather();
}
stock GetWeatherEx()
{
        return GlobalNormalWeather;
}
stock SetPlayerRealWeatherEx(playerid, observerid)
{
        if(observerid != -1 && !RealWeather[observerid][ValidWeather]) return;
        PlayerWeather[playerid] = observerid;
        PlayerNormalWeather[playerid] = -1;
        UpdateWeather();
}
stock GetRealPlayerWeatherEx(playerid)
{
        return PlayerWeather[playerid];
}
stock SetPlayerWeatherEx(playerid, weatherid)
{
        PlayerNormalWeather[playerid] = weatherid;
        PlayerWeather[playerid] = -1;
        UpdateWeather();
}
stock GetPlayerWeatherEx(playerid)
{
        return PlayerNormalWeather[playerid];
}
 
// -----------------------------------------------------------------------------
// ------------------------ Internally used ------------------------------------
 
//     ----------------------- RealWeather ---------------------------------
 
stock GetFreeRealWeather()
{
        for(new i = 0; i < sizeof (RealWeather); i ++)
        {
            if(!RealWeather[i][ValidWeather]) return i;
        }
        return -1;
}
 
forward WeatherUpdater(observerid);
public WeatherUpdater(observerid)
{
        if(!RealWeather[observerid][ValidWeather])
        {
            KillTimer(RealWeather[observerid][UpdateTimer]);
            return;
        }
        HTTP(observerid + 950, HTTP_GET, RealWeather[observerid][WUrl], "", "ObserverUpdate");
}
 
forward ObserverUpdate(index, response_code, data[]);
public ObserverUpdate(index, response_code, data[])
{
    new oldstate = RealWeather[index - 950][LastWState];
        if(response_code != 200)
        {
                RealWeather[index - 950][LastWState] = WEATHER_UNKNOWN;
        } else
        {
               
                if(!strcmp(data, "Sunny")) RealWeather[index - 950][LastWState] = WEATHER_SUNNY;
            else if(!strcmp(data, "Fair") || !strcmp(data, "Mostly Sunny")) RealWeather[index - 950][LastWState] = WEATHER_MOSTLY_SUNNY;
            else if(!strcmp(data, "Partly Cloudy")) RealWeather[index - 950][LastWState] = WEATHER_PARTLY_CLOUDY;
            else if(!strcmp(data, "Mostly Cloudy")) RealWeather[index - 950][LastWState] = WEATHER_MOSTLY_CLOUDY;
            else if(!strcmp(data, "Cloudy")) RealWeather[index - 950][LastWState] = WEATHER_CLOUDY;
            else if(!strcmp(data, "Light Rain")) RealWeather[index - 950][LastWState] = WEATHER_LIGHT_RAIN;
            else if(!strcmp(data, "Showers") || !strcmp(data, "Scattered Showers")) RealWeather[index - 950][LastWState] = WEATHER_SHOWERS;
            else if(!strcmp(data, "Rain")) RealWeather[index - 950][LastWState] = WEATHER_RAIN;
            else if(!strcmp(data, "Mist") || !strcmp(data, "Fog") || !strcmp(data, "Haze")) RealWeather[index - 950][LastWState] = WEATHER_MIST;
            else if(!strcmp(data, "Rain/Snow") || !strcmp(data, "Rain/Snow Showers")) RealWeather[index - 950][LastWState] = WEATHER_SNOWRAIN;
            else if(!strcmp(data, "Light Snow")) RealWeather[index - 950][LastWState] = WEATHER_LIGHT_SNOW;
            else if(!strcmp(data, "T-Rain") || !strcmp(data, "Scattered T-Storm")) RealWeather[index - 950][LastWState] = WEATHER_LIGHT_THUNDERSTORM;
            else if(!strcmp(data, "T-Storm") || !strcmp(data, "Isolated T-Storm")) RealWeather[index - 950][LastWState] = WEATHER_THUNDERSTORM;
            //printf("Catched weather: %d", RealWeather[index - 950][LastWState]);
            UpdateWeather();
        }
        CallLocalFunction("OnRealWeatherUpdate", "iii", index - 950, oldstate, RealWeather[index - 950][LastWState]);
        return;
       
}
 
UpdateWeather()
{
        if(GlobalWeather != -1)
        {
            SetWeather(GetWeatherIDFromState(RealWeather[GlobalWeather][LastWState]));
        }
        if(GlobalNormalWeather != -1)
        {
            SetWeather(GlobalNormalWeather);
        }
        for(new i = 0; i < MAX_PLAYERS; i ++)
        {
            if(PlayerWeather[i] != -1) SetPlayerWeather(i, GetWeatherIDFromState(RealWeather[PlayerWeather[i]][LastWState]));
            if(PlayerNormalWeather[i] != -1) SetPlayerWeather(i, PlayerNormalWeather[i]);
        }
}
 
stock GetWeatherIDFromState(wstate)
{
        switch(wstate)
        {
                case WEATHER_UNKNOWN: return 1;
                case WEATHER_SUNNY: return 1;
                case WEATHER_PARTLY_CLOUDY: return 10;
                case WEATHER_MOSTLY_CLOUDY: return 4;
                case WEATHER_CLOUDY: return 7;
                case WEATHER_LIGHT_RAIN: return 16;
                case WEATHER_SHOWERS: return 16;
                case WEATHER_LIGHT_THUNDERSTORM: return 16;
                case WEATHER_SNOWRAIN: return 16;
                case WEATHER_LIGHT_SNOW: return 16;
                case WEATHER_RAIN: return 8;
                case WEATHER_THUNDERSTORM: return 8;
                case WEATHER_MIST: return 9;
        }
        return 1;
}
 
//     ------------------------ Weather zones ------------------------------
 
stock GetFreeWeatherZone()
{
    for(new i = 0; i < sizeof (WeatherZones); i ++)
        {
            if(!WeatherZones[i][ValidWeatherZone]) return i;
        }
        return -1;
}
 
new tez;
 
forward WeatherZoneUpdater(zoneid);
public WeatherZoneUpdater(zoneid)
{
        if(!WeatherZones[zoneid][ValidWeatherZone])
        {
            KillTimer(WeatherZones[zoneid][W_timer]);
            return;
        }
        if(WeatherZones[zoneid][W_movespeed] > 0.0)
        {
            new Float:xd, Float:yd, Float:zd;
            new Float:vx, Float:vy, Float:vz;
            xd = WeatherZones[zoneid][W_midx] - WeatherZones[zoneid][W_xt];
            yd = WeatherZones[zoneid][W_midy] - WeatherZones[zoneid][W_yt];
            zd = WeatherZones[zoneid][W_midz] - WeatherZones[zoneid][W_zt];
           
            /*vx = floatsqroot( (WeatherZones[zoneid][W_movespeed] * WeatherZones[zoneid][W_movespeed]) / (((yd * yd + zd * zd) / xd * xd) + 1) );
        if(xd > 0) vx *= -1;
                vy = (yd / xd) * vx;
            vz = (zd / xd) * vx;*/
           
            vx = WeatherZones[zoneid][W_movespeed] * (xd / (xd + yd + zd)) * 2.0;
            vy = WeatherZones[zoneid][W_movespeed] * (yd / (xd + yd + zd)) * 2.0;
            vz = WeatherZones[zoneid][W_movespeed] * (zd / (xd + yd + zd)) * 2.0;
            if(xd > 0.0) vx *= -1;
            if(yd > 0.0) vy *= -1;
            if(zd > 0.0) vz *= -1;
 
                if((vx > 0 && WeatherZones[zoneid][W_midx] + vx >= WeatherZones[zoneid][W_xt]) || (vx < 0 && WeatherZones[zoneid][W_midx] + vx <= WeatherZones[zoneid][W_xt]))
                {
                    WeatherZones[zoneid][W_midx] = WeatherZones[zoneid][W_xt];
                    WeatherZones[zoneid][W_midy] = WeatherZones[zoneid][W_yt];
                    WeatherZones[zoneid][W_midz] = WeatherZones[zoneid][W_zt];
                    WeatherZones[zoneid][W_movespeed] = 0.0;
                    CallLocalFunction("OnWeatherZoneMoved", "i", zoneid);
                } else {
                    WeatherZones[zoneid][W_midx] = WeatherZones[zoneid][W_midx] + vx;
                    WeatherZones[zoneid][W_midy] = WeatherZones[zoneid][W_midy] + vy;
                    WeatherZones[zoneid][W_midz] = WeatherZones[zoneid][W_midz] + vz;
                }
           
            //printf("Zone pos: %.1f %.1f %.1f / %.2f %.2f %.2f", WeatherZones[zoneid][W_midx], WeatherZones[zoneid][W_midy], WeatherZones[zoneid][W_midz], vx, vy, vz);
 
                GangZoneDestroy(tez);
                tez = GangZoneCreate(WeatherZones[zoneid][W_midx] - WeatherZones[zoneid][W_length] / 2, WeatherZones[zoneid][W_midy] - WeatherZones[zoneid][W_width] / 2, (WeatherZones[zoneid][W_midx] - WeatherZones[zoneid][W_length] / 2) + WeatherZones[zoneid][W_length], (WeatherZones[zoneid][W_midy] - WeatherZones[zoneid][W_width] / 2) + WeatherZones[zoneid][W_width]);
                GangZoneShowForAll(tez, 0xFF000099);
           
        }
        for(new i = 0; i < MAX_PLAYERS; i ++)
        {
            if(!IsPlayerConnected(i)) continue;
                if((WeatherZones[zoneid][W_length] < 0.0 && IsPlayerInRangeOfPoint(i, WeatherZones[zoneid][W_length] * -1, WeatherZones[zoneid][W_midx], WeatherZones[zoneid][W_midy], WeatherZones[zoneid][W_midz])) ||
                        (WeatherZones[zoneid][W_length] > 0.0 && MIsPlayerInArea(i, WeatherZones[zoneid][W_midx], WeatherZones[zoneid][W_midy], WeatherZones[zoneid][W_midz],
                        WeatherZones[zoneid][W_length], WeatherZones[zoneid][W_width],  WeatherZones[zoneid][W_height])))
                {
                if(WeatherZones[zoneid][W_observer]) SetPlayerRealWeatherEx(i, WeatherZones[zoneid][W_WeatherID]);
                        else SetPlayerWeatherEx(i, WeatherZones[zoneid][W_WeatherID]);
                        if(zoneid != PlayerZone[i])
                        {
                            CallLocalFunction("OnPlayerWeatherZoneChange", "iii", i, PlayerZone[i], zoneid);
                            PlayerZone[i] = zoneid;
                        }
                } else
                {
                        if(PlayerZone[i] != -1) {
                            CallLocalFunction("OnPlayerWeatherZoneChange", "iii", i, PlayerZone[i], -1);
                                PlayerZone[i] = -1;
                                SetPlayerWeatherEx(i, -1);
                                SetPlayerRealWeatherEx(i, -1);
                        }
                }
           
        }
        UpdateWeather();
}
 
//     -------------------- General stocks ---------------------------------
 
stock MIsPlayerInArea(playerid, Float:x, Float:y, Float:z, Float:l, Float:w, Float:h)
{
        new Float:px, Float:py, Float:pz;
        GetPlayerPos(playerid, px, py, pz);
        x -= l / 2;
        y -= w / 2;
        z -= h / 2;
        if(px >= x && px <= x + l)
            if(py >= y && py <= y + w)
                        if(pz >= z && pz <= z + h)
                            return true;
        return false;
}