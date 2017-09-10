/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <fun>
#include <codmod>

#define DMG_BULLET (1<<1)

new const perk_name[] = "Niewidzialny";
new const perk_desc[] = "Jestes niewidoczny";

new bool:ma_perk[33];

public plugin_init() 
{
	register_plugin(perk_name, "1.0", "Pas");
	
	cod_register_perk(perk_name, perk_desc);
	register_event("ResetHUD", "ResetHUD", "abe");
}

public cod_perk_enabled(id)
{
	client_print(id, print_chat, "Perk %s zostal stworzony przez Pas", perk_name);
	ma_perk[id] = true;
}

public cod_perk_disabled(id)
{
	set_user_rendering(id,kRenderFxGlowShell,0,0,0 ,kRenderTransAlpha, 255);
	ma_perk[id] = false;
}
	

public ResetHUD(id)
{
	if(ma_perk[id])
		set_task(0.5, "UstawStalker", id)
}


public UstawStalker(id)
{
	if(is_user_connected(id))
	{
		set_user_rendering(id,kRenderFxGlowShell,0,0,0 ,kRenderTransAlpha, 1);
	}
}