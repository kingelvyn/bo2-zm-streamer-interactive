// RANDOM PERK ---------------------------------------------------------------

streamer_reward_random_perk( player, _ )
{
    if ( !isDefined( level.streamer_perk_pool ) )
        level.streamer_perk_pool = [];

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

// HELPER FUNCTIONS --------------------------

streamer_player_has_perk( player, perkName )
{
    return player hasPerk( perkName );
}

streamer_player_set_perk( player, perkName )
{
    // Use the stock BO2 zombies perk granting function.
    player maps\mp\zombies\_zm_perks::give_perk( perkName );
}