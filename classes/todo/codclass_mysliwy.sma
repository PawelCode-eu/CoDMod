/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <codmod>
#include <hamsandwich>
#include <engine>

#define DMG_BULLET (1<<1)

new const model[] = "models/QTM_CodMod/mine.mdl"

new bool:ma_klase[33];

new const nazwa[] = "Mysliwy";
new const opis[] = "Natychmiastowe zabicie z noza(PPM), 1/4 na zabicie ze scout, zwiekszone obrazenia z M3, ma 1 pulapke ktora zakopuje wrogow.";
new const bronie = 1<<CSW_SCOUT | 1<<CSW_M3 | 1<<CSW_USP;
new const zdrowie = 40;
new const kondycja = 20;
new const inteligencja = 5;
new const wytrzymalosc = 0;

new ilosc_pulapek_gracza[33];

public plugin_init() 
{
	register_plugin(nazwa, "1.0", "QTM_Peyote");
	
	cod_register_class(nazwa, opis, bronie, zdrowie, kondycja, inteligencja, wytrzymalosc);
	
	RegisterHam(Ham_TakeDamage, "player", "TakeDamage");
	
	register_event("HLTV", "NowaRunda", "a", "1=0", "2=0");
	register_event("ResetHUD", "ResetHUD", "abe");
	
	register_touch("trap", "player",  "DotykPulapki");
}

public plugin_precache()
	precache_model(model);

public cod_class_enabled(id)
{
	ma_klase[id] = true;
	ResetHUD(id);
}
	
public cod_class_disabled(id)
	ma_klase[id] = false;

public TakeDamage(this, idinflictor, idattacker, Float:damage, damagebits)
{
	if(!is_user_connected(idattacker))
		return HAM_IGNORED;
	
	if(!ma_klase[idattacker])
		return HAM_IGNORED;
		
	if(!(damagebits & DMG_BULLET))
		return HAM_IGNORED;
		
	new weapon = get_user_weapon(idattacker);
	
	if((weapon == CSW_KNIFE && damage > 20.0) || (weapon == CSW_SCOUT && !random(4)))
		damage = get_user_health(this)-damage+1.0;
		
	if(weapon == CSW_M3)
		damage *= 0.2;
		
	cod_inflict_damage(idattacker, this, damage, 0.0, idinflictor, damagebits);
		
	return HAM_IGNORED;
}

public cod_class_skill_used(id)
{		
	if (!ilosc_pulapek_gracza[id])
	{
		client_print(id, print_center, "Wykorzystales juz wszystkie pulapki!");
		return PLUGIN_CONTINUE;
	}
	
	ilosc_pulapek_gracza[id]--;
	
	new Float:origin[3];
	entity_get_vector(id, EV_VEC_origin, origin);
		
	new ent = create_entity("info_target");
	entity_set_string(ent ,EV_SZ_classname, "trap");
	entity_set_edict(ent ,EV_ENT_owner, id);
	entity_set_int(ent, EV_INT_movetype, MOVETYPE_TOSS);
	entity_set_origin(ent, origin);
	entity_set_int(ent, EV_INT_solid, SOLID_BBOX);
	
	entity_set_model(ent, model);
	entity_set_size(ent,Float:{-16.0,-16.0,0.0},Float:{16.0,16.0,2.0});
	
	drop_to_floor(ent);
	
	set_rendering(ent,kRenderFxNone, 0,0,0, kRenderTransTexture,50);
	
	
	return PLUGIN_CONTINUE;
}

public DotykPulapki(ent, id)
{
	if(!is_valid_ent(ent))
		return;
		
	new attacker = entity_get_edict(ent, EV_ENT_owner);
	if (get_user_team(attacker) != get_user_team(id))
	{
		new Float:fOrigin[3];
		entity_get_vector(id, EV_VEC_origin, fOrigin);
		fOrigin[2] -= 30.0;
		entity_set_vector(id, EV_VEC_origin, fOrigin);
		set_task(30.0, "Odkop", id);

		remove_entity(ent);
	}
}

public ResetHUD(id)
	ilosc_pulapek_gracza[id] = 1;

public NowaRunda()
{
	new ent = find_ent_by_class(-1, "trap");
	while(ent > 0) 
	{
		remove_entity(ent);
		ent = find_ent_by_class(ent, "trap");	
	}
}

public client_disconnect(id)
{
	new ent = find_ent_by_class(0, "trap");
	while(ent > 0)
	{
		if(entity_get_edict(id, EV_ENT_owner) == id)
			remove_entity(ent);
		ent = find_ent_by_class(ent, "trap");
	}
}

public Odkop(id)
{
	new Float:fOrigin[3];
	entity_get_vector(id, EV_VEC_origin, fOrigin);
	fOrigin[2] += 30.0;
	entity_set_vector(id, EV_VEC_origin, fOrigin);
}