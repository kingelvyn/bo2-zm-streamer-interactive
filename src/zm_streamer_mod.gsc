// BO2 Zombies - Streamer Mod V1
// Core spin + weighted reward logic

// ENTRY POINT
// level thread streamer_mod_init();

init()
{
    level thread streamer_mod_init();
}

streamer_mod_init()
{
    if ( !isDefined( level.streamer_mod_initialized ) )
    {
        level.streamer_mod_initialized = true;
        streamer_setup_rewards();
        level.streamer_spin_cooldown_ms = 2000; // 2s per-player cooldown (tweak)

        streamer_setup_input();

        level thread streamer_mod_debug_announce();
    }
}

streamer_mod_debug_announce()
{
    // Simple on-load confirmation that the script is active.
    wait 3;

    players = getentarray( "player", "classname" );
    for ( i = 0; i < players.size; i++ )
    {
        players[i] iprintlnbold( "Streamer Mod V0 by 11 loaded! test" );
    }
}

// ---------------------------------------------------------------------------
// REWARD TABLE
// ---------------------------------------------------------------------------

// You can tune weights & values here.
// All weights are relative (bigger weight = more likely).

streamer_setup_rewards()
{
    level.streamer_rewards = [];

    // Points rewards
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "points_small",   15, "streamer_reward_points", 1000 );
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "points_large",   15, "streamer_reward_points", 5000 );

    // Random weapon (box-style)
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "random_weapon",  50, "streamer_reward_random_weapon", 0 );

    // Random perk
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "random_perk",    10, "streamer_reward_random_perk", 0 );

    // Powerup-style rewards
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "max_ammo",        5, "streamer_reward_powerup", "ammo" );
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "insta_kill",      5, "streamer_reward_powerup", "insta_kill" );
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "firesale",        5, "streamer_reward_powerup", "fire_sale" );

    // Receive all perks 
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "all_perks",       2, "streamer_reward_all_perks", 0 );
}

streamer_make_reward( ref, weight, funcName, data )
{
    reward             = spawnstruct();
    reward.ref         = ref;
    reward.weight      = weight;
    reward.funcName    = funcName; // string name of function to call
    reward.data        = data;     // value / extra data
    return reward;
}

// ---------------------------------------------------------------------------
// TRIGGER HANDLER
// ---------------------------------------------------------------------------

streamer_spin_trigger_use()
{
    self setCursorHint( "HINT_NOICON" );
    self setHintString( "Press &&1 to SPIN" );

    for ( ;; )
    {
        self waittill( "trigger", player );

        if ( !isDefined( player ) || !isPlayer( player ) )
            continue;

        // Cooldown protection
        if ( !streamer_can_spin( player ) )
        {
            remaining = int( ( player.streamer_next_spin_time - gettime() ) / 1000 );
            if ( remaining < 0 )
                remaining = 0;
            player iprintlnbold( "Spin cooling down (" + remaining + "s)" );
            continue;
        }

        player thread streamer_do_spin();
    }
}

// ---------------------------------------------------------------------------
// KEYBIND-BASED INPUT (NO RADIANT)
// ---------------------------------------------------------------------------

streamer_setup_input()
{
    level thread streamer_bind_player_spin_commands();
}

streamer_bind_player_spin_commands()
{
    for ( ;; )
    {
        players = getentarray( "player", "classname" );

        for ( i = 0; i < players.size; i++ )
        {
            player = players[i];

            if ( !isDefined( player.streamer_spin_bound ) )
            {
                player.streamer_spin_bound = true;

                // Bind the custom command "streamer_spin" to +actionslot 3.
                // In-game you will bind F12 to "+actionslot 3" from the console.
                player notifyOnPlayerCommand( "streamer_spin", "+actionslot 3" );

                player thread streamer_player_spin_listener();
            }
        }

        wait 1;
    }
}

streamer_player_spin_listener()
{
    self endon( "disconnect" );

    for ( ;; )
    {
        self waittill( "streamer_spin" );

        if ( !streamer_can_spin( self ) )
        {
            remaining = int( ( self.streamer_next_spin_time - gettime() ) / 1000 );
            if ( remaining < 0 )
                remaining = 0;
            self iprintlnbold( "Spin cooling down (" + remaining + "s)" );
            continue;
        }

        self thread streamer_do_spin();
    }
}

streamer_can_spin( player )
{
    if ( !isDefined( player.streamer_next_spin_time ) )
        return true;

    return gettime() >= player.streamer_next_spin_time;
}

// ---------------------------------------------------------------------------
// CORE SPIN + WEIGHTED SELECTION
// ---------------------------------------------------------------------------

streamer_do_spin()
{
    // Prevent overlapping spins for the same player (multiple threads)
    if ( isDefined( self.streamer_spin_in_progress ) && self.streamer_spin_in_progress )
        return;

    self.streamer_spin_in_progress = true;

    // Set cooldown (even with no loop we keep a per-player delay)
    if ( !isDefined( level.streamer_spin_cooldown_ms ) )
        level.streamer_spin_cooldown_ms = 2000; // 2s default cooldown

    self.streamer_next_spin_time = gettime() + level.streamer_spin_cooldown_ms;

    // Single-shot selection: no reroll loop.
    reward = streamer_pick_weighted_reward();
    if ( isDefined( reward ) )
    {
        success = streamer_apply_reward( self, reward );
        if ( success )
        {
            // Notification text
            self iprintlnbold( "Reward: " + reward.ref );
            self.streamer_spin_in_progress = false;
            return;
        }
    }

    // Fallback if selected reward failed or no valid reward
    // Give small points so the spin is never totally wasted
    streamer_reward_points( self, 1000 );
    self iprintlnbold( "Fallback reward: 1000 points" );

    self.streamer_spin_in_progress = false;
}

streamer_pick_weighted_reward()
{
    if ( !isDefined( level.streamer_rewards ) || !level.streamer_rewards.size )
        return undefined;

    totalWeight = 0;
    for ( i = 0; i < level.streamer_rewards.size; i++ )
    {
        totalWeight += level.streamer_rewards[i].weight;
    }

    if ( totalWeight <= 0 )
        return undefined;

    roll = randomint( totalWeight );
    running = 0;

    for ( i = 0; i < level.streamer_rewards.size; i++ )
    {
        running += level.streamer_rewards[i].weight;
        if ( roll < running )
            return level.streamer_rewards[i];
    }

    // Should never reach here
    return level.streamer_rewards[level.streamer_rewards.size - 1];
}

streamer_apply_reward( player, reward )
{
    if ( !isDefined( reward ) )
        return false;

    // Dispatch explicitly so we avoid any issues with dynamic function calls.
    switch ( reward.ref )
    {
        case "points_small":
        case "points_large":
            return streamer_reward_points( player, reward.data );

        case "random_weapon":
            return streamer_reward_random_weapon( player, reward.data );

        case "random_perk":
            return streamer_reward_random_perk( player, reward.data );

        case "max_ammo":
        case "insta_kill":
        case "firesale":
            return streamer_reward_powerup( player, reward.data );

        case "all_perks":
            return streamer_reward_all_perks( player, reward.data );

        default:
            return false;
    }
}

// ---------------------------------------------------------------------------
// INDIVIDUAL REWARDS
// ---------------------------------------------------------------------------

// POINTS --------------------------------------------------------------------

streamer_reward_points( player, amount )
{
    if ( amount <= 0 )
        return false;

    // Keep this generic: award score directly.
    // (Method checks like `isDefined( player zm_add_points )` are a compile-time syntax error in T6 GSC.)
    player.score += amount;
    player playsound( "zmb_cha_ching" );

    return true;
}

// RANDOM WEAPON -------------------------------------------------------------

streamer_reward_random_weapon( player, _ )
{
    if ( !isDefined( player ) )
        return false;

    if ( !isDefined( level.streamer_weapon_pool ) )
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

    if ( !isDefined( level.streamer_weapon_pool ) )
        return false;

    if ( level.streamer_weapon_pool.size <= 0 )
        return false;

    weap = undefined;

    for ( i = 0; i < 6; i++ )
    {
        testWeap = level.streamer_weapon_pool[ randomint( level.streamer_weapon_pool.size ) ];

        if ( !( player hasWeapon( testWeap ) ) )
        {
            weap = testWeap;
            break;
        }
    }

    if ( !isDefined( weap ) )
        return false;

    weapons = player getWeaponsList();
    maxWeapons = 2;

    if ( player hasPerk( "specialty_extraammo" ) )
        maxWeapons = 3;

    if ( !isDefined( weapons ) || weapons.size < maxWeapons )
    {
        player giveWeapon( weap );

        if ( !( player hasWeapon( weap ) ) )
            return false;

        player switchToWeapon( weap );
        return true;
    }

    current = player getCurrentWeapon();

    if ( !isDefined( current ) || current == "" )
        return false;

    player takeWeapon( current );
    player giveWeapon( weap );

    if ( player hasWeapon( weap ) )
    {
        player switchToWeapon( weap );
        iprintln( "Rolled weapon: " + weap );
        return true;
    }

    // rollback if give failed
    player giveWeapon( current );
    iprintln( "Rolled weapon: " + weap );

    if ( player hasWeapon( current ) )
        player switchToWeapon( current );

    return false;
}


streamer_reward_random_weapon_old( player, _ )
{
    // Example: use the mystery box weapon list or your own custom list.
    // Replace with whatever array you are using.

    if ( !isDefined( level.streamer_weapon_pool ) )
    {
        level.streamer_weapon_pool = [];

        // Default BO2 ZM weapons (safe starter pool). You can expand/replace this list.
        level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "m1911_zm";
        level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "mp5k_zm";
        level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "m14_zm";
        level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "m16_zm";
        level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "galil_zm";
        level.streamer_weapon_pool[level.streamer_weapon_pool.size] = "rpd_zm";
    }

    if ( !level.streamer_weapon_pool.size )
        return false;

    // Roll a random weapon from the pool.
    weap = level.streamer_weapon_pool[ randomint( level.streamer_weapon_pool.size ) ];

    // 3) If player already owns the rolled weapon, fail so the caller
    //    can give fallback points instead.
    if ( player hasWeapon( weap ) )
        return false;

    // 1 & 2) Handle weapon slot limits:
    //    - if under max, just give the weapon;
    //    - if at max, try to give the new weapon, and only if that
    //      succeeds, drop the previously equipped gun. This avoids
    //      ever leaving the player with no weapons if the give fails.
    weapons = player getWeaponsList();
    maxWeapons = 2;
    if ( player hasPerk( "specialty_extraammo" ) )
        maxWeapons = 3;

    if ( isDefined( weapons ) && weapons.size >= maxWeapons )
    {
        current = player getCurrentWeapon();
        player giveWeapon( weap );

        // Validate give BEFORE taking away the old gun, so we never
        // strand the player with no weapons on a failed give.
        if ( !( player hasWeapon( weap ) ) )
            return false;

        player switchToWeapon( weap );

        if ( isDefined( current ) && current != "" && current != weap )
            player takeWeapon( current );

        return true;
    }

    player giveWeapon( weap );
    player switchToWeapon( weap );

    // Validate that the give actually worked (invalid weapon names will fail silently)
    if ( !( player hasWeapon( weap ) ) )
        return false;

    return true;
}

// RANDOM PERK ---------------------------------------------------------------

streamer_reward_random_perk( player, _ )
{
    if ( !isDefined( level.streamer_perk_pool ) )
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

    if ( !level.streamer_perk_pool.size )
        return false;

    attempts = level.streamer_perk_pool.size;
    while ( attempts > 0 )
    {
        idx = randomint( level.streamer_perk_pool.size );
        perkName = level.streamer_perk_pool[idx];

        if ( !streamer_player_has_perk( player, perkName ) )
        {
            streamer_player_set_perk( player, perkName );

            // Validate it applied; if not, reroll
            if ( streamer_player_has_perk( player, perkName ) )
                return true;
            return false;
        }

        attempts--;
    }

    // All perks in pool already owned -> invalid, reroll
    return false;
}

streamer_player_has_perk( player, perkName )
{
    return player hasPerk( perkName );
}

streamer_player_set_perk( player, perkName )
{
    // Use the stock BO2 zombies perk granting function.
    player maps\mp\zombies\_zm_perks::give_perk( perkName );
}

// POWERUPS (MAX AMMO / INSTA KILL / FIRE SALE) ------------------------------

streamer_reward_powerup( player, powerupType )
{
    if ( !isDefined( powerupType ) )
        return false;

    org = player.origin + ( 0, 0, 32 );

    // Use stock BO2 zombies powerup drop function.
    // Names: full_ammo (max ammo), insta_kill, fire_sale, double_points, nuke, carpenter, etc.
    level.powerup_drop_count = 0;

    switch ( powerupType )
    {
        case "ammo":
            powerup = level maps\mp\zombies\_zm_powerups::specific_powerup_drop( "full_ammo", org );
            break;
        case "insta_kill":
            powerup = level maps\mp\zombies\_zm_powerups::specific_powerup_drop( "insta_kill", org );
            break;
        case "fire_sale":
            powerup = level maps\mp\zombies\_zm_powerups::specific_powerup_drop( "fire_sale", org );
            break;
        default:
            return false;
    }

    if ( isDefined( powerup ) )
    {
        powerup thread maps\mp\zombies\_zm_powerups::powerup_timeout();
        return true;
    }

    return false;
}

// RECEIVE ALL PERKS ------------------------------

streamer_reward_all_perks( player, _ )
{
    grantedAny = false;

    if ( !isDefined( player ) )
        return false;

    if ( !isDefined( level.streamer_perk_pool ) )
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

    if ( !level.streamer_perk_pool.size )
        return false;

    for ( i = 0; i < level.streamer_perk_pool.size; i++ )
    {
        perkName = level.streamer_perk_pool[i];

        if ( !streamer_player_has_perk( player, perkName ) )
        {
            streamer_player_set_perk( player, perkName );

            if ( streamer_player_has_perk( player, perkName ) )
                grantedAny = true;
        }
    }

    return grantedAny;
}