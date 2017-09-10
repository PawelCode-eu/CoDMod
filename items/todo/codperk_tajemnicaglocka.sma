/* ---------------Perk stworzony dla amxx.pl---------------
------------------przez bulka_z_maslem--------------------- */

#include <amxmodx>
#include <hamsandwich>
#include <codmod>

#define DMG_BULLET (1<<1)

new const perk_name[] = "Tajemnica glocka";
new const perk_desc[] = "Dostajesz glocka + 30dmg z niego oraz usp + 20dmg z niego";

new bool:ma_perk[33];

public plugin_init()
{
	register_plugin(perk_name, "1.0", "bulka_z_maslem");
	
	cod_register_perk(perk_name, perk_desc);
	RegisterHam(Ham_TakeDamage, "player", "TakeDamage");
}

public cod_perk_enabled(id)
{
	cod_give_weapon(id, CSW_GLOCK18);
	cod_give_weapon(id, CSW_USP);
	ma_perk[id] = true;
	return COD_CONTINUE;
}

public cod_perk_disabled(id)
{
	cod_take_weapon(id, CSW_GLOCK18);
	cod_take_weapon(id, CSW_USP);
	ma_perk[id] = false;
}

public TakeDamage(this, idinflictor, idattacker, Float:damage, damagebits)
{
	if(!is_user_connected(idattacker))
		return HAM_IGNORED;
	
	if(!ma_perk[idattacker])
		return HAM_IGNORED;
	
	if(get_user_team(this) != get_user_team(idattacker) && get_user_weapon(idattacker) == CSW_GLOCK18 && damagebits & DMG_BULLET)
		cod_inflict_damage(idattacker, this, 30.0, 0.0, idinflictor, damagebits);
		
	if(get_user_team(this) != get_user_team(idattacker) && get_user_weapon(idattacker) == CSW_USP && damagebits & DMG_BULLET)
		cod_inflict_damage(idattacker, this, 20.0, 0.0, idinflictor, damagebits);
	
	return HAM_IGNORED;
}

/* ---------------Perk stworzony dla amxx.pl---------------
------------------przez bulka_z_maslem--------------------- */
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1045\\ f0\\ fs16 \n\\ par }
*/