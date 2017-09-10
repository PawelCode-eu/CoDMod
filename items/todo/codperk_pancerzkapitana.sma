/* ---------------Perk stworzony dla amxx.pl---------------
------------------przez bulka_z_maslem--------------------- */

#include <amxmodx>
#include <hamsandwich>
#include <codmod>

#define DMG_BULLET (1<<1)

new const perk_name[] = "Pancerz kapitana";
new const perk_desc[] = "Odbijasz LW pociskow na runde";

new bool:ma_perk[33];
new wartosc_perku[33];
new pozostale_strzaly[33];

public plugin_init() 
{
	register_plugin(perk_name, "1.0", "bulka_z_maslem");
	
	cod_register_perk(perk_name, perk_desc, 2, 4);
	
	RegisterHam(Ham_TakeDamage, "player", "TakeDamage");
	
	RegisterHam(Ham_Spawn, "player", "Spawn", 1);
}

public cod_perk_enabled(id, wartosc)
{
	ma_perk[id] = true;
	pozostale_strzaly[id] = (wartosc_perku[id] = wartosc);
}

public cod_perk_disabled(id)
	ma_perk[id] = false;

public TakeDamage(this, idinflictor, idattacker, Float:damage, damagebits)
{
	if(!ma_perk[this])
		return HAM_IGNORED;

	if(pozostale_strzaly[this] > 0 && damagebits & DMG_BULLET)
	{
		pozostale_strzaly[this]--;
		return HAM_SUPERCEDE;
	}
	return HAM_IGNORED;
}

public Spawn(id)
	pozostale_strzaly[id] = wartosc_perku[id];

/* ---------------Perk stworzony dla amxx.pl---------------
------------------przez bulka_z_maslem--------------------- */
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1045\\ f0\\ fs16 \n\\ par }
*/