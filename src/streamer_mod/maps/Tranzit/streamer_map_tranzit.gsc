#include scripts\zm\streamer_mod\maps\Tranzit\streamer_pools_tranzit;

// Map specific assets

init_tranzit()
{
    if ( isDefined( level.streamer_tranzit_initialized) )
        return;

    level.streamer_tranzit_initialized = true;

    streamer_init_weapon_pool_tranzit();
    streamer_init_perk_pool_tranzit();

    init_buried_perks();
}

init_tranzit_perks()
{
    if ( isDefined( level.streamer_tranzit_perks_initialized ) )
        return;

    level.streamer_tranzit_perks_initialized = true;
}