#include scripts\zm\streamer_mod\maps\streamer_pools_common;

// ---------------------------------------------------------------------------
// MOB OF THE DEAD POOLS
// Map codename: zm_prison
// ---------------------------------------------------------------------------

streamer_init_weapon_pool_mob()
{
    level.streamer_weapon_pool = [];

    // -----------------------------------------------------------------------
    // Wall buys
    // -----------------------------------------------------------------------
    streamer_add_weapon_to_pool( "beretta93r_zm" );
    streamer_add_weapon_to_pool( "uzi_zm" );
    streamer_add_weapon_to_pool( "thompson_zm" );
    streamer_add_weapon_to_pool( "mp5k_zm" );
    streamer_add_weapon_to_pool( "rottweil72_zm" );
    streamer_add_weapon_to_pool( "870mcs_zm" );
    streamer_add_weapon_to_pool( "m14_zm" );

    // -----------------------------------------------------------------------
    // Mystery Box weapons
    // -----------------------------------------------------------------------
    streamer_add_weapon_to_pool( "m1911_zm" );
    streamer_add_weapon_to_pool( "judge_zm" );
    streamer_add_weapon_to_pool( "fiveseven_zm" );
    streamer_add_weapon_to_pool( "fivesevendw_zm" );
    streamer_add_weapon_to_pool( "pdw57_zm" );
    streamer_add_weapon_to_pool( "saiga12_zm" );
    streamer_add_weapon_to_pool( "ak47_zm" );
    streamer_add_weapon_to_pool( "tar21_zm" );
    streamer_add_weapon_to_pool( "galil_zm" );
    streamer_add_weapon_to_pool( "fnfal_zm" );
    streamer_add_weapon_to_pool( "dsr50_zm" );
    streamer_add_weapon_to_pool( "barretm82_zm" );
    streamer_add_weapon_to_pool( "minigun_alcatraz_zm" );
    streamer_add_weapon_to_pool( "lsat_zm" );
    streamer_add_weapon_to_pool( "usrpg_zm" );
    streamer_add_weapon_to_pool( "ray_gun_zm" );
    streamer_add_weapon_to_pool( "raygun_mark2_zm" );
    streamer_add_weapon_to_pool( "blundergat_zm" );
    streamer_add_weapon_to_pool( "blundersplat_zm" );
    //streamer_add_weapon_to_pool( "cymbal_monkey_zm" );            // Grenades need special atention
}

streamer_init_perk_pool_mob()
{
    level.streamer_perk_pool = [];

    streamer_add_perk_to_pool( "specialty_armorvest" );             // Juggernog
    streamer_add_perk_to_pool( "specialty_fastreload" );            // Speed Cola
    streamer_add_perk_to_pool( "specialty_rof" );                   // Double Tap II
    streamer_add_perk_to_pool( "specialty_grenadepulldeath" );      // Electric Cherry
    streamer_add_perk_to_pool( "specialty_deadshot" );           // Deadshot Daquiri
}