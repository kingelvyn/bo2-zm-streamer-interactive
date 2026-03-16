#include scripts\zm\streamer_mod\maps\Mob\streamer_pools_mob;

// Map specific assets

init_mob()
{
    if ( isDefined( level.streamer_mob_initialized) )
        return;

    level.streamer_mob_initialized = true;

    streamer_init_weapon_pool_mob();
    streamer_init_perk_pool_mob();

    level.zombiemode_using_deadshot_perk = 1;
    level.zombiemode_using_electric_cherry_perk = 1;

    init_mob_perks();
}

init_mob_perks()
{
    if ( isDefined( level.streamer_mob_perks_initialized ) )
        return;

    level.streamer_mob_perks_initialized = true;
}