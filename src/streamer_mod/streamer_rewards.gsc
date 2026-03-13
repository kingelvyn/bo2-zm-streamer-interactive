#include scripts\zm\streamer_mod\streamer_reward_points;
#include scripts\zm\streamer_mod\streamer_reward_weapons;
#include scripts\zm\streamer_mod\streamer_reward_perks;
#include scripts\zm\streamer_mod\streamer_reward_powerups;

// ---------------------------------------------------------------------------
// REWARD TABLE
// ---------------------------------------------------------------------------

// You can tune weights & values here.
// All weights are relative (bigger weight = more likely).

streamer_setup_rewards()
{
    level.streamer_rewards = [];

    // Points rewards
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "points_small",   1, "streamer_reward_points", 1000 );
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "points_large",   1, "streamer_reward_points", 5000 );

    // Random weapon (box-style)
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "random_weapon",  1, "streamer_reward_random_weapon", 0 );

    // Random perk
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "random_perk",     1, "streamer_reward_random_perk", 0 );

    // Powerup-style rewards
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "max_ammo",        1, "streamer_reward_powerup", "ammo" );
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "insta_kill",      1, "streamer_reward_powerup", "insta_kill" );
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "firesale",        1, "streamer_reward_powerup", "fire_sale" );

    // Receive all perks 
    level.streamer_rewards[level.streamer_rewards.size] = streamer_make_reward( "all_perks",       80, "streamer_reward_all_perks", 0 );
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
            self iprintlnbold( "^2Reward: ^5" + reward.ref );
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