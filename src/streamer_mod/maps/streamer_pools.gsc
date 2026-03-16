#include scripts\zm\streamer_mod\maps\streamer_pools_common;
#include scripts\zm\streamer_mod\maps\streamer_pools_default;
#include scripts\zm\streamer_mod\maps\Buried\streamer_pools_buried;
#include scripts\zm\streamer_mod\maps\Origins\streamer_pools_origins;
#include scripts\zm\streamer_mod\maps\Tranzit\streamer_pools_tranzit;
#include scripts\zm\streamer_mod\maps\DieRise\streamer_pools_dierise;
#include scripts\zm\streamer_mod\maps\Nuketown\streamer_pools_nuketown;
#include scripts\zm\streamer_mod\maps\Mob\streamer_pools_mob;
#include scripts\zm\streamer_mod\streamer_debug;


// ---------------------------------------------------------------------------
// POOL SETUP
// ---------------------------------------------------------------------------

streamer_init_pools()
{
    mapName = streamer_get_current_map();

    switch ( mapName )
    {
        case "zm_buried":
            streamer_init_weapon_pool_buried();
            streamer_init_perk_pool_buried();
            break;

        case "zm_tomb":
            streamer_init_weapon_pool_origins();
            streamer_init_perk_pool_origins();
            break;

        case "zm_transit":
            streamer_init_weapon_pool_tranzit();
            streamer_init_perk_pool_tranzit();
            break;

        case "zm_highrise":
            streamer_init_weapon_pool_die_rise();
            streamer_init_perk_pool_die_rise();
            break;

        case "zm_prison":
            streamer_init_weapon_pool_mob();
            streamer_init_perk_pool_mob();
            break;

        default:
            streamer_debug_print ("Default pools init");
            streamer_init_weapon_pool_default();
            streamer_init_perk_pool_default();
            break;
    }    
}