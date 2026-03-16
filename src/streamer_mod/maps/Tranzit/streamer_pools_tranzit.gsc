#include scripts\zm\streamer_mod\maps\streamer_pools_common;

// ---------------------------------------------------------------------------
// TRANZIT POOLS
// Map codename: zm_transit
// ---------------------------------------------------------------------------

streamer_init_weapon_pool_tranzit()
{
    level.streamer_weapon_pool = [];

    // -----------------------------------------------------------------------
    // Wall buys
    // -----------------------------------------------------------------------
    streamer_add_weapon_to_pool( "m14_zm" );
    streamer_add_weapon_to_pool( "rottweil72_zm" );
    streamer_add_weapon_to_pool( "beretta93r_zm" );
    streamer_add_weapon_to_pool( "mp5k_zm" );
    streamer_add_weapon_to_pool( "ak74u_zm" );
    streamer_add_weapon_to_pool( "m16_zm" );
    streamer_add_weapon_to_pool( "870mcs_zm" );

    // -----------------------------------------------------------------------
    // Mystery Box weapons
    // -----------------------------------------------------------------------
    streamer_add_weapon_to_pool( "fiveseven_zm" );
    streamer_add_weapon_to_pool( "kard_zm" );
    streamer_add_weapon_to_pool( "python_zm" );
    streamer_add_weapon_to_pool( "judge_zm" );
    streamer_add_weapon_to_pool( "qcw05_zm" );
    streamer_add_weapon_to_pool( "saritch_zm" );
    streamer_add_weapon_to_pool( "fnfal_zm" );
    streamer_add_weapon_to_pool( "xm8_zm" );
    streamer_add_weapon_to_pool( "type95_zm" );
    streamer_add_weapon_to_pool( "tar21_zm" );
    streamer_add_weapon_to_pool( "galil_zm" );
    streamer_add_weapon_to_pool( "srm1216_zm" );
    streamer_add_weapon_to_pool( "saiga12_zm" );
    streamer_add_weapon_to_pool( "barretm82_zm" );
    streamer_add_weapon_to_pool( "dsr50_zm" );
    streamer_add_weapon_to_pool( "hamr_zm" );
    streamer_add_weapon_to_pool( "rpd_zm" );
    streamer_add_weapon_to_pool( "knife_ballistic_zm" );
    streamer_add_weapon_to_pool( "m32_zm" );
    streamer_add_weapon_to_pool( "usrpg_zm" );
    //streamer_add_weapon_to_pool( "emp_grenade_zm" );              // Grenades need special attention
    streamer_add_weapon_to_pool( "ray_gun_zm" );
    streamer_add_weapon_to_pool( "raygun_mark2_zm" );
    streamer_add_weapon_to_pool( "jetgun_zm" );
    //streamer_add_weapon_to_pool( "cymbal_monkey_zm" );            // Grenades need special attention
}

streamer_init_perk_pool_tranzit()
{
    level.streamer_perk_pool = [];

    streamer_add_perk_to_pool( "specialty_quickrevive" );       // Quick Revive
    streamer_add_perk_to_pool( "specialty_armorvest" );         // Juggernog
    streamer_add_perk_to_pool( "specialty_fastreload" );        // Speed Cola
    streamer_add_perk_to_pool( "specialty_rof" );               // Double Tap II
    streamer_add_perk_to_pool( "specialty_longersprint" );      // Stamin-Up
    streamer_add_perk_to_pool( "specialty_scavenger" );         // Tombstone
}