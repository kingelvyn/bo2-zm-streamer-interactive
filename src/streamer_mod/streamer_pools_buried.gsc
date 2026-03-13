#include scripts\zm\streamer_mod\streamer_pools_common;

// ---------------------------------------------------------------------------
// BURIED POOLS
// Map codename: zm_buried
// ---------------------------------------------------------------------------

streamer_init_weapon_pool_buried()
{
    level.streamer_weapon_pool = [];

    // -----------------------------------------------------------------------
    // Wall buys
    // -----------------------------------------------------------------------
    streamer_add_weapon_to_pool( "m14_zm" );         // M14
    streamer_add_weapon_to_pool( "rottweil72_zm" );  // Olympia
    streamer_add_weapon_to_pool( "beretta93r_zm" );  // B23R
    streamer_add_weapon_to_pool( "mp5k_zm" );        // MP5
    streamer_add_weapon_to_pool( "ak74u_zm" );       // AK74u
    streamer_add_weapon_to_pool( "pdw57_zm" );       // PDW-57
    streamer_add_weapon_to_pool( "m16_zm" );         // Colt M16A1
    streamer_add_weapon_to_pool( "an94_zm" );        // AN-94
    streamer_add_weapon_to_pool( "870mcs_zm" );      // Remington 870 MCS
    streamer_add_weapon_to_pool( "svu_zm" );         // SVU-AS
    streamer_add_weapon_to_pool( "lsat_zm" );        // LSAT

    // -----------------------------------------------------------------------
    // Mystery Box weapons that fit your current random gun logic
    // -----------------------------------------------------------------------
    streamer_add_weapon_to_pool( "knife_ballistic_zm" ); // Ballistic Knife
    streamer_add_weapon_to_pool( "barretm82_zm" );       // Barrett M82A1
    streamer_add_weapon_to_pool( "dsr50_zm" );           // DSR 50
    streamer_add_weapon_to_pool( "judge_zm" );           // Executioner
    streamer_add_weapon_to_pool( "fnfal_zm" );           // FAL
    streamer_add_weapon_to_pool( "fiveseven_zm" );       // Five-seven
    streamer_add_weapon_to_pool( "galil_zm" );           // Galil
    streamer_add_weapon_to_pool( "hamr_zm" );            // HAMR
    streamer_add_weapon_to_pool( "kard_zm" );            // KAP-40
    streamer_add_weapon_to_pool( "srm1216_zm" );         // M1216
    streamer_add_weapon_to_pool( "tar21_zm" );           // MTAR
    streamer_add_weapon_to_pool( "usrpg_zm" );           // RPG
    streamer_add_weapon_to_pool( "saiga12_zm" );         // S12
    streamer_add_weapon_to_pool( "saritch_zm" );         // SMR
    streamer_add_weapon_to_pool( "m32_zm" );             // War Machine

    // Wonder weapons that still behave like weapon grants
    streamer_add_weapon_to_pool( "ray_gun_zm" );         // Ray Gun
    streamer_add_weapon_to_pool( "raygun_mark2_zm" );    // Ray Gun Mark II
    streamer_add_weapon_to_pool( "slowgun_zm" );         // Paralyzer
    streamer_add_weapon_to_pool( "time_bomb" );          // Time Bomb
    streamer_add_weapon_to_pool( "cymbal_monkey" );      // Monkey Bombs
    streamer_add_weapon_to_pool( "remingtonnewarmy_zm" );// Remington New Army
}

streamer_init_perk_pool_buried()
{
    level.streamer_perk_pool = [];

    streamer_add_perk_to_pool( "specialty_armorvest" );     // Juggernog
    streamer_add_perk_to_pool( "specialty_quickrevive" );   // Quick Revive
    streamer_add_perk_to_pool( "specialty_fastreload" );    // Speed Cola
    streamer_add_perk_to_pool( "specialty_rof" );           // Double Tap
    streamer_add_perk_to_pool( "specialty_longersprint" );  // Stamin-Up
    streamer_add_perk_to_pool( "specialty_extraammo" );     // Mule Kick
    streamer_add_perk_to_pool( "specialty_vultureaid" );    // Vulture aid
}