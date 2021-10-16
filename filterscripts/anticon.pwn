#include <a_samp>

//Kisiye uygulanacak islem turu
// 1=Ban -- 2=Kick
#define ISLEM      2

//Banlaninca oyuncuya mesaj gonderme
// 0=Kapali -- 1=Acik
#define BANMESAJ   1

//Banlaninca oyuncuya gonderilecek mesaj
#define BANMESAJI   "iRoleplay: Sunucuya saldýrý giriþiminde bulundunuz ve banlandýnýz."

//Kicklenince oyuncuya mesaj gonderme
// 0=Kapali -- 1=Acik
#define KICKMESAJ   1

//Kicklenince oyuncuya gonderilecek mesaj
#define KICKMESAJI   "iRoleplay: Sunucuya saldýrý giriþiminde bulundunuz ve atýldýnýz. Farklý nickle girin."

//Gonderilecek yazinin rengi
#define YAZIRENGI   (0x9ACD32AA)

//Yasak isimler
//Buyuklugunu icerideki isim sayisina gore ayarlayin
new fyasakisim[45][0] = {
	{"nul"},
        {"YN-rp"},
        {"yn-rp."},
        {"Yeninesil"},
        {"Yeninesilrpg"},
	{"nul."},
	{"nul,"},
	{"aux"},
	{"aux."},
	{"aux,"},
	{"con"},
	{"con."},
	{"Con."},
	{"CoN."},
	{"CoN,"},
	{"con,"},
	{"prn"},
	{"prn."},
	{"prn,"},
	{"prn,"},
	{"prn."},
	{"com0"},
	{"com1"},
	{"com2"},
	{"com3"},
	{"com4"},
	{"com5"},
	{"com6"},
	{"com7"},
	{"com8"},
	{"com9"},
	{"lpt0"},
	{"lpt1"},
	{"lpt2"},
	{"lpt3"},
	{"lpt4"},
	{"lpt5"},
	{"lpt6"},
	{"lpt7"},
	{"lpt8"},
	{"lpt9"},
	{"siker"},
	{"Siker"},
	{"sikeR"},
	{"sikerr"},
	{"Sikerr"},
	{"sikeRR"},
	{"sikeRr"},
	{"sikerR"}
};

public OnPlayerConnect(playerid)
{
	new oyuncuisim[MAX_PLAYER_NAME], oyuncuisim2[MAX_PLAYER_NAME];
	GetPlayerName(playerid,oyuncuisim,sizeof(oyuncuisim));

	for(new i=0; i<sizeof(fyasakisim); i++)
	{
		if(!strfind(oyuncuisim,fyasakisim[i][0],true))
		{
		    format(oyuncuisim2,MAX_PLAYER_NAME,"oyuncu_%d",playerid);
		    SetPlayerName(playerid, oyuncuisim2);
			#if ISLEM == 1
				#if BANMESAJ
					SendClientMessage(playerid,YAZIRENGI,BANMESAJI);
				#endif
				SendClientMessage(playerid,YAZIRENGI,BANMESAJI);
			#endif

			#if ISLEM == 2
				#if KICKMESAJ
					SendClientMessage(playerid,YAZIRENGI,KICKMESAJI);
				#endif
				SendClientMessage(playerid,YAZIRENGI,KICKMESAJI);
			#endif
		}
	}
	return 1;
}

