/*
======================================================

		     Evo Scripts™
	       eSenkronize™ Teknolojisi
                     By EvoturK™

======================================================
*/
native GetVehicleBenzin(vehicleid); // Arabadaki Benzin Miktarý
native GetVehicleEngine(vehicleid); // Motorun Durumu (0 : Kapalý | 1 : Açýk)

#define GetVehicleBenzin     EvoBenzin_GetVehicleBenzin
#define GetVehicleEngine     EvoBenzin_GetVehicleEngine

forward EvoBenzin_GetVehicleBenzin(vehicleid);
public EvoBenzin_GetVehicleBenzin(vehicleid)
{
	return CallRemoteFunction("eSenkronize_GetVehicleBenzin", "i", vehicleid);
}

forward EvoBenzin_GetVehicleEngine(vehicleid);
public EvoBenzin_GetVehicleEngine(vehicleid)
{
	return CallRemoteFunction("eSenkronize_GetVehicleEngine", "i", vehicleid);
}