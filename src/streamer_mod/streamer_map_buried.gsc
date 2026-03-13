#include scripts\zm\streamer_mod\streamer_pools_buried;
#include scripts\zm\_zm_perk_vulture;

init_buried()
{
    if ( isDefined( level.streamer_buried_initialized ) )
        return;

    level.streamer_buried_initialized = true;

    streamer_init_weapon_pool_buried();
    streamer_init_perk_pool_buried();

    init_buried_perks();
}

init_buried_perks()
{
    if ( isDefined( level.streamer_buried_perks_initialized ) )
        return;

    level.streamer_buried_perks_initialized = true;

    thread zm_perk_vulture::init();
}