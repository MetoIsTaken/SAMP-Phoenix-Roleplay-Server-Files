/*
    Extended vehicle functions by Emmet_

	Thanks to:

	- [uL]Pottus -> GetVehicleTopSpeed idea
	- kvann -> SetVehicleInterior idea
*/
#define GetVehicleInterior(%0) \
	(g_VehicleInterior[(%0)])

static stock
	g_VehicleInterior[MAX_VEHICLES],
	g_VehicleTrailer[MAX_VEHICLES],
	g_VehicleTimer[MAX_VEHICLES],
	Float:g_VehiclePos[MAX_VEHICLES][3]
;

enum e_ParamTypes {
	VEHICLE_TYPE_ENGINE,
	VEHICLE_TYPE_LIGHTS,
 	VEHICLE_TYPE_ALARM,
	VEHICLE_TYPE_DOORS,
	VEHICLE_TYPE_BONNET,
	VEHICLE_TYPE_BOOT,
	VEHICLE_TYPE_OBJECTIVE
};

static const Float:gTopSpeed[] = {
	157.0, 147.0, 185.0, 111.0, 133.0, 163.0, 110.0, 148.0, 99.0, 157.0, 129.0, 221.0,
	168.0, 111.0, 105.0, 192.0, 153.0, 115.0, 148.0, 145.0, 153.0, 140.0, 99.0, 136.0,
	173.0, 165.0, 157.0, 201.0, 131.0, 95.0, 111.0, 166.0, 148.0, 157.0, 142.0, 168.0,
    136.0, 140.0, 126.0, 110.0, 164.0, 192.0, 157.0, 107.0, 96.0, 157.0, 136.0, 147.0,
    140.0, 157.0, 111.0, 148.0, 171.0, 185.0, 117.0, 140.0, 183.0, 157.0, 123.0, 99.0,
    65.0, 140.0, 157.0, 148.0, 140.0, 213.0, 177.0, 163.0, 107.0, 122.0, 140.0, 171.0,
    178.0, 165.0, 107.0, 120.0, 142.0, 157.0, 157.0, 163.0, 130.0, 160.0, 157.0, 149.0,
    175.0, 148.0, 60.0, 70.0, 111.0, 166.0, 168.0, 157.0, 171.0, 148.0, 202.0, 163.0,
    151.0, 147.0, 148.0, 142.0, 153.0, 144.0, 157.0, 121.0, 143.0, 157.0, 157.0, 177.0,
    169.0, 153.0, 177.0, 163.0, 160.0, 171.0, 146.0, 94.0, 60.0, 110.0, 60.0, 157.0,
    157.0, 130.0, 157.0, 153.0, 136.0, 86.0, 153.0, 163.0, 107.0, 162.0, 175.0, 175.0,
    175.0, 157.0, 151.0, 110.0, 168.0, 170.0, 1.0
};

forward SetParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
public SetParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective)
{
	SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if (IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
	    new
			vehicleid = GetPlayerVehicleID(playerid),
			trailerid = GetVehicleTrailer(vehicleid);

	    if (trailerid != g_VehicleTrailer[vehicleid])
	    {
	        if (trailerid != 0)
			{
				CallLocalFunction("OnTrailerHooked", "ddd", playerid, vehicleid, trailerid);
			}
			else
			{
			    CallLocalFunction("OnTrailerUnhooked", "ddd", playerid, vehicleid, g_VehicleTrailer[vehicleid]);
			}
			g_VehicleTrailer[vehicleid] = trailerid;
		}
	}
	#if defined EVF_OnPlayerUpdate
	    EVF_OnPlayerUpdate(playerid);
	#endif
	return 1;
}

stock GetVehicleParams(vehicleid, type)
{
	static
	    params[7];

	GetVehicleParamsEx(vehicleid, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
	return (!(params[type] <= 0));
}

stock SetVehicleParams(vehicleid, type, status, time = 0)
{
	static
	    params[7];

    GetVehicleParamsEx(vehicleid, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
	params[type] = status;

	if (time > 0) {
		return SetTimerEx("SetParamsEx", time, false, "dddddddd", vehicleid, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
	}
	return SetVehicleParamsEx(vehicleid, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
}

stock GetVehicleBoot(vehicleid, &Float:x, &Float:y, &Float:z)
{
	if (!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
	    return (x = 0.0, y = 0.0, z = 0.0), 0;

	static
	    Float:pos[7]
	;
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
	GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
	GetVehicleZAngle(vehicleid, pos[6]);

	x = pos[3] - (floatsqroot(pos[1] + pos[1]) * floatsin(-pos[6], degrees));
	y = pos[4] - (floatsqroot(pos[1] + pos[1]) * floatcos(-pos[6], degrees));
 	z = pos[5];

	return 1;
}

stock GetVehicleHood(vehicleid, &Float:x, &Float:y, &Float:z)
{
    if (!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
	    return (x = 0.0, y = 0.0, z = 0.0), 0;

	static
	    Float:pos[7]
	;
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
	GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
	GetVehicleZAngle(vehicleid, pos[6]);

	x = pos[3] + (floatsqroot(pos[1] + pos[1]) * floatsin(-pos[6], degrees));
	y = pos[4] + (floatsqroot(pos[1] + pos[1]) * floatcos(-pos[6], degrees));
 	z = pos[5];

	return 1;
}

stock GetVehicleRoof(vehicleid, &Float:x, &Float:y, &Float:z)
{
    if (!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
	    return (x = 0.0, y = 0.0, z = 0.0), 0;

	static
	    Float:pos[6]
	;
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
	GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);

	x = pos[3];
	y = pos[4];
	z = pos[5] + floatsqroot(pos[2]);

	return 1;
}

stock GetOffsetFromPosition(vehicleid, Float:x, Float:y, Float:z, &Float:fOffsetX, &Float:fOffsetY, &Float:fOffsetZ)
{
    if (!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
	    return (x = 0.0, y = 0.0, z = 0.0), 0;

	new
	    Float:vX,
	    Float:vY,
	    Float:vZ;

	GetVehiclePos(vehicleid, vX, vY, vZ);

	fOffsetX = (x - vX);
	fOffsetY = (y - vY);
	fOffsetZ = (z - vZ);

	return 1;
}

stock GetNearestVehicle(playerid)
{
	static
	    Float:x[2],
	    Float:y[2],
	    Float:z[2];

	for (new i = 1; i != MAX_VEHICLES; i ++)
	{
	    if (!GetVehicleModel(i))
	        continue;

		if (GetPlayerInterior(playerid) != GetVehicleInterior(i))
		    continue;

		if (GetPlayerVirtualWorld(playerid) != GetVehicleVirtualWorld(i))
		    continue;

		GetVehiclePos(i, x[0], y[0], z[0]);
		GetVehicleModelInfo(GetVehicleModel(i), VEHICLE_MODEL_INFO_SIZE, x[1], y[1], z[1]);

		if (IsPlayerInRangeOfPoint(playerid, floatsqroot(x[1] + y[1] + z[1]), x[0], y[0], z[0]))
		{
		    return i;
		}
	}
	return INVALID_VEHICLE_ID;
}

stock GetVehicleDriver(vehicleid)
{
	for (new i = 0, j = GetMaxPlayers(); i != j; i ++) {
	    if (GetPlayerState(i) == PLAYER_STATE_DRIVER && IsPlayerInVehicle(i, vehicleid)) return i;
	}
	return INVALID_PLAYER_ID;
}

stock IsSeatOccupied(vehicleid, seatid)
{
	if (!GetVehicleModel(vehicleid))
		return 0;

	for (new i = 0, j = GetMaxPlayers(); i != j; i ++)
	{
	    if (IsPlayerInVehicle(i, vehicleid) && GetPlayerVehicleSeat(i) == seatid) return 1;
	}
	return 0;
}

stock GetVehicleNextSeat(vehicleid, passenger = 1)
{
	if (!GetVehicleModel(vehicleid) || GetVehicleSeats(vehicleid) <= 1)
	    return -1;

	for (new i = passenger; i < GetVehicleSeats(vehicleid); i ++) {
	    if (!IsSeatOccupied(vehicleid, i)) return i;
	}
	return -1;
}

stock GetVehicleSeats(vehicleid)
	return GetVehicleModelSeats(GetVehicleModel(vehicleid));

stock GetVehicleModelSeats(modelid)
{
    static const gVehicleSeats[] =
	{
		4, 2, 2, 2, 4, 4, 1, 2, 2, 4, 2, 2, 2, 4, 2, 2, 4, 2, 4, 2, 4, 4, 2, 2, 2, 1, 4, 4, 4, 2,
		1, 7, 1, 2, 2, 0, 2, 7, 4, 2, 4, 1, 2, 2, 2, 4, 1, 2, 1, 0, 0, 2, 1, 1, 1, 2, 2, 2, 4,
		4, 2, 2, 2, 2, 1, 1, 4, 4, 2, 2, 4, 2, 1, 1, 2, 2, 1, 2, 2, 4, 2, 1, 4, 3, 1, 1, 1, 4, 2,
		2, 4, 2, 4, 1, 2, 2, 2, 4, 4, 2, 2, 1, 2, 2, 2, 2, 2, 4, 2, 1, 1, 2, 1, 1, 2, 2, 4, 2, 2,
		1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 4, 1, 1, 1, 2, 2, 2, 2, 7, 7, 1, 4, 2, 2, 2, 2, 2, 4, 4,
		2, 2, 4, 4, 2, 1, 2, 2, 2, 2, 2, 2, 4, 4, 2, 2, 1, 2, 4, 4, 1, 0, 0, 1, 1, 2, 1, 2, 2, 1, 2,
		4, 4, 2, 4, 1, 0, 4, 2, 2, 2, 2, 0, 0, 7, 2, 2, 1, 4, 4, 4, 2, 2, 2, 2, 2, 4, 2, 0, 0, 0,
		4, 0, 0
	};
	return (modelid < 400 || modelid > 611) ? (0) : (gVehicleSeats[modelid - 400]);
}

stock Float:GetVehicleTopSpeed(vehicleid, bool:kmh = true)
{
	new model = GetVehicleModel(vehicleid);

	if (!model)
		return 0.0;

	else switch (kmh)
	{
		case true:
			return gTopSpeed[model - 400];

	    case false:
	        return (gTopSpeed[model - 400] / 1.609344);
	}
	return 0.0;
}

stock IsTirePopped(vehicleid, tireid)
{
    new
	    panels,
	    doors,
	    lights,
	    tires;

	GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

	switch (GetVehicleModel(vehicleid))
	{
	    case 448, 461..463, 468, 521..523, 581, 586:
	    {
	        if ((tireid == 0) && (tires & 10 || tires & 11))
	            return 1;
	            
			else if ((tireid == 1) && (tires & 01 || tires & 11))
			    return 1;
		}
		default:
		{
		    if ((tireid == 0) && (tires & 1000 || tires & 1001 || tires & 1010 || tires & 1011 || tires & 1100 || tires & 1101 || tires & 1110 || tires & 1111))
				return 1;

			else if ((tireid == 1) && (tires & 0010 || tires & 0011 || tires & 0110 || tires & 0111 || tires & 1010 || tires & 1011 || tires & 1110 || tires & 1111))
			    return 1;
			    
			else if ((tireid == 2) && (tires & 0100 || tires & 0101 || tires & 0110 || tires & 0111 || tires & 1100 || tires & 1101 || tires & 1110 || tires & 1111))
			    return 1;
			    
			else if ((tireid == 3) && (tires & 0001 || tires & 0011 || tires & 0101 || tires & 0111 || tires & 1001 || tires & 1011 || tires & 1101 || tires & 1111))
			    return 1;

		}
	}
	return 0;
}

stock EVF_LinkVehicleToInterior(vehicleid, interiorid)
{
	g_VehicleInterior[vehicleid] = interiorid;
	return LinkVehicleToInterior(vehicleid, interiorid);
}

stock EVF_CreateVehicle(modelid, Float:x, Float:y, Float:z, Float:a, color1, color2, respawn_delay)
{
	new vehicleid = CreateVehicle(modelid, x, y, z, a, color1, color2, respawn_delay);

	if (vehicleid != INVALID_VEHICLE_ID) {
		g_VehicleInterior[vehicleid] = 0;
		g_VehicleTrailer[vehicleid] = INVALID_VEHICLE_ID;
		CallLocalFunction("OnVehicleCreated", "d", vehicleid);
	}
	return vehicleid;
}

stock EVF_AddStaticVehicle(modelid, Float:x, Float:y, Float:z, Float:a, color1, color2)
{
	new vehicleid = AddStaticVehicle(modelid, x, y, z, a, color1, color2);

	if (vehicleid != INVALID_VEHICLE_ID) {
		g_VehicleInterior[vehicleid] = 0;
		g_VehicleTrailer[vehicleid] = INVALID_VEHICLE_ID;
		CallLocalFunction("OnVehicleCreated", "d", vehicleid);
	}
	return vehicleid;
}

stock EVF_AddStaticVehicleEx(modelid, Float:x, Float:y, Float:z, Float:a, color1, color2, respawn_delay)
{
	new vehicleid = AddStaticVehicleEx(modelid, x, y, z, a, color1, color2, respawn_delay);

	if (vehicleid != INVALID_VEHICLE_ID) {
		g_VehicleInterior[vehicleid] = 0;
		g_VehicleTrailer[vehicleid] = INVALID_VEHICLE_ID;
		CallLocalFunction("OnVehicleCreated", "d", vehicleid);
	}
	return vehicleid;
}

#if defined _ALS_LinkVehicleToInterior
	#define LinkVehicleToInterior
#else
	#define _ALS_LinkVehicleToInterior
#endif

#if defined _ALS_CreateVehicle
	#define CreateVehicle
#else
	#define _ALS_CreateVehicle
#endif

#if defined _ALS_AddStaticVehicle
	#define AddStaticVehicle
#else
	#define _ALS_AddStaticVehicle
#endif

#if defined _ALS_AddStaticVehicleEx
	#define AddStaticVehicleEx
#else
	#define _ALS_AddStaticVehicleEx
#endif

#if defined _ALS_OnPlayerUpdate
	#undef OnPlayerUpdate
#else
	#define _ALS_OnPlayerUpdate
#endif

#define LinkVehicleToInterior 	EVF_LinkVehicleToInterior
#define CreateVehicle 			EVF_CreateVehicle
#define AddStaticVehicle 		EVF_AddStaticVehicle
#define AddStaticVehicleEx 		EVF_AddStaticVehicleEx
#define OnPlayerUpdate          EVF_OnPlayerUpdate
#define SetVehicleInterior      LinkVehicleToInterior

#if defined EVF_OnPlayerUpdate
	forward EVF_OnPlayerUpdate(playerid);
#endif

forward OnVehicleCreated(vehicleid);
forward OnTrailerHooked(playerid, vehicleid, trailerid);
forward OnTrailerUnhooked(playerid, vehicleid, trailerid);