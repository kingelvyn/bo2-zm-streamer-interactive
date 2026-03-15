// ---------------------------------------------------------------------------
// POINTS
// ---------------------------------------------------------------------------
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