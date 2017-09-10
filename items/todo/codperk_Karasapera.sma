/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <fakemeta>
#include <codmod>

new const perk_name[] = "Kara sapera";
new const perk_desc[] = "Widzisz miny, dostajesz 80 hp";

new bool:ma_perk[33];

public plugin_init()
 {
	register_plugin(perk_name, "1.0", "Pas");
	
	cod_register_perk(perk_name, perk_desc);
	register_forward(FM_AddToFullPack, "FwdAddToFullPack", 1)
}

public cod_perk_enabled(id)
{
        client_print(id, print_chat, "Perk %s zostal stworzony przez Pas", perk_name);
	if(cod_get_user_class(id) == cod_get_classid("Obronca"))
		return COD_STOP;
	cod_set_user_bonus_health(id, cod_get_user_health(id, 0, 0)+80);
	ma_perk[id] = true;
	return COD_CONTINUE;
}

public cod_perk_disabled(id)
{
	cod_set_user_bonus_health(id, cod_get_user_health(id, 0, 0)-80);
	ma_perk[id] = false;
}
	

public FwdAddToFullPack(es_handle, e, ent, host, hostflags, player, pSet)
{
	if(!is_user_connected(host))
		return;
	
	if(!ma_perk[host])
		return;
	
	if(!pev_valid(ent))
		return;
	
	new classname[5];
	pev(ent, pev_classname, classname, 4);
	if(equal(classname, "mine"))
	{
		set_es(es_handle, ES_RenderMode, kRenderTransAdd);
		set_es(es_handle, ES_RenderAmt, 255.0);
	}
	
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1045\\ f0\\ fs16 \n\\ par }
*/