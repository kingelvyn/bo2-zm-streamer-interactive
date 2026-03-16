#include scripts\zm\streamer_mod\maps\DieRise\streamer_pools_dierise;
#include scripts\zm\_zm_perk_whoswho;

// Map specific assets

init_dierise()
{
    if ( isDefined( level.streamer_dierise_initialized) )
        return;

    level.streamer_dierise_initialized = true;

    streamer_init_weapon_pool_die_rise();
    streamer_init_perk_pool_die_rise();
    
    init_dierise_perks();
}

init_dierise_perks()
{
    if ( isDefined( level.streamer_die_rise_perks_initialized ) )
        return;

    level.streamer_die_rise_perks_initialized = true;

    thread zm_perk_whoswho::init();
}