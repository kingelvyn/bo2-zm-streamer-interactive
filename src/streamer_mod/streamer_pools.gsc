#include scripts\zm\streamer_mod\streamer_pools_common;
#include scripts\zm\streamer_mod\streamer_pools_default;
#include scripts\zm\streamer_mod\streamer_pools_buried;

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

        //case "zm_transit":
        //    streamer_init_weapon_pool_transit();
        //    streamer_init_perk_pool_transit();
        //    break;

        //case "zm_highrise":
        //    streamer_init_weapon_pool_die_rise();
        //    streamer_init_perk_pool_die_rise();
        //    break;

        //case "zm_prison":
        //    streamer_init_weapon_pool_mob();
        //    streamer_init_perk_pool_mob();
        //    break;

        //case "zm_tomb":
        //    streamer_init_weapon_pool_origins();
        //    streamer_init_perk_pool_origins();
        //    break;

        default:
            streamer_init_weapon_pool_default();
            streamer_init_perk_pool_default();
            break;
    }    
}