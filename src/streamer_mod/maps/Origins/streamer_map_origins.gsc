#include scripts\zm\streamer_mod\maps\Origins\streamer_pools_origins;

// Map specific assets

init_origins()
{
    if ( isDefined( level.streamer_origins_initialized) )
        return;

    level.streamer_origins_initialized = true;

    streamer_init_weapon_pool_origins();
    streamer_init_perk_pool_origins();

    init_buried_perks();
}

init_buried_perks()
{
    if ( isDefined( level.streamer_origins_perks_initialized ) )
        return;

    level.streamer_origins_perks_initialized = true;
}