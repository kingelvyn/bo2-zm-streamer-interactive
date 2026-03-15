#include scripts\zm\streamer_mod\streamer_debug;

// ---------------------------------------------------------------------------
// RANDOM WEAPON
// ---------------------------------------------------------------------------
streamer_reward_random_weapon( player, _ )
{
    if ( !isDefined( player ) )
        return false;

    if ( !isDefined( level.streamer_weapon_pool ) )
        return false;

    if ( level.streamer_weapon_pool.size <= 0 )
        return false;

    trackedWeaponCount = streamer_count_reward_pool_weapons( player );
    current = player getCurrentWeapon();
    weap = undefined;

    // -----------------------------------------------------------------------
    // Case 1: Player has room for another reward-pool weapon
    // Example: only starter pistol, or starter pistol + no tracked box gun yet
    // -----------------------------------------------------------------------
    if ( trackedWeaponCount < 1 )
    {
        for ( i = 0; i < 10; i++ )
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

        player giveWeapon( weap );

        if ( !( player hasWeapon( weap ) ) )
            return false;

        player switchToWeapon( weap );
        streamer_debug_print( "Rolled weapon success: " + weap );
        return true;
    }

    // -----------------------------------------------------------------------
    // Case 2: Player already has a tracked reward weapon
    // Replace the currently equipped weapon for chaos
    // -----------------------------------------------------------------------
    if ( !isDefined( current ) || current == "" )
        return false;

    for ( i = 0; i < 10; i++ )
    {
        testWeap = level.streamer_weapon_pool[ randomint( level.streamer_weapon_pool.size ) ];

        if ( testWeap != current && !( player hasWeapon( testWeap ) ) )
        {
            weap = testWeap;
            break;
        }
    }

    if ( !isDefined( weap ) )
        return false;

    player takeWeapon( current );
    player giveWeapon( weap );

    if ( player hasWeapon( weap ) )
    {
        player switchToWeapon( weap );
        streamer_debug_print( "Rolled weapon success: " + weap );
        return true;
    }

    // rollback if give failed
    player giveWeapon( current );

    if ( player hasWeapon( current ) )
        player switchToWeapon( current );

    streamer_debug_print( "Rolled weapon failed: " + weap );
    return false;
}

// ---------------------------------------------------------------------------
// HELPER FUNCTIONS
// ---------------------------------------------------------------------------
streamer_count_reward_pool_weapons( player )
{
    count = 0;

    if ( !isDefined( player ) )
        return 0;

    if ( !isDefined( level.streamer_weapon_pool ) )
        return 0;

    for ( i = 0; i < level.streamer_weapon_pool.size; i++ )
    {
        if ( player hasWeapon( level.streamer_weapon_pool[i] ) )
            count++;
    }

    return count;
}

streamer_reward_weapon_dispatch( player, reward )
{
    if ( !isDefined( reward ) )
        return false;

    switch ( reward.ref )
    {
        case "random_weapon":
            return streamer_reward_random_weapon( player, reward.data );

        default:
            return false;
    }
}