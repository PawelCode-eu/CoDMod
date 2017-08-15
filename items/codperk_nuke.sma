/* Klasa stworzona przy pomocy AMXX-Studio */

#include <amxmodx>
#include <codmod>
#include <cstrike>
#include <hamsandwich>
#include <fakemeta>

#define MAX 32

new const perk_name[] = "NUKE";
new const perk_desc[] = "Po uzyciu zabija wszystkich na mapie i znika";

new ma_perk[33];
new bool:nuke[MAX+1];
new bool:nuke_player[MAX+1];
new licznik_zabic[MAX+1];
new ZmienKilla[2];

public plugin_init(){
	register_plugin(perk_name, "1.0", "Trikolos")
	cod_register_perk(perk_name, perk_desc);	
	register_message(get_user_msgid("DeathMsg"), "message_DeathMsg")
}

public plugin_precache(){
	precache_sound("mw/nuke_friend.wav");
	precache_sound("mw/nuke_enemy.wav"); 
}

public cod_perk_enabled(id)
	ma_perk[id] = true;

public cod_class_disabled(id)
	ma_perk[id] = false;

public cod_perk_used(id){
	if (is_user_alive(id))
	{
		UzyjChemi(id);
	}
}

public UzyjChemi(id){
	new num, players[32];
	get_players(players, num, "gh");
	for(new a = 0; a < num; a++)
	{
		new i = players[a];
		if(is_user_alive(i))
			Display_Fade(i,(10<<12),(10<<12),(1<<16),255, 42, 42,171);
		
		if(get_user_team(id) != get_user_team(i))
			client_cmd(i, "spk sound/mw/nuke_enemy.wav");
		else
			client_cmd(i, "spk sound/mw/nuke_friend.wav");
	}
	new nick[64];
	get_user_name(id, nick, 63);
	set_hudmessage(255, 0, 0, -1.0, 0.25, 0, 6.0, 7.0);
	show_hudmessage(0, "Gracz %s uruchomil perk: NUKE!!!", nick);
	set_task(10.0,"shakehud");
	set_task(13.5,"del_nuke", id);
	set_task(1.0, "wyrzuc", id)
}

public shakehud(){
	new num, players[32];
	get_players(players, num, "gh");
	for(new a = 0; a < num; a++)
	{
		new i = players[a];
		if(is_user_alive(i))
		{
			Display_Fade(i,(3<<12),(3<<12),(1<<16),255, 85, 42,215);
			message_begin(MSG_ONE, get_user_msgid("ScreenShake"), {0,0,0}, i);
			write_short(255<<12);
			write_short(4<<12);
			write_short(255<<12);
			message_end();
		}
	}
}

public del_nuke(id){
	new num, players[32];
	get_players(players, num, "gh");
	for(new a = 0; a < num; a++)
	{
		new i = players[a];
		if(is_user_alive(i))
		{
			if(get_user_team(id) != get_user_team(i))
			{
				cs_set_user_armor(i, 0, CS_ARMOR_NONE);
				UTIL_Kill(id, i, float(get_user_health(i)), DMG_BULLET)
			}
			else
				user_silentkill(i);
		}
	}
	nuke_player[id] = false;
	licznik_zabic[id] = 0;
}

stock Display_Fade(id,duration,holdtime,fadetype,red,green,blue,alpha){
	message_begin(MSG_ONE, get_user_msgid("ScreenFade"),{0,0,0},id);
	write_short(duration);
	write_short(holdtime);
	write_short(fadetype);
	write_byte(red);
	write_byte(green);
	write_byte(blue);
	write_byte(alpha);
	message_end();
}

stock UTIL_Kill(atakujacy, obrywajacy, Float:damage, damagebits, ile=0){
	ZmienKilla[ile] |= (1<<atakujacy);
	ExecuteHam(Ham_TakeDamage, obrywajacy, atakujacy, atakujacy, damage, damagebits);
	ZmienKilla[ile] &= ~(1<<atakujacy);
}

public client_putinserver(id){
	licznik_zabic[id] = 0;
}

public message_DeathMsg(){
	new killer = get_msg_arg_int(1);
	if(ZmienKilla[0] & (1<<killer))
	{
		set_msg_arg_string(4, "grenade");
		return PLUGIN_CONTINUE;
	}
	return PLUGIN_CONTINUE;
}

public wyrzuc(id)
{
	client_cmd(id, "say /drop")
}