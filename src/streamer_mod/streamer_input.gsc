#include scripts\zm\streamer_mod\wheel\streamer_rewards;

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
// KEYBIND-BASED INPUT
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

                // Bind the custom command "streamer_spin" to +actionslot 1
                player notifyOnPlayerCommand( "streamer_spin", "+actionslot 1" );

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
