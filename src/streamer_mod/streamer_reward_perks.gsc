#include scripts\zm\streamer_mod\streamer_debug;

// RANDOM PERK ---------------------------------------------------------------

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
        return false;

    idx = randomint( availablePerks.size );
    perkName = availablePerks[idx];

    streamer_player_set_perk( player, perkName );
    streamer_debug_print( "Perk rolled: " + perkName );

    if ( streamer_wait_for_perk_apply( player, perkName, 0.25 ) )
    {
        streamer_debug_print( "Perk applied: " + perkName );
        return true;
    }

    streamer_debug_print( "FAILED perk: " + perkName );
    return false;
}

// RECEIVE ALL PERKS ------------------------------

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

    for ( i = 0; i < level.streamer_perk_pool.size; i++ )
    {
        perkName = level.streamer_perk_pool[i];

        if ( streamer_player_has_perk( player, perkName ) )
            continue;

        streamer_player_set_perk( player, perkName );
        streamer_debug_print( "Perk received: " + perkName );

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
    if ( player hasPerk( perkName ) )
        return true;

    return false;
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