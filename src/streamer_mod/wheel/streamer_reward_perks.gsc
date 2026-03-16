#include scripts\zm\streamer_mod\streamer_debug;
#include maps\mp\zombies\_zm_perks;

// ---------------------------------------------------------------------------
// RANDOM PERK
// ---------------------------------------------------------------------------

streamer_reward_random_perk( player, _ )
{
    availablePerks = [];

    if ( !isDefined( player ) )
        return false;

    if ( !isDefined( level.streamer_perk_pool ) || !level.streamer_perk_pool.size )
        return false;

    for ( i = 0; i < level.streamer_perk_pool.size; i++ )
    {
        perkName = level.streamer_perk_pool[i];

        if ( !streamer_player_has_perk( player, perkName ) )
            availablePerks[availablePerks.size] = perkName;
    }

    if ( !availablePerks.size )
    {
        streamer_debug_print( "Failed: no available perks / max slot reached" );
        return false;
    }

    idx = randomint( availablePerks.size );
    perkName = availablePerks[idx];

    streamer_debug_print( "Perk rolled: " + perkName );
    streamer_player_set_perk( player, perkName );

    if ( streamer_wait_for_perk_apply( player, perkName, 0.25 ) )
    {
        streamer_debug_print( "Perk applied: " + perkName );
        return true;
    }

    streamer_debug_print( "FAILED to apply perk: " + perkName );
    return false;
}

// ---------------------------------------------------------------------------
// RECEIVE ALL PERKS
// ---------------------------------------------------------------------------

streamer_reward_all_perks( player, _ )
{
    grantedAny = false;

    if ( !isDefined( player ) )
        return false;

    if ( !isDefined( level.streamer_perk_pool ) || !level.streamer_perk_pool.size )
    {
        streamer_debug_print( "No perk pool initialized." );
        return false;
    }

    streamer_debug_print( "reward_all_perks: pool size = " + level.streamer_perk_pool.size );

    for ( i = 0; i < level.streamer_perk_pool.size; i++ )
    {
        perkName = level.streamer_perk_pool[i];

        streamer_debug_print( "Trying perk: " + perkName );

        if ( streamer_player_has_perk( player, perkName ) )
        {
            streamer_debug_print( "Already has perk: " + perkName );
            continue;
        }
        
        streamer_debug_print( "Perk received: " + perkName );
        streamer_player_set_perk( player, perkName );

        if ( streamer_wait_for_perk_apply( player, perkName, 0.25 ) )
            grantedAny = true;
        else
            streamer_debug_print( "FAILED perk: " + perkName );
    }

    return grantedAny;
}

// HELPER FUNCTIONS --------------------------

streamer_player_has_perk( player, perkName )
{
    return player hasPerk( perkName );
}

streamer_player_set_perk( player, perkName )
{
    if ( streamer_player_has_perk( player, perkName ) )
        return;

    player maps\mp\zombies\_zm_perks::wait_give_perk( perkName, 1 );
}

streamer_wait_for_perk_apply( player, perkName, timeout )
{
    elapsed = 0;
    interval = 0.05;

    while ( elapsed < timeout )
    {
        if ( streamer_player_has_perk( player, perkName ) )
            return true;

        wait interval;
        elapsed += interval;
    }

    return false;
}

streamer_reward_perk_dispatch( player, reward )
{
    if ( !isDefined( reward ) )
        return false;

    switch ( reward.ref )
    {
        case "random_perk":
            return streamer_reward_random_perk( player, reward.data );

        case "all_perks":
            return streamer_reward_all_perks( player, reward.data );

        default:
            return false;
    }
}