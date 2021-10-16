/*
	easyDialog.inc - Dialogs made easier!

	With this useful include, scripters can easily create
	dialogs and show them to players.

	This include will prevent dialog spoofing, ID collision
	and a lot more.

	Created by Emmet on Friday, November 15, 2013.
*/
#define Dialog:%0(%1) \
	forward public %0@g_DB_DC(%1); public %0@g_DB_DC(%1)

#define Dialog_Show(%0,%1,%2,%3,%4,%5,%6) \
	Dialog_ShowEx(%0, #%1, %2, %3, %4, %5, %6)

#define Dialog_Close(%0) \
	(Dialog_Reset(%0), ShowPlayerDialog(playerid, -1, DIALOG_STYLE_MSGBOX, " ", " ", " ", ""))

#define Dialog_Call(%0,%1,%2,%3,%4) \
	(CallLocalFunction(Dialog_GetCallback(%0), "ddds", %1, %2, %3, %4))

#if !defined isnull
	#define isnull(%1) \
		((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

static stock
	g_DG_DialogFunction[MAX_PLAYERS][32 char]
;

stock Dialog_Reset(playerid)
{
	g_DG_DialogFunction[playerid]{0} = EOS;
}

stock Dialog_GetCallback(dialog[])
{
	new
		str[48]
	;
	if (!dialog[0]) {
	    return str;
	}
	format(str, 48, "%s@g_DB_DC", dialog);
	return str;
}

stock Dialog_Exists(dialog[])
{
	new
		status = (funcidx(Dialog_GetCallback(dialog)) == -1) ? (0) : (1)
	;
	return status;
}

stock Dialog_ShowEx(playerid, dialog[], style, caption[], info[], button1[], button2[])
{
	if (funcidx("OnDialogReceived") == -1 || CallLocalFunction("OnDialogReceived", "dsd", playerid, dialog, Dialog_Exists(dialog)) != 0)
	{
		strpack(g_DG_DialogFunction[playerid], Dialog_GetCallback(dialog));
		ShowPlayerDialog(playerid, 0, style, caption, info, button1, button2);
	}
	return 1;
}
		
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	new
		pos = -1,
		input[128]
	;
	strcat(input, inputtext);
	
	if (!input[0]) {
		input[0] = '\1';
	}
	while ((pos = strfind(input, "%", true)) != -1) {
		input[pos] = '#';
	}
	if (dialogid == 0 && g_DG_DialogFunction[playerid]{0} != EOS)
	{
	    new function[32];
		strunpack(function, g_DG_DialogFunction[playerid]);
		
		Dialog_Reset(playerid);
		return CallLocalFunction(function, "ddds", playerid, response, listitem, input);
	}
	return CallLocalFunction("DG_OnDialogResponse", "dddds", playerid, dialogid, response, listitem, input);
}

#if defined _ALS_OnDialogResponse
	#undef OnDialogResponse
#else
	#define _ALS_OnDialogResponse
#endif

#define OnDialogResponse DG_OnDialogResponse

forward OnDialogReceived(playerid, dialog[], success);
forward DG_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);