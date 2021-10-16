   #include "a_samp.inc"
new var[MAX_PLAYERS] = {-1,...}, uyarilar[MAX_PLAYERS] = {0,...}, bool:npc[MAX_PLAYERS] = {false,...}, MAKS_OYUNCU_= MAX_PLAYERS;
    public OnFilterScriptInit()
    {
            SendRconCommand("yasakliyenile");
            print("Anti-Bot güvenliði aktif.");
            return 1;
    }
    public OnPlayerConnect(playerid)
    {
            if(YerelIP(IpH(playerid)) >= 6) return YasakH(playerid), 0;
            MAKS_OYUNCU_= playerid > MAKS_OYUNCU_? playerid : MaksID(),
            npc[playerid] = bool:IsPlayerNPC(playerid),
            var[playerid] = SetTimerEx("DBT",2500,false,"i",playerid),
            uyarilar[playerid] = 0;
            return 1;
    }

    public OnPlayerDisconnect(playerid, reason)
    {
            MAKS_OYUNCU_= MaksID(playerid);
            if(npc[playerid]) npc[playerid] = false;
            if(var[playerid] != -1)
            {
                    KillTimer(var[playerid]);
                    var[playerid] = -1;
            }
            uyarilar[playerid] = 0;
            return 1;
    }
    stock YerelIP(ip[])
    {
            new c = 0;
            for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && !strcmp(IpH(i),ip)) c++;
            return c;
    }
    forward DBT(playerid);
    public DBT(playerid)
    {
            new i = GetPlayerPing(playerid);
            if(i <= 0 || i >= 50000)
            {
                    if(uyarilar[playerid] >= 1) YasakH(playerid);
                    else uyarilar[playerid]++, var[playerid] = SetTimerEx("DBT",1500,false,"i",playerid);
            }
            return 0;
    }
    stock IpH(playerid)
    {
            new ip[16];
            GetPlayerIp(playerid,ip,sizeof(ip));
            return ip;
    }
    stock YasakH(playerid)
    {
            new ip[32];
            GetPlayerIp(playerid,ip,sizeof(ip));
            for(new i = 0, p = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && !npc[i])
            {
                    p = GetPlayerPing(i);
                    if(i == playerid || !strcmp(ip,IpH(i)) || p <= 0 || p >= 50000)
                    {
                            BanEx(i,"Bot");
                            if(var[i] != -1)
                            {
                                    KillTimer(var[i]);
                                    var[i] = -1;
                            }
                    }
            }
            format(ip,sizeof(ip),"IpBan %s",ip);
            return SendRconCommand(ip);
    }
    stock MaksID(exceptof = INVALID_PLAYER_ID)
    {
            new h = 0;
            for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && i != exceptof && i > h) h = i;
            return h;
    }
