/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <hamsandwich>
#include <fun>
#include <codmod>
#include <colorchat>

#define DMG_BULLET (1<<1)
#define DMG_DEAGLE (1<<4)

new const perk_name[] = "Esencje Deagle";
new const perk_desc[] = "1/4 Na Natychmiastowe zabicie ze DEAGL'A";

new bool:ma_perk[33];

public plugin_init() 
{
	register_plugin(perk_name, "1.0", "Pas");
	
	cod_register_perk(perk_name, perk_desc);
	RegisterHam(Ham_TakeDamage, "player", "TakeDamage");
}

public cod_perk_enabled(id)
{
        client_print(id, print_chat, "Perk %s zostal stworzony przez Pas", perk_name);
	cod_give_weapon(id, CSW_DEAGLE);
	ma_perk[id] = true;
}

public cod_perk_disabled(id)
{
	cod_take_weapon(id, CSW_DEAGLE);
	ma_perk[id] = false;
}
	
public TakeDamage(this, idinflictor, idattacker, Float:damage, damagebits)
{
	if(!is_user_connected(idattacker))
		return HAM_IGNORED;
	
	if(!ma_perk[idattacker])
		return HAM_IGNORED;
	
	if(damagebits & DMG_DEAGLE && !random(4))
		cod_inflict_damage(idattacker, this, float(get_user_health(this))-damage+1.0, 0.0, idinflictor, damagebits);
		
	return HAM_IGNORED;
}

/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1045\\ f0\\ fs16 \n\\ par }
*/