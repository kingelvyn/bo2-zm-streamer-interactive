#include scripts\zm\streamer_mod\maps\Mob\streamer_pools_mob;

// Map specific assets

init_mob()
{
    if ( isDefined( level.streamer_origins_initialized) )
        return;

    level.streamer_origins_initialized = true;

    streamer_init_weapon_pool_mob();
    streamer_init_perk_pool_mob();

    init_mob_perks();
}

init_mob_perks()
{
    if ( isDefined( level.streamer_mob_perks_initialized ) )
        return;

    level.streamer_mob_perks_initialized = true;
}