#include scripts\zm\streamer_mod\wheel\streamer_rewards;

// ---------------------------------------------------------------------------
// EXTERNAL SPIN INPUT - from Twitch
// ---------------------------------------------------------------------------

streamer_setup_external_spin_input()
{
    level thread streamer_bind_external_spin_command();
}

streamer_bind_external_spin_command()
{
    for ( ;; )
    {
        players = getentarray( "player", "classname" );

        for ( i = 0; i < players.size; i++ )
        {
            player = players[i];

            if ( !isDefined( player.streamer_external_spin_bound ) )
            {
                player.streamer_external_spin_bound = true;
                player notifyOnPlayerCommand( "streamer_external_spin", "+actionslot 1" );
                player thread streamer_external_spin_listener();
                player iprintlnbold( "^2Twitch spin input enabled!" );
            }
        }

        wait 1;
    }
}

streamer_external_spin_listener()
{
    self endon( "disconnect" );

    for ( ;; )
    {
        self waittill( "streamer_external_spin" );

        // Only fire if this was triggered externally from Twitch
        if ( !isDefined( level.streamer_external_spin_pending ) || !level.streamer_external_spin_pending )
            continue;

        level.streamer_external_spin_pending = false;

        self iprintlnbold( "^2Twitch spin triggered!" );
        self thread streamer_do_spin();
    }
}