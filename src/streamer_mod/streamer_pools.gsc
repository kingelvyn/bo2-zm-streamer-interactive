// ---------------------------------------------------------------------------
// POOL SETUP
// ---------------------------------------------------------------------------

streamer_init_pools()
{
    switch ( level.script )
    {
        case "zm_transit":
            streamer_init_weapon_pool();
            streamer_init_perk_pool();
            break;

        default:
            streamer_init_weapon_pool();
            streamer_init_perk_pool();
            iprintln( "WEAPON & PERK POOLS LOADED" );
            break;
    }
    
}

streamer_init_weapon_pool()
{
    level.streamer_weapon_pool = [];

    // Wall buys
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "m14_zm";          // M14
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "rottweil72_zm";   // Olympia
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "mp5k_zm";         // MP5
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "870mcs_zm";       // Remington 870 MCS
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "ak74u_zm";        // AK-74u
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "m16_zm";          // M16A4
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "beretta93r_zm";   // B23R (bus)

    // Box weapons
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "knife_ballistic_zm"; // Ballistic Knife
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "barretm82_zm";       // Barrett M82A1
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "qcw05_zm";           // Chicom CQB
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "dsr50_zm";           // DSR 50
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "judge_zm";           // Executioner
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "fnfal_zm";           // FAL
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "fiveseven_zm";       // Five-seven
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "galil_zm";           // Galil
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "hamr_zm";            // HAMR
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "kard_zm";            // KAP-40
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "srm1216_zm";         // M1216
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "xm8_zm";             // M8A1
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "tar21_zm";           // MTAR
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "python_zm";          // Python
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "rpd_zm";             // RPD
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "usrpg_zm";           // RPG
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "saiga12_zm";         // S12
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "saritch_zm";         // SMR
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "type95_zm";          // Type 25
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "m32_zm";             // War Machine

    // Wonder / specials that behave like weapons
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "ray_gun_zm";         // Ray Gun
    level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "raygun_mark2_zm";    // Ray Gun Mark II
}

streamer_init_perk_pool()
{
    level.streamer_perk_pool = [];

    // Core BO2 zombies perks. This list is safe on most maps.
    level.streamer_perk_pool[level.streamer_perk_pool.size] = "specialty_armorvest";     // Juggernog
    level.streamer_perk_pool[level.streamer_perk_pool.size] = "specialty_quickrevive";   // Quick Revive
    level.streamer_perk_pool[level.streamer_perk_pool.size] = "specialty_fastreload";    // Speed Cola
    level.streamer_perk_pool[level.streamer_perk_pool.size] = "specialty_rof";           // Double Tap
    level.streamer_perk_pool[level.streamer_perk_pool.size] = "specialty_extraammo";     // Mule Kick
    level.streamer_perk_pool[level.streamer_perk_pool.size] = "specialty_longersprint";  // Stamin-Up
}
