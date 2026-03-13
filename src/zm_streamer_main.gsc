// BO2 Zombies - Streamer Mod v0
// ENTRY POINT

#include scripts\zm\streamer_mod\streamer_pools;
#include scripts\zm\streamer_mod\streamer_rewards;
#include scripts\zm\streamer_mod\streamer_input;

init()
{
    level thread streamer_mod_init();
}

streamer_mod_init()
{
    if ( !isDefined( level.streamer_mod_initialized ) )
    {
        level.streamer_mod_initialized = true;
        level.streamer_spin_cooldown_ms = 2000; // 2s per-player cooldown (tweak)
        level thread streamer_mod_debug_announce();

        streamer_init_pools();
        streamer_setup_rewards();
        streamer_setup_input();
    }
}

streamer_mod_debug_announce()
{
    // Simple on-load confirmation that the script is active.
    wait 3;

    players = getentarray( "player", "classname" );
    for ( i = 0; i < players.size; i++ )
    {
        players[i] iprintlnbold( "Streamer Mod v0 by 11 loaded! test" );
    }
}