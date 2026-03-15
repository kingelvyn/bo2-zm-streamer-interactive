#include scripts\zm\streamer_mod\maps\Nuketown\streamer_pools_nuketown;

// Map specific assets

init_nuketown()
{
    if ( isDefined( level.streamer_nuketown_initialized) )
        return;

    level.streamer_nuketown_initialized = true;

    streamer_init_weapon_pool_nuketown();
    streamer_init_perk_pool_nuketown();

    init_buried_perks();
}

init_buried_perks()
{
    if ( isDefined( level.streamer_nuketown_perks_initialized ) )
        return;

    level.streamer_nuketown_perks_initialized = true;
}