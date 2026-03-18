#include scripts\zm\streamer_mod\streamer_debug;
#include maps\mp\zombies\_zm;
#include scripts\zm\streamer_mod\wheel\streamer_reward_points;
#include scripts\zm\streamer_mod\wheel\streamer_reward_weapons;
#include scripts\zm\streamer_mod\wheel\streamer_reward_perks;
#include scripts\zm\streamer_mod\wheel\streamer_reward_powerups;

// ---------------------------------------------------------------------------
// REWARD TABLE
// ---------------------------------------------------------------------------

// You can tune weights & values here.
// All weights are relative (bigger weight = more likely).

streamer_setup_rewards()
{
    level.streamer_rewards = [];

    // Points rewards
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "points_small", "+1000 Points", "points",   15, 1000 );
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "points_large", "+5000 Points", "points",   15, 5000 );
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "points_wipe",    "Points removed mwahahaha",    "points",    5, 0 );

    // Random weapon (box-style)
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "random_weapon", "Random Weapon", "weapon", 15, 0 );

    // Give Raygun Mark 2
    //level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "raygun_mk2", "Ray Gun Mark II", "weapon",    3, "raygun_mark2_zm" );

    // Random perk
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "random_perk", "Random Perk", "perk",       5, 0 );

    // Powerup-style rewards
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "max_ammo", "Max Ammo", "powerup",          5, "ammo" );
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "insta_kill", "Insta-Kill", "powerup",      5, "insta_kill" );
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "firesale", "FIRESALE", "powerup",          5, "fire_sale" );
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "nuke", "Nuke", "powerup",                  5, "nuke" );
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "carpenter", "Carpenter", "powerup",        5, "carpenter" );
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "double_points", "2X Points", "powerup",    5, "double_points" );

    // Receive all perks 
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "all_perks", "All Perks", "perk",           1, 0 );
    // Remove random perk
    //level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "remove_perk", "Raandom perk removed",   "perk",      5, "remove" );

    // Skip to next round
    //level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "next_round", "Round skipped", "round",     20, 0 );
}

streamer_make_reward( ref, displayName, type, weight, data )
{
    reward             = spawnstruct();
    reward.ref         = ref;
    reward.displayName = displayName; 
    reward.type        = type;              // string of category of reward     
    reward.weight      = weight;
    reward.data        = data;              // value / extra data
    return reward;
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
        level.streamer_spin_cooldown_ms = 3000; // 2s default cooldown

    self.streamer_next_spin_time = gettime() + level.streamer_spin_cooldown_ms;

    // Single-shot selection: no reroll loop.
    reward = streamer_pick_weighted_reward();
    if ( isDefined( reward ) )
    {
        success = streamer_apply_reward( self, reward );
        if ( success )
        {
            // Notification text
            self iprintlnbold( "^2Random Reward: ^5" + reward.displayName );
            self.streamer_spin_in_progress = false;
            return;
        }
    }

    // Fallback if selected reward failed or no valid reward
    // Give small points so the spin is never totally wasted
    streamer_reward_points( self, 1000 );
    self iprintlnbold( "^2Fallback reward: ^51000 points" );

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
    switch ( reward.type )
    {
        case "points":
            if ( reward.ref == "points_wipe" )
            {
                streamer_debug_print( "Points removed mwahahaha" );
                player.score = 0;
                return true;
            }
            streamer_debug_print ("Points: " + reward.data);
            return streamer_reward_points( player, reward.data );

        case "weapon":
        if ( reward.ref == "raygun_mk2" )
            {
                streamer_debug_print ( "Giving Ray Gun Mark II" );
                player giveWeapon ( reward.data );
                player switchToWeapon ( reward.data );
                return true;
            }
            return streamer_reward_weapon_dispatch( player, reward );

        case "perk":
            if ( reward.ref == "remove_perk" )
            {
                streamer_debug_print ( "Removing random perk mwahahahah" );
                return streamer_reward_perk_dispatch ( player, reward );
            }
            return streamer_reward_perk_dispatch( player, reward );

        case "powerup":
            streamer_debug_print ("Powerup: " + reward.data);
            return streamer_reward_powerup( player, reward.data );

        case "round":
            streamer_debug_print( "Current round: " + level.round_number );
            level thread streamer_skip_round();
            streamer_debug_print( "Skip round called" );
            return true;

        default:
            return false;
    }
}

streamer_skip_round()
{
    nextRound = level.round_number + 1;
    level.round_number = nextRound;
    level.zombie_total = 0;
    level.zombie_count = 0;
    level notify( "end_of_round" );
    streamer_debug_print( "Round set to: " + nextRound );
}