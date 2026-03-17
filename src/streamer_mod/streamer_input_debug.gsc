#include scripts\zm\streamer_mod\streamer_debug;
#include scripts\zm\streamer_mod\wheel\streamer_reward_weapons;
#include scripts\zm\streamer_mod\wheel\streamer_reward_perks;

// ---------------------------------------------------------------------------
// STREAMER REWARD TEST BINDS
// ---------------------------------------------------------------------------

streamer_reward_test_setup()
{
    level thread streamer_bind_reward_test_commands();
}

streamer_bind_reward_test_commands()
{
    for ( ;; )
    {
        players = getentarray( "player", "classname" );

        for ( i = 0; i < players.size; i++ )
        {
            player = players[i];

            if ( !isDefined( player.streamer_reward_test_bound ) )
            {
                player.streamer_reward_test_bound = false;

                // Main binds
                player notifyOnPlayerCommand( "test_random_weapon", "+actionslot 2" );
                player notifyOnPlayerCommand( "test_random_perk", "+actionslot 3" );
                player notifyOnPlayerCommand( "test_all_perks", "+actionslot 4" );

                player thread streamer_reward_test_listener_random_weapon();
                player thread streamer_reward_test_listener_random_perk();
                player thread streamer_reward_test_listener_all_perks();

                player iprintlnbold( "^2Streamer reward test binds enabled" );
            }
        }

        wait 1;
    }
}

// ---------------------------------------------------------------------------
// RANDOM WEAPON
// ---------------------------------------------------------------------------

streamer_reward_test_listener_random_weapon()
{
    self endon( "disconnect" );

    for ( ;; )
    {
        self waittill( "test_random_weapon" );

        if ( !streamer_test_binds_enabled() )
            continue;

        self iprintlnbold( "^2Testing Reward: ^5Random Weapon" );

        reward = spawnstruct();
        reward.ref = "random_weapon";
        reward.displayName = "Random Weapon";
        reward.type = "weapon";
        reward.weight = 0;
        reward.data = 0;

        streamer_reward_weapon_dispatch( self, reward );
    }
}

// ---------------------------------------------------------------------------
// RANDOM PERK
// ---------------------------------------------------------------------------

streamer_reward_test_listener_random_perk()
{
    self endon( "disconnect" );

    for ( ;; )
    {
        self waittill( "test_random_perk" );

        if ( !streamer_test_binds_enabled() )
            continue;

        self iprintlnbold( "^2Testing Reward: ^5Random Perk" );

        reward = spawnstruct();
        reward.ref = "random_perk";
        reward.displayName = "Random Perk";
        reward.type = "perk";
        reward.weight = 0;
        reward.data = 0;

        streamer_reward_perk_dispatch( self, reward );
    }
}

// ---------------------------------------------------------------------------
// ALL PERKS
// ---------------------------------------------------------------------------

streamer_reward_test_listener_all_perks()
{
    self endon( "disconnect" );

    for ( ;; )
    {
        self waittill( "test_all_perks" );

        if ( !streamer_test_binds_enabled() )
            continue;

        self iprintlnbold( "^2Testing Reward: ^5All Perks" );

        reward = spawnstruct();
        reward.ref = "all_perks";
        reward.displayName = "All Perks";
        reward.type = "perk";
        reward.weight = 0;
        reward.data = 0;

        streamer_reward_perk_dispatch( self, reward );
    }
}


// ---------------------------------------------------------------------------
// ENABLE/DISABLE
// ---------------------------------------------------------------------------
streamer_test_binds_enabled()
{
    return isDefined( level.streamer_reward_test_enabled ) && level.streamer_reward_test_enabled;
}