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

                // Dedicated external trigger bind
                player notifyOnPlayerCommand( "streamer_external_spin", "+actionslot 1" );

                player thread streamer_external_spin_listener();
                player iprintlnbold( "^2External spin input enabled" );
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

        self iprintlnbold( "^2External spin triggered" );
        self thread streamer_do_spin();
    }
}