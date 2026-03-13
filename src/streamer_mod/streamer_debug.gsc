streamer_debug_print( msg )
{
    if ( isDefined( level.streamer_debug ) && level.streamer_debug )
        iprintln( "[11 MOD] " + msg );
}