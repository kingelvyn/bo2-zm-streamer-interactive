#include scripts\zm\streamer_mod\maps\streamer_pools_common;

// ---------------------------------------------------------------------------
// ORIGINS POOLS
// Map codename: zm_tomb
// ---------------------------------------------------------------------------

streamer_init_weapon_pool_origins()
{
    level.streamer_weapon_pool = [];

    // -----------------------------------------------------------------------
    // Wall buys
    // -----------------------------------------------------------------------
    streamer_add_weapon_to_pool( "m14_zm" );
    streamer_add_weapon_to_pool( "mp44_zm" );
    streamer_add_weapon_to_pool( "870mcs_zm" );
    streamer_add_weapon_to_pool( "ak74u_zm" );
    streamer_add_weapon_to_pool( "mp40_zm" );
    streamer_add_weapon_to_pool( "ballista_zm" );
    streamer_add_weapon_to_pool( "beretta93r_zm" );
    streamer_add_weapon_to_pool( "fiveseven_zm" );
    streamer_add_weapon_to_pool( "beacon_zm" );

    // -----------------------------------------------------------------------
    // Mystery Box weapons
    // -----------------------------------------------------------------------
    streamer_add_weapon_to_pool( "hamr_zm" );
    streamer_add_weapon_to_pool( "mg08_zm" );
    streamer_add_weapon_to_pool( "type95_zm" );
    streamer_add_weapon_to_pool( "galil_zm" );
    streamer_add_weapon_to_pool( "fnfal_zm" );
    streamer_add_weapon_to_pool( "scar_zm" );
    streamer_add_weapon_to_pool( "ksg_zm" );
    streamer_add_weapon_to_pool( "srm1216_zm" );
    streamer_add_weapon_to_pool( "ak74u_extclip_zm" );
    streamer_add_weapon_to_pool( "pdw57_zm" );
    streamer_add_weapon_to_pool( "thompson_zm" );
    streamer_add_weapon_to_pool( "qcw05_zm" );
    streamer_add_weapon_to_pool( "stalker_mp40_zm" );
    streamer_add_weapon_to_pool( "evoskorpion_zm" );
    streamer_add_weapon_to_pool( "dsr50_zm" );
    streamer_add_weapon_to_pool( "beretta93r_extclip_zm" );
    streamer_add_weapon_to_pool( "kard_zm" );
    streamer_add_weapon_to_pool( "python_zm" );
    streamer_add_weapon_to_pool( "fivesevendw_zm" );
    streamer_add_weapon_to_pool( "m32_zm" );
    //streamer_add_weapon_to_pool( "cymbal_monkey_zm" );
    streamer_add_weapon_to_pool( "ray_gun_zm" );
    streamer_add_weapon_to_pool( "raygun_mark2_zm" );
}

streamer_init_perk_pool_origins()
{
    level.streamer_perk_pool = [];

    streamer_add_perk_to_pool( "specialty_armorvest" );             // Juggernog
    streamer_add_perk_to_pool( "specialty_quickrevive" );           // Quick Revive
    streamer_add_perk_to_pool( "specialty_fastreload" );            // Speed Cola
    streamer_add_perk_to_pool( "specialty_rof" );                   // Double Tap II
    streamer_add_perk_to_pool( "specialty_longersprint" );          // Stamin-Up
    streamer_add_perk_to_pool( "specialty_additionalprimaryweapon" );          // Mule Kick
    streamer_add_perk_to_pool( "specialty_ads_zombies" );           // Deadshot Daiquiri
}